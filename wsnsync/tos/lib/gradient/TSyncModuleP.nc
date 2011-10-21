/*
* Copyright (c) 2011, Ege University
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
* @author: K. Sinan YILDIRIM <sinanyil81@gmail.com>
*/

#include <Timer.h>
#include "TSync.h"

generic module TSyncModuleP (typedef precision_tag){

  provides {
    interface GlobalTime;
    interface TSyncReceive;
    interface Init;
    interface StdControl;
  } 

  uses {
    interface Leds;   
    interface Boot;
    interface Random;
    interface TSyncComm;
    interface Estimator as GlobalEstimate;
    interface Estimator as LocalEstimate;
    interface Timer<TMilli> as BeaconTimer;
    interface LocalTime<precision_tag> as LocalTime;
    interface MessageCounter;
  } 
}
implementation {
  
  enum {
    STATE_IDLE = 0x00,
    STATE_SENT = 0x01,
    STATE_REPLY= 0x02,
    STATE_RECEIVE = 0x04,
  };

  enum {
    MAX_ERROR = 100,
  };
  
  /* up to approximately 4 second random offset */
  #define RANDOM_OFFSET (call Random.rand16()&0xFFF)
  
  bool busy = FALSE;
  TSyncMsg sPacket;

  uint16_t root; 

  bool     status;
  
  uint32_t beaconLocal;
  uint32_t beaconGlobal;
  uint8_t  index;  
  uint32_t local;
  uint32_t global;
  
  void searchReply(TSyncMsg *msgptr){
    int i;
    /* search for REPLY */
    for(i = 0;i<MAX_NEIGHBOR;i++){
      int32_t error = (int32_t)(beaconGlobal - msgptr->reply[i].clock);                    
      if(error < MAX_ERROR && error > -MAX_ERROR){
        call LocalEstimate.addEntry(beaconLocal,msgptr->reply[i].clock);
        status |= STATE_REPLY;
      }
    }
  }

  command error_t TSyncReceive.receive(TSyncMsg *msgptr, uint32_t rTimestamp){
   
    
    call MessageCounter.incrementReceived();
    
    if(msgptr->root < root){
      return SUCCESS;
    }
    else if(msgptr->root > root){
      call GlobalEstimate.clear();
      call LocalEstimate.clear();
      root = msgptr->root;     
      status = STATE_IDLE;
    }
     
    if(status & STATE_SENT){  
      searchReply(msgptr);
    }
    
    /* send REPLY */
    sPacket.reply[index].clock = call GlobalEstimate.estimateY(rTimestamp);
    index = (index + 1) % MAX_NEIGHBOR;
      
    local = rTimestamp;
    global = msgptr->clock;      
    status |= STATE_RECEIVE;
    
    call Leds.led1Toggle();
    
    return SUCCESS;
  }  
  
  void update(){    
    /* Check if we received any BEACON */
    if(status & STATE_RECEIVE){
      /* Check if there are neighbors which has sent REPLY to our BEACON */
      if(status & STATE_REPLY){
        call GlobalEstimate.addEntry(beaconLocal,call LocalEstimate.estimateY(beaconLocal));
        call Leds.led2Toggle();
      }
      else if(call GlobalEstimate.isValid() == SUCCESS){
          call LocalEstimate.clear();
          call LocalEstimate.addEntry(local,global);
          call LocalEstimate.addEntry(local,call GlobalEstimate.estimateY(local));
          call GlobalEstimate.addEntry(local,call LocalEstimate.estimateY(local));
      }
      else{
        call GlobalEstimate.addEntry(local,global);
      }
    }

    call LocalEstimate.clear();
  }
  
  void clearPacket(){
    int i;
    
    /* clear REPLY */
    for(i = 0;i<MAX_NEIGHBOR;i++){
      sPacket.reply[i].clock = 0;
    }
          
    index = 0;
  }
  
  void sendBeacon(){
    
    
    beaconLocal = call LocalTime.get();
    if(call GlobalEstimate.isValid() == SUCCESS){
      beaconGlobal = call GlobalEstimate.estimateY(beaconLocal);
    }
    else{
      beaconGlobal = beaconLocal;
    }
    
    sPacket.root  = root;  
    sPacket.id    = TOS_NODE_ID;    
    sPacket.clock = beaconGlobal;

    call TSyncComm.broadcast(&sPacket,AM_BROADCAST_ADDR,beaconLocal);
    
    /* add our estimate to table */
    call LocalEstimate.addEntry(beaconLocal,beaconGlobal);
    
    call MessageCounter.incrementSent();
    call Leds.led0Toggle();
  }
  
  event void BeaconTimer.fired(){
        
    update();
            
    if((call GlobalEstimate.isValid() == SUCCESS) || (root == TOS_NODE_ID)){
      sendBeacon();
      status = STATE_SENT;
    }
    else{
      status = STATE_IDLE;
    }
    
    clearPacket();
    call BeaconTimer.startOneShot(BEACON_PERIOD + RANDOM_OFFSET);
  }
  
  command uint32_t GlobalTime.getLocalTime(){
    return call LocalTime.get();
  }
      
  command error_t GlobalTime.getGlobalTime(uint32_t *time){
    *time = call GlobalTime.getLocalTime();
    *time = call GlobalEstimate.estimateY(*time);
    return call GlobalEstimate.isValid();
  }
  
  command error_t GlobalTime.local2Global(uint32_t *time){
    
    *time = call GlobalEstimate.estimateY(*time);
    return call GlobalEstimate.isValid();
  }
      
  command error_t GlobalTime.global2Local(uint32_t *time){
    *time = call GlobalEstimate.estimateX(*time);
    return call GlobalEstimate.isValid();
  }
  
  command error_t Init.init()
  {
    call GlobalEstimate.clear();
    call LocalEstimate.clear();
    
    return SUCCESS;
  }  
  
  event void Boot.booted()
  {
    call StdControl.start();
  }  

  command error_t StdControl.start(){
    
    root        = TOS_NODE_ID;
    beaconLocal = 0;
    status      = STATE_IDLE;
    
    clearPacket();
        
    call BeaconTimer.startOneShot(BEACON_PERIOD + RANDOM_OFFSET);
        
    return SUCCESS;
  }

  command error_t StdControl.stop(){
    
    call BeaconTimer.stop();
    return SUCCESS;
  }
  
}
