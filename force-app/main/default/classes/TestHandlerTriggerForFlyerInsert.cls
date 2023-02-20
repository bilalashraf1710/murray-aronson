@isTest
private class TestHandlerTriggerForFlyerInsert {
    
    @testSetup
    static void TestSetupCreateFlyerDirectType()
    {
			Building__c	building1 = new Building__c();
        	building1.Name = 'TestBuilding';
        	insert building1;
       
        	building1 = [Select Id, Name from Building__c where Name = 'TestBuilding'];
        	Flyers__c Flyer1 = new Flyers__c(Building__c=building1.Id);
        	Flyer1.Flyer_Type__c='Direct';
        	Flyer1.Active_or_Inactive__c='Active';
        	Flyer1.Flyer_Date__c= Date.newInstance(2022,10,20);
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
    static void TestUpdateDirectFlyerStatus()
    {
      //TestSetupCreateFlyerDirectType();
      Building__c building2 = [Select Id, Name from Building__c where Name = 'TestBuilding'];
      Flyers__c Flyer2 = new Flyers__c(Building__c=building2.Id);
      Flyer2.Flyer_Type__c='Direct';
      Flyer2.Active_or_Inactive__c='Active';
      Flyer2.Flyer_Date__c= Date.newInstance(2022,10,30);
        //insert Flyer2;
      Database.SaveResult result = Database.insert(Flyer2, false);
      System.assert(result.isSuccess());
    }
    
   
     @isTest
    static void TestUpdateSaleFlyerStatus()
    {
      //TestSetupCreateFlyerSaleType();
      Building__c building2 = [Select Id, Name from Building__c where Name = 'TestBuilding'];
      Flyers__c Flyer2 = new Flyers__c(Building__c=building2.Id);
      Flyer2.Flyer_Type__c='Direct';
      Flyer2.Active_or_Inactive__c='Active';
      Flyer2.Flyer_Date__c= Date.newInstance(2022,10,14);
      //insert Flyer2;
      Database.SaveResult result = Database.insert(Flyer2, false);
      System.assert(result.isSuccess());
    }
    


}