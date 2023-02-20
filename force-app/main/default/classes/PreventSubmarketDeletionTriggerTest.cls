@isTest
public with sharing class PreventSubmarketDeletionTriggerTest {
    @isTest
    public static void testPreventSubmarketDeletionTrigger() {
		Market__c market = new Market__c(
            Continent__c = 'North America',
            Country__c = 'United States',
            State_Territory__c = 'CA'
        );
        insert market;
        
        Submarket__c submarket = new Submarket__c(
        	Continent__c = 'North America',
            Country__c = 'United States',
            State_Territory__c = 'CA',
            Market__c = market.Id
        );
        insert submarket;    
        
        try{
            delete submarket;
        } catch (Exception e){
            system.Assert(true, 'exception was expected');
        }
        
        submarket = [SELECT Id FROM Submarket__c WHERE Id =: submarket.Id LIMIT 1];
        system.Assert(submarket != null);
        
        Task task = [SELECT WhatId FROM Task WHERE WhatId =: submarket.Id];
        delete task;
        delete submarket;
        
        Submarket__c[] submarketList = [SELECT Id FROM Submarket__c LIMIT 1];
        system.Assert(submarketList.size()==0);
        
        
    }
}