module LogicalClockC
{
    provides
    {
        interface LogicalClock;
    }
}
implementation
{
    uint32_t base;                    	// base of the logical clock
    float multiplier;                   // rate multiplier of the logical clock
    uint32_t lastUpdate;                // local time at which the offset of the logical clock is updated

    command void LogicalClock.start(){
        atomic{
            offset = 0;
            lastUpdate = 0;
            multiplier = 0.0;
        }
    }

    command void LogicalClock.setRate(float rate){
        atomic multiplier = rate;
    }

    async command float LogicalClock.getRate(){
        return multiplier;
    }

    command void LogicalClock.setValue(uint32_t value,uint32_t localTime){
        atomic{
            base = value;
            lastUpdate = localTime;
        }
    }

    async command void LogicalClock.getValue(uint32_t *time){
        uint32_t timePassed = *time - lastUpdate;

        *time = base;
        *time += timePassed + (int32_t)(multiplier*(int32_t)(timePassed));
        
    }
}