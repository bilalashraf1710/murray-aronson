trigger TriggerDeleteDirectoryObjectDocuments on Building_Directory__c (before delete) {
    
     if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
        HandlerTriggerDeleteDirectoryDocuments.deleteDocumentAfterDeletingDirectoryPhotoObject(trigger.oldMap);
    }

}