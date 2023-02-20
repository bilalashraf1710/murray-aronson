public class HandlerTriggerDeleteDocumentForVideo {
    
    public static void deleteDocumentAfterDeletingVideoObject(Map<Id,Video__c> deletedVideoList)
    {
		Set<id> allDeletedVideoIds = deletedVideoList.keySet();
        List<ContentDocumentLink> allDeletedVideoLinkedDocumentObjects = new List<ContentDocumentLink>();
         List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        
        if(allDeletedVideoIds!=NULL)
        {
        
	        //getting all content document ids from content document link object related to Video
        	allDeletedVideoLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedVideoIds ];
       
        }
         
        if(allDeletedVideoLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedVideoLinkedDocumentObjects)
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