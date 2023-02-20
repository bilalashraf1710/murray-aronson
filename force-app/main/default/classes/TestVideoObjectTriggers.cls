@isTest
private class TestVideoObjectTriggers {
    
    @testSetup
    static void TestSetupCreateVideoAndContentDocumentObject()
    {
			Building__c	building1 = new Building__c();
        	building1.Name = 'TestBuilding';
        	insert building1;
       
        	building1 = [Select Id, Name from Building__c where Name = 'TestBuilding'];
        	Suites__c Suites1 = new Suites__c(Building__c=building1.Id);
        	insert Suites1;
        
        	Video__c video = new Video__c(Suites__c=Suites1.Id,Date__c=date.newInstance(2022,12,19));
        	insert video;
            
        
        	ContentVersion contentVersion = new ContentVersion(
                    						Title = 'a picture',
                    						PathOnClient   = 'Pic.jpg',
                    						VersionData    = Blob.valueOf('Test Content'),
                    						IsMajorVersion = true);
            insert contentVersion;
        
        	 ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        	 video = [Select Id from Video__c][0];
        	
        
        
        	//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = video.id;
            cdl.ContentDocumentId = document.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl; 
        	
    }
    
      @isTest
    static void TestDeleteVideoWhenDocumentDeleted()
    {
			ContentDocument testObjectContentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument][0];
        	 Database.DeleteResult result = Database.Delete(testObjectContentDocument, false);
    		 System.assert(result.isSuccess());
    }
    
    
    @isTest
    static void TestDeleteDocumentWhenVideoDeleted()
    {
        Video__c testObjectVideo = [Select Id from Video__c][0];
        Database.DeleteResult result = Database.Delete(testObjectVideo, false);
    	System.assert(result.isSuccess());
        
    }

}