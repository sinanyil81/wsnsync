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

module CpuAppModule{

  uses interface AMSend as SerialSend;
  uses interface SplitControl as SerialControl;
  uses interface Packet as SerialPacket;
  
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface LocalTime<TMicro> as LocalTime;
}
implementation{
  
  typedef struct TableItem
  {
    uint8_t     state;
    uint32_t    localTime;
    int32_t     timeOffset;                     // globalTime - localTime
  } TableItem;
  
  TableItem   table[8];
  TableItem   table16[16];  
  TableItem   tableMedian8[8];
  TableItem   tableMedian16[16];
  
  uint8_t tableEntries      = 8;
  uint8_t tableEntries16    = 16;  
  uint8_t tableEntriesMedian8   = 8;
  uint8_t tableEntriesMedian16  = 16;
  
  float       skew;
  float       skew16;  
  float       medianSkew8;
  float       medianSkew16;
  
  uint32_t    localAverage;
  uint32_t    localAverage16;  
  uint32_t    localAverageMedian8;
  uint32_t    localAverageMedian16;
  
  int32_t     offsetAverage;
  int32_t     offsetAverage16;  
  int32_t     offsetAverageMedian8;
  int32_t     offsetAverageMedian16;
  
  int64_t localSum;
  int64_t offsetSum;
  int32_t localAverageRest;
  int32_t offsetAverageRest;
  
  uint32_t newLocalAverage;
  uint32_t newLocalAverage16;  
  uint32_t newLocalAverageMedian8;
  uint32_t newLocalAverageMedian16;
  
  int32_t newOffsetAverage;
  int32_t newOffsetAverage16;  
  int32_t newOffsetAverageMedian8;
  int32_t newOffsetAverageMedian16;
  
  float newSkew;
  float newSkew16;
  float newSkewMedian8;
  float newSkewMedian16;
  
  uint32_t cpuReg8;
  uint32_t cpuReg16;
  uint32_t cpuMed8;
  uint32_t cpuMed16;

  message_t serialBuffer;
  bool serialLock = FALSE;
  
  float conSlopes[16];
  
  void theil(TableItem *tbl,uint8_t tblEntries,uint32_t *nLA,int32_t *nOA,float *nS){
    int32_t numConSlopes = 0;
    int8_t i,j;

    for(i = 1; i < tblEntries; i++){
      /* compute consecutive slopes */
      {
        int32_t a = (int32_t)(tbl[i].timeOffset - tbl[i-1].timeOffset);
        int32_t b = (int32_t)(tbl[i].localTime  - tbl[i-1].localTime);

        if( b != 0 ){
          conSlopes[numConSlopes++] = (float)a/(float)b;
        }
      }
    }
    
    /* sort slopes: do not need to sort all of the values */
    for(i = 0; i <= (numConSlopes>>1); ++i) {
      float tmp;
      uint8_t min = i;
        
      for(j = i+1; j < numConSlopes; ++j){
        if(conSlopes[min] > conSlopes[j]){
          min = j;
        }
      }
        
      tmp = conSlopes[i];
      conSlopes[i] = conSlopes[min];
      conSlopes[min] = tmp;
    }            

    /* calculate the median of the slopes */
    i = numConSlopes>>1;
    if(numConSlopes & 0x1) {
      *nS = conSlopes[i];
    }
    else{
      *nS = (conSlopes[i] - conSlopes[i-1])/2.0f + conSlopes[i-1];
    }

    localSum = 0;
    localAverageRest = 0;
    offsetSum = 0;
    offsetAverageRest = 0;

    *nLA = tbl[0].localTime;
    *nOA = tbl[0].timeOffset;

    for(i = 1; i < tblEntries; i++){
      localSum += (int32_t)(tbl[i].localTime - *nLA) / tblEntries;
      localAverageRest += (tbl[i].localTime - *nLA) % tblEntries;

      offsetSum += (int32_t)(tbl[i].timeOffset - *nOA) / tblEntries;
      offsetAverageRest += (tbl[i].timeOffset - *nOA) % tblEntries;
    }

    *nLA += localSum + localAverageRest / tblEntries;
    *nOA += offsetSum + offsetAverageRest / tblEntries;        
}
  
  void reg8(){
    
    int8_t i;
      
    cpuReg8 = call LocalTime.get();
    
    localSum = 0;
    localAverageRest = 0;
    offsetSum = 0;
    offsetAverageRest = 0;

    newLocalAverage = table[0].localTime;
    newOffsetAverage = table[0].timeOffset;       

    for(i = 1; i < tableEntries; i++){
      localSum += (int32_t)(table[i].localTime - newLocalAverage) / tableEntries;
      localAverageRest += (table[i].localTime - newLocalAverage) % tableEntries;

      offsetSum += (int32_t)(table[i].timeOffset - newOffsetAverage) / tableEntries;
      offsetAverageRest += (table[i].timeOffset - newOffsetAverage) % tableEntries;
    }

    newLocalAverage += localSum + localAverageRest / tableEntries;
    newOffsetAverage += offsetSum + offsetAverageRest / tableEntries;

    localSum = offsetSum = 0;

    for(i = 0; i < tableEntries; ++i){
      int32_t a = table[i].localTime - newLocalAverage;
      int32_t b = table[i].timeOffset - newOffsetAverage;

      localSum  += (int64_t)a * a;
      offsetSum += (int64_t)a * b;
    }

    if( localSum != 0 )
        newSkew = (float)offsetSum / (float)localSum;     
    
    atomic
    {
        skew = newSkew;
        offsetAverage = newOffsetAverage;
        localAverage = newLocalAverage;
    }
    
    cpuReg8 = call LocalTime.get() - cpuReg8;
  }
  
  void reg16(){
    
    int8_t i;
    cpuReg16 = call LocalTime.get();
    
    localSum = 0;
    localAverageRest = 0;
    offsetSum = 0;
    offsetAverageRest = 0;

    newLocalAverage16 = table16[0].localTime;
    newOffsetAverage16 = table16[0].timeOffset;       

    for(i = 1; i < tableEntries16; i++){
      localSum += (int32_t)(table16[i].localTime - newLocalAverage16) / tableEntries16;
      localAverageRest += (table16[i].localTime - newLocalAverage16) % tableEntries16;

      offsetSum += (int32_t)(table16[i].timeOffset - newOffsetAverage16) / tableEntries16;
      offsetAverageRest += (table16[i].timeOffset - newOffsetAverage16) % tableEntries16;
    }

    newLocalAverage16 += localSum + localAverageRest / tableEntries16;
    newOffsetAverage16 += offsetSum + offsetAverageRest / tableEntries16;

    localSum = offsetSum = 0;

    for(i = 0; i < tableEntries16; ++i){
      int32_t a = table16[i].localTime - newLocalAverage16;
      int32_t b = table16[i].timeOffset - newOffsetAverage16;

      localSum  += (int64_t)a * a;
      offsetSum += (int64_t)a * b;
    }

    if( localSum != 0 )
        newSkew16 = (float)offsetSum / (float)localSum;    
    
    atomic
    {
        skew16 = newSkew16;
        offsetAverage16 = newOffsetAverage16;
        localAverage16 = newLocalAverage16;
    }
      
    cpuReg16 = call LocalTime.get() - cpuReg16;
  }
  
  void med8(){
    int32_t numConSlopes = 0;
    int8_t i,j;

    cpuMed8 = call LocalTime.get();
    
    for(i = 1; i < tableEntriesMedian8; i++){
      /* compute consecutive slopes */
      {
        int32_t a = (int32_t)(tableMedian8[i].timeOffset - tableMedian8[i-1].timeOffset);
        int32_t b = (int32_t)(tableMedian8[i].localTime  - tableMedian8[i-1].localTime);

        if( b != 0 ){
          conSlopes[numConSlopes++] = (float)a/(float)b;
        }
      }
    }
    
    /* sort slopes: do not need to sort all of the values */
    for(i = 0; i <= (numConSlopes>>1); ++i) {
      float tmp;
      uint8_t min = i;
        
      for(j = i+1; j < numConSlopes; ++j){
        if(conSlopes[min] > conSlopes[j]){
          min = j;
        }
      }
        
      tmp = conSlopes[i];
      conSlopes[i] = conSlopes[min];
      conSlopes[min] = tmp;
    }            

    /* calculate the median of the slopes */
    i = numConSlopes>>1;
    if(numConSlopes & 0x1) {
      newSkewMedian8 = conSlopes[i];
    }
    else{
      newSkewMedian8 = (conSlopes[i] - conSlopes[i-1])/2.0f + conSlopes[i-1];
    }

    localSum = 0;
    localAverageRest = 0;
    offsetSum = 0;
    offsetAverageRest = 0;

    newLocalAverageMedian8 = tableMedian8[0].localTime;
    newOffsetAverageMedian8 = tableMedian8[0].timeOffset;

    for(i = 1; i < tableEntriesMedian8; i++){
      localSum += (int32_t)(tableMedian8[i].localTime - newLocalAverageMedian8) / tableEntriesMedian8;
      localAverageRest += (tableMedian8[i].localTime - newLocalAverageMedian8) % tableEntriesMedian8;

      offsetSum += (int32_t)(tableMedian8[i].timeOffset - newOffsetAverageMedian8) / tableEntriesMedian8;
      offsetAverageRest += (tableMedian8[i].timeOffset - newOffsetAverageMedian8) % tableEntriesMedian8;
    }

    newLocalAverageMedian8 += localSum + localAverageRest / tableEntriesMedian8;
    newOffsetAverageMedian8 += offsetSum + offsetAverageRest / tableEntriesMedian8;  
    
    atomic
    {
        medianSkew8 = newSkewMedian8;
        offsetAverageMedian8 = newOffsetAverageMedian8;
        localAverageMedian8 = newLocalAverageMedian8;
    }
    
    cpuMed8 = call LocalTime.get() - cpuMed8;
  }  
  
  void med16(){
    int32_t numConSlopes = 0;
    int8_t i,j;

    cpuMed16 = call LocalTime.get();
    
    for(i = 1; i < tableEntriesMedian16; i++){
      /* compute consecutive slopes */
      {
        int32_t a = (int32_t)(tableMedian16[i].timeOffset - tableMedian16[i-1].timeOffset);
        int32_t b = (int32_t)(tableMedian16[i].localTime  - tableMedian16[i-1].localTime);

        if( b != 0 ){
          conSlopes[numConSlopes++] = (float)a/(float)b;
        }
      }
    }
    
    /* sort slopes: do not need to sort all of the values */
    for(i = 0; i <= (numConSlopes>>1); ++i) {
      float tmp;
      uint8_t min = i;
        
      for(j = i+1; j < numConSlopes; ++j){
        if(conSlopes[min] > conSlopes[j]){
          min = j;
        }
      }
        
      tmp = conSlopes[i];
      conSlopes[i] = conSlopes[min];
      conSlopes[min] = tmp;
    }            

    /* calculate the median of the slopes */
    i = numConSlopes>>1;
    if(numConSlopes & 0x1) {
      newSkewMedian16 = conSlopes[i];
    }
    else{
      newSkewMedian16 = (conSlopes[i] - conSlopes[i-1])/2.0f + conSlopes[i-1];
    }

    localSum = 0;
    localAverageRest = 0;
    offsetSum = 0;
    offsetAverageRest = 0;

    newLocalAverageMedian16 = tableMedian16[0].localTime;
    newOffsetAverageMedian16 = tableMedian16[0].timeOffset;

    for(i = 1; i < tableEntriesMedian16; i++){
      localSum += (int32_t)(tableMedian16[i].localTime - newLocalAverageMedian16) / tableEntriesMedian16;
      localAverageRest += (tableMedian16[i].localTime - newLocalAverageMedian16) % tableEntriesMedian16;

      offsetSum += (int32_t)(tableMedian16[i].timeOffset - newOffsetAverageMedian16) / tableEntriesMedian16;
      offsetAverageRest += (tableMedian16[i].timeOffset - newOffsetAverageMedian16) % tableEntriesMedian16;
    }

    newLocalAverageMedian16 += localSum + localAverageRest / tableEntriesMedian16;
    newOffsetAverageMedian16 += offsetSum + offsetAverageRest / tableEntriesMedian16;  
    
    atomic
    {
        medianSkew16 = newSkewMedian16;
        offsetAverageMedian16 = newOffsetAverageMedian16;
        localAverageMedian16 = newLocalAverageMedian16;
    }
    
    cpuMed16 = call LocalTime.get() - cpuMed16;
  }

  void sendSerial(){
   
    if (serialLock) {
      return;
    }
    else {
      serial_msg_t* rcm = (serial_msg_t*)call SerialPacket.getPayload(&serialBuffer, sizeof(serial_msg_t));
      
      if (rcm == NULL) {return;}

      rcm->cpuTimeReg8 = cpuReg8;
      rcm->cpuTimeReg16 = cpuReg16;
      rcm->cpuTimeMed8 = cpuMed8;
      rcm->cpuTimeMed16 = cpuMed16;
      
      
      if (call SerialSend.send(AM_BROADCAST_ADDR, &serialBuffer, sizeof(serial_msg_t)) == SUCCESS) {
        serialLock = TRUE;
      }
    }
  }
  
  void init(){
    
    table[0].localTime = 0;
    table[1].localTime = 1;
    table[2].localTime = 2;
    table[3].localTime = 3;
    table[4].localTime = 4;
    table[5].localTime = 5;
    table[6].localTime = 6;
    table[7].localTime = 7;
        
    tableMedian8[0].localTime = 0;
    tableMedian8[1].localTime = 1;
    tableMedian8[2].localTime = 2;
    tableMedian8[3].localTime = 3;
    tableMedian8[4].localTime = 4;
    tableMedian8[5].localTime = 5;
    tableMedian8[6].localTime = 6;
    tableMedian8[7].localTime = 7;    
    
    table16[0].localTime = 0;
    table16[1].localTime = 1;
    table16[2].localTime = 2;
    table16[3].localTime = 3;
    table16[4].localTime = 4;
    table16[5].localTime = 5;
    table16[6].localTime = 6;
    table16[7].localTime = 7;
    table16[8].localTime = 8;
    table16[9].localTime = 9;
    table16[10].localTime = 10;
    table16[11].localTime = 11;
    table16[12].localTime = 12;
    table16[13].localTime = 13;
    table16[14].localTime = 14;
    table16[15].localTime = 15;  
    
    tableMedian16[0].localTime = 0;
    tableMedian16[1].localTime = 1;
    tableMedian16[2].localTime = 2;
    tableMedian16[3].localTime = 3;
    tableMedian16[4].localTime = 4;
    tableMedian16[5].localTime = 5;
    tableMedian16[6].localTime = 6;
    tableMedian16[7].localTime = 7;
    tableMedian16[8].localTime = 8;
    tableMedian16[9].localTime = 9;
    tableMedian16[10].localTime = 10;
    tableMedian16[11].localTime = 11;
    tableMedian16[12].localTime = 12;
    tableMedian16[13].localTime = 13;
    tableMedian16[14].localTime = 14;
    tableMedian16[15].localTime = 15;  
    
    table[0].timeOffset = 65535L;
    table[1].timeOffset = 32768L;
    table[2].timeOffset = 16384,
    table[3].timeOffset = 8192;
    table[4].timeOffset = 4096;
    table[5].timeOffset = 2048;
    table[6].timeOffset = 1024;
    table[7].timeOffset = 512;
    
    tableMedian8[0].timeOffset = 65535L;
    tableMedian8[1].timeOffset = 32768L;
    tableMedian8[2].timeOffset = 16384,
    tableMedian8[3].timeOffset = 8192;
    tableMedian8[4].timeOffset = 4096;
    tableMedian8[5].timeOffset = 2048;
    tableMedian8[6].timeOffset = 1024;
    tableMedian8[7].timeOffset = 512;
    
    table16[0].timeOffset = 65535L;
    table16[1].timeOffset = 32768L;
    table16[2].timeOffset = 16384,
    table16[3].timeOffset = 8192;
    table16[4].timeOffset = 4096;
    table16[5].timeOffset = 2048;
    table16[6].timeOffset = 1024;
    table16[7].timeOffset = 512;
    table16[8].timeOffset = 256;
    table16[9].timeOffset = 128;
    table16[10].timeOffset = 64,
    table16[11].timeOffset = 32;
    table16[12].timeOffset = 16;
    table16[13].timeOffset = 8;
    table16[14].timeOffset = 4;
    table16[15].timeOffset = 2;
    
    tableMedian16[0].timeOffset = 65535L;
    tableMedian16[1].timeOffset = 32768L;
    tableMedian16[2].timeOffset = 16384,
    tableMedian16[3].timeOffset = 8192;
    tableMedian16[4].timeOffset = 4096;
    tableMedian16[5].timeOffset = 2048;
    tableMedian16[6].timeOffset = 1024;
    tableMedian16[7].timeOffset = 512;
    tableMedian16[8].timeOffset = 256;
    tableMedian16[9].timeOffset = 128;
    tableMedian16[10].timeOffset = 64,
    tableMedian16[11].timeOffset = 32;
    tableMedian16[12].timeOffset = 16;
    tableMedian16[13].timeOffset = 8;
    tableMedian16[14].timeOffset = 4;
    tableMedian16[15].timeOffset = 2;
  }
  
  event void SerialSend.sendDone(message_t* bufPtr, error_t error) {
    if (&serialBuffer == bufPtr) {
      serialLock = FALSE;
    }
  }    
  
  event void Boot.booted(){
    call SerialControl.start();
    call Timer0.startPeriodic(5000);
  }
  
  event void SerialControl.startDone(error_t err) {}
  event void SerialControl.stopDone(error_t err) {}
  
  event void Timer0.fired(){    
    init();
    call Leds.led1Toggle();
    reg8();
    call Leds.led1Toggle();
    reg16();
    call Leds.led1Toggle();
    med8();
    call Leds.led1Toggle();
    med16();
    call Leds.led1Toggle();
    
    sendSerial();    
    call Leds.led0Toggle();
  }
}