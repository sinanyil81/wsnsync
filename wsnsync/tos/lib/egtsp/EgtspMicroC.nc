#include "EgtspMsg.h"

configuration EgtspMicroC
{
  uses interface Boot;
  provides interface Init;
  provides interface StdControl;
  provides interface GlobalTime<TMicro>;

  //interfaces for extra fcionality: need not to be wired
  provides interface TimeSyncInfo;
  provides interface TimeSyncMode;
  provides interface TimeSyncNotify;
}

implementation
{
#if defined(PLATFORM_MICAZ) || defined(PLATFORM_TELOSB)
;
#else
#error "LPL timesync is not available for your platform"
#endif

  components new EgtspP(TMicro) as TimeSyncP;

  GlobalTime      =   TimeSyncP;
  StdControl      =   TimeSyncP;
  Init            =   TimeSyncP;
  Boot            =   TimeSyncP;
  TimeSyncInfo    =   TimeSyncP;
  TimeSyncMode    =   TimeSyncP;
  TimeSyncNotify  =   TimeSyncP;

  components TimeSyncMessageC as ActiveMessageC;
  TimeSyncP.RadioControl    ->  ActiveMessageC;
  TimeSyncP.Send            ->  ActiveMessageC.TimeSyncAMSendRadio[TIMESYNC_AM_EGTSP];
  TimeSyncP.Receive         ->  ActiveMessageC.Receive[TIMESYNC_AM_EGTSP];
  TimeSyncP.TimeSyncPacket  ->  ActiveMessageC;

  components LocalTimeMicroC;
  TimeSyncP.LocalTime     -> LocalTimeMicroC;

  components new TimerMilliC() as TimerC;
  TimeSyncP.Timer ->  TimerC;

  components RandomC;
  TimeSyncP.Random -> RandomC;

  components EgtspNeighborTableC;
  TimeSyncP.EgtspNeighborTable -> EgtspNeighborTableC;
  

  components EgtspClockC;
  TimeSyncP.EgtspClock -> EgtspClockC;
  
#if defined(TIMESYNC_LEDS)
  components LedsC;
#else
  components NoLedsC as LedsC;
#endif
  TimeSyncP.Leds  ->  LedsC;
  
  EgtspNeighborTableC.Leds -> LedsC;
  
#ifdef LOW_POWER_LISTENING
  TimeSyncP.LowPowerListening -> ActiveMessageC;
#endif
}
