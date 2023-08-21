public with sharing class MarketSubmarketCityController {
    
    @AuraEnabled
    public static String getMarketName(string recordId)
    {
        try{
        Market__c obj = [Select Id, Name from Market__c where Id =:recordId];
        return obj.Name;
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
     @AuraEnabled
    public static List<Submarket__c> getMarketRelatedSubMarkets(string recordId)
    {
        try {
        List<Submarket__c> submarketList = [Select Id, Name from Submarket__c where Market__c =:recordId];
        return submarketList;
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
     @AuraEnabled
    public static List<City__c> getSubMarketRelatedCities(string recordId)
    {
        try{
        List<City__c> CitiesList = [Select Id, Name from City__c where Submarket__c =:recordId];
        return CitiesList;
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }

}