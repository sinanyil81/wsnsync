#include "Avt.h"

module AvtP
{
    provides
    {
        interface Avt;
    }       
}
implementation
{
	#define INCREASE_FACTOR 2.0
	#define DECREASE_FACTOR 3.0
	 
	float lowerBound = 0.0;
	float upperBound = 0.0;
	float value = 0.0;
	
	float delta, deltaMin, deltaMax;
	
	uint8_t lastFeedback = FEEDBACK_GOOD;
			
    command void Avt.init(float lBound,float uBound,float val)
    {
		lowerBound = lBound;
		upperBound = uBound;
		value = val;
		
		/* delta bounds */
		deltaMin = 0.0000000001;
		deltaMax = 0.0001;
		delta = (dMin + dMax)/2.0;
    }
    
    command float Avt.getValue(){
    
    	return value;
    }
    
    void increaseDelta(){
    	delta = delta * INCREASE_FACTOR;    
    	
    	if(delta > deltaMax){
    		delta = deltaMax;
    	}	
    }
    
    void decreaseDelta(){
    	delta = delta / DECREASE_FACTOR;
    	
    	if(delta < deltaMin){
    		delta = deltaMin;
    	}     
    }
        
    void updateDelta(uint8_t feedback){
    	if (lastFeedback == FEEDBACK_GOOD) {
			if (feedback == FEEDBACK_GOOD) {
				decreaseDelta();
			} else {
				increaseDelta();
			}
		}else if (lastFeedback != feedback) {
			decreaseDelta();
		}else{
			increaseDelta();
		}
    }
    
    float min(float a,float b){
    	if(a<b) 
    		return a;
    		
    	return b;
    }
    
    float max(float a,float b){
    	if(a>b) 
    		return a;
    		
    	return b;
    }
    
    command void Avt.adjustValue(uint8_t feedback);
    {    	
    	// 1 - Updates the delta value
		updateDelta(feedback);

		// 2 - Adjust the current value
		if (feedback != FEEDBACK_GOOD) {
			value = min(upperBound,max(lowerBound,value + delta*(feedback == FEEDBACK_GREATER ? 1.0 : -1.0)));
		}
		
		lastFeedback = feedback;
    } 
}
