public with sharing class PreventSubmarketDeletionTriggerHelper {
    public static Set<Id> getSubmarketIdsRelatedToTasks(Map<Id,Submarket__c> submarketList){
        Set<Id> submarketIds = submarketList.keyset();
        Task[] tasksAffiliatedWithSubmarkets = [SELECT WhatId FROM Task WHERE WhatId IN:submarketIds];

        Set<Id> submarketIdsRelatedToTasks = new Set<Id>();
        for(Task t : tasksAffiliatedWithSubmarkets) {
            submarketIdsRelatedToTasks.add(t.WhatId);
        }

        return submarketIdsRelatedToTasks;
    }
}