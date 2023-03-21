@isTest
private class TestMarketSubmarketCityController{
    
    @isTest
    static void TestGetMarketName()
    {
        Market__c marketObj = new  Market__c(Name='test market');
       insert marketObj;
       String marketName = MarketSubmarketCityController.getMarketName(marketObj.Id);
       System.assertEquals('test market',marketName,'Market Name should be same');
    }

    @isTest
    static void TestGetMarketRelatedSubmarkets()
    {
        Market__c marketObj = new  Market__c(Name='test market');
       insert marketObj;
       Submarket__c newSubMarketObj =   new  Submarket__c(Name='test Sub-market',Market__c= marketObj.Id);
       insert newSubMarketObj;
       List<Submarket__c> submarketList = MarketSubmarketCityController.getMarketRelatedSubMarkets(marketObj.Id);
       System.assertEquals(1,submarketList.size(),'Submarket count should be 1');
    }

    @isTest
    static void TestGetSubMarketRelatedCities()
    {
        Market__c marketObj = new  Market__c(Name='test market');
       insert marketObj;
       Submarket__c newSubMarketObj =   new  Submarket__c(Name='test Sub-market',Market__c= marketObj.Id);
       insert newSubMarketObj;
       City__c newCityObj = new City__c(Name='test City',Submarket__c= newSubMarketObj.Id);
       insert newCityObj;
       List<City__c> CitiesList = MarketSubmarketCityController.getSubMarketRelatedCities(newSubMarketObj.Id);
       System.assertEquals(1,CitiesList.size(),'Cities count should be 1');
    }

    @isTest
    static void TestGetMarketNameException()
    {
       try 
        {
            String marketName = MarketSubmarketCityController.getMarketName('1233xxxx');
        }
       catch (Exception e) {
        System.assertEquals(false,e.getMessage().contains('List has no rows for assignment to SObject'));
       }
    }

}