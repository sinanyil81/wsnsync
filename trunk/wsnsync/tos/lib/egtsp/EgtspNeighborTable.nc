interface EgtspNeighborTable
{
    command void reset();
    
    command void update(uint32_t time);
    
    command uint32_t getNumNeighbors();
    
    command error_t storeInfo(uint16_t id,float multiplier,float rootMultiplier,uint32_t localTime,uint32_t globalTime,uint32_t timestamp);
                               
    command void getNeighborhoodRate(float *myRate);
    
    command uint32_t getNeighborhoodOffset(uint32_t clock, uint32_t timestamp);
        
}