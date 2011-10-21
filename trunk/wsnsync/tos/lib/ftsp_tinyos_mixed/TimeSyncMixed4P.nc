/*
 * Copyright (c) 2002, Vanderbilt University
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
 *
 * @author: Miklos Maroti, Brano Kusy (kusy@isis.vanderbilt.edu), Janos Sallai
 * Ported to T2: 3/17/08 by Brano Kusy (branislav.kusy@gmail.com)
 */
#include "TimeSyncMsg.h"

generic module TimeSyncMixedP(typedef precision_tag)
{
    provides
    {
        interface Init;
        interface StdControl;
        interface GlobalTime<precision_tag>;

        //interfaces for extra functionality: need not to be wired
        interface TimeSyncInfo;
        interface TimeSyncMode;
        interface TimeSyncNotify;
    }
    uses
    {
        interface Boot;
        interface SplitControl as RadioControl;
        interface TimeSyncAMSend<precision_tag,uint32_t> as Send;
        interface Receive;
        interface Timer<TMilli>;
        interface Random;
        interface Leds;
        interface TimeSyncPacket<precision_tag,uint32_t>;
        interface LocalTime<precision_tag> as LocalTime;
        interface MessageCounter;

#ifdef LOW_POWER_LISTENING
        interface LowPowerListening;
#endif

    }
}
implementation
{
#ifndef TIMESYNC_RATE
#define TIMESYNC_RATE   10
#endif

    enum {
        MAX_ENTRIES           = 8,              // number of entries in the table
        BEACON_RATE           = TIMESYNC_RATE,  // how often send the beacon msg (in seconds)
        ROOT_TIMEOUT          = 5,              //time to declare itself the root if no msg was received (in sync periods)
        IGNORE_ROOT_MSG       = 4,              // after becoming the root ignore other roots messages (in send period)
        ENTRY_VALID_LIMIT     = 4,              // number of entries to become synchronized
        ENTRY_SEND_LIMIT      = 3,              // number of entries to send sync messages
        ENTRY_THROWOUT_LIMIT  = 500,            // if time sync error is bigger than this clear the table
    };

    typedef struct TableItem
    {
        uint8_t     state;
        uint32_t    localTime;
        int32_t     timeOffset;                     // globalTime - localTime
    } TableItem;

    enum {
        ENTRY_EMPTY = 0,
        ENTRY_FULL = 1,
    };

    TableItem   table[MAX_ENTRIES];
    TableItem   table16[MAX_ENTRIES+8];
    
    TableItem   tableMedian8[MAX_ENTRIES];
    TableItem   tableMedian9[MAX_ENTRIES+1];
    
    TableItem   tableMedian16[MAX_ENTRIES+8];
    TableItem   tableMedian17[MAX_ENTRIES+9];
    
    uint8_t tableEntries;
    uint8_t tableEntries16;
    
    uint8_t tableEntriesMedian8;
    uint8_t tableEntriesMedian9;
    
    uint8_t tableEntriesMedian16;
    uint8_t tableEntriesMedian17;
    
    int8_t tableEnd;
    int8_t tableEnd16;
    
    int8_t tableEndMedian8;
    int8_t tableEndMedian9;
    
    int8_t tableEndMedian16;
    int8_t tableEndMedian17;

    enum {
        STATE_IDLE = 0x00,
        STATE_PROCESSING = 0x01,
        STATE_SENDING = 0x02,
        STATE_INIT = 0x04,
    };

    uint8_t state, mode;

/*
    We do linear regression from localTime to timeOffset (globalTime - localTime).
    This way we can keep the slope close to zero (ideally) and represent it
    as a float with high precision.

        timeOffset - offsetAverage = skew * (localTime - localAverage)
        timeOffset = offsetAverage + skew * (localTime - localAverage)
        globalTime = localTime + offsetAverage + skew * (localTime - localAverage)
*/

    float       skew;
    float       skew16;
    
    float       medianSkew8;
    float       medianSkew9;

    float       medianSkew16;
    float       medianSkew17;
   
    uint32_t    localAverage;
    uint32_t    localAverage16;
    
    uint32_t    localAverageMedian8;
    uint32_t    localAverageMedian9;
    
    uint32_t    localAverageMedian16;
    uint32_t    localAverageMedian17;
    
    int32_t     offsetAverage;
    int32_t     offsetAverage16;
    
    int32_t     offsetAverageMedian8;
    int32_t     offsetAverageMedian9;

    int32_t     offsetAverageMedian16;
    int32_t     offsetAverageMedian17;
    
    uint8_t     numEntries; // the number of full entries in the table

    message_t processedMsgBuffer;
    message_t* processedMsg;

    message_t outgoingMsgBuffer;
    TimeSyncMsg* outgoingMsg;

    uint8_t heartBeats; // the number of sucessfully sent messages
                        // since adding a new entry with lower beacon id than ours

    async command uint32_t GlobalTime.getLocalTime()
    {
        return call LocalTime.get();
    }

    async command error_t GlobalTime.getGlobalTime(uint32_t *time)
    {
        *time = call GlobalTime.getLocalTime();
        return call GlobalTime.local2Global(time);
    }

    error_t is_synced()
    {
      if (numEntries>=ENTRY_VALID_LIMIT || outgoingMsg->rootID==TOS_NODE_ID)
        return SUCCESS;
      else
        return FAIL;
    }


    async command error_t GlobalTime.local2Global(uint32_t *time)
    {
        *time += offsetAverage + (int32_t)(skew * (int32_t)(*time - localAverage));
        return is_synced();
    }
    
    async command error_t GlobalTime.local2Global16(uint32_t *time)
    {
        *time += offsetAverage16 + (int32_t)(skew16 * (int32_t)(*time - localAverage16));
        return is_synced();
    }    
    
    async command error_t GlobalTime.local2GlobalMedian8(uint32_t *time)
    {
        *time += offsetAverageMedian8 + (int32_t)(medianSkew8 * (int32_t)(*time - localAverageMedian8));
        return is_synced();
    }

    async command error_t GlobalTime.local2GlobalMedian9(uint32_t *time)
    {
        *time += offsetAverageMedian9 + (int32_t)(medianSkew9 * (int32_t)(*time - localAverageMedian9));
        return is_synced();
    }

    async command error_t GlobalTime.local2GlobalMedian16(uint32_t *time)
    {
        *time += offsetAverageMedian16 + (int32_t)(medianSkew16 * (int32_t)(*time - localAverageMedian16));
        return is_synced();
    }

    async command error_t GlobalTime.local2GlobalMedian17(uint32_t *time)
    {
        *time += offsetAverageMedian17 + (int32_t)(medianSkew17 * (int32_t)(*time - localAverageMedian17));
        return is_synced();
    }       

    async command error_t GlobalTime.global2Local(uint32_t *time)
    {
        uint32_t approxLocalTime = *time - offsetAverage;
        *time = approxLocalTime - (int32_t)(skew * (int32_t)(approxLocalTime - localAverage));
        return is_synced();
    }
    
    /* variables stored for Theil method */
    float conSlopes[16];

    int compareSlopes(const void *a, const void *b){
      float diff = *((float *)a) - *((float *)b);
      
      if(diff > 0.0f)
        return 1;
      else if(diff < 0.0f)
        return -1;
      else
        return 0;
    }
   
    int64_t localSum;
    int64_t offsetSum;
    int32_t localAverageRest;
    int32_t offsetAverageRest;

    uint32_t newLocalAverage;
    uint32_t newLocalAverage16;
    
    uint32_t newLocalAverageMedian8;
    uint32_t newLocalAverageMedian9;
    
    uint32_t newLocalAverageMedian16;
    uint32_t newLocalAverageMedian17;

    int32_t newOffsetAverage;
    int32_t newOffsetAverage16;
    
    int32_t newOffsetAverageMedian8;
    int32_t newOffsetAverageMedian9;

    int32_t newOffsetAverageMedian16;
    int32_t newOffsetAverageMedian17;

    float newSkew;
    float newSkew16;
    
    float newSkewMedian8;
    float newSkewMedian9;
    
    float newSkewMedian16;
    float newSkewMedian17;   

    void theil(TableItem *tbl,uint8_t tblEntries,uint32_t *nLA,int32_t *nOA,float *nS){
        int32_t numConSlopes = 0;
        int8_t i,j;

        for(i = 1; i < tblEntries; i++){
          /* compute consecutive slopes */
          {
            int32_t a = (int32_t)(tbl[i].timeOffset - tbl[i-1].timeOffset);
            int32_t b = (int32_t)(tbl[i].localTime  - tbl[i-1].localTime);

            if( b != 0 ){
              conSlopes[numConSlopes++] = (float)a/(float)b;
            }
          }
        }
        
        /* sort slopes: do not need to sort all of the values */
        for(i = 0; i <= (numConSlopes>>1); ++i) {
          float tmp;
          uint8_t min = i;
            
          for(j = i+1; j < numConSlopes; ++j){
            if(conSlopes[min] > conSlopes[j]){
              min = j;
            }
          }
            
          tmp = conSlopes[i];
          conSlopes[i] = conSlopes[min];
          conSlopes[min] = tmp;
        }            

        /* sort slopes */
//         qsort(conSlopes,numConSlopes,sizeof(float),compareSlopes);

        /* calculate the median of the slopes */
        i = numConSlopes>>1;
        if(numConSlopes & 0x1) {
          *nS = conSlopes[i];
        }
        else{
          *nS = (conSlopes[i] - conSlopes[i-1])/2.0f + conSlopes[i-1];
        }

        localSum = 0;
        localAverageRest = 0;
        offsetSum = 0;
        offsetAverageRest = 0;

        *nLA = tbl[0].localTime;
        *nOA = tbl[0].timeOffset;

        for(i = 1; i < tblEntries; i++){
          localSum += (int32_t)(tbl[i].localTime - *nLA) / tblEntries;
          localAverageRest += (tbl[i].localTime - *nLA) % tblEntries;

          offsetSum += (int32_t)(tbl[i].timeOffset - *nOA) / tblEntries;
          offsetAverageRest += (tbl[i].timeOffset - *nOA) % tblEntries;
        }

        *nLA += localSum + localAverageRest / tblEntries;
        *nOA += offsetSum + offsetAverageRest / tblEntries;        
    }
    
    void calculateConversion()
    {

        int8_t i;

        if(tableEntries < 2) return;

        newSkew = skew;
        newSkew16 = skew16;
        
        newSkewMedian8 = medianSkew8;
        newSkewMedian9 = medianSkew9;
        
        newSkewMedian16 = medianSkew16;
        newSkewMedian17 = medianSkew17;

        localSum = 0;
        localAverageRest = 0;
        offsetSum = 0;
        offsetAverageRest = 0;

        newLocalAverage = table[0].localTime;
        newOffsetAverage = table[0].timeOffset;       

        for(i = 1; i < tableEntries; i++){
          localSum += (int32_t)(table[i].localTime - newLocalAverage) / tableEntries;
          localAverageRest += (table[i].localTime - newLocalAverage) % tableEntries;

          offsetSum += (int32_t)(table[i].timeOffset - newOffsetAverage) / tableEntries;
          offsetAverageRest += (table[i].timeOffset - newOffsetAverage) % tableEntries;
        }

        newLocalAverage += localSum + localAverageRest / tableEntries;
        newOffsetAverage += offsetSum + offsetAverageRest / tableEntries;

        localSum = offsetSum = 0;

        for(i = 0; i < tableEntries; ++i){
          int32_t a = table[i].localTime - newLocalAverage;
          int32_t b = table[i].timeOffset - newOffsetAverage;

          localSum  += (int64_t)a * a;
          offsetSum += (int64_t)a * b;
        }

        if( localSum != 0 )
            newSkew = (float)offsetSum / (float)localSum;        
        
        localSum = 0;
        localAverageRest = 0;
        offsetSum = 0;
        offsetAverageRest = 0;

        newLocalAverage16 = table16[0].localTime;
        newOffsetAverage16 = table16[0].timeOffset;       

        for(i = 1; i < tableEntries16; i++){
          localSum += (int32_t)(table16[i].localTime - newLocalAverage16) / tableEntries16;
          localAverageRest += (table16[i].localTime - newLocalAverage16) % tableEntries16;

          offsetSum += (int32_t)(table16[i].timeOffset - newOffsetAverage16) / tableEntries16;
          offsetAverageRest += (table16[i].timeOffset - newOffsetAverage16) % tableEntries16;
        }

        newLocalAverage16 += localSum + localAverageRest / tableEntries16;
        newOffsetAverage16 += offsetSum + offsetAverageRest / tableEntries16;

        localSum = offsetSum = 0;

        for(i = 0; i < tableEntries16; ++i){
          int32_t a = table16[i].localTime - newLocalAverage16;
          int32_t b = table16[i].timeOffset - newOffsetAverage16;

          localSum  += (int64_t)a * a;
          offsetSum += (int64_t)a * b;
        }

        if( localSum != 0 )
            newSkew16 = (float)offsetSum / (float)localSum;                

        theil(tableMedian8,tableEntriesMedian8,&newLocalAverageMedian8,&newOffsetAverageMedian8,&newSkewMedian8);
        theil(tableMedian9,tableEntriesMedian9,&newLocalAverageMedian9,&newOffsetAverageMedian9,&newSkewMedian9);
        theil(tableMedian16,tableEntriesMedian16,&newLocalAverageMedian16,&newOffsetAverageMedian16,&newSkewMedian16);
        theil(tableMedian17,tableEntriesMedian17,&newLocalAverageMedian17,&newOffsetAverageMedian17,&newSkewMedian17);

        atomic
        {
            skew            = newSkew;
            skew16          = newSkew16;
            
            medianSkew8     = newSkewMedian8;
            medianSkew9     = newSkewMedian9;
            
            medianSkew16    = newSkewMedian16;
            medianSkew17    = newSkewMedian17;

            offsetAverage           = newOffsetAverage;
            offsetAverage16         = newOffsetAverage16;
            
            offsetAverageMedian8    = newOffsetAverageMedian8;
            offsetAverageMedian9    = newOffsetAverageMedian9;
            
            offsetAverageMedian16   = newOffsetAverageMedian16;
            offsetAverageMedian17   = newOffsetAverageMedian17;

            localAverage            = newLocalAverage;
            localAverage16          = newLocalAverage16;
            
            localAverageMedian8     = newLocalAverageMedian8;
            localAverageMedian9     = newLocalAverageMedian9;
            
            localAverageMedian16    = newLocalAverageMedian16;
            localAverageMedian17    = newLocalAverageMedian17;
            
            numEntries = tableEntries;
        }
    }

    void clearTable()
    {
        int8_t i;
        
        for(i = 0; i < MAX_ENTRIES; ++i){
            table[i].state = ENTRY_EMPTY;
        }
        
        for(i = 0; i < MAX_ENTRIES+8; ++i){
          table16[i].state = ENTRY_EMPTY;
        }        

        for(i = 0; i < MAX_ENTRIES; ++i){
          tableMedian8[i].state = ENTRY_EMPTY;
        }

        for(i = 0; i < (MAX_ENTRIES+1); ++i){
          tableMedian9[i].state = ENTRY_EMPTY;
        }

        for(i = 0; i < (MAX_ENTRIES+8); ++i){
            tableMedian16[i].state = ENTRY_EMPTY;
        }

        for(i = 0; i < (MAX_ENTRIES+9); ++i){
          tableMedian17[i].state = ENTRY_EMPTY;
        }
                
        atomic numEntries = 0;

        tableEntries = 0;
        tableEntries16 = 0;
        
        tableEntriesMedian8 = 0;
        tableEntriesMedian9 = 0;
        
        tableEntriesMedian16 = 0;
        tableEntriesMedian17 = 0;
        
        tableEnd = -1;
        tableEnd16 = -1;
        
        tableEndMedian8 = -1;
        tableEndMedian9 = -1;
        
        tableEndMedian16 = -1;
        tableEndMedian17 = -1;
    }

    void add(uint32_t localTime,int32_t globalTime,TableItem *t,uint8_t *tEntries, int8_t *tEnd,uint8_t MaxEntries){
        int8_t i;

        if (*tEntries == MaxEntries){
          /* shift left all the entries: we get ranked  x values */
          for( i=0; i < MaxEntries-1; i++)
            t[i] = t[i+1];
        }
        else{
          *tEnd = *tEnd + 1;
          *tEntries = *tEntries + 1;
        }

        t[*tEnd].state = ENTRY_FULL;
        t[*tEnd].localTime = localTime;
        t[*tEnd].timeOffset = globalTime - localTime;
    }
    

    void addNewEntry(TimeSyncMsg *msg)
    {
      add(msg->localTime,msg->globalTime,table,&tableEntries,&tableEnd,MAX_ENTRIES);    
      add(msg->localTime,msg->globalTime16,table16,&tableEntries16,&tableEnd16,MAX_ENTRIES+8);
          
      add(msg->localTime,msg->globalTimeMedian8,tableMedian8,&tableEntriesMedian8,&tableEndMedian8,MAX_ENTRIES);
      add(msg->localTime,msg->globalTimeMedian9,tableMedian9,&tableEntriesMedian9,&tableEndMedian9,MAX_ENTRIES+1);
          
      add(msg->localTime,msg->globalTimeMedian16,tableMedian16,&tableEntriesMedian16,&tableEndMedian16,MAX_ENTRIES+8);
      add(msg->localTime,msg->globalTimeMedian17,tableMedian17,&tableEntriesMedian17,&tableEndMedian17,MAX_ENTRIES+9);
    }

    void task processMsg()
    {
        TimeSyncMsg* msg = (TimeSyncMsg*)(call Send.getPayload(processedMsg, sizeof(TimeSyncMsg)));

        if( msg->rootID < outgoingMsg->rootID &&
            //after becoming the root, a node ignores messages that advertise the old root (it may take
            //some time for all nodes to timeout and discard the old root) 
            !(heartBeats < IGNORE_ROOT_MSG && outgoingMsg->rootID == TOS_NODE_ID) ){
            outgoingMsg->rootID = msg->rootID;
            outgoingMsg->seqNum = msg->seqNum;
            clearTable();
        }
        else if( outgoingMsg->rootID == msg->rootID && (int8_t)(msg->seqNum - outgoingMsg->seqNum) > 0 ) {
            outgoingMsg->seqNum = msg->seqNum;
        }
        else
            goto exit;

        call Leds.led0Toggle();
        if( outgoingMsg->rootID < TOS_NODE_ID )
            heartBeats = 0;

        addNewEntry(msg);
        calculateConversion();
        signal TimeSyncNotify.msg_received();

    exit:
        state &= ~STATE_PROCESSING;
    }

    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)
    {
#ifdef TIMESYNC_DEBUG   // this code can be used to simulate multiple hopsf
        uint8_t incomingID = (uint8_t)((TimeSyncMsg*)payload)->nodeID;
        int8_t diff = (incomingID & 0x0F) - (TOS_NODE_ID & 0x0F);
        if( diff < -1 || diff > 1 )
            return msg;
        diff = (incomingID & 0xF0) - (TOS_NODE_ID & 0xF0);
        if( diff < -16 || diff > 16 )
            return msg;
#endif
      
      uint16_t incomingID = (uint8_t)((TimeSyncMsg*)payload)->nodeID;
      int16_t diff = (incomingID - TOS_NODE_ID);
      /* LINE topology */
       if( diff < -1 || diff > 1 )
         return msg;

        call MessageCounter.incrementReceived();
        if( (state & STATE_PROCESSING) == 0
            && call TimeSyncPacket.isValid(msg)) {
            message_t* old = processedMsg;

            processedMsg = msg;
            ((TimeSyncMsg*)(payload))->localTime = call TimeSyncPacket.eventTime(msg);

            state |= STATE_PROCESSING;
            post processMsg();

            return old;
        }

        return msg;
    }

    task void sendMsg()
    {
        uint32_t localTime, globalTime,globalTime16,globalTimeMedian8,globalTimeMedian9,globalTimeMedian16,globalTimeMedian17;

        globalTime16  = globalTime = localTime = call GlobalTime.getLocalTime();
        globalTimeMedian8 = globalTimeMedian9 = globalTimeMedian16 = globalTimeMedian17 = globalTime;
        
        call GlobalTime.local2Global(&globalTime);
        call GlobalTime.local2Global16(&globalTime16);

        call GlobalTime.local2GlobalMedian8(&globalTimeMedian8);
        call GlobalTime.local2GlobalMedian9(&globalTimeMedian9);
        
        call GlobalTime.local2GlobalMedian16(&globalTimeMedian16);
        call GlobalTime.local2GlobalMedian17(&globalTimeMedian17);


        // we need to periodically update the reference point for the root
        // to avoid wrapping the 32-bit (localTime - localAverage) value
        if( outgoingMsg->rootID == TOS_NODE_ID ) {
            if( (int32_t)(localTime - localAverage) >= 0x20000000 )
            {
                atomic
                {
                    localAverage = localTime;
                    offsetAverage = globalTime - localTime;
                }
            }
        }
        else if( heartBeats >= ROOT_TIMEOUT ) {
            heartBeats = 0; //to allow ROOT_SWITCH_IGNORE to work
            outgoingMsg->rootID = TOS_NODE_ID;
            ++(outgoingMsg->seqNum); // maybe set it to zero?
        }

        outgoingMsg->globalTime         = globalTime;
        outgoingMsg->globalTime16       = globalTime16;
        
        outgoingMsg->globalTimeMedian8  = globalTimeMedian8;
        outgoingMsg->globalTimeMedian9  = globalTimeMedian9;
        
        outgoingMsg->globalTimeMedian16 = globalTimeMedian16;
        outgoingMsg->globalTimeMedian17 = globalTimeMedian17;        
        
#ifdef LOW_POWER_LISTENING
        call LowPowerListening.setRemoteWakeupInterval(&outgoingMsgBuffer, LPL_INTERVAL);
#endif
        // we don't send time sync msg, if we don't have enough data
        if( numEntries < ENTRY_SEND_LIMIT && outgoingMsg->rootID != TOS_NODE_ID ){
            ++heartBeats;
            state &= ~STATE_SENDING;
        }
        else if( call Send.send(AM_BROADCAST_ADDR, &outgoingMsgBuffer, TIMESYNCMSG_LEN, localTime ) != SUCCESS ){
            state &= ~STATE_SENDING;
            signal TimeSyncNotify.msg_sent();
        }
        
        call MessageCounter.incrementSent();
    }

    event void Send.sendDone(message_t* ptr, error_t error)
    {
        if (ptr != &outgoingMsgBuffer)
          return;

        if(error == SUCCESS)
        {
            ++heartBeats;
            call Leds.led1Toggle();

            if( outgoingMsg->rootID == TOS_NODE_ID )
                ++(outgoingMsg->seqNum);
        }

        state &= ~STATE_SENDING;
        signal TimeSyncNotify.msg_sent();
    }

    void timeSyncMsgSend()
    {
        if( outgoingMsg->rootID == 0xFFFF && ++heartBeats >= ROOT_TIMEOUT ) {
            outgoingMsg->seqNum = 0;
            outgoingMsg->rootID = TOS_NODE_ID;
        }

        if( outgoingMsg->rootID != 0xFFFF && (state & STATE_SENDING) == 0 ) {
           state |= STATE_SENDING;
           post sendMsg();
        }
    }

    event void Timer.fired()
    {
      if (mode == TS_TIMER_MODE) {
        timeSyncMsgSend();
      }
      else
        call Timer.stop();
    }

    command error_t TimeSyncMode.setMode(uint8_t mode_){
        if (mode_ == TS_TIMER_MODE){
            call Timer.startPeriodic((uint32_t)(896U+(call Random.rand16()&0xFF)) * BEACON_RATE);
        }
        else
            call Timer.stop();

        mode = mode_;
        return SUCCESS;
    }

    command uint8_t TimeSyncMode.getMode(){
        return mode;
    }

    command error_t TimeSyncMode.send(){
        if (mode == TS_USER_MODE){
            timeSyncMsgSend();
            return SUCCESS;
        }
        return FAIL;
    }

    command error_t Init.init()
    {
        atomic{
            skew = 0.0;
            skew16 = 0.0;
            
            medianSkew8 = 0.0;
            medianSkew9 = 0.0;

            medianSkew16 = 0.0;
            medianSkew17 = 0.0;
            
            localAverage = 0;
            localAverage16 = 0;
            
            localAverageMedian8 = 0;
            localAverageMedian9 = 0;
            
            localAverageMedian16 = 0;
            localAverageMedian17 = 0;
            
            offsetAverage = 0;
            offsetAverage16 = 0;

            offsetAverageMedian8 = 0;
            offsetAverageMedian9 = 0;
            
            offsetAverageMedian16 = 0;
            offsetAverageMedian17 = 0;
        };

        clearTable();

        atomic outgoingMsg = (TimeSyncMsg*)call Send.getPayload(&outgoingMsgBuffer, sizeof(TimeSyncMsg));
        outgoingMsg->rootID = 0xFFFF;

        processedMsg = &processedMsgBuffer;
        state = STATE_INIT;

        return SUCCESS;
    }

    event void Boot.booted()
    {
      call RadioControl.start();
      call StdControl.start();
    }

    command error_t StdControl.start()
    {
        heartBeats = 0;
        outgoingMsg->nodeID = TOS_NODE_ID;
        call TimeSyncMode.setMode(TS_TIMER_MODE);

        return SUCCESS;
    }

    command error_t StdControl.stop()
    {
        call Timer.stop();
        return SUCCESS;
    }

    async command float     TimeSyncInfo.getSkew() { return skew; }
    async command float     TimeSyncInfo.getSkew16() { return skew16; }
    
    async command float     TimeSyncInfo.getSkewMedian8() { return medianSkew8; }
    async command float     TimeSyncInfo.getSkewMedian9() { return medianSkew9; }
    
    async command float     TimeSyncInfo.getSkewMedian16() { return medianSkew16; }
    async command float     TimeSyncInfo.getSkewMedian17() { return medianSkew17; }
    
    async command uint32_t  TimeSyncInfo.getOffset() { return offsetAverage; }
    async command uint32_t  TimeSyncInfo.getSyncPoint() { return localAverage; }
    async command uint16_t  TimeSyncInfo.getRootID() { return outgoingMsg->rootID; }
    async command uint8_t   TimeSyncInfo.getSeqNum() { return outgoingMsg->seqNum; }
    async command uint8_t   TimeSyncInfo.getNumEntries() { return numEntries; }
    async command uint8_t   TimeSyncInfo.getHeartBeats() { return heartBeats; }

    default event void TimeSyncNotify.msg_received(){}
    default event void TimeSyncNotify.msg_sent(){}

    event void RadioControl.startDone(error_t error){}
    event void RadioControl.stopDone(error_t error){}
}
