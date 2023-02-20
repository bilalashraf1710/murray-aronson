trigger TriggerDeleteDocumentRelatedLease on ContentDocument (before delete) {
    
    if(trigger.isdelete && CheckLeaseDocumentTriggerStopRecursion.runOnce())
    {
        HandlerTriggerDeleteDocumentRelatedLease.deleteLeaseAfterDeletingDocument(trigger.old);
    }
    
    

}