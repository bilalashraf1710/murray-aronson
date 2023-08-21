public class AccountTriggerHelper {

    public static void InsertBuilding(list<Account> AccountList)
    {
        MAP<string,id> AccAddMap = new MAP<string,id>();
        List<Account> accList = new List<Account>();
        for(Account l : AccountList)
        {
            
            if ( string.isNotBlank(l.Full_Address__c))
            	AccAddMap.put(l.Full_Address__c.toLowerCase() ,l.id );
        }

        list<building_account__c> OAcclist = new list<building_account__c>();
        for(Building__c oBuild : [select id,Full_Address__c from Building__c where Full_Address__c = :AccAddMap.keyset() ])
        {
            if(AccAddMap.containsKey(oBuild.Full_Address__c))
            {
                building_account__c OLead = new building_account__c(Building_BA__c = oBuild.id , Building_Account__c = AccAddMap.get(oBuild.Full_Address__c));
                Account acc = new Account();
                acc.Id = AccAddMap.get(oBuild.Full_Address__c);
                acc.Building_Id__c = oBuild.id;
                accList.add(acc);
                OLead.name =string.valueof( oBuild.id  )+  string.valueof(AccAddMap.get(oBuild.Full_Address__c) );
                OAcclist.add(Olead);
            }
        }
        If(!OAcclist.isEmpty())
        {
            system.debug('hello test');
            upsert OAcclist name;
        }
        If(!accList.isEmpty())
        {
            StopUpdateRecursion.isfutureupdate=true;
            update accList;
        }
        
    }  
}