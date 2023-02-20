public class HandlerTriggerDeleteDirectoryPhotoObject {
    
     public static void deleteDirectoryPhotoObjectAfterDeletingDocument(List<ContentDocument> deletedDocumentList)
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
			system.debug(allDeletedDocumentLinkedEntityObjects); // getting Directory Photo Object id connected to deleted document
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
            
            List<Building_Directory__c> DeleteDirectoryPhotoObjectList = new List<Building_Directory__c>();
            if(setOfLinkedEntityIds!=NULL)
            {
            DeleteDirectoryPhotoObjectList = [Select Id,Name from Building_Directory__c where Id IN :setOfLinkedEntityIds];
            system.debug(DeleteDirectoryPhotoObjectList);// getting the Directory photo object that want to delete
            
            }  
            
            if(DeleteDirectoryPhotoObjectList!=NULL)
            {
            delete DeleteDirectoryPhotoObjectList;
            }
        }



}