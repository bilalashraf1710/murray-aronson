trigger TriggerDeleteDocumentRelatedFlyer on ContentDocument (before delete) {
    
    if(trigger.isdelete && CheckFlyerDocumentTriggerStopRecursion.runOnce())
    {
    HandlerTriggerDeleteDocumentRelatedFlyer.deleteFlyerAfterDeletingDocument(trigger.old);
    }
    

}