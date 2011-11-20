interface Neighbors
{
	/* resets collected neighborhood information */
    command void reset();
    
    /* checks neighborhood: removes neighbors if information has not been received
    for an amount of time */
    command void update(uint32_t currentTime);
    
    /* stores collected neighbor information */
    command error_t storeInfo(uint16_t neighborID,uint32_t neighborClock,uint32_t eventTime);
    
    /* returns the relative hardware clock rate of the node */                       
    command error_t getRelativeRate(uint16_t neighborID,float *rate);
}