#if defined(LOGMSG_H)
#else
#define LOGMSG_H

typedef nx_struct serial_msg_t {
  nx_uint32_t cpuTimeReg8;
  nx_uint32_t cpuTimeReg16;
  nx_uint32_t cpuTimeMed8;
  nx_uint32_t cpuTimeMed16;
} serial_msg_t;

enum {
  AM_SERIAL_MSG_T = 0x89,
};

#endif
