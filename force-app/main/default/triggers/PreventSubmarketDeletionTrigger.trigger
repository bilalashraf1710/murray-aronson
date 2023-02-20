trigger PreventSubmarketDeletionTrigger on Submarket__c (before delete) {

    Set<Id> submarketIdsRelatedToTasks = PreventSubmarketDeletionTriggerHelper.getSubmarketIdsRelatedToTasks(Trigger.Oldmap);

    for(Submarket__c submarket : Trigger.Old){
        if(submarketIdsRelatedToTasks.contains(submarket.Id)){
            submarket.addError('Cannot delete. \n There are tasks affiliated with this Submarket');
        }
        
    }
}