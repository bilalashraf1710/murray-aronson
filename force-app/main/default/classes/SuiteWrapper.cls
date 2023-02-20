public class SuiteWrapper  implements Comparable{
    

       public IndividualSuite suite;
    
    // Constructor
    public SuiteWrapper(IndividualSuite sui) {
    	// Guard against wrapping a null 
    	if(sui == null) {
    		Exception ex = new NullPointerException();
    		ex.setMessage('Suite argument cannot be null'); 
    		throw ex;
    	}
        suite = sui;
    }
    
    // Compare Suites based on the Suite Nmber.
    public Integer compareTo(Object compareTo) {
        
        system.debug('In compare function');
        // Cast argument to SuiteWrapper
        SuiteWrapper compareTosuite = (SuiteWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        system.debug('Suite number =>' + suite.SuiteNumberSort + 'compareTosuite=> ' + compareTosuite.suite.SuiteNumberSort);
        if ((suite.SuiteNumberSort == null) && (compareTosuite.suite.SuiteNumberSort == null)) {
            // both wrappers have null Amounts
            returnValue = 0;
        } else if ((suite.SuiteNumberSort == null) && (compareTosuite.suite.SuiteNumberSort != null)){
            // nulls-first implementation
            returnValue = -1;
        } else if ((suite.SuiteNumberSort != null) && (compareTosuite.suite.SuiteNumberSort == null)){
            // nulls-first implementation
            returnValue = 1;
        } else if (suite.SuiteNumberSort > compareTosuite.suite.SuiteNumberSort) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (suite.SuiteNumberSort < compareTosuite.suite.SuiteNumberSort) {
            // Set return value to a negative value.
            returnValue = -1;
        } 
        return returnValue;
    }

}