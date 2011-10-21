COMPONENT = TSyncFtspAppC

CFLAGS += -DTIMESYNC_RATE=30
CFLAGS += -DTIMESYNC_LEDS
CFLAGS += -DTOSH_DATA_LENGTH=96

PFLAGS += -I../../../tos/lib/messagecounter/
PFLAGS += -I../../../tos/lib/nosleep/

#enable protocol
PFLAGS += -I../../../tos/lib/ftsp_tinyos/
#PFLAGS += -I../../../tos/lib/ftsp_tinyos_modified/
#PFLAGS += -I../../../tos/lib/ftsp_tinyos_modified/regression/

#enable cc2420x
PFLAGS += -I../../../tos/platforms/micaz/
CFLAGS +=-I../../../tos/platforms/micaz/CC2420X

BUILD_EXTRA_DEPS = TSyncAppMsg.class SerialMsg.class
CLEAN_EXTRA = *.class TSyncAppMsg.java SerialMsg.java

TSyncAppMsg.class: TSyncAppMsg.java
	javac *.java
	
TSyncAppMsg.java: TSyncApp.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=TSyncAppMsg TSyncApp.h TSyncAppMsg_t -o $@
	
SerialMsg.class: SerialMsg.java
	javac *.java
	
SerialMsg.java: ../../../tos/lib/ftsp_tinyos/SerialMsg.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=SerialMsg ../../../tos/lib/ftsp_tinyos/SerialMsg.h serial_msg_t -o $@


include $(MAKERULES)