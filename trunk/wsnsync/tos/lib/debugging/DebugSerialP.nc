#include "DebugMsg.h"

module DebugSerialP{

  provides interface DebugSerial;
  
  uses interface AMSend as SerialSend;
  uses interface SplitControl as SerialControl;
  uses interface Packet as SerialPacket;  
  uses interface Boot;
}
implementation{
  
  message_t serialBuffer;
  bool serialLock = FALSE; 
  
  command error_t DebugSerial.sendSerial(uint32_t pa,uint32_t pb,uint32_t pc,uint32_t pd,uint32_t pe,uint32_t pf,uint32_t pg){
  	serial_msg_t* rcm;
  	
  	if (serialLock == TRUE) {
      return FAIL;
    }
    
    rcm = (serial_msg_t*)call SerialPacket.getPayload(&serialBuffer, sizeof(serial_msg_t));
      
    if (rcm == NULL) {return FAIL;}

    rcm->a = pa;
    rcm->b = pb;
    rcm->c = pc;
    rcm->d = pd;
    rcm->e = pe;
    rcm->f = pf;
    rcm->g = pg;      
      
    if (call SerialSend.send(AM_BROADCAST_ADDR, &serialBuffer, sizeof(serial_msg_t)) == SUCCESS) {
    	serialLock = TRUE;
    	return SUCCESS;
    }
         
    return FAIL;
  }
  
  event void SerialSend.sendDone(message_t* bufPtr, error_t error) {
    if (&serialBuffer == bufPtr) {
      serialLock = FALSE;
    }
  }    
  
  event void Boot.booted(){
    call SerialControl.start();
  }
  
  event void SerialControl.startDone(error_t err) {}
  event void SerialControl.stopDone(error_t err) {}
  
}