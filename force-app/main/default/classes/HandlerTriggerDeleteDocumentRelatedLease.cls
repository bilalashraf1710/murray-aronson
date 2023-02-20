public class HandlerTriggerDeleteDocumentRelatedLease {
    
    	public static void deleteLeaseAfterDeletingDocument(List<ContentDocument> deletedDocumentList)
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
			system.debug(allDeletedDocumentLinkedEntityObjects); // getting lease id connected to deleted document
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
            
            List<Lease__c> DeleteLeaseList = new List<Lease__c>();
            if(setOfLinkedEntityIds!=NULL)
            {
            DeleteLeaseList = [Select Id,Name from Lease__c where Id IN :setOfLinkedEntityIds];
            system.debug(DeleteLeaseList);// getting the lease object that want to delete
            
            }  
            
            if(DeleteLeaseList!=NULL)
            {
            delete DeleteLeaseList;
            }
        }

}