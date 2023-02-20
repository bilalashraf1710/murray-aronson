@isTest
public class CreateLeaseControllerTest {
    
	@testSetup
    public static void testSetup(){
                Account ac = new Account(Name='test');
        insert ac;
         
        Lease__c lease = new Lease__c(Account__c = ac.Id, Lease_Date__c = date.newInstance(2022,10,31));
        insert lease;
        
                    ContentVersion contentVersion = new ContentVersion(
                    Title          = 'a picture',
                    PathOnClient   = 'Pic.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;

            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = lease.Id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;
    }
	
    
    @isTest
    public static void getAccountNameFromId(){
        //CreateLeaseController.getAccountNameFromId(null);
        Account ac = new Account(Name='test');
        insert ac;
        
        String name = CreateLeaseController.getAccountNameFromId(ac.Id);
        system.assert(name != null);
        
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        //CreateLeaseController.saveLease(lease);
        
        //ContentDocument cd = new ContentDocument();
        //insert cd;
        //CreateLeaseController.attachFile(lease, ac.id);
    }

    
    @isTest
    public static void saveLeaseTest(){
        Account ac = new Account(Name='test');
        insert ac;
        
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        CreateLeaseController.saveLease(lease);
    }

    /*
    @isTest
    public static void attachFileTest(){
        Account ac = new Account(Name='test');
        insert ac;
        
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        
        CreateLeaseController.attachFile(lease, ac.Id);
    }
    */
    
    @isTest
    public static void attachFileTest2(){
        //List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'ab picture',
                    PathOnClient   = 'Pic12.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Account ac = new Account(Name='test');
        insert ac;
        
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        
        //upsert contentVersion_2;
     //= [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        //List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //Lease__c lease = [SELECT Id, Name FROM Lease__c LIMIT 1];
        //ContentDocumentLink cdl = new ContentDocumentLink();
        //ContentDocument cd = new ContentDocument();
        //insert cd;
        //cd.Id = contentVersion_2.ContentDocumentId;
        if(documents.size()>0){
            CreateLeaseController.attachFile(lease, documents[0].Id);
        }
    }
    
	
    @isTest
    public static void deleteFileById(){
            ContentVersion contentVersion_1 = new ContentVersion(
      Title = 'Penguins',
      PathOnClient = 'Penguins.jpg',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert contentVersion_1;
    
    ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        Lease__c lease = [SELECT Id, Name FROM Lease__c LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink();
        if(documents.size()>0){
            CreateLeaseController.deleteFileById(documents[0].Id);
        }
        //CreateLeaseController.deleteFileById(documents[0].Id);
    }
    
    
    @isTest
    public static void deleteLeasesByNameFromAccountTest(){
        Account ac = new Account(Name='abcc=');
        insert ac;
        CreateLeaseController.deleteLeasesByNameFromAccount(ac.Id, 'Highlighted Lease');
    }
    
    @isTest
    public static void deleteLeasesByNameAndDateFromAccountTest(){
        Account ac = new Account(Name='abcc=');
        insert ac;
        CreateLeaseController.deleteLeasesByDateAndNameFromAccount(ac.Id, 'Highlighted Lease',date.newInstance(2022,10,31) );
    }

    @isTest
    public static void getLeasesListByAccountIdTest(){
        Account ac = new Account(Name='abcc=');
        insert ac;
        CreateLeaseController.getLeasesListByAccountId(ac.Id);
    }    
}