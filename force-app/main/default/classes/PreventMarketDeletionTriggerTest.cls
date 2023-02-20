@isTest
public with sharing class PreventMarketDeletionTriggerTest {
    @isTest
    public static void testPreventMarketDeletionTrigger() {
		Market__c market = new Market__c(
            Continent__c = 'North America',
            Country__c = 'United States',
            State_Territory__c = 'CA'
        );
        insert market;
        try{
            delete market;
        } catch (Exception e){
            system.Assert(true, 'exception was expected');
        }
        
        market = [SELECT Id FROM Market__c WHERE Id =: market.Id LIMIT 1];
        system.Assert(market != null);
        
        Task task = [SELECT WhatId FROM Task WHERE WhatId =: market.Id];
        delete task;
        delete market;
        
        Market__c[] marketList = [SELECT Id FROM Market__c LIMIT 1];
        system.Assert(marketList.size()==0);
        
        
    }
}