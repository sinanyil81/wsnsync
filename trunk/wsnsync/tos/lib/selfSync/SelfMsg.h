#if defined(SELFMSG_H)
#else
#define SELFMSG_H

typedef nx_struct SelfMsg
{	
	nx_uint16_t	nodeID;
	nx_uint32_t	globalTime;	
} SelfMsg;

enum {
    TIMESYNC_AM_SELFSYNC = 0x3D,
    EGTSPMSG_LEN = sizeof(SelfMsg),
    TS_TIMER_MODE = 0,      // see TimeSyncMode interface
    TS_USER_MODE = 1,       // see TimeSyncMode interface
};

#endif
