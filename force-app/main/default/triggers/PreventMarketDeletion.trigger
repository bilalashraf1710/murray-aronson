trigger PreventMarketDeletion on Market__c (before delete) {

    Set<Id> marketIdsRelatedToTasks = PreventMarketDeletionTriggerHelper.getMarketIdsRelatedToTasks(Trigger.Oldmap);

    for(Market__c market : Trigger.Old){
        if(marketIdsRelatedToTasks.contains(market.Id)){
            market.addError('Cannot delete. \n There are tasks affiliated with this Market');
        }
        
    }
}