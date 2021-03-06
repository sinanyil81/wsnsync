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

configuration TSyncRftspAppC{
}
implementation{
  components MainC,LedsC,NoSleepC; 
  components ActiveMessageC as AM;
   
  components new TimerMilliC() as Timer0;
   
  components RftspMicroC as Rftsp;
  components FcsaMicroC as Fcsa;
  components new TSyncRftspAppModule(TMicro) as App; 
  //components MessageCounterC;
  
  MainC.SoftwareInit -> Rftsp;
  MainC.SoftwareInit -> Fcsa;

  Rftsp.Boot            -> MainC; 
  App.RftspTime        	-> Rftsp;
  App.RftspControl      -> Rftsp;
  App.RftspInfo      	-> Rftsp;
  
  Fcsa.Boot            	-> MainC; 
  App.FcsaTime        	-> Fcsa;
  App.FcsaControl      	-> Fcsa;
  App.FcsaInfo      	-> Fcsa;
  
  App.Leds              -> LedsC;
  App.AMControl         -> AM;
  App.AMSend            -> AM.AMSend[AM_TSYNCAPPMSG_T];
  App.Receive           -> AM.Receive[AM_TSYNCAPPMSG_T];
  App.Packet            -> AM;
  App.PacketTimeStamp   -> AM;
  App.Timer0            -> Timer0;
  //App.MessageCounter    -> MessageCounterC;
}
