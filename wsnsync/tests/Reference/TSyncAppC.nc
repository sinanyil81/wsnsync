#include "TSyncApp.h"

configuration TSyncAppC{
}
implementation{

  components ActiveMessageC as AM;
  
  components MainC;
  components LedsC,RandomC;
  components new AMSenderC(AM_TSYNCAPPMSG_T);
  components new AMReceiverC(AM_TSYNCAPPMSG_T);
  components new TimerMilliC() as Timer0;
  components TSyncAppModule as App;

  App.Boot              -> MainC;
  App.AMControl         -> AM;
  App.AMSend            -> AMSenderC;
  App.Packet            -> AMSenderC;
  App.Leds              -> LedsC;
  App.Timer0            -> Timer0;
  App.Random            -> RandomC;
}
