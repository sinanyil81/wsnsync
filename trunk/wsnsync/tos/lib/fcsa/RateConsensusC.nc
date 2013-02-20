/*
 * Copyright (c) 2013, EGE University, Izmir, Turkey
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * @author: K. Sinan YILDIRIM (sinanyil81@gmail.com)
 */

module RateConsensusC
{
    provides
    {
        interface RateConsensus;
    }
}
implementation
{
    enum {          
        MAX_NEIGHBORS         = 8,              // maximum number of neighbors
        MAX_ENTRIES           = 8,              // maximum number of 
        NEIGHBOR_RATE         = 30,             // beacon period for neighbors (in seconds)
        NEIGHBOR_TIMEOUT      = NEIGHBOR_RATE*5,// timeout for removing the neighbor from the neighbor table
        ENTRY_THROWOUT_LIMIT  = 500,            // if time sync error is bigger than this, discard entry
        ENTRY_VALID_LIMIT     = 4,              // number of entries to become synchronized                        
    };

    enum {
        ENTRY_EMPTY = 0,
        ENTRY_FULL = 1,
    };

    typedef struct TableItem
    {
        uint8_t     state;
        uint32_t    localTime;
        int32_t     timeOffset; // globalTime - localTime
    } TableItem;

    typedef struct NeighborEntry{
        uint8_t state;                      // is entry full or empty ?
        uint16_t id;                        // ID of the neighbor
        float multiplier;                   // latest rate multiplier received

        TableItem   table[MAX_ENTRIES];     // stores the timestamp pairs in order to calculate
                                            // the slope of the least-squares line
        uint8_t tableEntries;               // number of the full entries
        float skew;                         // the relative hardware rate calculated by performing least-squares regression
        uint32_t localAverage;              // least-squares average of x
        int32_t offsetAverage;              // least-squares average of y-x

        uint32_t timestamp;                 // receipt time of the last message
    }NeighborEntry;

    NeighborEntry neighbors[MAX_NEIGHBORS]; // neighbor table in order to discover neighbors
    uint8_t numNeighbors = 0;

    error_t checkEntry(uint8_t index, uint32_t localTime,uint32_t targetTime)
    {
        uint32_t estimate = localTime;
        int32_t timeError;
        
        if(neighbors[index].tableEntries < ENTRY_VALID_LIMIT){
            return SUCCESS;
        }
        
        estimate += neighbors[index].offsetAverage + (int32_t)(neighbors[index].skew*(int32_t)(localTime - neighbors[index].localAverage));

        timeError = (int32_t)(targetTime - estimate);

        if((timeError > ENTRY_THROWOUT_LIMIT) || (timeError < -ENTRY_THROWOUT_LIMIT))
        {
            return FAIL; // don't incorporate a bad reading
        }

        return SUCCESS;
    }

    void addNewEntry(TableItem *table,uint8_t *tableEntries, uint32_t X, uint32_t Y)
    {
        int8_t i, freeItem = -1, oldestItem = 0;
        uint32_t age, oldestTime = 0;

        *tableEntries = 0; // don't reset table size unless you're recounting

        for(i = 0; i < MAX_ENTRIES; ++i) {
            age = X - table[i].localTime;

            //logical time error compensation
            if( age >= 0x7FFFFFFFL )
                table[i].state = ENTRY_EMPTY;

            if( table[i].state == ENTRY_EMPTY )
                freeItem = i;
            else
                ++(*tableEntries);

            if( age >= oldestTime ) {
                oldestTime = age;
                oldestItem = i;
            }
        }

        if( freeItem < 0 )
            freeItem = oldestItem;
        else
            ++(*tableEntries);

        table[freeItem].state = ENTRY_FULL;
        table[freeItem].localTime = X;
        table[freeItem].timeOffset = Y - X;
    }


    void calculateConversion(TableItem *table, uint8_t tableEntries,float *skew,uint32_t *localAverage,int32_t *offsetAverage)
    {
        float newSkew = 0.0;
        uint32_t newLocalAverage;
        int32_t newOffsetAverage;
        int32_t localAverageRest;
        int32_t offsetAverageRest;

        int64_t localSum;
        int64_t offsetSum;

        int8_t i;

        for(i = 0; i < MAX_ENTRIES && table[i].state != ENTRY_FULL; ++i)
            ;

        if( i >= MAX_ENTRIES )  // table is empty
            return;
/*
        We use a rough approximation first to avoid time overflow errors. The idea
        is that all times in the table should be relatively close to each other.
*/
        newLocalAverage = table[i].localTime;
        newOffsetAverage = table[i].timeOffset;

        localSum = 0;
        localAverageRest = 0;
        offsetSum = 0;
        offsetAverageRest = 0;

        while( ++i < MAX_ENTRIES )
            if( table[i].state == ENTRY_FULL ) {
                /*
                   This only works because C ISO 1999 defines the signe for modulo the same as for the Dividend!
                */
                localSum += (int32_t)(table[i].localTime - newLocalAverage) / tableEntries;
                localAverageRest += (table[i].localTime - newLocalAverage) % tableEntries;
                offsetSum += (int32_t)(table[i].timeOffset - newOffsetAverage) / tableEntries;
                offsetAverageRest += (table[i].timeOffset - newOffsetAverage) % tableEntries;
            }

        newLocalAverage += localSum + localAverageRest / tableEntries;
        newOffsetAverage += offsetSum + offsetAverageRest / tableEntries;

        localSum = offsetSum = 0;
        for(i = 0; i < MAX_ENTRIES; ++i)
            if( table[i].state == ENTRY_FULL ) {
                int32_t a = table[i].localTime - newLocalAverage;
                int32_t b = table[i].timeOffset - newOffsetAverage;

                localSum += (int64_t)a * a;
                offsetSum += (int64_t)a * b;
            }

        if( localSum != 0 )
            newSkew = (float)offsetSum / (float)localSum;

        *skew = newSkew;
        *localAverage = newLocalAverage;
        *offsetAverage = newOffsetAverage;
    }

    void clearTable(TableItem *table,uint8_t *tableEntries)
    {
        int8_t i;
        for(i = 0; i < MAX_ENTRIES; ++i)
            table[i].state = ENTRY_EMPTY;

        *tableEntries = 0;
    }

    void clearNeighbor(uint8_t i){
        neighbors[i].state = ENTRY_EMPTY;
        neighbors[i].multiplier = 0.0;
        neighbors[i].skew = 0.0;
        clearTable(neighbors[i].table,&neighbors[i].tableEntries);
    }

    void clearNeighbors(){
        uint8_t i;

        for(i = 0; i < MAX_NEIGHBORS; ++i){
            clearNeighbor(i);
        }

        numNeighbors = 0;
    }

    int8_t getNeighborSlot(uint16_t id) {
        int8_t i;

        for (i = 0; i < MAX_NEIGHBORS; i++) {
            if ((neighbors[i].state == ENTRY_FULL) && (neighbors[i].id == id)) {
                return i;
            }
        }

        return -1;
    }

    int8_t getFreeSlot() {
        int8_t i, freeItem = -1;

        for (i = 0; i < MAX_NEIGHBORS; ++i) {
            if (neighbors[i].state == ENTRY_EMPTY)  {
                freeItem = i;
            }
        }

        return freeItem;
    }

    command void RateConsensus.reset(){
        clearNeighbors();
    }

    command void RateConsensus.updateNeighbors(uint32_t currentTime){
        int8_t i;
        uint32_t age;

        for (i = 0; i < MAX_NEIGHBORS; ++i) {
            age = currentTime - neighbors[i].timestamp;
            
            if ((age >= (NEIGHBOR_TIMEOUT*1000000L)) && (neighbors[i].state == ENTRY_FULL)){
                clearNeighbor(i);
            }
        }
    }

    command error_t RateConsensus.storeNeighborInfo(uint16_t neighborID,float multiplier, uint32_t neighborClock,uint32_t eventTime){

        uint8_t found = 0;
        int8_t index = getNeighborSlot(neighborID);

        if(index >= 0){
            found = 1;
        }
        else {
            index = getFreeSlot();
        }

        if (index >= 0) {

            if(checkEntry(index,eventTime,neighborClock) == SUCCESS){
                neighbors[index].state = ENTRY_FULL;
                neighbors[index].id = neighborID;
                neighbors[index].timestamp = eventTime;
                neighbors[index].multiplier = multiplier;

                addNewEntry(neighbors[index].table,
                            &neighbors[index].tableEntries,
                            eventTime,
                            neighborClock);

                if(found){
                    calculateConversion(neighbors[index].table,
                                        neighbors[index].tableEntries,
                                        &neighbors[index].skew,
                                        &neighbors[index].localAverage,
                                        &neighbors[index].offsetAverage);
                }
                else{
                    neighbors[index].skew = 0.0;
                    neighbors[index].localAverage = 0;
                    neighbors[index].offsetAverage = 0;
                }

                return SUCCESS;
            }
        }

        return FAIL;        
    }

    command float RateConsensus.getRate(float myRate){
        float rateSum = myRate;
        uint8_t i;

        numNeighbors = 0;

        for (i = 0; i < MAX_NEIGHBORS; i++) {
            if(neighbors[i].state == ENTRY_FULL){
                rateSum += neighbors[i].skew*neighbors[i].multiplier;
                rateSum += neighbors[i].multiplier;
                rateSum += neighbors[i].skew;
                numNeighbors++;
            }
        }

        return rateSum/(float)(numNeighbors+1);
    }
}