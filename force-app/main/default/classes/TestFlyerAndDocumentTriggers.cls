@isTest
private class TestFlyerAndDocumentTriggers {
    
    @testSetup
    static void TestSetupCreateFlyerAndContentDocumentObject()
    {
			Building__c	building1 = new Building__c();
        	building1.Name = 'TestBuilding';
        	insert building1;
       
        	building1 = [Select Id, Name from Building__c where Name = 'TestBuilding'];
        	Flyers__c Flyer1 = new Flyers__c(Building__c=building1.Id);
        	Flyer1.Flyer_Type__c='Direct';
        	Flyer1.Flyer_Date__c=date.newInstance(2022,10,31);
        	Flyer1.Active_or_Inactive__c='Active';
        	insert Flyer1;
        
        	ContentVersion contentVersion = new ContentVersion(
                    						Title = 'a picture',
                    						PathOnClient   = 'Pic.jpg',
                    						VersionData    = Blob.valueOf('Test Content'),
                    						IsMajorVersion = true);
            insert contentVersion;
        
        	 ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        	Flyer1 = [Select Id from Flyers__c][0];
        	
        
        
        	//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = Flyer1.id;
            cdl.ContentDocumentId = document.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl; 
        	
    }
    
    @isTest
    static void TestDeleteFlyerWhenDocumentDeleted()
    {
			ContentDocument testObjectContentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument][0];
        	 Database.DeleteResult result = Database.Delete(testObjectContentDocument, false);
    		 System.assert(result.isSuccess());
    }
    
    @isTest
    static void TestDeleteDocumentWhenFlyerDeleted()
    {
        Flyers__c testObjectFlyer = [Select Id from Flyers__c][0];
        Database.DeleteResult result = Database.Delete(testObjectFlyer, false);
    	System.assert(result.isSuccess());
        
    }
    
    
    @isTest
    static void TestHandlerWhenRecentFlyerDeleted()
    {
        
		Building__c	building1 =  [Select Id, Name from Building__c where Name = 'TestBuilding'];
        Flyers__c Flyer1 = new Flyers__c(Building__c=building1.Id);
        	Flyer1.Flyer_Type__c='Direct';
        	Flyer1.Flyer_Date__c=date.newInstance(2023,10,31);
        	Flyer1.Active_or_Inactive__c='Active';
        	insert Flyer1;
        Flyers__c testObjectFlyer = [Select Id from Flyers__c where Flyer_Date__c = 2023-10-31];
        Database.DeleteResult result = Database.Delete(testObjectFlyer, false);
    	System.assert(result.isSuccess());
        
    }


}