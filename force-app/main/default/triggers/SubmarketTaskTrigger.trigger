trigger SubmarketTaskTrigger on Submarket__c (after insert) {
    SubmarketTaskTriggerHelper.CreateSubmarketRelatedTasks(Trigger.new);
}