trigger TriggerDeletePhotoObjectWhenPhotoDeleted on ContentDocument (before delete) {
    
    if(trigger.isdelete && CheckPhotoObjectTriggerStopRecursion.runOnce())
    {
    HandlerTriggerForObjectDeletion.deletePhotoObjectAfterDeletingPhoto(trigger.old);
    }

}