@isTest
private class TestCostarReportAndDocumentTriggers {
    
	@testSetup
    public static void createSetupForCostarReport()
    {
		Market__c marketObj = new  Market__c(Name='test market');
       insert marketObj;
       
	   Submarket__c newSubMarketObj =   new  Submarket__c(Name='test Sub-market',Market__c= marketObj.Id);
       insert newSubMarketObj;
        
       City__c newCityObj = new City__c(Name='test City',Submarket__c= newSubMarketObj.Id);
       insert newCityObj;
        
       Costar_Report__c newCostarReportObj = new Costar_Report__c(City__c=newCityObj.Id,Costar_Report_Date__c = date.newInstance(2022,12,19));
       insert newCostarReportObj;
       
       ContentVersion contentVersion = new ContentVersion(
                    						Title = 'a picture',
                    						PathOnClient   = 'Pic.jpg',
                    						VersionData    = Blob.valueOf('Test Content'),
                    						IsMajorVersion = true);
            insert contentVersion;
        
        	 ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        	//create ContentDocumentLink  record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = newCostarReportObj.id;
            cdl.ContentDocumentId = document.Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl; 
        
    }
    
    @isTest
    static void TestDeleteCostarReportWhenDocumentDeleted()
    {
			
        ContentDocument testObjectContentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument][0];
        Database.DeleteResult result = Database.Delete(testObjectContentDocument, false);
    	System.assert(result.isSuccess());
    }
    
    
    @isTest
    static void TestDeleteDocumentWhenCostarReportDeleted()
    {	
       
        Costar_Report__c testObjectCostarReport = [Select Id from Costar_Report__c][0];
        Database.DeleteResult result = Database.Delete(testObjectCostarReport, false);
    	System.assert(result.isSuccess());
        
    }
        

}