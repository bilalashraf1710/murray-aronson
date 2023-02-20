public with sharing class SubmarketTaskTriggerHelper {
    public static void CreateSubmarketRelatedTasks(Submarket__c[] marketObjects) {
        Task[] submarketRelatedTasks = new Task[]{};
        for(Submarket__c submarket : marketObjects) {
            Task t = new Task(
                Subject = 'Add Cities',
                Type__c = 'Murray Aronson',
                Sub_Type__c = 'Market Intel',
                Status = 'Not Started',
                Priority = 'Normal',
                ActivityDate = system.today(),
                WhatId = submarket.Id);
            submarketRelatedTasks.add(t);
        }
        insert submarketRelatedTasks;
    }
}