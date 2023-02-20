public with sharing class NewSubmarketController {
    @AuraEnabled
    public static Market__c getMarketById(String marketId){
        try {
            return [SELECT Continent__c, Country__c, State_Territory__c FROM Market__c WHERE Id=:marketId LIMIT 1];
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Submarket__c getSubmarketById(String submarketId){
        try {
            return [SELECT Continent__c, Country__c, State_Territory__c FROM Submarket__c WHERE Id=:submarketId LIMIT 1];
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}