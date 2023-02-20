@isTest
private class TestOMAndRentalTrigger {
    
    @testSetup
    static void TestSetupOMRentalRollAndContentDocumentObject()
    {
			Building__c	building1 = new Building__c();
        	building1.Name = 'TestBuilding';
        	insert building1;
       
        	OM_and_Rent_Roll__c OmRRObj = new OM_and_Rent_Roll__c(Building__c=building1.Id,Date__c=date.newInstance(2022,12,19));
        	insert OmRRObj;
            
        
        	ContentVersion contentVersion = new ContentVersion(
                    						Title = 'a picture',
                    						PathOnClient   = 'Pic.jpg',
                    						VersionData    = Blob.valueOf('Test Content'),
                    						IsMajorVersion = true);
            insert contentVersion;
        
        	 ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        	
        
        	//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = OmRRObj.id;
            cdl.ContentDocumentId = document.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl; 
        	
    }
    
    @isTest
    static void TestDeleteOMRentalWhenDocumentDeleted()
    {
			ContentDocument testObjectContentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument][0];
        	 Database.DeleteResult result = Database.Delete(testObjectContentDocument, false);
    		 System.assert(result.isSuccess());
    }
    
    
    @isTest
    static void TestDeleteDocumentWhenOMRentalDeleted()
    {
        OM_and_Rent_Roll__c testObjectOMRental = [Select Id from OM_and_Rent_Roll__c][0];
        Database.DeleteResult result = Database.Delete(testObjectOMRental, false);
    	System.assert(result.isSuccess());
        
    }
    

}