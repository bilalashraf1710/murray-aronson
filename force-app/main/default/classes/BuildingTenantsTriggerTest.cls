@isTest
public with sharing class BuildingTenantsTriggerTest {
    @isTest
    public static void buildingTenantsTriggerTest() {
		Account ac = new Account(
        	Name='testAccount'
        );
        insert ac;
        Market__c market = new Market__c(
        	Continent__c='North America',
            Country__c='United States',
            State_Territory__c='CA'
        );
        insert market;
        Building__c bld = new Building__c(
        	Name='testBuilding',
            Continent__c='North America',
            Country__c='United States',
            StatePK__c='CA',
            Market_Lookup__c=market.Id
        );
        insert bld;
        
		building_account__c buildingTenants = new building_account__c(
        	Building_Account__c = ac.Id,
            Building_BA__c = bld.Id
        );
        insert buildingTenants;
        
        Account ac2 = [SELECT Market_Lookup__c FROM Account WHERE Id =:ac.Id LIMIT 1];
        system.assertEquals(ac2.Market_Lookup__c, bld.Market_Lookup__c);
    }
}