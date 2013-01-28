COMPONENT = TSyncSelfAppC

CFLAGS += -DROOT_ID=1
CFLAGS += -DTIMESYNC_RATE=30
CFLAGS += -DTIMESYNC_LEDS

PFLAGS += -I../../../tos/lib/nosleep/

#enable protocol
PFLAGS += -I../../../tos/lib/selfSync/

BUILD_EXTRA_DEPS = TSyncAppMsg.class
CLEAN_EXTRA = *.class TSyncAppMsg.java

TSyncAppMsg.class: TSyncAppMsg.java
	javac *.java
	
TSyncAppMsg.java: TSyncApp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=TSyncAppMsg TSyncApp.h TSyncAppMsg_t -o $@
	
include $(MAKERULES)