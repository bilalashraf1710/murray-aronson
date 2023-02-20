trigger MarketTaskTrigger on Market__c (after insert) {
    MarketTaskTriggerHelper.CreateMarketRelatedTasks(Trigger.new);
}