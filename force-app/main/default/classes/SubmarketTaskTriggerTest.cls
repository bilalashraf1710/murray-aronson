@isTest
public with sharing class SubmarketTaskTriggerTest {
    @isTest
    public static void createSubmarketTaskTriggerTest() {
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
        
        Task t = [SELECT Subject, WhatId FROM Task WHERE WhatId =:submarket.Id LIMIT 1];
        system.AssertEquals(t.Subject, 'Add Cities');
        system.AssertEquals(t.WhatId, submarket.Id);
    }
}