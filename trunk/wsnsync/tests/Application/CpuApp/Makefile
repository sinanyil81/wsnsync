COMPONENT = CpuAppC

CFLAGS += -DTIMESYNC_RATE=30
CFLAGS += -DTIMESYNC_LEDS
CFLAGS += -DTOSH_DATA_LENGTH=52

BUILD_EXTRA_DEPS = SerialMsg.class
CLEAN_EXTRA = *.class SerialMsg.java
	
SerialMsg.class: SerialMsg.java
	javac *.java
	
SerialMsg.java: SerialMsg.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=SerialMsg SerialMsg.h serial_msg_t -o $@


include $(MAKERULES)