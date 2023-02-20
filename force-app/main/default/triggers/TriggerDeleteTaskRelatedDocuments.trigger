trigger TriggerDeleteTaskRelatedDocuments on Task (before delete) {
    
    if(trigger.isdelete)
    {
        HandlerTriggerDeleteTaskRelatedDocuments.deleteDocumentsAfterDeletingTaskObject(trigger.old);
    }

}