trigger BuildingMarketChangeTrigger on Building__c (after update) {
    Set<Id> changedBuildingIds = new Set<Id>();
    for( Id buildingId : Trigger.newMap.keySet() ){
        if( Trigger.oldMap.get(buildingId).Market_Lookup__c != Trigger.newMap.get(buildingId).Market_Lookup__c 
         || Trigger.oldMap.get(buildingId).City_Lookup__c != Trigger.newMap.get(buildingId).City_Lookup__c 
         || Trigger.oldMap.get(buildingId).Submarket_Lookup__c != Trigger.newMap.get(buildingId).Submarket_Lookup__c ){
        	// do something here because your field has changed
            changedBuildingIds.add(buildingId);
        }
    }
    Set<Id> accountIdsSet = new Set<Id>();
    Set<Id> buildingIdsSet = new Set<Id>();

    List<building_account__c> buildingAccountsList = [SELECT Building_Account__c, Building_BA__c FROM building_account__c WHERE Building_BA__c IN:changedBuildingIds];
    for(building_account__c bldAcc : buildingAccountsList){
        accountIdsSet.add(bldAcc.Building_Account__c);
        buildingIdsSet.add(bldAcc.Building_BA__c);
    }

    List<Building__c> buildings = [SELECT City_Lookup__c, Market_Lookup__c, Submarket_Lookup__c FROM Building__c WHERE Id IN:buildingIdsSet];
    Map<Id, Building__c> buildingsMap = new Map<Id, Building__c>(buildings);
    List<Account> accounts = [SELECT Id, City_Lookup__c, Market_Lookup__c, Submarket_Lookup__c  FROM Account WHERE Id IN:accountIdsSet];
    Map<Id, Account> accountsMap = new Map<Id, Account>(accounts);

    List<Account> updatedAccounts = new List<Account>();

    for(building_account__c bldAcc : buildingAccountsList){
        Account ac = new Account();
        Building__c bld = new Building__c();
        ac = accountsMap.get(bldAcc.Building_Account__c);
        bld = buildingsMap.get(bldAcc.Building_BA__c);
        ac.City_Lookup__c = bld.City_Lookup__c;
        ac.Market_Lookup__c = bld.Market_Lookup__c;
        ac.Submarket_Lookup__c = bld.Submarket_Lookup__c;
        updatedAccounts.add(ac);
    }
    update updatedAccounts;

}