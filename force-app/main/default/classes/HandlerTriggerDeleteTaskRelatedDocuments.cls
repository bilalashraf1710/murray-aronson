public class HandlerTriggerDeleteTaskRelatedDocuments {
    
     public static void deleteDocumentsAfterDeletingTaskObject(List<Task> deletedTaskList)
    {
		Set<id> allDeletedTaskIds = new Set<id>();
        system.debug(deletedTaskList);
        for(Task TaskObj : deletedTaskList)
        {
			allDeletedTaskIds.add(TaskObj.id);// set of all deleted Task object
        }
        
        system.debug(allDeletedTaskIds);
        
        List<ContentDocumentLink> allDeletedTaskLinkedDocumentObjects = new List<ContentDocumentLink>();
        
        if(allDeletedTaskIds!=NULL)
        {
        
        //getting all content document ids from content document link object related to Task
        allDeletedTaskLinkedDocumentObjects = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId IN :allDeletedTaskIds ];
            system.debug(allDeletedTaskLinkedDocumentObjects);
        }
         
        
        Set<id> SetOfDocumentids = new Set<id>();
        
        if(allDeletedTaskLinkedDocumentObjects!=NULL)
        {
        for(ContentDocumentLink obj : allDeletedTaskLinkedDocumentObjects)
        {
            SetOfDocumentids.add(obj.ContentDocumentId); // adds in sets 
        }
        
        
        system.debug(SetOfDocumentids);
        }
        
        List<ContentDocument> deletedDocumentIdsList= new List<ContentDocument>();
        if(SetOfDocumentids!=NULL)
        {
         deletedDocumentIdsList = [Select Id from ContentDocument where Id IN : SetOfDocumentids];
        system.debug(deletedDocumentIdsList);// getting content document object that wants to delete
        }
        if(deletedDocumentIdsList!=NULL)
        { 
        delete deletedDocumentIdsList;
            
        }
        
          
    }

}