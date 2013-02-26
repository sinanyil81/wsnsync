#if defined(LOGMSG_H)
#else
#define LOGMSG_H

typedef nx_struct serial_msg_t {
  nx_uint16_t nodeid;
  nx_uint32_t clock;
  nx_uint32_t skew; 
} serial_msg_t;

enum {
  AM_SERIAL_MSG_T = 0x89,
};

#endif
