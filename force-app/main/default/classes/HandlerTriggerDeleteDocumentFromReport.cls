public class HandlerTriggerDeleteDocumentFromReport {
    
     public static void deleteDocumentAfterDeletingCostarReportObject(Map<Id,Costar_Report__c> deletedCostarReportList)
    {
		Set<id> allDeletedCostarReportIds = deletedCostarReportList.keySet();
        List<ContentDocumentLink> allDeletedCostarReportLinkedDocumentObjects = new List<ContentDocumentLink>();
        
        if(allDeletedCostarReportIds!=NULL)
        {
        	//getting all content document ids from content document link object related to Costar Report
        	allDeletedCostarReportLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedCostarReportIds ];  
        }
            
        List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        if(allDeletedCostarReportLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedCostarReportLinkedDocumentObjects)
        	{
                ContentDocument docObj = new ContentDocument(Id = obj.ContentDocumentId); //ading all document ids that want to delete
                deletedDocumentIdsList.add(docObj);
        	}
        
        }
       
        if(deletedDocumentIdsList!=NULL)
        { 
        delete deletedDocumentIdsList;    
        }
                
    }

}