public class HandlerTriggerDeleteFlyerRelatedDocument {
    
    public static void deleteDocumentAfterDeletingFlyerObject(Map<Id,Flyers__c> deletedFlyerList)
    {
		Set<id> allDeletedFlyerIds = deletedFlyerList.keySet();
       
        List<ContentDocumentLink> allDeletedFlyerLinkedDocumentObjects = new List<ContentDocumentLink>();
         List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        
        if(allDeletedFlyerIds!=NULL)
        {
        
	        //getting all content document ids from content document link object related to Flyer
        	allDeletedFlyerLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedFlyerIds ];
       
        }
         
        if(allDeletedFlyerLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedFlyerLinkedDocumentObjects)
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