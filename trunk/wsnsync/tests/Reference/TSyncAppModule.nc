/*
* Copyright (c) 2012, Ege University
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
* - Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the
* distribution.
* - Neither the name of the copyright holders nor the names of
* its contributors may be used to endorse or promote products derived
* from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
* THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*
* @author K. Sinan YILDIRIM (sinanyil81@gmail.com)
*
*/
#include "TSyncApp.h"

module TSyncAppModule{

  uses interface AMSend;
  uses interface Boot;
  uses interface Packet;
  uses interface Leds;
  uses interface SplitControl as AMControl;
  uses interface Timer<TMilli> as Timer0;
  uses interface Random;
}
implementation{
  
  message_t pktSend;
  bool busy = FALSE;
    
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

  void broadcastQUERY(){

    TSyncAppMsg *msgptr = (TSyncAppMsg *)(call Packet.getPayload(&pktSend, sizeof(TSyncAppMsg)));

    if (msgptr == NULL){
      return;
    }
    
    msgptr->nodeid  = TOS_NODE_ID;    
    msgptr->clock = (call Timer0.getNow())/1024;
    
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

  event void Boot.booted(){
    call AMControl.start();
  }

  event void AMControl.startDone(error_t error){

    if (error == SUCCESS) {
      call Timer0.startOneShot(3000);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t error){

  }

  event void Timer0.fired(){

    uint32_t period = PERIOD;
    
    broadcastQUERY();

    call Leds.led0Toggle();
    call Leds.led1Toggle();
    call Leds.led2Toggle();
    
    period += (call Random.rand16()%4)*1000;
    
    call Timer0.startOneShot(period);
  }
}