@isTest
public with sharing class FlyersListControllerTest {
    @isTest
    public static void getAllFlyersByAccountIdTest() {
		Account ac = new Account(Name='123');
        insert ac;
        Flyers__c flyer = new Flyers__c(Account__c=ac.Id, Flyer_Type__c='Direct', Active_or_Inactive__c='Active');
        insert flyer;
        
        Flyer_Account__c flyerAccountJunction = new Flyer_Account__c(Account__c=ac.Id, Building_Flyer__c=flyer.Id);
        insert flyerAccountJunction;
        List<Flyers__c> flyersListToReturn = FlyersListController.getAllFlyersByAccountId(ac.Id);
        system.assertEquals(1, flyersListToReturn.size());
    }
    
    @isTest
    public static void getAllFlyersBySuiteIdTest(){
        Account ac = new Account(Name='123');
        insert ac;
        Flyers__c flyer = new Flyers__c(Account__c=ac.Id, Flyer_Type__c='Direct', Active_or_Inactive__c='Active');
        insert flyer;
        
        Building__c b= new Building__c(Name='test building');
        insert b;
        Suites__c suite = new Suites__c(Building__c=b.Id);
        insert suite;
        
        Flyer_Suite__c flyerSuiteJunction = new Flyer_Suite__c(Building_Flyer__c=flyer.Id, Suites__c=suite.Id);
        insert flyerSuiteJunction;
        List<Flyers__c> flyersListToReturn = FlyersListController.getAllFlyersBySuiteId(suite.Id);
        system.assertEquals(1, flyersListToReturn.size());
    }
    
    @isTest
    public static void getAllFlyersByBuildingIdTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        Flyers__c flyer = new Flyers__c(Building__c=b.Id, Flyer_Type__c='Direct', Active_or_Inactive__c='Active');
        insert flyer;
        List<Flyers__c> flyersListToReturn = FlyersListController.getAllFlyersByBuildingId(b.Id);
        system.assertEquals(1, flyersListToReturn.size());
    }
    
    @isTest
    public static void getAccountNameFromIdTest(){
        Account ac = new Account(Name='test123');
        insert ac;
        String accountName = FlyersListController.getAccountNameFromId(ac.Id);
        system.assertEquals('test123', accountName);
    }
    
    @isTest
    public static void getSObjectTypeFromIdTest(){
        Account ac = new Account(Name='test123');
        insert ac;
        String objectType = FlyersListController.getSObjectTypeFromId(ac.Id);
        system.assertEquals('Account', objectType);
    }
    
    @isTest
    public static void getBuildingNameByIdTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        String buildingName = FlyersListController.getBuildingNameById(b.Id);
        system.assertEquals('test building', buildingName);
    }
    
    @isTest
    public static void getAllRelatedFilesByIdTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        List<String> idsList = new List<String>();
        idsList.add(b.Id);
        FlyersListController.getAllRelatedFilesById(idsList);
    }
    
    @isTest
    public static void getBuildingNameAndIdByAccountIdTest(){
        Account ac = new Account(Name='test123');
        insert ac;
        Building__c b= new Building__c(Name='test building');
        insert b;
        building_account__c buildingAccount = new building_account__c(Building_Account__c=ac.Id, Building_BA__c=b.Id);
        insert buildingAccount;
        
		FlyersListController.getBuildingNameAndIdByAccountId(ac.Id);   
    }
    
    @isTest
    public static void getBuildingNameAndIdBySuiteIdTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        Suites__c suite = new Suites__c(Building__c=b.Id);
        insert suite;
        
		FlyersListController.getBuildingNameAndIdBySuiteId(suite.Id);   
    }
}