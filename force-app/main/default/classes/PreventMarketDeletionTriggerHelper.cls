public with sharing class PreventMarketDeletionTriggerHelper {

    public static Set<Id> getMarketIdsRelatedToTasks(Map<Id,Market__c> marketList){
        Set<Id> marketIds = marketList.keyset();
        Task[] tasksAffiliatedWithMarkets = [SELECT WhatId FROM Task WHERE WhatId IN:marketIds];

        Set<Id> marketIdsRelatedToTasks = new Set<Id>();
        for(Task t : tasksAffiliatedWithMarkets) {
            marketIdsRelatedToTasks.add(t.WhatId);
        }

        return marketIdsRelatedToTasks;
    }
}