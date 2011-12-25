#if defined(EGTSPMSG_H)
#else
#define EGTSPMSG_H

typedef nx_struct EgtspMsg
{	
	nx_uint16_t	nodeID;		// the node if of the sender
    nx_uint32_t localTime;  // local time of the sender
    nx_uint32_t multiplier; // rate multiplier of the sender

	nx_uint32_t	globalTime; 	// time of the root node
	nx_uint32_t rootMultiplier; // rate multiplier of the root node	
    nx_uint8_t  seqNum;     	// sequence number for the root
	
} EgtspMsg;

enum {
    TIMESYNC_AM_EGTSP = 0x3D,
    EGTSPMSG_LEN = sizeof(EgtspMsg),
    TS_TIMER_MODE = 0,      // see TimeSyncMode interface
    TS_USER_MODE = 1,       // see TimeSyncMode interface
};

#endif
