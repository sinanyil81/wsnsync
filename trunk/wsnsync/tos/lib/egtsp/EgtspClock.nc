interface EgtspClock
{
    command void start();
    
    command void setRate(float multiplier); 
    
    command void setValue(uint32_t value,uint32_t localTime);
    
    async command void getValue(uint32_t *time);

    async command float getRate();
}