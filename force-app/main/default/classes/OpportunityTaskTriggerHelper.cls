public with sharing class OpportunityTaskTriggerHelper {
    public static string comments = '1. Create and send invoice and W9\n2. Upload lease document to Salesforce\n3. Update Salesforce fields\n4. Add Critical Dates\n5. Create combined and highlighted lease documents and upload to Salesforce. ';
    public static void CreateOpportunityTasks(Map<Id,Opportunity> newMap, Map<Id, Opportunity> oldMap){
        Task[] oppTasks = new Task[]{};
        for(Id oppId : newMap.keySet()) {
            if(oldMap.get(oppId).StageName != newMap.get(oppId).StageName){
                if(newMap.get(oppId).StageName == 'Commission'){
                    Task t = new Task(
                        Subject = 'Post Close To Do\'s',
                        Type__c = 'Murray Aronson',
                        Sub_Type__c = 'Account Servicing',
                        Status = 'Not Started',
                        Priority = 'Normal',
                        ActivityDate = system.today(),
                        Periodicity__c = 'N/A',
                        OwnerId = newMap.get(oppId).OwnerId,
                        Description = OpportunityTaskTriggerHelper.comments,
                        WhatId = newMap.get(oppId).AccountId);
                        oppTasks.add(t);
                }
            }
        }
        insert oppTasks;
    }

    public static void CreateOpportunityTasksOnInsert(Opportunity[] oppList) {
        Task[] oppTasks = new Task[]{};
        for(Opportunity opp : oppList) {
            if(opp.StageName == 'Commission'){
                Task t = new Task(
                    Subject = 'Post Close To Do\'s',
                    Type__c = 'Murray Aronson',
                    Sub_Type__c = 'Account Servicing',
                    Status = 'Not Started',
                    Priority = 'Normal',
                    ActivityDate = system.today(),
                    Periodicity__c = 'N/A',
                    OwnerId = opp.OwnerId,
                    Description = OpportunityTaskTriggerHelper.comments,
                    WhatId = opp.AccountId);
                    oppTasks.add(t);
            }
        }
        insert oppTasks;
    }
}