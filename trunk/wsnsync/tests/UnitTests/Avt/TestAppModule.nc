#include "test_debug.h"
#include "Avt.h"

module TestAppModule{
  uses interface Boot;
  uses interface Avt;
}
implementation{
	
	void test1(){
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_LOWER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
		call Avt.adjustValue(FEEDBACK_GREATER);
		DEBUG_PRINT("Avt value [%0.10f] Delta value [%0.10f] \n",call Avt.getValue(),call Avt.getDelta());
	}

	event void Boot.booted(){
		 
        call Avt.init(-0.0001,0.0001,0); 
		
		test1();
	}
}