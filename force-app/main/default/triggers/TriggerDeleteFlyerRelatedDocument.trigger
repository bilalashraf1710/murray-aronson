trigger TriggerDeleteFlyerRelatedDocument on Flyers__c (before delete) {
    
    
    if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
        HandlerTriggerDeleteFlyerRelatedDocument.deleteDocumentAfterDeletingFlyerObject(trigger.oldMap);
    }
    
        HanlderWhenRecentFlyerDelete.UpdateSecondRecentFlyerField(trigger.old);
    
    

}