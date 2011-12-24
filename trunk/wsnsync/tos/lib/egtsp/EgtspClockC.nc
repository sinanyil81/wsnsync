module EgtspC
{
    provides
    {
        interface EgtspClock;
    }
}
implementation
{
    uint32_t offset;                    // offset of the logical clock
    float multiplier;                   // rate multiplier of the logical clock
    uint32_t lastUpdate;                // local time at which the offset of the logical clock is updated

    command void EgtspClock.start(){
        atomic{
            offset = 0;
            lastUpdate = 0;
            multiplier = 0.0;
        }
    }

    command void EgtspClock.setRate(float rate){
        atomic multiplier = rate;
    }

    async command float EgtspClock.getRate(){
        return multiplier;
    }

    command void EgtspClock.setValue(uint32_t value,uint32_t localTime){
        atomic{
            offset = value;
            lastUpdate = localTime;
        }
    }

    async command void EgtspClock.getValue(uint32_t *time){
        uint32_t timePassed = *time - lastUpdate;

        *time = offset;
        *time += timePassed + (int32_t)(multiplier*(int32_t)(timePassed));
        
    }
}