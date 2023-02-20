public class HandlerTriggerDeleteDirectoryDocuments {
    
      public static void deleteDocumentAfterDeletingDirectoryPhotoObject(Map<Id,Building_Directory__c> deletedDirectoryPhotoObjectList)
    {
		Set<id> allDeletedDirectoryPhotoObjectIds = deletedDirectoryPhotoObjectList.keySet();
        List<ContentDocumentLink> allDeletedDirectoryPhotoLinkedDocumentObjects = new List<ContentDocumentLink>();
         List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        
        if(allDeletedDirectoryPhotoObjectIds!=NULL)
        {
        
	        //getting all content document ids from content document link object related to Directory Photo Object
        	allDeletedDirectoryPhotoLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedDirectoryPhotoObjectIds ];
       
        }
         
        if(allDeletedDirectoryPhotoLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedDirectoryPhotoLinkedDocumentObjects)
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