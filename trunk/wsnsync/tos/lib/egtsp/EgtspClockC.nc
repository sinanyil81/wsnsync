module EgtspClockC
{
    provides
    {
        interface EgtspClock;
    }
}
implementation
{
    uint32_t base;                    	// base of the logical clock
    uint32_t offset;                    // offset of the logical clock
    uint32_t UTCOffset;                 // offset of the logical clock
    float multiplier;                   // rate multiplier of the logical clock
    float rootMultiplier;               // rate multiplier of the root node
    uint32_t lastUpdate;                // local time at which the base of the logical clock is updated

    command void EgtspClock.start(){
        atomic{
            base = 0;
            offset = 0;
            UTCOffset = 0;
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

    async command void EgtspClock.getRate(float *rate){
        *rate = multiplier;
    }
    
    async command void EgtspClock.getRootRate(float *rate){
        *rate = rootMultiplier;
    }
    
    command void EgtspClock.setOffset(uint32_t value){
        atomic{
            //offset = value;
            base += value;
        }
    }    
    
	command void EgtspClock.setUTCOffset(uint32_t value){
        atomic{
            UTCOffset = value;
        }
    }   

    command void EgtspClock.setValue(uint32_t value,uint32_t localTime){
        atomic{
            base = value;
            lastUpdate = localTime;
        }
    }
    
    async command void EgtspClock.getOffset(uint32_t *o){
    	*o = offset;
    }
    
    async command void EgtspClock.getUTCOffset(uint32_t *o){
    	*o = UTCOffset;
    }    

    async command void EgtspClock.getValue(uint32_t *time){
    
        uint32_t timePassed = *time - lastUpdate;
        float r = (multiplier - rootMultiplier)/(rootMultiplier + 1.0);
        
        //*time = base + offset;
        *time = base;
        *time += timePassed + (int32_t)(r*(int32_t)(timePassed));        
    }
}