module EgtspClockC
{
    provides interface EgtspClock;
}
implementation
{
    uint32_t base;          // base of the logical clock
    float multiplier;       // rate multiplier of the logical clock
    float rootMultiplier;   // rate multiplier of the root node
    uint32_t lastUpdate;    // local time at which the base of the logical clock is updated

    command void EgtspClock.start(){
        atomic{
            base = 0;
            lastUpdate = 0;
            multiplier = 0.0;
            rootMultiplier = 0.0;
        }
    }

    command void EgtspClock.setRate(float rate){
        atomic multiplier = rate;
    }
    
    command void EgtspClock.setRootRate(float rate){
        atomic rootMultiplier = rate;
    }

    async command float EgtspClock.getRate(){
        return multiplier;
    }
    
    async command float EgtspClock.getRootRate(){
        return rootMultiplier;
    }

    command void EgtspClock.setValue(uint32_t value,uint32_t localTime){
        atomic{
            base = value;
            lastUpdate = localTime;
        }
    }
    
    command void EgtspClock.update(uint32_t time){
    
        uint32_t timePassed = time - lastUpdate;
        float r = (multiplier - rootMultiplier)/(rootMultiplier + 1.0);
        uint32_t value = base + timePassed + (int32_t)(r*(int32_t)(timePassed));
        
        atomic{
            base = value;
            lastUpdate = time;
        }  
                 
    }

    async command void EgtspClock.getValue(uint32_t *time){
    
        uint32_t timePassed = *time - lastUpdate;
        float r = (multiplier - rootMultiplier)/(rootMultiplier + 1.0);
        
        *time = base + timePassed + (int32_t)(r*(int32_t)(timePassed));        
    }

}