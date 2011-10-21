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


configuration TSyncMicroC{
  
  provides {
    interface StdControl as TSyncControl;
    interface GlobalTime;
    interface Init as Init;
  }
  
  uses interface Boot;
  uses interface MessageCounter;
}
implementation {

  components LedsC,RandomC;
  components new TimerMilliC() as Timer0;
  components LocalTimeMicroC;
  components TimeSyncMessageC as TSMessage;  
  components new TSyncModuleP(TMicro) as TSync;
  components new TSyncCommP(TMicro) as TComm;
  
  components new RegressionC() as GlobalEstimate;
  components new RegressionC() as LocalEstimate;

  TSync.Leds            -> LedsC;
  TSync.TSyncComm       -> TComm;
  TSync.GlobalEstimate  -> GlobalEstimate;
  TSync.LocalEstimate   -> LocalEstimate;
  TSync.BeaconTimer     -> Timer0;
  TSync.LocalTime       -> LocalTimeMicroC;
  TSync.Random          -> RandomC;
  
  MessageCounter        = TSync;  
  TSyncControl          = TSync;
  GlobalTime            = TSync;
  
  TComm.AMControl       -> TSMessage;
  TComm.AMSend          -> TSMessage.TimeSyncAMSendRadio[AM_TSYNCMSG_T];
  TComm.TimeSyncPacket  -> TSMessage;
  TComm.Receive         -> TSMessage.Receive[AM_TSYNCMSG_T];
  TComm.Leds            -> LedsC;
  TComm.TSyncReceive    -> TSync;
  Boot                  = TComm;
  Boot                  = TSync;
  Init                  = TComm;
  Init                  = TSync;
}

