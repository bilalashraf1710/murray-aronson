@isTest
public class FilesListControllerTest {
	@isTest
    public static void getAllRelatedFilesByIdTest(){
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
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=lease.Id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: contentVersion_2.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers'; 
        
        
        insert contentlink;
        
		FilesListController.getAllRelatedFilesById(lease.Id); 
    }
}