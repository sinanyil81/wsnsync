#include "SelfMsg.h"

configuration SelfSyncMicroC
{
  uses interface Boot;
  provides interface Init;
  provides interface StdControl;
  provides interface GlobalTime<TMicro>;
  provides interface TimeSyncInfo;
}

implementation
{
#if defined(PLATFORM_MICAZ) || defined(PLATFORM_TELOSB)
;
#else
#error "LPL timesync is not available for your platform"
#endif

  components new SelfSyncP(TMicro) as TimeSyncP;

  GlobalTime      =   TimeSyncP;
  StdControl      =   TimeSyncP;
  Init            =   TimeSyncP;
  Boot            =   TimeSyncP;
  TimeSyncInfo    =   TimeSyncP;

  components TimeSyncMessageC as ActiveMessageC;
  TimeSyncP.RadioControl    ->  ActiveMessageC;
  TimeSyncP.Send            ->  ActiveMessageC.TimeSyncAMSendRadio[TIMESYNC_AM_SELFSYNC];
  TimeSyncP.Receive         ->  ActiveMessageC.Receive[TIMESYNC_AM_SELFSYNC];
  TimeSyncP.TimeSyncPacket  ->  ActiveMessageC;

  components LocalTimeMicroC;
  TimeSyncP.LocalTime     -> LocalTimeMicroC;

  components new TimerMilliC() as TimerC;
  TimeSyncP.Timer ->  TimerC;

  components RandomC;
  TimeSyncP.Random -> RandomC;

  components AvtC;  
  TimeSyncP.Avt -> AvtC;

  components LogicalClockC;
  TimeSyncP.LogicalClock -> LogicalClockC;
  
#if defined(TIMESYNC_LEDS)
  components LedsC;
#else
  components NoLedsC as LedsC;
#endif
  TimeSyncP.Leds  ->  LedsC;
  
#ifdef LOW_POWER_LISTENING
  TimeSyncP.LowPowerListening -> ActiveMessageC;
#endif
}
