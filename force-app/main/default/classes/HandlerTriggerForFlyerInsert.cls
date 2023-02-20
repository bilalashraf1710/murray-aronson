public class HandlerTriggerForFlyerInsert {
    
    

    public static void UpdateDirectFlyerStatus(List<Flyers__c> FlyersList)
        
    {
        Flyers__c FlyerObj = FlyersList[0];


        
        if(CheckFlyerDateRecentOrNot(FlyerObj))
        {
        
           
			if((FlyerObj.Flyer_Type__c == 'Direct' || FlyerObj.Flyer_Type__c == 'Sale') && FlyerObj.Active_or_Inactive__c=='Active')
            {
                
                
                List<Flyers__c> AllFlyersRelatedToBuilding = [Select Id,Name, building__c,Active_or_Inactive__c,Flyer_Date__c,
                                                              Flyer_Type__c
                                                              from Flyers__c where building__c =:FlyerObj.Building__c 
                                                              AND ID != :FlyerObj.Id
                                                             ];
                
                
                
                
                List<Flyers__c> FlyersNeedToUpdate = new List<Flyers__c>();
                
                if(AllFlyersRelatedToBuilding!=NULL)
                {
                  
                for(Flyers__c obj : AllFlyersRelatedToBuilding)
                {
                    if((FlyerObj.Flyer_Type__c == 'Direct' || FlyerObj.Flyer_Type__c == 'Sale') && obj.Active_or_Inactive__c == 'Active')
                    {
                        	
							obj.Active_or_Inactive__c = 'Inactive';
                        	FlyersNeedToUpdate.add(obj);
                    }
                }
                    
                }
                
               
                
                
                if(FlyersNeedToUpdate!=NULL)
                {
                    UpdationClassForFlyer.isfutureupdate=true;
					update FlyersNeedToUpdate;
                }

            }
            
        
        
        }
        
        
      	else 
        {
          
            if((FlyerObj.Flyer_Type__c == 'Direct' || FlyerObj.Flyer_Type__c == 'Sale') && FlyerObj.Active_or_Inactive__c=='Active')
            {
                
                List<Flyers__c> AllFlyersRelatedToBuilding = [Select Id,Name, building__c,Active_or_Inactive__c,Flyer_Date__c,
                                                              Flyer_Type__c
                                                              from Flyers__c where building__c =:FlyerObj.Building__c 
                                                              AND ID = :FlyerObj.Id
                                                             ];
                
              
                
                
                List<Flyers__c> FlyersNeedToUpdate = new List<Flyers__c>();
                
                if(AllFlyersRelatedToBuilding!=NULL)
                {
                  
                for(Flyers__c obj : AllFlyersRelatedToBuilding)
                {
                    if((FlyerObj.Flyer_Type__c == 'Direct' || FlyerObj.Flyer_Type__c == 'Sale') && obj.Active_or_Inactive__c == 'Active')
                    {
                        	
							obj.Active_or_Inactive__c = 'Inactive';
                        	FlyersNeedToUpdate.add(obj);
                    }
                }
                    
                }
                
               
                if(FlyersNeedToUpdate!=NULL)
                {
                    UpdationClassForFlyer.isfutureupdate=true;
					update FlyersNeedToUpdate;
                    
                }
            }

        }
    }
    
     public static Boolean CheckFlyerDateRecentOrNot(Flyers__c Obj)
     {
         
		List<Flyers__c> flyersList = [Select Id,Name, building__c,Active_or_Inactive__c,Flyer_Date__c,
                                      Flyer_Type__c
                                      from Flyers__c where building__c =:Obj.Building__c AND Flyer_Date__c > :Obj.Flyer_Date__c AND Flyer_Type__c IN ('Direct','Sale')];
         
         
      if(flyersList.size()>0)
     {
        return false;
     }
      else
    {
        return true;
    }

     }
   
    
   
    
}