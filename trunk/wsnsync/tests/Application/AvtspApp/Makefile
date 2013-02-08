COMPONENT = TSyncAvtspAppC

CFLAGS += -DTIMESYNC_RATE=30
CFLAGS += -DTIMESYNC_LEDS
#CFLAGS += -DTOSH_DATA_LENGTH=40

PFLAGS += -I../../../tos/lib/nosleep/

#enable protocol
PFLAGS += -I../../../tos/lib/avtsp/

#enable cc2420x
#PFLAGS += -I../../../tos/platforms/micaz/
#CFLAGS +=-I../../../tos/platforms/micaz/CC2420X

BUILD_EXTRA_DEPS = TSyncAppMsg.class
CLEAN_EXTRA = *.class TSyncAppMsg.java

TSyncAppMsg.class: TSyncAppMsg.java
	javac *.java
	
TSyncAppMsg.java: TSyncApp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=TSyncAppMsg TSyncApp.h TSyncAppMsg_t -o $@
	
include $(MAKERULES)