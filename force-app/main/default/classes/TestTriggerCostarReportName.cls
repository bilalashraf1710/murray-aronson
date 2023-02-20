@isTest
private class TestTriggerCostarReportName {
    
    @isTest
    public static void TestChangeCostarReportNameOnInsert()
    {
       Market__c marketObj = new  Market__c(Name='test market');
       insert marketObj;
       
	   Submarket__c newSubMarketObj =   new  Submarket__c(Name='test Sub-market',Market__c= marketObj.Id);
       insert newSubMarketObj;
        
       City__c newCityObj = new City__c(Name='test City',Submarket__c= newSubMarketObj.Id);
       insert newCityObj;
        
       Costar_Report__c newCostarReportObj = new Costar_Report__c(City__c=newCityObj.Id);
       newCostarReportObj.Costar_Report_Date__c = date.newInstance(2022,12,19);
       Insert newCostarReportObj;
    }

}