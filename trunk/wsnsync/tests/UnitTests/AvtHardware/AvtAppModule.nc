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

#include "Timer.h"
#include "Avt.h"

module AvtAppModule{

  uses interface AMSend as SerialSend;
  uses interface SplitControl as SerialControl;
  uses interface Packet as SerialPacket;
  uses interface Avt;
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface LocalTime<TMicro> as LocalTime;
}
implementation{
  
  message_t serialBuffer;
  bool serialLock = FALSE; 
  
  float val = 0.0f;

  void sendSerial(){
   
    if (serialLock) {
      return;
    }
    else {
      serial_msg_t* rcm = (serial_msg_t*)call SerialPacket.getPayload(&serialBuffer, sizeof(serial_msg_t));
      
      if (rcm == NULL) {return;}

      rcm->nodeid = TOS_NODE_ID;
      rcm->clock = 0;
      rcm->skew = *((uint32_t *)&val);
      
      
      if (call SerialSend.send(AM_BROADCAST_ADDR, &serialBuffer, sizeof(serial_msg_t)) == SUCCESS) {
        serialLock = TRUE;
      }
    }
  }
 
  event void SerialSend.sendDone(message_t* bufPtr, error_t error) {
    if (&serialBuffer == bufPtr) {
      serialLock = FALSE;
    }
  }    
  
  event void Boot.booted(){
    call SerialControl.start();
    call Timer0.startPeriodic(5000);
    call Avt.init();
  }
  
  event void SerialControl.startDone(error_t err) {}
  event void SerialControl.stopDone(error_t err) {}
  
  uint8_t feedback = FEEDBACK_LOWER;
  
  event void Timer0.fired(){    
    call Avt.adjustValue(FEEDBACK_LOWER);
    call Avt.adjustValue(FEEDBACK_GREATER);
    	
    //val = call Avt.getValue();
    val = call Avt.getDelta();
    sendSerial();    
    call Leds.led0Toggle();
  }
}