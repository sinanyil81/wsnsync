#if defined(LOGSYNCMSG_H)
#else
#define LOGSYNCMSG_H

typedef nx_struct serial_msg_t {
  nx_uint32_t x[8];
  nx_int32_t y[8];
  nx_uint32_t median;
} serial_msg_t;

enum {
  AM_SERIAL_MSG_T = 0x89,
};

#endif
