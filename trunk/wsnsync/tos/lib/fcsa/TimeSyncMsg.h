#if defined(TIMESYNCMSG_H)
#else
#define TIMESYNCMSG_H

typedef nx_struct TimeSyncMsg
{	
	nx_uint16_t	nodeID;		// the node if of the sender
    nx_uint32_t localTime;  // local time of the sender
    nx_uint32_t multiplier; // rate multiplier for the sender

	nx_uint32_t	globalTime; // time of the root node	
    nx_uint8_t  seqNum;     // sequence number for the root
	
} TimeSyncMsg;

enum {
    TIMESYNC_AM_FTSP = 0x3E,
    TIMESYNCMSG_LEN = sizeof(TimeSyncMsg),
    TS_TIMER_MODE = 0,      // see TimeSyncMode interface
    TS_USER_MODE = 1,       // see TimeSyncMode interface
};

#endif
