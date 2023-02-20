public with sharing class MarketTaskTriggerHelper {
    public static void CreateMarketRelatedTasks(Market__c[] marketObjects) {
        Task[] marketRelatedTasks = new Task[]{};
        for(Market__c m : marketObjects) {
            Task t = new Task(
                Subject = 'Add Submarkets',
                Type__c = 'Murray Aronson',
                Sub_Type__c = 'Market Intel',
                Status = 'Not Started',
                Priority = 'Normal',
                ActivityDate = system.today(),
                WhatId = m.Id);
            marketRelatedTasks.add(t);
        }
        try{
            insert marketRelatedTasks;
        } catch(Exception e){
            system.debug('Exception ' + e);
            throw new AuraHandledException(e.getMessage());
        }
        
    }
}