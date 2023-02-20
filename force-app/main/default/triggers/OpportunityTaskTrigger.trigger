trigger OpportunityTaskTrigger on Opportunity (after update, after insert) {
    if(Trigger.isUpdate){
        OpportunityTaskTriggerHelper.CreateOpportunityTasks(Trigger.NewMap, Trigger.OldMap);
    }
    if(Trigger.isInsert){
        OpportunityTaskTriggerHelper.CreateOpportunityTasksOnInsert(Trigger.New);
    }
    
}