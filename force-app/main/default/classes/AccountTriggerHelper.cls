public class AccountTriggerHelper {

    public static void InsertBuilding(list<Account> AccountList)
    {
        MAP<string,id> AccAddMap = new MAP<string,id>();
        for(Account l : AccountList)
        {
            
          /* string street = String.isNotBlank(l.Property_Address__c) ?  l.Property_Address__c : '';
            string city =string.isNotBlank(l.City__c) ?  l.City__c : '';
            string state = string.isNotBlank(l.State__c) ?  l.State__c : '';
            string s = street + city+ state;
            System.debug('s'+s);*/
            if ( string.isNotBlank(l.Full_Address__c))
            	AccAddMap.put(l.Full_Address__c.toLowerCase() ,l.id );
        }
        
         System.debug('leadAddMap'+AccAddMap);
        list<building_account__c> OAcclist = new list<building_account__c>();
        for(Building__c oBuild : [select id,Full_Address__c from Building__c where Full_Address__c = :AccAddMap.keyset() ])
        {
            system.debug('oBuild '+ oBuild);
            if(AccAddMap.containsKey(oBuild.Full_Address__c))
            {
                system.debug('In if condition' + oBuild.Full_Address__c);
                building_account__c OLead = new building_account__c(Building_BA__c = oBuild.id , Building_Account__c = AccAddMap.get(oBuild.Full_Address__c));
                OLead.name =string.valueof( oBuild.id  )+  string.valueof(AccAddMap.get(oBuild.Full_Address__c) );
                system.debug('Olead ' + Olead);
                OAcclist.add(Olead);
            }
        }
        System.debug('OAcclist'+OAcclist);
        If(!OAcclist.isEmpty())
        {
            upsert OAcclist name;
        }
        
    }  
}