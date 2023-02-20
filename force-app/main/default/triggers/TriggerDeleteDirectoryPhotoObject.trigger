trigger TriggerDeleteDirectoryPhotoObject on ContentDocument (before delete) {
    
    if(trigger.isdelete && DirectoryObjectTriggerStopRecursion.runOnce())
    {
    HandlerTriggerDeleteDirectoryPhotoObject.deleteDirectoryPhotoObjectAfterDeletingDocument(trigger.old);
    }

}