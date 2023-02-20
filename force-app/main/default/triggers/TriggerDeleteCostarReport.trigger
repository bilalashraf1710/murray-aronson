trigger TriggerDeleteCostarReport on ContentDocument (before delete) {
    
     if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
        HandlerTriggerDeleteCostarReport.deleteCostarReportObjectAfterDeletingDocument(trigger.old);
    }
   

}