#if defined(FCSAMSG_H)
#else
#define FCSAMSG_H

typedef nx_struct FcsaMsg
{	
	nx_uint16_t	nodeID;		// the node if of the sender
    nx_uint32_t localTime;  // local time of the sender
    nx_uint32_t multiplier; // rate multiplier for the sender

	nx_uint32_t	globalTime; // time of the root node	
    nx_uint8_t  seqNum;     // sequence number for the root
	
} FcsaMsg;

enum {
    TIMESYNC_AM_FCSA = 0x3D,
    TIMESYNCMSG_LEN = sizeof(FcsaMsg),
    TS_TIMER_MODE = 0,      // see TimeSyncMode interface
    TS_USER_MODE = 1,       // see TimeSyncMode interface
};

#endif
