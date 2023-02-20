public class HandlerTriggerDeleteCostarReport {
    
     public static void deleteCostarReportObjectAfterDeletingDocument(List<ContentDocument> deletedDocumentList)
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
			system.debug(allDeletedDocumentLinkedEntityObjects); // getting Costar Report id connected to deleted document
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
            
            List<Costar_Report__c> DeleteCostarReportList = new List<Costar_Report__c>();
            if(setOfLinkedEntityIds!=NULL)
            {
            DeleteCostarReportList = [Select Id,Name from Costar_Report__c where Id IN :setOfLinkedEntityIds];
            system.debug(DeleteCostarReportList);// getting the Costar Report object that want to delete
            
            }  
            
            if(DeleteCostarReportList!=NULL)
            {
            delete DeleteCostarReportList;
            }
        }
    
    

}