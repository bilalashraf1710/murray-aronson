public class HandlerForTriggerOnFloorPlan {
    
    public static void deleteDocumentAfterDeletingFloorPlanObject(Map<Id,Floor_Plan__c> deletedFloorPlanList)
    {
		Set<id> allDeletedFloorPlanIds = deletedFloorPlanList.keySet();
        List<ContentDocumentLink> allDeletedFloorPlanLinkedDocumentObjects = new List<ContentDocumentLink>();
         List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        
        if(allDeletedFloorPlanIds!=NULL)
        {
        
	        //getting all content document ids from content document link object related to Floor Plan
        	allDeletedFloorPlanLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedFloorPlanIds ];
       
        }
         
        if(allDeletedFloorPlanLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedFloorPlanLinkedDocumentObjects)
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