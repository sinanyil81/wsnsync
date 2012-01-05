module FCSAClockC
{
    provides
    {
        interface FCSAClock;
    }
}
implementation
{
    uint32_t offset;                    // offset of the logical clock
    float multiplier;                   // rate multiplier of the logical clock
    float rootMultiplier;               // rate multiplier of the root node
    uint32_t lastUpdate;                // local time at which the offset of the logical clock is updated

    command void FCSAClock.start(){
        atomic{
            offset = 0;
            lastUpdate = 0;
            multiplier = 0.0;
            rootMultiplier = 0.0;
        }
    }

    command void FCSAClock.setRate(float rate){
        atomic multiplier = rate;
    }
    
    command void FCSAClock.setRootRate(float rate){
        atomic rootMultiplier = rate;
    }

    async command void FCSAClock.getRate(float *rate){
        *rate = multiplier;
    }
    
    async command void FCSAClock.getRootRate(float *rate){
        *rate = rootMultiplier;
    }

    command void FCSAClock.setValue(uint32_t value,uint32_t localTime){
        atomic{
            offset = value;
            lastUpdate = localTime;
        }
    }

    async command void FCSAClock.getValue(uint32_t *time){
    
        uint32_t timePassed = *time - lastUpdate;
        float r = (multiplier - rootMultiplier)/(rootMultiplier + 1.0);
        
        *time = offset;
        *time += timePassed + (int32_t)(r*(int32_t)(timePassed));        
    }
}