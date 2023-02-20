trigger TriggerDeleteVideoForDocument on ContentDocument (before delete) {
    
     if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
    HandlerTriggerDeleteVideoForDocument.deleteVideoObjectAfterDeletingDocument(trigger.old);
    }

}