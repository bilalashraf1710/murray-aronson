public with sharing class MarketSubmarketCityController {
    
    @AuraEnabled
    public static String getMarketName(string recordId)
    {
        Market__c obj = [Select Id, Name from Market__c where Id =:recordId];
        system.debug(' obj => '+ obj);
        return obj.Name;
    }
    
    
     @AuraEnabled
    public static List<Submarket__c> getMarketRelatedSubMarkets(string recordId)
    {
        List<Submarket__c> submarketList = [Select Id, Name from Submarket__c where Market__c =:recordId];
        system.debug(' submarketList => '+ submarketList);
        return submarketList;
    }
    
     @AuraEnabled
    public static List<City__c> getSubMarketRelatedCities(string recordId)
    {
        List<City__c> CitiesList = [Select Id, Name from City__c where Submarket__c =:recordId];
        system.debug(' CitiesList => '+ CitiesList);
        return CitiesList;
    }

}