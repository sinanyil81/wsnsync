#if defined(RFTSPMSG_H)
#else
#define RFTSPMSG_H

typedef nx_struct RftspMsg
{	
	nx_uint16_t	nodeID;		// the node if of the sender
    nx_uint32_t localTime;  // local time of the sender
    
    nx_uint32_t rootID; 	// id of the reference node
    nx_uint32_t rootRate; 	// relative rate of the reference node
	nx_uint32_t	rootClock; 	// time of the reference node	
    nx_uint8_t  seqNum;     // sequence number for the reference
	
} RftspMsg;

enum {
    TIMESYNC_AM_RFTSP = 0x3C,
    RFTSPMSG_LEN = sizeof(RftspMsg),
    RFTSP_TIMER_MODE = 0,      // see TimeSyncMode interface
    RFTSP_USER_MODE = 1,       // see TimeSyncMode interface
};

#endif
