#if defined(_DEBUGMSG_H)
#else
#define _DEBUGMSG_H

typedef nx_struct serial_msg_t {
  nx_uint32_t a;
  nx_uint32_t b;
  nx_uint32_t c;
  nx_uint32_t d;
  nx_uint32_t e;
  nx_uint32_t f;
  nx_uint32_t g;
} serial_msg_t;

enum {
  AM_SERIAL_MSG_T = 0x89,
};

#endif
