trigger TriggerOnSuitePhoto on Suite_Photos__c (before delete) {
    
     if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
        SuitePhotoTriggerHandler.deleteDocumentAfterDeletingSuitePhotoObject(trigger.oldMap);
    }

}