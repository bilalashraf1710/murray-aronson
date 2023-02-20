@isTest
public class Test_UploadAttachmentController {
    
    @isTest
    public static void createCD(){
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =Blob.valueOf('test');          
        insert cv;    
        
        Lease__c l = new Lease__c();
        insert l;

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id =: cv.Id];
        UploadAttachmentController.setContentDocumentTitleById(testContent.ContentDocumentId, 'yts', l.Id);
        
        System.assert([Select id,title from ContentDocument where title = 'yts'].size() > 0);

    }

    
    @isTest
    public static void getAllLeaseFilesByIdTest(){
        Account ac = new Account(Name='test');
        insert ac;
        
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        lease = [SELECT Id, Account__c FROM Lease__c LIMIT 1];
        UploadAttachmentController.getAllLeaseFilesById(lease.Id);
        
        //ContentDocumentLink cdl = new ContentDocumentLink();
        //cdl.LinkedEntityId = lease.Id;
        //insert cdl;
        UploadAttachmentController.getAllLeaseFilesById(lease.Id);
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=lease.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        UploadAttachmentController.getAllLeaseFilesById(lease.Id);
    }
/*
    @isTest
    public static void getAllLeaseFilesByIdTest2(){
        Account ac = new Account(Name='test');
        insert ac;
         
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = lease.Id;
        //insert cdl;
        UploadAttachmentController.getAllLeaseFilesById(lease.Id);
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        //content.LinkedEntityId=sub.id;
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=lease.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        UploadAttachmentController.getAllLeaseFilesById(null);
    }

    */
    @isTest
    public static void getLeaseObjectByIdTest(){
        Account ac = new Account(Name='test');
        insert ac;
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        UploadAttachmentController.getLeaseObjectById(lease.Id);
    }
	
    
    @isTest
    public static void getContentDocumentByIdTest(){
        Account ac = new Account(Name='test');
        insert ac;
        Lease__c lease = new Lease__c(Account__c = ac.Id);
        insert lease;
        
        ContentVersion contentVersion_1 = new ContentVersion(
      Title = 'Penguins',
      PathOnClient = 'Penguins.jpg',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert contentVersion_1;
    
    ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        lease = [SELECT Id, Name FROM Lease__c LIMIT 1];
        
		UploadAttachmentController.getContentDocumentById(lease.Id);      
    }
	
}