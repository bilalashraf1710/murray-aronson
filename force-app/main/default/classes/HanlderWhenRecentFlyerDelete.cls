public class HanlderWhenRecentFlyerDelete {
    
    public static void UpdateSecondRecentFlyerField(List<Flyers__c> deletedFlyerList)
    {
        
        
        Flyers__c FlyerObj = deletedFlyerList[0];
    
        
        
        if(CheckFlyerDateRecentOrNot(FlyerObj))
        {
           
            if((FlyerObj.Flyer_Type__c == 'Direct' || FlyerObj.Flyer_Type__c == 'Sale') && FlyerObj.Active_or_Inactive__c=='Active')
            {
               
                  List<Flyers__c> GettingMostRecentFlyer = [Select Id,Name, building__c,Active_or_Inactive__c,Flyer_Date__c,
                                                              Flyer_Type__c
                                                              from Flyers__c where building__c =:FlyerObj.Building__c 
                                                              AND ID != :FlyerObj.Id
                                                              AND Flyer_Type__c =:FlyerObj.Flyer_Type__c
                                                              Order by Flyer_Date__c DESC
                                                              Limit 1
                                                             ];
                
                
                
                
                List<Flyers__c> FlyerNeedToUpdate = new List<Flyers__c>();
                
                if(GettingMostRecentFlyer!=NULL)
                {
                  
                for(Flyers__c obj : GettingMostRecentFlyer)
                {
                    if((FlyerObj.Flyer_Type__c == 'Direct' || FlyerObj.Flyer_Type__c == 'Sale') && obj.Active_or_Inactive__c == 'Inactive')
                    {
                        	
							obj.Active_or_Inactive__c = 'Active';
                        	FlyerNeedToUpdate.add(obj);
                    }
                }
                    
                }
                
                system.debug(FlyerNeedToUpdate);
                if(FlyerNeedToUpdate!=NULL)
                {
                    UpdationClassForFlyer.isfutureupdate=true;
					update FlyerNeedToUpdate;
                }
            }
            }
        
    }
    
     public static Boolean CheckFlyerDateRecentOrNot(Flyers__c Obj)
     {
        
		List<Flyers__c> flyersList = [Select Id,Name, building__c,Active_or_Inactive__c,Flyer_Date__c,
                                      Flyer_Type__c
                                      from Flyers__c where building__c =:Obj.Building__c AND Flyer_Date__c > :Obj.Flyer_Date__c AND Flyer_Type__c =:Obj.Flyer_Type__c];
         
        
         
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