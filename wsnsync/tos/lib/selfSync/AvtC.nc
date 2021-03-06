#include "Avt.h"

module AvtC
{
    provides
    {
        interface Avt;
    }       
}
implementation
{
	#define INCREASE_FACTOR 2.0f
	#define DECREASE_FACTOR 3.0f
	 
	float lowerBound = 0.0;
	float upperBound = 0.0;
	float value = 0.0;
	
	float delta, deltaMin, deltaMax;
	
	uint8_t numSuccessiveGood = 0;
	
	uint8_t lastFeedback = FEEDBACK_NONE;
			
    command void Avt.init(float lBound,float uBound,float val)
    {
		lowerBound = lBound;
		upperBound = uBound;
		value = val;
		
		/* delta bounds */
		deltaMin = 0.00000001f;
		deltaMax = 0.00001024f;
		delta = 0.00000032f;
    }
    
    command float Avt.getValue(){
    
    	return value;
    }
    
	command float Avt.getDelta(){
    
    	return delta;
    }
    
    void increaseDelta(){
    	delta *= INCREASE_FACTOR;    
    	
    	if(delta > deltaMax){
    		delta = deltaMax;
    	}	
    }
    
    void decreaseDelta(){
    	delta /= DECREASE_FACTOR;
    	
    	if(delta < deltaMin){
    		delta = deltaMin;
    	}     
    }
        
    void updateDelta(uint8_t feedback){
    	if(lastFeedback == FEEDBACK_NONE)
    		return;
    
    	if (lastFeedback == FEEDBACK_GOOD) {
			if (feedback == FEEDBACK_GOOD) {
				numSuccessiveGood++;
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
    
    command void Avt.adjustValue(uint8_t feedback)
    {    	
    	// 1 - Updates the delta value
		updateDelta(feedback);

		// 2 - Adjust the current value
		if (feedback != FEEDBACK_GOOD) {
			value = min(upperBound,max(lowerBound,value + delta*(feedback == FEEDBACK_GREATER ? 1.0f : -1.0f)));
		}
		
		lastFeedback = feedback;
    } 
}
