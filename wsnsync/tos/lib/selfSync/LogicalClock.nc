interface LogicalClock
{
    command void start();
    
    async command float getRate();
    
    command void setRate(float multiplier);
       
    command void setValue(uint32_t value,uint32_t localTime);
    
    command void update(uint32_t localTime);    
        
    async command void getValue(uint32_t *time);       
}