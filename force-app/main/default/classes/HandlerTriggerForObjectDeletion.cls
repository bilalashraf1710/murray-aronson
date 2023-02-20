public class HandlerTriggerForObjectDeletion {
    
    
    public static void deletePhotoObjectAfterDeletingPhoto(List<ContentDocument> deletedDocumentList)
        {
            Set<id> allDeletedDocumentIds = new Set<id>();
            system.debug(deletedDocumentList);
			for(ContentDocument file : deletedDocumentList)
            {
                allDeletedDocumentIds.add(file.id);// add deleted document ids to a set.
			}
            system.debug(allDeletedDocumentIds);
            
            List<ContentDocumentLink> allDeletedDocumentLinkedEntityObjects = new List<ContentDocumentLink>();
            if(allDeletedDocumentIds!=NULL)
            {
            allDeletedDocumentLinkedEntityObjects = [SELECT LinkedEntityId,ContentDocumentId FROM ContentDocumentLink where ContentDocumentId IN :allDeletedDocumentIds];
			system.debug(allDeletedDocumentLinkedEntityObjects); // getting Photo Object id connected to deleted document
            }
            
            set<id> setOfLinkedEntityIds = new set<id>();
            
            if(allDeletedDocumentLinkedEntityObjects!=NULL)
            {
            
            for(ContentDocumentLink obj : allDeletedDocumentLinkedEntityObjects)
            {
					setOfLinkedEntityIds.add(obj.LinkedEntityId);// making set for the linkedEntityids
            }
            
            system.debug(setOfLinkedEntityIds);
                
            }
            
            List<Building_Photo__c> DeletePhotoObjectList = new List<Building_Photo__c>();
            if(setOfLinkedEntityIds!=NULL)
            {
            DeletePhotoObjectList = [Select Id,Name from Building_Photo__c where Id IN :setOfLinkedEntityIds];
            system.debug(DeletePhotoObjectList);// getting the photo object that want to delete
            
            }  
            
            if(DeletePhotoObjectList!=NULL)
            {
            delete DeletePhotoObjectList;
            }
        }


}