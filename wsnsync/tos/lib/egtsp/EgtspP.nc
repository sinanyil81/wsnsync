#include "EgtspMsg.h"

generic module EgtspP(typedef precision_tag)
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
        interface EgtspNeighborTable;
        interface EgtspClock;        

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
        BEACON_RATE  = TIMESYNC_RATE,  // how often send the beacon msg (in seconds)
        CLOCK_ERROR_LIMIT = 1000
    };

    enum {
        STATE_IDLE = 0x00,
        STATE_PROCESSING = 0x01,
        STATE_SENDING = 0x02,
        STATE_INIT = 0x04,
    };


    uint8_t state, mode;

    message_t processedMsgBuffer;
    message_t* processedMsg;    

    message_t outgoingMsgBuffer;
    EgtspMsg* outgoingMsg;

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
    	call EgtspClock.getValue(time);
	   	
	   	return is_synced();
    }
    
    async command error_t GlobalTime.local2GlobalUTC(uint32_t *time)
    {
    	int32_t offset;
    	
    	call GlobalTime.local2Global(time);
    	call EgtspClock.getUTCOffset(&offset);
    	    	   	        
        *time -= offset;
        
        call EgtspClock.getOffset(&offset); 
        *time = offset;
        
        *time = call EgtspNeighborTable.getNumNeighbors();
        
        return is_synced();
    }

	/**
	* TODO
	*/
    async command error_t GlobalTime.global2Local(uint32_t *time)
    {
//         uint32_t approxLocalTime = *time - offsetAverage;
//         *time = approxLocalTime - (int32_t)(skew * (int32_t)(approxLocalTime - localAverage));
        return is_synced();
    }

    void task processMsg()
    {
        uint32_t mult,rootMult;
        float rate;
        error_t status;
        int32_t offset;
        uint32_t time = processedMsgEventTime;
                
        EgtspMsg* msg = (EgtspMsg*)(call Send.getPayload(processedMsg, sizeof(EgtspMsg)));

		/* calculate logical clock value */
        call EgtspClock.getValue(&time);

		/* insert new neighbor data */
        mult = msg->multiplier;
        rootMult = msg->rootMultiplier;
        status = call EgtspNeighborTable.storeInfo(msg->nodeID,
                                        	      *((float *)&mult),
                                        	      *((float *)&rootMult),
                                            	  msg->localTime,
                                                  msg->globalTime,
                                                  processedMsgEventTime);
		
		/* update neighborhood */
		call EgtspNeighborTable.update(processedMsgEventTime);		
				
		/* calculate and set new logical clock rate multiplier */		
        call EgtspClock.getRate(&rate);
        call EgtspNeighborTable.getNeighborhoodRate(&rate);        
        call EgtspClock.setRate(rate);                
        if(TOS_NODE_ID == ROOT_ID){
        	call EgtspClock.setRootRate(rate);
        }                       
                	
        /* calculate and set new logical clock offset */
        //call EgtspClock.setValue(time,processedMsgEventTime);
        call EgtspClock.update(processedMsgEventTime);
        
        call EgtspClock.getOffset(&offset);
        call EgtspNeighborTable.getNeighborhoodOffset(&offset,time,processedMsgEventTime);
        call EgtspClock.setOffset(offset);               	                             
          
        if( (int8_t)(msg->seqNum - outgoingMsg->seqNum) > 0 ) {
            outgoingMsg->seqNum = msg->seqNum;
        }
        else
            goto exit;       

 		if( status == SUCCESS ){
 			/* check wheter the error is large or not */
 			int32_t timeError = (int32_t)(time - msg->globalTime);
 			if((timeError > CLOCK_ERROR_LIMIT) || (timeError < -CLOCK_ERROR_LIMIT))
        	{
        		//call EgtspClock.setValue(msg->globalTime,processedMsgEventTime);
            	call EgtspClock.setOffset(0);
        	}
 			
 			/* store root's logical clock rate multiplier */
            mult = msg->rootMultiplier;
            call EgtspClock.setRootRate(*((float *)&mult));           
            /* store root's offset = (logical clock - local clock) */
            call EgtspClock.setUTCOffset(msg->rootOffset);
            
            call Leds.led1Toggle();
        }
         
        signal TimeSyncNotify.msg_received();

    exit:
        state &= ~STATE_PROCESSING;
    }

    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)
    {
        /* TODO */
        uint16_t incomingID = (uint8_t)((EgtspMsg*)payload)->nodeID;
        int16_t diff = (incomingID - TOS_NODE_ID);

//        /* LINE topology */
        if( diff < -1 || diff > 1 )
            return msg;
//        /* TODO */
        
        /* RING of 20 sensor nodes */
//        if(TOS_NODE_ID == 1){
//        	if( incomingID !=20 && incomingID!=2)
//            	return msg;
//        }
//        else if(TOS_NODE_ID == 20){
//        	if( incomingID !=1 && incomingID!=19)
//            	return msg;
//        }
//        else if( diff < -1 || diff > 1 )
//        	return msg;

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
        uint32_t localTime, globalTime,offset;
        float multiplier;

        globalTime = localTime = call GlobalTime.getLocalTime();                    	
        call GlobalTime.local2Global(&globalTime);
                        
        call EgtspClock.getRate(&multiplier);
        outgoingMsg->multiplier = *((uint32_t*)(&multiplier));
               
        call EgtspClock.getRootRate(&multiplier);   	
        outgoingMsg->rootMultiplier = *((uint32_t*)(&multiplier));
               
        outgoingMsg->localTime = localTime;
        outgoingMsg->globalTime = globalTime;
        
        if(TOS_NODE_ID == ROOT_ID){
        	offset = globalTime - localTime;
        	call EgtspClock.setUTCOffset(offset);
        }
        else{
        	call EgtspClock.getUTCOffset(&offset);
        }
        
        outgoingMsg->rootOffset = offset;
        
#ifdef LOW_POWER_LISTENING
        call LowPowerListening.setRemoteWakeupInterval(&outgoingMsgBuffer, LPL_INTERVAL);
#endif
         if( call Send.send(AM_BROADCAST_ADDR, &outgoingMsgBuffer, EGTSPMSG_LEN, localTime ) != SUCCESS ){
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
            if( TOS_NODE_ID == ROOT_ID ){
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
        
        call EgtspNeighborTable.reset();
        call EgtspClock.start();        

        atomic outgoingMsg = (EgtspMsg*)call Send.getPayload(&outgoingMsgBuffer, sizeof(EgtspMsg));

        outgoingMsg->nodeID = TOS_NODE_ID;
        outgoingMsg->seqNum = 0;

        if(TOS_NODE_ID == ROOT_ID)
            call Leds.led0On();

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
        call TimeSyncMode.setMode(TS_TIMER_MODE);

        return SUCCESS;
    }

    command error_t StdControl.stop()
    {
        call Timer.stop();
        return SUCCESS;
    }

    async command float TimeSyncInfo.getSkew() {
    	float rate;   	
    	call EgtspClock.getRate(&rate);
    	 
    	return rate; 
    }
    
    async command uint16_t  TimeSyncInfo.getRootID() { return ROOT_ID; }
    async command uint8_t   TimeSyncInfo.getSeqNum() { return outgoingMsg->seqNum; }

    default event void TimeSyncNotify.msg_received(){}
    default event void TimeSyncNotify.msg_sent(){}

    event void RadioControl.startDone(error_t error){}
    event void RadioControl.stopDone(error_t error){}
}
