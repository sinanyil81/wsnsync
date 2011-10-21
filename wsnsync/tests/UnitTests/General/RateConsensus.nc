interface RateConsensus
{
    command void reset();
    
    command void updateNeighbors(uint32_t currentTime);
    
    command error_t storeNeighborInfo(uint8_t neighborID,float multiplier,uint32_t neighborClock,uint32_t eventTime);
                           
    command float getRate(float myRate);

    command void print();
}