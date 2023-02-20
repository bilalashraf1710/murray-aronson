trigger TriggerDeleteDocumentForVideo on Video__c (before delete) {
    
    if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
		HandlerTriggerDeleteDocumentForVideo.deleteDocumentAfterDeletingVideoObject(trigger.oldMap);
    }

}