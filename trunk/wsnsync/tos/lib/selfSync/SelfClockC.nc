module SelfClockC
{
    provides interface SelfClock;
}
implementation
{
    uint32_t value;
    int32_t offset;
    float multiplier;
    uint32_t lastUpdate;

    command void SelfClock.start(){
        atomic{
		    value = 0;
		    offset = 0;
		    multiplier = 0.0;
		    lastUpdate = 0;            
        }
    }

    command void SelfClock.setRate(float rate){
        atomic multiplier = rate;
    }
    
    command int32_t SelfClock.getOffset(){
    	return offset;
    }
    
	command void SelfClock.setOffset(int32_t val){
    	atomic offset = val;
    }
    
    command void SelfClock.setValue(uint32_t val,uint32_t localTime){
        atomic{
            value = val;
            offset = 0;
            lastUpdate = localTime;
        }
    }
    
    command void SelfClock.update(uint32_t time){
    
        uint32_t timePassed = time - lastUpdate;       
        uint32_t val = value + timePassed + (int32_t)(multiplier*(int32_t)(timePassed));
        
        atomic{
            value = val;
            lastUpdate = time;
        }      
    }

    async command void SelfClock.getValue(uint32_t *time){
    
        uint32_t timePassed = *time - lastUpdate;
               
        *time = value + offset + timePassed + (int32_t)(multiplier*(int32_t)(timePassed));        
    }

}