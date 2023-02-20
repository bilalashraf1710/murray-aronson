@isTest
private class TestTaskAndDocumentTriggers {

     @testSetup
    static void TestSetupCreateFlyerAndContentDocumentObject()
    {
			Task Task1 = new Task();
        	Task1.Subject = 'TestTask';
        	Task1.Periodicity__c='Daily';
        	Task1.Type__c='Murray Aronson';
        	Task1.Sub_Type__c='Prospecting';
        	insert Task1;
       
        
        	ContentVersion contentVersion = new ContentVersion(
                    						Title = 'a picture',
                    						PathOnClient   = 'Pic.jpg',
                    						VersionData    = Blob.valueOf('Test Content'),
                    						IsMajorVersion = true);
            insert contentVersion;
        
        	 ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        	Task1 = [Select Id from Task][0];
        	
        
        
        	//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = Task1.id;
            cdl.ContentDocumentId = document.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl; 
        	
    }
    
    /*
     @isTest
    static void TestDeleteTaskWhenDocumentDeleted()
    {
			ContentDocument testObjectContentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument][0];
        	 Database.DeleteResult result = Database.Delete(testObjectContentDocument, false);
    		 System.assert(result.isSuccess());
    }

*/
    
    @isTest
    static void TestDeleteDocumentWhenTaskDeleted()
    {
        Task testObjectTask = [Select Id from Task][0];
        Database.DeleteResult result = Database.Delete(testObjectTask, false);
    	System.assert(result.isSuccess());
        
    }

    
}