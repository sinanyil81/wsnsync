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

generic module TSyncCommP (typedef am_precision_tag){

  provides {
    interface TSyncComm;
    interface StdControl;
    interface Init;
  } 

  uses {
    interface Boot;
    interface SplitControl as AMControl;       
    interface TimeSyncAMSend<am_precision_tag,uint32_t> as AMSend;
    interface TimeSyncPacket<am_precision_tag,uint32_t>;    
    interface Receive;
    interface Leds;
    
    interface TSyncReceive;    
  } 
}
implementation {
  
  message_t msgSendBuffer;
  TSyncMsg *msgSend;
  bool busy = FALSE;

  command error_t TSyncComm.broadcast(TSyncMsg *p, uint16_t dest, uint32_t sTimestamp){
    
    if(busy == FALSE){
      busy  = TRUE;
      memcpy(msgSend,p,sizeof(TSyncMsg));
      call AMSend.send(dest,&msgSendBuffer,sizeof(TSyncMsg),sTimestamp);
      
      return SUCCESS;
    }
    
    return FAIL;
  }       
  
  event void AMSend.sendDone(message_t *msg, error_t error){

    if (msg != &msgSendBuffer)
      return;
    
    busy = FALSE;
  }
                             
  event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len){
   
    if(len == sizeof(TSyncMsg))
    {
      TSyncMsg *msgptr = (TSyncMsg*)payload;

      /* NOTE test */
      uint16_t incomingID = msgptr->id;
      int16_t diff = (incomingID - TOS_NODE_ID);
      
      /* NOTE for test LINE --------------------------------------------*/
//       if( diff < -1 || diff > 1 )
//         return msg;
      /* NOTE for test -------------------------------------------------*/

      /* NOTE for test RING --------------------------------------------*/
      if(TOS_NODE_ID == 1){
        if( incomingID !=20 && incomingID!=2)
          return msg;
      }
      else if(TOS_NODE_ID == 20){
        if( incomingID !=1 && incomingID!=19)
          return msg;
      }
      else if( diff < -1 || diff > 1 )
         return msg;
      /* NOTE for test -------------------------------------------------*/
      
      if(call TimeSyncPacket.isValid(msg)){
        call TSyncReceive.receive(msgptr,call TimeSyncPacket.eventTime(msg));
      }
    }

    return msg;
  }
  
  event void Boot.booted(){
    call AMControl.start();
  }
  
  command error_t Init.init()
  {
    msgSend = (TSyncMsg *)(call AMSend.getPayload(&msgSendBuffer, sizeof(TSyncMsg)));
    return SUCCESS;
  }  

  event void AMControl.stopDone(error_t error){

  }

  event void AMControl.startDone(error_t error){

    if (error == SUCCESS) {
      call StdControl.start();
    }
    else {
      call AMControl.start();
    }
  }

  command error_t StdControl.start(){
                 
      return SUCCESS;
  }

  command error_t StdControl.stop(){
    
    return SUCCESS;
  }
  
}
