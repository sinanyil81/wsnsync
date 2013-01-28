interface Avt
{
	command void init(float lowerBound,float upperBound,float value);
	command void adjustValue(uint8_t feedback);
	command float getValue();	
}