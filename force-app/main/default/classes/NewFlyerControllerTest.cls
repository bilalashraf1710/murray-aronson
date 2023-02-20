@isTest
public with sharing class NewFlyerControllerTest {
    @testSetup
    public static void testSetup(){
        Account ac = new Account(Name='test');
        insert ac;
         
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        
        ContentVersion contentVersion = new ContentVersion(
        Title          = 'a picture',
        PathOnClient   = 'Pic.jpg',
        VersionData    = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = lease.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }
    @isTest
    public static void getBuildingNameByIdTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        String buildingName = NewFlyerController.getBuildingNameFromId(b.Id);
        system.assertEquals('test building', buildingName);
    }
    
    @isTest
    public static void saveFlyerTest(){
        Account ac = new Account(Name='123');
        insert ac;
        Flyers__c flyer = new Flyers__c(Account__c=ac.Id, Flyer_Type__c='Direct', Active_or_Inactive__c='Active');
        NewFlyerController.saveFlyer(flyer);
    }
    
    @isTest
    public static void addFlyerRelationshipWithSuitesTest(){
		Account ac = new Account(Name='123');
        insert ac;
        Flyers__c flyer = new Flyers__c(Account__c=ac.Id, Flyer_Type__c='Direct', Active_or_Inactive__c='Active');
        insert flyer;
        
        Building__c b= new Building__c(Name='test building');
        insert b;
        Suites__c suite = new Suites__c(Building__c=b.Id);
        insert suite;
        
        List<Id> suiteIds = new List<Id>();
        suiteIds.add(suite.Id);
        
        NewFlyerController.addFlyerRelationshipWithSuites(flyer.Id, suiteIds);
    }
    
    @isTest
    public static void addFlyerRelationshipWithAccountsTest(){
		Account ac = new Account(Name='123');
        insert ac;
        Flyers__c flyer = new Flyers__c(Account__c=ac.Id, Flyer_Type__c='Direct', Active_or_Inactive__c='Active');
        insert flyer;
        
        Building__c b= new Building__c(Name='test building');
        insert b;
        Suites__c suite = new Suites__c(Building__c=b.Id);
        insert suite;
        
        List<Id> accountIds = new List<Id>();
        accountIds.add(ac.Id);
        
        NewFlyerController.addFlyerRelationshipWithAccounts(flyer.Id, accountIds);
    }
    
    @isTest
    public static void attachFileTest(){
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'ab picture',
                    PathOnClient   = 'Pic12.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Account ac = new Account(Name='123');
        insert ac;
        Flyers__c flyer = new Flyers__c(Account__c=ac.Id, Flyer_Type__c='Direct', Active_or_Inactive__c='Active');
        insert flyer;
        
        
        if(documents.size()>0){
            NewFlyerController.attachFile(flyer, documents[0].Id);
        }
    }
    
    @isTest
    public static void getBuildingAccountIdsTest(){
        Account ac = new Account(Name='123');
        insert ac;
        
        Building__c b= new Building__c(Name='test building');
        insert b;
        
        building_account__c ba1 = new building_account__c();
        ba1.Building_Account__c = ac.Id;
        ba1.Building_BA__c = b.Id;
        insert ba1;
        
        List<String> listOfBuildingAccounts = NewFlyerController.getBuildingAccountIds(b.Id);
        system.assertEquals(1, listOfBuildingAccounts.size());
    }
    
    @isTest
    public static void getContentDocumentByIdTest(){
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        if(documents.size()>0){
            Id contentDocId = documents[0].Id;
            NewFlyerController.getContentDocumentById(contentDocId);
        }
        
    }
}