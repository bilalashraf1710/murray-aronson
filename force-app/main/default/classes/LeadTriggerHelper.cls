public class LeadTriggerHelper {
    
    //@InvocableMethod
    public static void unlinkBuilding(List<Lead> LeadIds){
        
     Set<String> LeadIdSet = new Set<String>();   
     List<building_lead__c> UnlinkBuilding = new List<building_lead__c>();
     
      for (Lead ld: LeadIds){
            
          if (ld.IsConverted == true && !LeadIdSet.contains(ld.id)) {
                LeadIdSet.add(ld.id);
                system.debug('LeadIdSet' + LeadIdSet);
          }
      }  
        
          if(!LeadIdSet.isempty()){      
             List<building_lead__c> ListBuilead = [SELECT id, building_lead__c  FROM building_lead__c WHERE building_lead__c  in: LeadIdSet];
                 system.debug('ListLeadSet' + ListBuilead);
             for (building_lead__c bl: ListBuilead) {
                 UnlinkBuilding.add(bl);
                 system.debug('AssingUnlinkBuilding' + UnlinkBuilding);
            }   
          }
        
         If(!UnlinkBuilding.isEmpty()){          
          delete UnlinkBuilding;
          system.debug('EndUnlink' + UnlinkBuilding);   
         }    
   }    
   
    public static void DeleteContact(set<id> setContact)
    {
        List<Contact> ContactList = [select id from contact where id = :setContact];
        If(!ContactList.isEmpty())
        {
            delete ContactList;
        } 
    }
    
    public static void InsertBuilding(list<Lead> LeadList)
    {
        MAP<string,id> leadAddMap = new MAP<string,id>();
        for(lead l : leadlist)
        {
            
            /*string street = String.isNotBlank(l.Street) ?  l.Street : '';
            string city =string.isNotBlank(l.City__c) ?  l.City__c : '';
            string state = string.isNotBlank(l.State__c) ?  l.State__c : '';
            string s = street + city+ state;
            System.debug('s'+s);*/
             if ( string.isNotBlank(l.Full_Address__c) && !l.IsConverted == true)
           		 leadAddMap.put(l.Full_Address__c.toLowerCase() ,l.id );
        }
          System.debug('leadAddMap'+leadAddMap);
        list<building_lead__c> OLeadlist = new list<building_lead__c>();
        for(Building__c oBuild : [select id,Full_Address__c from Building__c where Full_Address__c = :leadAddMap.keyset() ])
        {
            if(leadAddMap.containsKey(oBuild.Full_Address__c))
            {
                building_lead__c OLead = new building_lead__c(Building_BL__c = oBuild.id , Building_Lead__c = leadAddMap.get(oBuild.Full_Address__c));
                OLead.name = string.valueof(oBuild.id) + string.valueof(leadAddMap.get(oBuild.Full_Address__c));
                OLeadlist.add(Olead);
            }
        }
        System.debug('OLeadlist'+OLeadlist);
        If(!OLeadlist.isEmpty())
        {
            upsert OLeadlist name;
        }
        
    }
    
    public static void UpdateLeadConverted(list<Lead> LeadList){
    
    // List Final     
    List<Task> TaskInsert = new List<Task>();
    unlinkBuilding(LeadList);
    
    for (Lead ld: LeadList){
        Task Tasks = new Task();
                
        if(Ld.IsConverted == true){
          Tasks.OwnerId 	= ld.OwnerId ; 
          Tasks.WhatId  	= ld.ConvertedAccountId ;  
          Tasks.Subject     = ld.Company ;  
            
          TaskInsert.add(Tasks);               
          system.debug('TaskTrigger' + TaskInsert);
               
         }
           
    }
        
    If(!TaskInsert.isEmpty()){          
       insert TaskInsert;       
    }
  }      
    
}