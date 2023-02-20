public class HandlerTriggerOnOMRental {
    
    public static void deleteDocumentAfterDeletingFloorPlanObject(Map<Id,OM_and_Rent_Roll__c> deletedOMRentalList)
    {
		Set<id> allDeletedOMRentalIds = deletedOMRentalList.keySet();
        List<ContentDocumentLink> allDeletedOMRentalLinkedDocumentObjects = new List<ContentDocumentLink>();
         List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        
        if(allDeletedOMRentalIds!=NULL)
        {
        
	        //getting all content document ids from content document link object related to OM & Rental Object
        	allDeletedOMRentalLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedOMRentalIds ];
       
        }
         
        if(allDeletedOMRentalLinkedDocumentObjects!=NULL)
        {
        	for(ContentDocumentLink obj : allDeletedOMRentalLinkedDocumentObjects)
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