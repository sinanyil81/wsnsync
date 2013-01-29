module LogicalClockC
{
    provides interface LogicalClock;
}
implementation
{
    uint32_t value;
    float multiplier;
    uint32_t lastUpdate;

    command void LogicalClock.start(){
        atomic{
		    value = 0;
		    multiplier = 0.0;
		    lastUpdate = 0;            
        }
    }
    
    async command float LogicalClock.getRate(){
        return multiplier;
    }

    command void LogicalClock.setRate(float rate){
        atomic multiplier = rate;
    }
        
    command void LogicalClock.setValue(uint32_t val,uint32_t localTime){
        atomic{
            value = val;
            lastUpdate = localTime;
        }
    }
    
    command void LogicalClock.update(uint32_t time){
    
        uint32_t timePassed = time - lastUpdate;       
        uint32_t val = value + timePassed + (int32_t)(multiplier*(int32_t)(timePassed));
        
        atomic{
            value = val;
            lastUpdate = time;
        }      
    }

    async command void LogicalClock.getValue(uint32_t *time){
    
        uint32_t timePassed = *time - lastUpdate;
               
        *time = value + timePassed + (int32_t)(multiplier*(int32_t)(timePassed));        
    }

}