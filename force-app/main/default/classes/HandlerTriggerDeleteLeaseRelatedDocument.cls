public class HandlerTriggerDeleteLeaseRelatedDocument {
    
    public static void deleteDocumentAfterDeletingLeaseObject(Map<Id,Lease__c> deletedLeaseList)
    {
		Set<id> allDeletedLeaseIds = deletedLeaseList.keySet();
        List<ContentDocumentLink> allDeletedLeaseLinkedDocumentObjects = new List<ContentDocumentLink>();
         List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        
        if(allDeletedLeaseIds!=NULL)
        {
        
	        //getting all content document ids from content document link object related to Lease
        	allDeletedLeaseLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedLeaseIds ];
       
        }
         
        if(allDeletedLeaseLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedLeaseLinkedDocumentObjects)
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