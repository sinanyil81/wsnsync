COMPONENT = AvtAppC

PFLAGS += -I../../../tos/lib/avtsp/

BUILD_EXTRA_DEPS = SerialMsg.class
CLEAN_EXTRA = *.class SerialMsg.java
	
SerialMsg.class: SerialMsg.java
	javac *.java
	
SerialMsg.java: SerialMsg.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=SerialMsg SerialMsg.h serial_msg_t -o $@


include $(MAKERULES)