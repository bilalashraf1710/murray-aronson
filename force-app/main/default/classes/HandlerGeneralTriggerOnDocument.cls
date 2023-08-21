public class HandlerGeneralTriggerOnDocument {
    
    public static void deleteRelativeObjectAfterDeletingDocument(Map<Id,ContentDocument> deletedDocumentList)
        {
            
            List<ContentDocumentLink> allDeletedDocumentLinkedEntityObjects = new List<ContentDocumentLink>();
            Set<id> setOfLinkedEntityIds = new Set<id>();
            
            Set<id> allDeletedDocumentIds = deletedDocumentList.keySet();
            
            if(allDeletedDocumentIds!=NULL)
            {
            	allDeletedDocumentLinkedEntityObjects = [SELECT LinkedEntityId,ContentDocumentId FROM ContentDocumentLink where ContentDocumentId IN :allDeletedDocumentIds];
				 // getting Linked Entity id connected to deleted document
            }
            
          
            if(allDeletedDocumentLinkedEntityObjects!=NULL)
            {
            	for(ContentDocumentLink obj : allDeletedDocumentLinkedEntityObjects)
           	    {
					setOfLinkedEntityIds.add(obj.LinkedEntityId);// making set for the linkedEntityids           
            	}    
            }

            String ObjectType;
            Id directoryObjectId;
            if(setOfLinkedEntityIds!=NULL)
            {
                for(Id recordid : setOfLinkedEntityIds)
                {
                    if(String.valueOf(recordid.getSObjectType()) != 'User')
                    {
                        directoryObjectId = recordid;
                        ObjectType =  String.valueOf(recordid.getSObjectType());
                        break;
                    }
                }
            }
            
           
            List<SObject> DeleteSObjectList = new List<SObject>();
            if(setOfLinkedEntityIds!=NULL)
            {
            	if(ObjectType =='Costar_Report__c' ||
               	   //ObjectType =='Building_Directory__c' ||
               	   ObjectType =='Flyers__c' ||
               	   ObjectType =='Lease__c' ||
               	   ObjectType =='Building_Photo__c'||
               	   ObjectType =='Video__c' ||
                   ObjectType =='Floor_Plan__c' 
                   ||
                   ObjectType =='OM_and_Rent_Roll__c'
                   )
            	{
            		String query= 'Select Id,Name from ' + ObjectType+ ' where Id IN :setOfLinkedEntityIds';    
            		DeleteSObjectList = Database.query(query);
            		system.debug(DeleteSObjectList);// getting the  Sobject that want to delete
            	}
                
                //else if (ObjectType =='Building_Directory__c' || ObjectType =='Suite_Photos__c')
             /*    else if (ObjectType =='Building_Directory__c')
                {
                    List<ContentDocumentLink> directoryObjDoc = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =:directoryObjectId];
                    system.debug('directoryObjDoc=>' + directoryObjDoc);
                    system.debug('directoryObjDocSize=>' + directoryObjDoc.size());
                    if(directoryObjDoc.size() < 2 )
                    {
					String query= 'Select Id,Name from ' + ObjectType+ ' where Id IN :setOfLinkedEntityIds';    
            		DeleteSObjectList = Database.query(query);
            		system.debug(DeleteSObjectList);// getting the  Sobject that want to delete
                    }
                    
                }
*/
            }  
            
            if(DeleteSObjectList!=NULL)
            {
            delete DeleteSObjectList;
            }
        }

}