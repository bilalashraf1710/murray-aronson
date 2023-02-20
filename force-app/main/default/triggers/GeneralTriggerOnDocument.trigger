trigger GeneralTriggerOnDocument on ContentDocument (before delete) {
    
    if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
      HandlerGeneralTriggerOnDocument.deleteRelativeObjectAfterDeletingDocument(trigger.oldMap);
    }

}