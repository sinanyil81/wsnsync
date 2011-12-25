interface EgtspClock
{
    command void start();
    
    command void setRate(float multiplier);
    
    command void setRootRate(float multiplier); 
    
    command void setValue(uint32_t value,uint32_t localTime);
    
    async command float getRate();
    
    async command float getRootRate();
    
    async command void getValue(uint32_t *time);
}