interface Avt
{
	command void init(float lowerBound,float upperBound,float value);
	/**
	 * Adjusts the value to the direction of the given feedback.
	 * <ul>
	 * 	<li><code>FEEDBACK_GREATER</code>: increments the current value</li>
	 *  <li><code>FEEDBACK_LOWER<code>: decrements the current value</li>
	 *  <li><code>FEEDBACK_GOOD</code>: decreases the criticity of the AVT but
	 *  	doesn't change the value. This feedbacks express that the current
	 *  	value is good and should evolve more slowly at the next adjustment.
	 *  </li>
	 * </ul>
	 * 
	 * 
	 * @param feedback
	 */
	command void adjustValue(uint8_t feedback);
	
	/**
	 * Current value determied by the AVT.
	 * 
	 * @return the current value determied by the AVT
	 */
	command float getValue();	
}