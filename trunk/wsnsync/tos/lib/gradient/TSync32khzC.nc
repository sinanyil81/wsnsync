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

configuration TSync32khzC{

  provides {
    interface StdControl as TSyncControl;
    interface TSyncTime;
  }
  
  uses interface Boot;
  uses interface MessageCounter;
}
implementation {
  components LedsC,RandomC;
  components new TimerMilliC() as Timer0;
  components new TimerMilliC() as Timer1;
  components TimeSyncMessageC;
  components Counter32khz32C, new CounterToLocalTimeC(T32khz) as LocalTime32khzC;
  LocalTime32khzC.Counter -> Counter32khz32C;
  
  components new TSyncModuleP(T32khz) as TSync;
  components new TSyncCommP(T32khz) as TComm;
  components TSyncRepositoryC;
  
  TSync.Leds            -> LedsC;
  TSync.TSyncComm       -> TComm;
  TSync.TSyncRepository -> TSyncRepositoryC;
  TSync.RootTimer       -> Timer0;
  TSync.LocalTime       -> LocalTime32khzC;
  MessageCounter        = TSync; 
  TSyncControl          = TSync;
  TSyncTime             = TSync;
  
  TComm.AMControl       -> TimeSyncMessageC;
  TComm.AMSend          -> TimeSyncMessageC.TimeSyncAMSend32khz[AM_TSYNCMSG_T];
  TComm.TimeSyncPacket  -> TimeSyncMessageC;
  TComm.Receive         -> TimeSyncMessageC.Receive[AM_TSYNCMSG_T];
  TComm.BroadcastTimer  -> Timer1;
  TComm.Leds            -> LedsC;
  TComm.Random          -> RandomC;
  TComm.TSyncReceive    -> TSync;
  Boot                  = TComm;
}
