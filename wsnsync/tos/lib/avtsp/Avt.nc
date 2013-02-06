interface Avt
{
	command void init(float lowerBound,float upperBound,float value,float deltaMin,float deltaMax,float initialDelta);
	command void adjustValue(uint8_t feedback);
	command float getValue();	
	command float getDelta();
}