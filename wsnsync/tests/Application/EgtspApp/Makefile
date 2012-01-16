COMPONENT = TSyncEgtspAppC

CFLAGS += -DROOT_ID=1
CFLAGS += -DTIMESYNC_RATE=30
CFLAGS += -DTIMESYNC_LEDS
#CFLAGS += -DTOSH_DATA_LENGTH=96

PFLAGS += -I../../../tos/lib/nosleep/

#enable protocol
#PFLAGS += -I../../../tos/lib/egtsp/
PFLAGS += -I../../../tos/lib/debugging/

#enable cc2420x
PFLAGS += -I../../../tos/platforms/micaz/
CFLAGS +=-I../../../tos/platforms/micaz/CC2420X

#BUILD_EXTRA_DEPS = TSyncAppMsg.class SerialMsg.class
BUILD_EXTRA_DEPS = TSyncAppMsg.class
CLEAN_EXTRA = *.class TSyncAppMsg.java

TSyncAppMsg.class: TSyncAppMsg.java
	javac *.java
	
#SerialMsg.class: SerialMsg.java
#	javac *.java	
	
TSyncAppMsg.java: TSyncApp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=TSyncAppMsg TSyncApp.h TSyncAppMsg_t -o $@
	
#SerialMsg.java: ../../../tos/lib/debugging/DebugMsg.h
#	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=SerialMsg ../../../tos/lib/debugging/DebugMsg.h serial_msg_t -o $@	

include $(MAKERULES)