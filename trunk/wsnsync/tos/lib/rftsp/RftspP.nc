#include "RftspMsg.h"

generic module RftspP(typedef precision_tag)
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
        interface Neighbors;      

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
        BEACON_RATE           = TIMESYNC_RATE,  // how often send the beacon msg (in seconds)
    };

    enum {
        STATE_IDLE = 0x00,
        STATE_PROCESSING = 0x01,
        STATE_SENDING = 0x02,
        STATE_INIT = 0x04,
    };
	
	uint32_t rootClock = 0;
	float rootRate = 0.0;
	uint32_t lastUpdate = 0;	

    uint8_t state, mode;

    message_t processedMsgBuffer;
    message_t* processedMsg;    

    message_t outgoingMsgBuffer;
    RftspMsg* outgoingMsg;

    uint32_t processedMsgEventTime;

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
//       if (numEntries>=ENTRY_VALID_LIMIT || outgoingMsg->rootID==TOS_NODE_ID)
//         return SUCCESS;
//       else
//         return FAIL;
      return SUCCESS;
    }


    async command error_t GlobalTime.local2Global(uint32_t *time)
    {
        call GlobalTime.global2Local(time);
        return is_synced();
    }

    async command error_t GlobalTime.global2Local(uint32_t *time)
    {
    	*time = rootClock + (int32_t)(*time - lastUpdate) + (int32_t)(rootRate * (int32_t)(*time - lastUpdate));
        return is_synced();
    }

    void task processMsg()
    {
    	float neighborRate = 0.0,receivedRate = 0.0,estimatedRate = 0.0f;
        error_t status;
        
        RftspMsg* msg = (RftspMsg*)(call Send.getPayload(processedMsg, sizeof(RftspMsg)));

//         call Neighborhood.updateNeighbors(call LocalTime.get());
        
        status = call Neighbors.storeInfo(msg->nodeID,msg->localTime,processedMsgEventTime);
        
        if(status == FAIL){
            goto exit;           
        }
                                                         
		if( msg->rootID < outgoingMsg->rootID){atomic rootRate = estimatedRate;
            outgoingMsg->rootID = msg->rootID;
            outgoingMsg->seqNum = msg->seqNum;
            
            atomic rootClock = msg->rootClock;
            atomic lastUpdate = processedMsgEventTime;
            
            if(call Neighbors.getRelativeRate(msg->nodeID,&neighborRate) == SUCCESS){
	            uint32_t tmp = msg->rootRate;
            	receivedRate = *((float *)&tmp);
            	estimatedRate = (receivedRate  + 1.0)* (neighborRate + 1.0) - 1.0;
            }
            
            atomic rootRate = estimatedRate;
        }
        else if( outgoingMsg->rootID == msg->rootID && (int8_t)(msg->seqNum - outgoingMsg->seqNum) > 0 ) {
            outgoingMsg->seqNum = msg->seqNum;
            
            atomic rootClock = msg->rootClock;
            atomic lastUpdate = processedMsgEventTime;
            
            if(call Neighbors.getRelativeRate(msg->nodeID,&neighborRate) == SUCCESS){
            	uint32_t tmp = msg->rootRate;
            	receivedRate = *((float *)&tmp);
            	estimatedRate = (receivedRate  + 1.0)* (neighborRate + 1.0) - 1.0;
            }
            
            atomic rootRate = estimatedRate;
        }
 		
 		call Leds.led1Toggle();
        signal TimeSyncNotify.msg_received();
        
    exit:
        state &= ~STATE_PROCESSING;
    }

    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)
    {
        /* TODO */
        uint16_t incomingID = (uint8_t)((RftspMsg*)payload)->nodeID;
        int16_t diff = (incomingID - TOS_NODE_ID);
        /* LINE topology */
        if( diff < -1 || diff > 1 )
            return msg;
        /* TODO */

        if( (state & STATE_PROCESSING) == 0 && call TimeSyncPacket.isValid(msg)) {
            message_t* old = processedMsg;

            processedMsg = msg;
            processedMsgEventTime = call TimeSyncPacket.eventTime(msg);

            state |= STATE_PROCESSING;
            post processMsg();

            return old;
        }

        return msg;
    }

    task void sendMsg()
    {
        uint32_t localTime, rootTime;
        float multiplier;

        rootTime = localTime = call GlobalTime.getLocalTime();
        call GlobalTime.local2Global(&rootTime);

		/* update root time */
        if( outgoingMsg->rootID == TOS_NODE_ID ) {
            atomic rootClock = rootTime;
			atomic lastUpdate = localTime;
        }
        
        outgoingMsg->rootRate = *((uint32_t*)(&rootRate));
        outgoingMsg->localTime = localTime;
        outgoingMsg->rootClock = rootTime;
        
#ifdef LOW_POWER_LISTENING
        call LowPowerListening.setRemoteWakeupInterval(&outgoingMsgBuffer, LPL_INTERVAL);
#endif
         if( call Send.send(AM_BROADCAST_ADDR, &outgoingMsgBuffer, RFTSPMSG_LEN, localTime ) != SUCCESS ){
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
            if( TOS_NODE_ID == outgoingMsg->rootID ){
                outgoingMsg->seqNum++;
                call Leds.led2Toggle();
            }   
        }      

        state &= ~STATE_SENDING;
        signal TimeSyncNotify.msg_sent();
    }

    void timeSyncMsgSend()
    {
        if( (state & STATE_SENDING) == 0 ) {
           state |= STATE_SENDING;
           post sendMsg();
        }
    }

    event void Timer.fired()
    {
      if (mode == RFTSP_TIMER_MODE) {
        timeSyncMsgSend();
      }
      else
        call Timer.stop();
    }

    command error_t TimeSyncMode.setMode(uint8_t mode_){
        if (mode_ == RFTSP_TIMER_MODE){
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
        if (mode == RFTSP_USER_MODE){
            timeSyncMsgSend();
            return SUCCESS;
        }
        return FAIL;
    }

    command error_t Init.init()
    {   
        
        call Neighbors.reset();
        atomic outgoingMsg = (RftspMsg*)call Send.getPayload(&outgoingMsgBuffer, sizeof(RftspMsg));

		outgoingMsg->rootID = TOS_NODE_ID;
        outgoingMsg->nodeID = TOS_NODE_ID;
        outgoingMsg->seqNum = 0;

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
        call TimeSyncMode.setMode(RFTSP_TIMER_MODE);

        return SUCCESS;
    }

    command error_t StdControl.stop()
    {
        call Timer.stop();
        return SUCCESS;
    }

    async command float     TimeSyncInfo.getSkew() { return rootRate; }
    async command uint16_t  TimeSyncInfo.getRootID() { return outgoingMsg->rootID;}
    async command uint8_t   TimeSyncInfo.getSeqNum() { return outgoingMsg->seqNum; }

    default event void TimeSyncNotify.msg_received(){}
    default event void TimeSyncNotify.msg_sent(){}

    event void RadioControl.startDone(error_t error){}
    event void RadioControl.stopDone(error_t error){}
}
