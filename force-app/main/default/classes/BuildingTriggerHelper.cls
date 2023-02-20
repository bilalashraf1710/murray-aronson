public class BuildingTriggerHelper {
    
    public static void InsertBuilding(list<Building__c> BuildingList)
    {
        MAP<string,id> AccAddMap = new MAP<string,id>();
        for(Building__c l : BuildingList)
        {
            AccAddMap.put(l.Full_Address__c.toLowerCase() ,l.id );
        }
        
        list<building_account__c> OAcclist = new list<building_account__c>();
        
        for(Account Oacc : [select id,Full_Address__c from Account where Full_Address__c = :AccAddMap.keyset() ])
        {
            if(AccAddMap.containsKey(Oacc.Full_Address__c))
            {
                building_account__c OLead = new building_account__c(Building_BA__c = AccAddMap.get(Oacc.Full_Address__c) , Building_Account__c = Oacc.id );
                OLead.name = string.valueof(AccAddMap.get(Oacc.Full_Address__c) )+ string.valueof(Oacc.id );
                OAcclist.add(Olead);
            }
        }
        list<building_lead__c> OLeadlist = new list<building_lead__c>();
        
        for(lead oLead : [select id,Full_Address__c from lead where Full_Address__c = :AccAddMap.keyset() ])
        {
            if(AccAddMap.containsKey(oLead.Full_Address__c))
            {
                building_lead__c OBl = new building_lead__c(Building_BL__c = AccAddMap.get(oLead.Full_Address__c)  , Building_Lead__c = oLead.id);
                OBl.name = string.valueof(AccAddMap.get(oLead.Full_Address__c) ) + string.valueof(oLead.id);
                system.debug('lead' +  OBl.name);
                OLeadlist.add(OBl);
            }
        }
        System.debug('OAcclist'+OAcclist);
        If(!OAcclist.isEmpty())
        {
            upsert OAcclist name;
        }
        If(!OLeadlist.isEmpty())
        {
            upsert OLeadlist name;
        }
        
    }  
    
    public static void checkDuplicateBefore(List<Building__c> newBldList, Map<Id,Building__c> oldBldMap){
        Set<String> buildingAddress = new Set<String>();
        List<Building__c> oldBldList = [SELECT Name, City__c, StatePK__c, ZIP__c FROM Building__c];
        for(Building__c bld: oldBldList){
            buildingAddress.add(bld.Name+bld.City__c+bld.StatePK__c+bld.ZIP__c);
        }
        String addressCheck = '';
        if(oldBldMap == null){
            for(Building__c b: newBldList){
                addressCheck = b.Name + b.City__c + b.StatePK__c + b.ZIP__c;
                if(buildingAddress.contains(addressCheck))
                {
                    b.addError('Building Already Exists');
                }
            }
        }
        else{
            for(Building__c b : newBldList){
                if(oldBldMap.get(b.id).Name != b.Name || oldBldMap.get(b.id).City__c != b.City__c || oldBldMap.get(b.id).ZIP__c != b.ZIP__c || oldBldMap.get(b.id).StatePK__c != b.StatePK__c){
                    addressCheck = b.Name + b.City__c + b.StatePK__c + b.ZIP__c;
                    if(buildingAddress.contains(addressCheck))
                    {
                        b.addError('Building Already Exists');
                    }
                }
            }    
        }
    }
}