interface EgtspNeighborTable
{
    command void reset();
    
    command void update(uint32_t time);
    
    command error_t storeInfo(uint16_t id,float multiplier,float rootMultiplier,uint32_t localTime,uint32_t globalTime,uint32_t timestamp);
                               
    command void getNeighborhoodRate(float *myRate);
    
    async command void getNeighborhoodOffset(uint32_t *myOffset,uint32_t myClock,uint32_t timestamp);
}