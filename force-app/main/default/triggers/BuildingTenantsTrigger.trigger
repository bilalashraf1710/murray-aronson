trigger BuildingTenantsTrigger on building_account__c (after insert) {
    List<building_account__c> bldAccountList = trigger.new;

    Set<Id> buildingIdsSet = new Set<Id>();
    Set<Id> accountIdsSet = new Set<Id>();

    for(building_account__c bldAcc : bldAccountList){
        buildingIdsSet.add(bldAcc.Building_BA__c);
        accountIdsSet.add(bldAcc.Building_Account__c);
    }

    List<Building__c> buildings = [SELECT City_Lookup__c, Market_Lookup__c, Submarket_Lookup__c FROM Building__c WHERE Id IN:buildingIdsSet];
    Map<Id, Building__c> buildingsMap = new Map<Id, Building__c>(buildings);
    List<Account> accounts = [SELECT Id, City_Lookup__c, Market_Lookup__c, Submarket_Lookup__c  FROM Account WHERE Id IN:accountIdsSet];
    Map<Id, Account> accountsMap = new Map<Id, Account>(accounts);


    List<Account> updatedAccounts = new List<Account>();

    for(building_account__c bldAcc : bldAccountList){
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