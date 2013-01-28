#include "SelfMsg.h"

generic module SelfSyncP(typedef precision_tag)
{
    provides
    {
        interface Init;
        interface StdControl;
        interface GlobalTime<precision_tag>;
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
        
        interface SelfClock;
        interface Avt;        

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

	#define MAX_PPM 0.0001
	#define MIN_PPM -0.0001

    enum {
        BEACON_RATE  = 30,  // how often send the beacon msg (in seconds)       
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
    SelfMsg* outgoingMsg;

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
		/* TODO */
		
      	return SUCCESS;
    }


    async command error_t GlobalTime.local2Global(uint32_t *time)
    {
		call SelfClock.getValue(time);    	
	   	
	   	return is_synced();
    }
    
    async command error_t GlobalTime.local2GlobalUTC(uint32_t *time)
    {    	
    	call GlobalTime.local2Global(time);    	    	   	        
        *time += call SelfClock.getUTCOffset();
        
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
		uint32_t myClock,myOffset;
		int32_t skew;         
        
        SelfMsg* msg = (SelfMsg*)(call Send.getPayload(processedMsg, sizeof(SelfMsg)));
        call SelfClock.update(processedMsgEventTime);
        
		call SelfClock.getValue(&myClock);
		myOffset = call SelfClock.getOffset();
		
		int32_t skew = myClock - msg->globalTime;
		int32_t threshold = (int32_t)((MAX_PPM - MIN_PPM)*1000000.0*(double)BEACON_RATE); 

		if (skew < -threshold) {
			call SelfClock.setOffset(myOffset-skew);
		} else if (skew > threshold) {
			// do nothing
		} else if (skew > TOLERANCE) {
			call Avt.adjustValue(FEEDBACK_LOWER);
			call SelfClock.setRate(call Avt.getValue());
		} else if (skew < (-1.0) * TOLERANCE) {
			call Avt.adjustValue(FEEDBACK_GREATER);
			call SelfClock.setRate(call Avt.getValue());
			call SelfClock.setOffset(myOffset-skew);
		} else {
			call Avt.adjustValue(FEEDBACK_GOOD);
			call SelfClock.setRate(call Avt.getValue());
		}        

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

  	  	/* 5X4 GRID topology */
//  	  if(TOS_NODE_ID % 4 == 1) {
//  	  	if(!(diff == 1 || diff == -4 || diff == 4 )){
//  	  		return msg;
//  	  	}
//  	  }
//  	  else if (TOS_NODE_ID % 4 == 0) {
//  	  	if(!(diff == -1 || diff == -4 || diff == 4 )){
//  	  		return msg;
//  	  	}
//  	  }
//  	  else if(!(diff == -1 || diff == 1 || diff == -4 || diff == 4 )){
//      	return msg;
//      }

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
        uint32_t localTime, globalTime;

        globalTime = localTime = call GlobalTime.getLocalTime();                    	
        call GlobalTime.local2Global(&globalTime);
                        
        outgoingMsg->globalTime = globalTime;
        
        
#ifdef LOW_POWER_LISTENING
        call LowPowerListening.setRemoteWakeupInterval(&outgoingMsgBuffer, LPL_INTERVAL);
#endif
         if( call Send.send(AM_BROADCAST_ADDR, &outgoingMsgBuffer, SELFMSG_LEN, localTime ) != SUCCESS ){
            state &= ~STATE_SENDING;
        }
    }

    event void Send.sendDone(message_t* ptr, error_t error)
    {
        if (ptr != &outgoingMsgBuffer)
          return;

        if(error == SUCCESS)
        {         

        }       

        state &= ~STATE_SENDING;
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
        
        /* init logical clock */ 
        call SelfClock.start();  
        
        /* init adaptive value tracker */      
        call Avt.init(MIN_PPM,MAX_PPM,0); 

        atomic outgoingMsg = (SelfMsg*)call Send.getPayload(&outgoingMsgBuffer, sizeof(SelfMsg));

        outgoingMsg->nodeID = TOS_NODE_ID;

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
    
    event void RadioControl.startDone(error_t error){}
    event void RadioControl.stopDone(error_t error){}
}
