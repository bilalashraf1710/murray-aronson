@isTest
private class TestFloorPlanTriggers {
    
    @testSetup
    static void TestSetupCreateFloorPlanAndContentDocumentObject()
    {
			Building__c	building1 = new Building__c();
        	building1.Name = 'TestBuilding';
        	insert building1;
       
        	building1 = [Select Id, Name from Building__c where Name = 'TestBuilding'];
        	Suites__c Suites1 = new Suites__c(Building__c=building1.Id);
        	insert Suites1;
        
        	Floor_Plan__c floorPlan = new Floor_Plan__c(Suites__c=Suites1.Id,Floor_Plan_Date__c=date.newInstance(2022,12,19));
        	insert floorPlan;
            
        
        	ContentVersion contentVersion = new ContentVersion(
                    						Title = 'a picture',
                    						PathOnClient   = 'Pic.jpg',
                    						VersionData    = Blob.valueOf('Test Content'),
                    						IsMajorVersion = true);
            insert contentVersion;
        
        	 ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        	 floorPlan = [Select Id from Floor_Plan__c][0];
        	
        
        
        	//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = floorPlan.id;
            cdl.ContentDocumentId = document.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl; 
        	
    }
    
      @isTest
    static void TestDeleteFloorPlanWhenDocumentDeleted()
    {
			ContentDocument testObjectContentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument][0];
        	 Database.DeleteResult result = Database.Delete(testObjectContentDocument, false);
    		 System.assert(result.isSuccess());
    }
    
    
    @isTest
    static void TestDeleteDocumentWhenFloorPlanDeleted()
    {
        Floor_Plan__c testObjectFloorPlan = [Select Id from Floor_Plan__c][0];
        Database.DeleteResult result = Database.Delete(testObjectFloorPlan, false);
    	System.assert(result.isSuccess());
        
    }
    

}