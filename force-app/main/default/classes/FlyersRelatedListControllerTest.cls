@isTest
public with sharing class FlyersRelatedListControllerTest {
    @isTest
    public static void getFlyerRelatedAccountsByIdTest(){
        Account ac = new Account(Name='123');
        insert ac;
        Flyers__c flyer = new Flyers__c(Account__c=ac.Id, Flyer_Type__c='Direct', Active_or_Inactive__c='Active');
        insert flyer;
        
        Flyer_Account__c flyerAccountJunction = new Flyer_Account__c(Account__c=ac.Id, Building_Flyer__c=flyer.Id);
        insert flyerAccountJunction;
        
        List<Account> acList = FlyersRelatedListController.getFlyerRelatedAccountsById(flyer.Id);
        system.assertEquals(1, acList.size());
    }
    
    @isTest
    public static void getFlyerRelatedSuitesByIdTest(){
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
        
        List<Suites__c> acList = FlyersRelatedListController.getFlyerRelatedSuitesById(flyer.Id);
        system.assertEquals(1, acList.size());
    }
}