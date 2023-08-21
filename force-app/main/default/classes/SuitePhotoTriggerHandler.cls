public class SuitePhotoTriggerHandler {
    
      public static void deleteDocumentAfterDeletingSuitePhotoObject(Map<Id,Suite_Photos__c> deletedSuitePhotoObjectList)
    {
		Set<id> allDeletedSuitePhotoObjectIds = deletedSuitePhotoObjectList.keySet();
        List<ContentDocumentLink> allDeletedSuitePhotoLinkedDocumentObjects = new List<ContentDocumentLink>();
         List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        
        if(allDeletedSuitePhotoObjectIds!=NULL)
        {
        
	        //getting all content document ids from content document link object related to Directory Photo Object
        	allDeletedSuitePhotoLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedSuitePhotoObjectIds ];
       
        }
         
        if(allDeletedSuitePhotoLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedSuitePhotoLinkedDocumentObjects)
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