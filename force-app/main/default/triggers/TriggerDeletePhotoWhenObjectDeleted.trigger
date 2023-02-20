trigger TriggerDeletePhotoWhenObjectDeleted on Building_Photo__c (before delete) {
    
    
     if(trigger.isdelete && StopRecursionForTriggers.runOnce())
    {
	HandlerTriggerForPhotoDeletion.deletePhotoAfterDeletingPhotoObject(trigger.oldMap);
    }

}