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
 *
 * Modified by K. Sinan YILDIRIM (sinanyil81@gmail.com) in order to implement 
 * PulseSync algorithm with a fixed reference node by using pairwise slope
 * with minimum variance.
 */
#include "TimeSyncMsg.h"

generic module TimeSyncPSMVP(typedef precision_tag)
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
        ENTRY_VALID_LIMIT     = 4,              // number of entries to become synchronized
        ENTRY_SEND_LIMIT      = 3,              // number of entries to send sync messages
        ENTRY_THROWOUT_LIMIT  = 1000,           // if time sync error is bigger than this clear the table
    };

    typedef struct TableItem
    {
        uint8_t     state;
        uint32_t    localTime;
        int32_t     timeOffset; // globalTime - localTime
    } TableItem;

    enum {
        ENTRY_EMPTY = 0,
        ENTRY_FULL = 1,
    };

    TableItem   table[MAX_ENTRIES];
    uint8_t tableEntries;
    int8_t tableEnd;         
    
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
    uint32_t    localAverage;
    int32_t     offsetAverage;
    uint8_t     numEntries; // the number of full entries in the table

    message_t processedMsgBuffer;
    message_t* processedMsg;

    message_t outgoingMsgBuffer;
    TimeSyncMsg* outgoingMsg;

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

    async command error_t GlobalTime.global2Local(uint32_t *time)
    {
        uint32_t approxLocalTime = *time - offsetAverage;
        *time = approxLocalTime - (int32_t)(skew * (int32_t)(approxLocalTime - localAverage));
        return is_synced();
    }

    void calculateConversion()
    {
       float newSkew = skew;
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
		
		{
        	int32_t a = (int32_t)(table[tableEntries-1].timeOffset - table[0].timeOffset);
        	int32_t b = (int32_t)(table[tableEntries-1].localTime  - table[0].localTime);
        
        	if( b != 0 ){
          		newSkew = (float)a/(float)b;
        	}
        }
                
        atomic
        {
            skew = newSkew;
            offsetAverage = newOffsetAverage;
            localAverage = newLocalAverage;
            numEntries = tableEntries;
        }
    }   

    void clearTable()
    {
        int8_t i;
        for(i = 0; i < MAX_ENTRIES; ++i)
            table[i].state = ENTRY_EMPTY;

        atomic numEntries = 0;
        tableEntries = 0;
        tableEnd = -1;
    }

    uint8_t numErrors=0;
    void addNewEntry(TimeSyncMsg *msg)
    {
    	int i;
        int32_t timeError;

        // clear table if the received entry's been inconsistent for some time
        timeError = msg->localTime;
        call GlobalTime.local2Global((uint32_t*)(&timeError));
        timeError -= msg->globalTime;
        if( (is_synced() == SUCCESS) &&
            (timeError > ENTRY_THROWOUT_LIMIT || timeError < -ENTRY_THROWOUT_LIMIT))
        {
            if (++numErrors>3)
                clearTable();
            return; // don't incorporate a bad reading
        }
        
        numErrors = 0;
            
        if (tableEntries == MAX_ENTRIES){
          /* shift left all the entries: we get ranked  x values */
          for( i = 0; i < MAX_ENTRIES-1; i++)
            table[i] = table[i+1];
        }
        else{
          tableEnd++;
          tableEntries++;
        }       

        table[tableEnd].state = ENTRY_FULL;
        table[tableEnd].localTime = msg->localTime;
        table[tableEnd].timeOffset = msg->globalTime - msg->localTime;
    }
    
        task void sendMsg()
    {
        uint32_t localTime, globalTime;

        globalTime = localTime = call GlobalTime.getLocalTime();
        call GlobalTime.local2Global(&globalTime);

       outgoingMsg->globalTime = globalTime;
#ifdef LOW_POWER_LISTENING
        call LowPowerListening.setRemoteWakeupInterval(&outgoingMsgBuffer, LPL_INTERVAL);
#endif
        // we don't send time sync msg, if we don't have enough data
        if( numEntries < ENTRY_SEND_LIMIT && outgoingMsg->rootID != TOS_NODE_ID ){
            state &= ~STATE_SENDING;
        }
        else if( call Send.send(AM_BROADCAST_ADDR, &outgoingMsgBuffer, TIMESYNCMSG_LEN, localTime ) != SUCCESS ){
            state &= ~STATE_SENDING;
            signal TimeSyncNotify.msg_sent();
        }
    }

    event void Send.sendDone(message_t* ptr, error_t error)
    {
        if (ptr != &outgoingMsgBuffer)
          return;

        if(error == SUCCESS)
        {
            call Leds.led1Toggle();

            if( outgoingMsg->rootID == TOS_NODE_ID )
                ++(outgoingMsg->seqNum);
        }

        state &= ~STATE_SENDING;
        signal TimeSyncNotify.msg_sent();
    }
    

    void task processMsg()
    {
        TimeSyncMsg* msg = (TimeSyncMsg*)(call Send.getPayload(processedMsg, sizeof(TimeSyncMsg)));

        if( ROOT_ID == msg->rootID && (int8_t)(msg->seqNum - outgoingMsg->seqNum) > 0 ) {
            outgoingMsg->seqNum = msg->seqNum;
        }
        else
            goto exit;

        call Leds.led0Toggle();

        addNewEntry(msg);
        calculateConversion();
        signal TimeSyncNotify.msg_received();
        post sendMsg();

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
        /* RING of 18 sensor nodes */
//         if(TOS_NODE_ID == 1){
//             if( incomingID !=18 && incomingID!=2)
//               return msg;
//         }
//         else if(TOS_NODE_ID == 18){
//           if( incomingID !=1 && incomingID!=17)
//             return msg;
//         }
//         else if( diff < -1 || diff > 1 )
//           return msg;

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

    void timeSyncMsgSend()
    {
    	state |= STATE_SENDING;
        post sendMsg();
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
            localAverage = 0;
            offsetAverage = 0;
        };

        clearTable();

        atomic outgoingMsg = (TimeSyncMsg*)call Send.getPayload(&outgoingMsgBuffer, sizeof(TimeSyncMsg));
        outgoingMsg->rootID = ROOT_ID;

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
        outgoingMsg->nodeID = TOS_NODE_ID;
        
        if(TOS_NODE_ID == ROOT_ID)
        	call TimeSyncMode.setMode(TS_TIMER_MODE);

        return SUCCESS;
    }

    command error_t StdControl.stop()
    {
        call Timer.stop();
        return SUCCESS;
    }

    async command float     TimeSyncInfo.getSkew() { return skew; }
    async command uint32_t  TimeSyncInfo.getOffset() { return offsetAverage; }
    async command uint32_t  TimeSyncInfo.getSyncPoint() { return localAverage; }
    async command uint16_t  TimeSyncInfo.getRootID() { return outgoingMsg->rootID; }
    async command uint8_t   TimeSyncInfo.getSeqNum() { return outgoingMsg->seqNum; }
    async command uint8_t   TimeSyncInfo.getNumEntries() { return numEntries; }
    async command uint8_t   TimeSyncInfo.getHeartBeats() { return 0; }

    default event void TimeSyncNotify.msg_received(){}
    default event void TimeSyncNotify.msg_sent(){}

    event void RadioControl.startDone(error_t error){}
    event void RadioControl.stopDone(error_t error){}
    
}
