interface EgtspNeighborTable
{
    command void reset();
    
    command void update(uint32_t time);
    
    command error_t storeInfo(uint8_t id,float multiplier,uint32_t localTime,uint32_t globalTime,uint32_t timestamp);
                           
    command void getNeighborhoodRate(float *myRate);
    
    command void getNeighborhoodTime(uint32_t *myClock,uint32_t timestamp);
}