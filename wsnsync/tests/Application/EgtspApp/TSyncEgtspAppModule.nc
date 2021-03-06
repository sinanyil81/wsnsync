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

#include "TSyncApp.h"
#include "Timer.h"

generic module TSyncEgtspAppModule(typedef precision_tag){

  uses interface AMSend;
  uses interface Receive;
  uses interface Boot;
  uses interface Packet;
  uses interface Leds;

  uses interface PacketTimeStamp<precision_tag,uint32_t>;

  uses interface SplitControl as AMControl;
  uses interface StdControl as TSyncControl;
  uses interface TimeSyncInfo;
  uses interface GlobalTime<TMicro>;
  uses interface Timer<TMilli> as Timer0;
  //uses interface MessageCounter;

}
implementation{

  message_t pktSend;
  bool busy = FALSE;

  uint32_t  clock   = 0;
  uint32_t  clock_gradient   = 0;
  float     skew    = 0;
  uint8_t   synced  = 0;
   
  task void sendTask(){
    
    if(busy==TRUE){
      post sendTask();
      return;
    }

    if (call AMSend.send(AM_BROADCAST_ADDR,&pktSend, sizeof(TSyncAppMsg)) == SUCCESS) {
      busy = TRUE;
    }
    else {
      post sendTask();
    }
  }

  void broadcastINFO(){
    
    TSyncAppMsg *msgptr = (TSyncAppMsg *)(call Packet.getPayload(&pktSend, sizeof(TSyncAppMsg)));

    if (msgptr == NULL){
      return;
    }

    msgptr->nodeid = TOS_NODE_ID;
    msgptr->clock  = clock;
    msgptr->clock_gradient  = clock_gradient;
    msgptr->skew   = *((uint32_t *)&skew);
    msgptr->synced = synced;
      
    post sendTask();
  }
  
  event void AMSend.sendDone(message_t *msg, error_t error){
    if (&pktSend == msg) {
      busy = FALSE;
    }
    else {
      return;
    }
   
    if(error != SUCCESS){

    }
  }

  event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len){

    if(len == sizeof(TSyncAppMsg)){
      TSyncAppMsg *msgptr = (TSyncAppMsg *)payload;
      
      // When the reference node 0 broadcasts a packet, all nodes inside the broadcast domain
      // timestamps that packet and calculates the global time. Then rebroadcasts their estimated 
      // global  time.
      if(msgptr->nodeid == 0){
        if (call PacketTimeStamp.isValid(msg)){
          clock = clock_gradient = call PacketTimeStamp.timestamp(msg);
          synced        = call GlobalTime.local2Global(&clock);
          synced        = call GlobalTime.local2GlobalUTC(&clock_gradient);
          skew          = call TimeSyncInfo.getSkew();
          call Timer0.startOneShot(50*TOS_NODE_ID + 20);
        }
      }
    }

    return msg;
  }

  event void Boot.booted(){
    call AMControl.start();
  }
  
  task void nosleep(){
    post nosleep();
  }
  
  event void AMControl.startDone(error_t error){

    if (error == SUCCESS) {
      call TSyncControl.start();
      post nosleep();
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t error){

  }
 
  event void Timer0.fired(){
    
    broadcastINFO();
  }
}