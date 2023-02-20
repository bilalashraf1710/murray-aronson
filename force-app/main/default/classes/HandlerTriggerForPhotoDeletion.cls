public class HandlerTriggerForPhotoDeletion {
    
     public static void deletePhotoAfterDeletingPhotoObject(Map<Id,Building_Photo__c> deletedPhotoList)
    {
		 Set<id> allDeletedPhotoObjectIds = deletedPhotoList.keySet();
         List<ContentDocumentLink> allDeletedPhotoLinkedDocumentObjects = new List<ContentDocumentLink>();
         List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        
        if(allDeletedPhotoObjectIds!=NULL)
        {
        
	        //getting all content document ids from content document link object related to Photo Object
        	allDeletedPhotoLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedPhotoObjectIds ];
       
        }
         
        if(allDeletedPhotoLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedPhotoLinkedDocumentObjects)
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