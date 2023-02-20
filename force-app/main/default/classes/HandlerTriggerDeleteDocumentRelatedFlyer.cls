public class HandlerTriggerDeleteDocumentRelatedFlyer {
    
    public static void deleteFlyerAfterDeletingDocument(List<ContentDocument> deletedDocumentList)
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
			system.debug(allDeletedDocumentLinkedEntityObjects); // getting Flyer id connected to deleted document
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
            
            List<Flyers__c> DeleteFlyerList = new List<Flyers__c>();
            if(setOfLinkedEntityIds!=NULL)
            {
            DeleteFlyerList = [Select Id,Name from Flyers__c where Id IN :setOfLinkedEntityIds];
            system.debug(DeleteFlyerList);// getting the Flyer object that want to delete
            
            }  
            
            if(DeleteFlyerList!=NULL)
            {
            delete DeleteFlyerList;
            }
        }

}