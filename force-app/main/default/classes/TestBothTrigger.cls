@isTest
private class TestBothTrigger {
    
    @testSetup
    static void TestSetupCreateLeaseAndContentDocumentObject()
    {
			Account	account1 = new Account();
        	account1.Name = 'TestAccount';
        	insert account1;
       
        	account1 = [Select Id, Name from Account where Name = 'TestAccount'];
        	Lease__c lease1 = new Lease__c(Account__c=account1.Id);
        	insert lease1;
        
        	ContentVersion contentVersion = new ContentVersion(
                    						Title = 'a picture',
                    						PathOnClient   = 'Pic.jpg',
                    						VersionData    = Blob.valueOf('Test Content'),
                    						IsMajorVersion = true);
            insert contentVersion;
        
        	 ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        	lease1 = [Select Id from Lease__c][0];
        
        
        	//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = lease1.id;
            cdl.ContentDocumentId = document.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl; 
        	
    }
    
    @isTest
    static void TestDeleteLeaseWhenDocumentDeleted()
    {
			ContentDocument testObjectContentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument][0];
        	 Database.DeleteResult result = Database.Delete(testObjectContentDocument, false);
    		 System.assert(result.isSuccess());
    }
    
    @isTest
    static void TestDeleteDocumentWhenLeaseDeleted()
    {
        Lease__c testObjectLease = [Select Id from Lease__c][0];
        Database.DeleteResult result = Database.Delete(testObjectLease, false);
    	System.assert(result.isSuccess());
        
    }
  

}