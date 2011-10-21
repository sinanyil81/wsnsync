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

module RegressionP{
  provides interface Estimator as Estimator[uint8_t num];
}
implementation {

  enum {
    ESTIMATOR_COUNT = uniqueCount(UQ_ESTIMATE)
  };
  
  enum {
    NUM_TABLE_ENTRY     = 8,
    MIN_TABLE_ENTRY     = 3,
  };

  enum {
    ENTRY_EMPTY = 0,
    ENTRY_FULL  = 1,
  };
    
  typedef struct TableEntry{
    uint8_t  state;
    uint32_t x;   
    int32_t y;
  } TableEntry;
  
  typedef struct Line{
    uint32_t X;
    int32_t Y;
    float slope;   
  } Line;

  typedef struct Table{
    uint8_t  numEntry;
    TableEntry entry[NUM_TABLE_ENTRY];
    Line line;
  } Table;

  Table tables[ESTIMATOR_COUNT];

  void calculateLine(uint8_t num){
    
    int64_t sumX = 0;
    int64_t sumY = 0;
    int32_t sumXRemainder = 0;
    int32_t sumYRemainder = 0;    
    uint32_t X;
    int32_t Y;
    uint8_t j;
    float slope = tables[num].line.slope;
    
    for(j=0;j<NUM_TABLE_ENTRY;j++){
      
      if(tables[num].entry[j].state == ENTRY_FULL){
        break;  
      }
    } 
    
    if(j>=NUM_TABLE_ENTRY){
      return;
    }
    
    X  = tables[num].entry[j].x;
    Y  = tables[num].entry[j].y;

        
    while(++j<NUM_TABLE_ENTRY){
      if(tables[num].entry[j].state == ENTRY_FULL){
        sumX += (int32_t)(tables[num].entry[j].x-X) / tables[num].numEntry;
        sumXRemainder += (tables[num].entry[j].x-X) % tables[num].numEntry;
        sumY += (int32_t)(tables[num].entry[j].y-Y) / tables[num].numEntry;
        sumYRemainder += (tables[num].entry[j].y-Y) % tables[num].numEntry;
      }
    }

    X += sumX + sumXRemainder / tables[num].numEntry;
    Y += sumY + sumYRemainder / tables[num].numEntry;

    sumX = sumY = 0;
    
    for(j=0;j<NUM_TABLE_ENTRY;j++){
      if(tables[num].entry[j].state == ENTRY_FULL){
        int32_t a = tables[num].entry[j].x - X;
        int32_t b = tables[num].entry[j].y - Y;

        sumX += (int64_t)a*b;
        sumY += (int64_t)a*a;
      }
    }

    if(sumY != 0){
      slope = (float)sumX/(float)sumY;      
    }

    tables[num].line.X = X;
    tables[num].line.Y = Y;
    tables[num].line.slope = slope;
  }
  
  uint8_t getFreeSlot(uint8_t num, uint32_t x){

    int j;
    uint32_t oldestAge  = 0;
    uint8_t  oldestItem = NUM_TABLE_ENTRY;
    uint8_t  freeItem   = NUM_TABLE_ENTRY;
    
    for(j=0;j<NUM_TABLE_ENTRY;j++){
      
      if(tables[num].entry[j].state == ENTRY_FULL){
        uint32_t age = x - tables[num].entry[j].x;
        
        if( age >= 0x7FFFFFFFL ){
          tables[num].entry[j].state = ENTRY_EMPTY;
          tables[num].numEntry--;
          freeItem = j;
        }
          
        if(age >= oldestAge){
          oldestAge = age;
          oldestItem = j;
        }
      }
      else{
        freeItem = j;
      }
    }

    if(freeItem == NUM_TABLE_ENTRY){
      freeItem = oldestItem;
      tables[num].entry[freeItem].state = ENTRY_EMPTY;
      tables[num].numEntry--;
    }

    return freeItem;
  }

  command void Estimator.addEntry[uint8_t num](uint32_t x, uint32_t y){
    
    uint8_t slot;

    slot = getFreeSlot(num,x);
    tables[num].entry[slot].state = ENTRY_FULL;
    tables[num].entry[slot].x = x;
    tables[num].entry[slot].y = (int32_t)(y-x);
    tables[num].numEntry++;

    calculateLine(num);
  }
  
  command void Estimator.clear[uint8_t num](){
    int j;
    
    tables[num].numEntry = 0;
    tables[num].line.X = 0;
    tables[num].line.Y = 0;
    tables[num].line.slope = 0.0;
    
    for(j=0;j<NUM_TABLE_ENTRY;j++){
      tables[num].entry[j].state = ENTRY_EMPTY;
    }
  } 

  command uint32_t Estimator.estimateY[uint8_t num](uint32_t x){
    
    x += tables[num].line.Y + (int32_t)(tables[num].line.slope*(int32_t)(x - tables[num].line.X));
    return x;
  }        
  
  command uint32_t Estimator.estimateX[uint8_t num](uint32_t y){
  
    return y - tables[num].line.Y - (int32_t)(tables[num].line.slope * (int32_t)(y - tables[num].line.Y - tables[num].line.X));
  }

  command error_t Estimator.isValid[uint8_t num](){
    
    if(tables[num].numEntry >= MIN_TABLE_ENTRY){
      return SUCCESS;
    }
    
    return FAIL;
  }   
}
