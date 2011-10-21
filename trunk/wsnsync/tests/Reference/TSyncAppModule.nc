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