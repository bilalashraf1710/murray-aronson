trigger TriggerDeleteLeaseRelatedDocument on Lease__c (before delete) {
    
    if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
		HandlerTriggerDeleteLeaseRelatedDocument.deleteDocumentAfterDeletingLeaseObject(trigger.oldMap);
        
    }


}