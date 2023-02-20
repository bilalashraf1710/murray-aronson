@isTest
private class TestDirectoryPhotoObjectTriggers {
    
    @testSetup
    static void TestSetupCreateDirectoryPhotoAndContentDocumentObject()
    {
			Building__c	building1 = new Building__c();
        	building1.Name = 'TestBuilding';
        	insert building1;
       
        	building1 = [Select Id, Name from Building__c where Name = 'TestBuilding'];
        	Building_Directory__c Photo1 = new Building_Directory__c(Building__c=building1.Id);
        	Photo1.Building__c=building1.Id;
        	Photo1.Date_Walked__c=date.newInstance(2022,10,31);
        	Photo1.Directory_Status__c = 'Fully Vacant';
        	insert Photo1;
        
        	ContentVersion contentVersion = new ContentVersion(
                    						Title = 'a picture',
                    						PathOnClient   = 'Pic.jpg',
                    						VersionData    = Blob.valueOf('Test Content'),
                    						IsMajorVersion = true);
            insert contentVersion;
        
        	 ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        	 Photo1 = [Select Id from Building_Directory__c][0];
        	
        
        
        	//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = Photo1.id;
            cdl.ContentDocumentId = document.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl; 
        	

}
    
     @isTest
    static void TestDeleteDirectoryPhotoObjectWhenDocumentDeleted()
    {
			ContentDocument testObjectContentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument][0];
        	 Database.DeleteResult result = Database.Delete(testObjectContentDocument, false);
    		 System.assert(result.isSuccess());
    }
    
    
     @isTest
    static void TestDeleteDocumentWhenDirectoryPhotoObjectrDeleted()
    {
        Building_Directory__c testObjectPhoto = [Select Id from Building_Directory__c][0];
        Database.DeleteResult result = Database.Delete(testObjectPhoto, false);
    	System.assert(result.isSuccess());
        
    }


}