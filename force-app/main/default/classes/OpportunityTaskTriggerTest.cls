@isTest
public with sharing class OpportunityTaskTriggerTest {
    @isTest
    public static void CreateOpportunityTasksOnUpdate(){
        Date d = Date.newInstance(2000, 2, 20);
        Account ac = new Account(
        Name='test Account',
        Client_Status__c = 'Active');
        insert ac;
        Opportunity op = new Opportunity(
            AccountId=ac.Id,
            Name = 'Test opp',
            Date_Added__c = d,
            Deal_Source__c = 'New Business',
            Commission__c = 'Percentage',
            CloseDate = d,
            Deal_Value__c = 12,
            StageName = 'Commission'
        );
        insert op;
        Task t = [SELECT Subject, WhatId FROM Task LIMIT 1];
        system.Assert(t.Subject == 'Post Close To Do\'s');
        system.Assert(t.WhatId == ac.Id);

    }
    
    @isTest
    public static void CreateOpportunityTasksOnInsert(){
        Date d = Date.newInstance(2000, 2, 20);
        Account ac = new Account(
        Name='test Account',
        Client_Status__c = 'Active');
        insert ac;
        
        Opportunity op2 = new Opportunity(
            AccountId=ac.Id,
            Name = 'Test opp2',
            Date_Added__c = d,
            Deal_Source__c = 'New Business',
            Commission__c = 'Percentage',
            CloseDate = d,
            Deal_Value__c = 12,
            StageName = 'Lease Execution'
        );
        insert op2;
        
        op2.StageName = 'Commission';
        update op2;
        Task t = [SELECT Subject, WhatId FROM Task LIMIT 1];
        system.Assert(t.Subject == 'Post Close To Do\'s');
        system.Assert(t.WhatId == ac.Id);
    }
}