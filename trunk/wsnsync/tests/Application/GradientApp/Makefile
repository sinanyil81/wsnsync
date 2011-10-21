COMPONENT = TSyncAppC

CFLAGS += -DBEACON_PERIOD=30000L
CFLAGS += -DMAX_NEIGHBOR=2

PFLAGS+=-DTASKLET_IS_TASK


PFLAGS += -I../../../tos/lib/messagecounter/
PFLAGS += -I../../../tos/lib/nosleep/
PFLAGS += -I../../../tests/

#enable protocol
PFLAGS += -I../../../tos/lib/gradient/
PFLAGS += -I../../../tos/lib/gradient/synclib/
PFLAGS += -I../../../tos/lib/gradient/synclib/comm/
PFLAGS += -I../../../tos/lib/gradient/synclib/estimate/

#enable cc2420x
PFLAGS += -I../../../tos/platforms/micaz/
CFLAGS +=-I../../../tos/platforms/micaz/CC2420X

BUILD_EXTRA_DEPS = TSyncAppMsg.class
CLEAN_EXTRA = *.class TSyncAppMsg.java

TSyncAppMsg.class: TSyncAppMsg.java
	javac *.java

TSyncAppMsg.java: TSyncApp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=TSyncAppMsg TSyncApp.h TSyncAppMsg_t -o $@

include $(MAKERULES)