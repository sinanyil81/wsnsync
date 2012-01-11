#include "DebugMsg.h"

configuration DebugSerialC
{
	provides interface DebugSerial;
	uses interface Boot;
}

implementation
{
	components SerialActiveMessageC as SAM;
	components DebugSerialP as DS;
	
  	DS.SerialSend -> SAM.AMSend[AM_SERIAL_MSG_T];
  	DS.SerialControl ->  SAM;
  	DS.SerialPacket ->  SAM;
  	
  	Boot = DS;
 	DebugSerial = DS; 	
}
