@isTest
public class TestCityMapController {
    
    @isTest
    public static void TestBuildingsRelatedCity()
    {
		Market__c marketObj = new  Market__c(Name='test market');
       insert marketObj;
       
	   Submarket__c newSubMarketObj =   new  Submarket__c(Name='test Sub-market',Market__c= marketObj.Id);
       insert newSubMarketObj;
        
       City__c newCityObj = new City__c(Name='test City',Submarket__c= newSubMarketObj.Id);
       insert newCityObj;
        
       List<Building__c> allBuildings = CityMapController.buildingsRelatedCity(newCityObj.Id);
       
        
    }
    
     

}