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

module StatsC{
  provides interface Estimator;
}
implementation {

  enum {
    NUM_TABLE_ENTRY     = 4,
    MIN_TABLE_ENTRY     = 2,
  };

  typedef struct TableEntry{
    uint8_t  state;
    uint32_t x;
    int32_t y;
  } TableEntry;

  typedef struct Line{
    float slope;
    uint32_t X;
    int32_t Y;
  } Line;

  typedef struct Table{
    int8_t  end;
    uint8_t  numEntry;
    TableEntry entry[NUM_TABLE_ENTRY];
  } Table;

  Table table;
  Line line;

  void calculateLine(){

    uint8_t j,k,l = 0;
    int64_t sumX = 0;
    int64_t sumY = 0;
    int32_t sumXRemainder = 0;
    int32_t sumYRemainder = 0;
    uint32_t X;
    int32_t Y;

    for(j=0;j<NUM_TABLE_ENTRY;j++){

      if(table.entry[j].state == ENTRY_FULL){
        break;
      }
    }

    if(j>=NUM_TABLE_ENTRY){
      return;
    }

    X  = table.entry[j].x;
    Y  = table.entry[j].y;


    while(++j<NUM_TABLE_ENTRY){
      if(table.entry[j].state == ENTRY_FULL){
        sumX += (int32_t)(table.entry[j].x-X) / table.numEntry;
        sumXRemainder += (table.entry[j].x-X) % table.numEntry;
        sumY += (int32_t)(table.entry[j].y-Y) / table.numEntry;
        sumYRemainder += (table.entry[j].y-Y) % table.numEntry;
      }
    }

    X += sumX + sumXRemainder / table.numEntry;
    Y += sumY + sumYRemainder / table.numEntry;

    sumX = 0;
    sumY = 0;

    k = table.end;

    for(j=0;j<NUM_TABLE_ENTRY-1;j++){
      if (++k == NUM_TABLE_ENTRY) k = 0;
      if(table.entry[k].state == ENTRY_FULL){
        l = k + 1;
        if (l == NUM_TABLE_ENTRY) l = 0;

        if(table.entry[l].state == ENTRY_FULL){

          sumX += (int32_t)(table.entry[l].x - table.entry[k].x);
          sumY += (int32_t)(table.entry[l].y - table.entry[k].y);
        }
      }
    }

    if(sumX != 0){
      line.slope = (float)sumY/(float)sumX;
    }

    line.X = X;
    line.Y = Y;
  }

  command void Estimator.addEntry(uint32_t x, uint32_t y){

    if (++table.end == NUM_TABLE_ENTRY) table.end = 0;
    table.entry[table.end].state = ENTRY_FULL;
    table.entry[table.end].x = x;
    table.entry[table.end].y = (int32_t)y-x;
    if(++table.numEntry > NUM_TABLE_ENTRY) table.numEntry = NUM_TABLE_ENTRY;

    calculateLine();
  }

  command void Estimator.clear(){
    int j;

    table.numEntry = 0;
    table.end = -1;
    line.slope = 0.0;
    line.X = 0;
    line.Y = 0;

    for(j=0;j<NUM_TABLE_ENTRY;j++){
      table.entry[j].state = ENTRY_EMPTY;
    }
  }

  command uint32_t Estimator.estimateY(uint32_t x){

    x += line.Y + (int32_t)(line.slope*(int32_t)(x - line.X));
    return x;
  }

  command uint32_t Estimator.estimateX(uint32_t y){

    return y - line.Y - (int32_t)(line.slope * (int32_t)(y - line.Y - line.X));
  }

  command error_t Estimator.isValid(){

    if(table.numEntry >= MIN_TABLE_ENTRY){
      return SUCCESS;
    }

    return FAIL;
  }
}
