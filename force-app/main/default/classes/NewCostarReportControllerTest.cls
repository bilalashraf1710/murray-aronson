@isTest
private class NewCostarReportControllerTest {
    
    @testSetup
    public static void createSetupForCostarReport()
    {
		Market__c marketObj = new  Market__c(Name='test market');
       insert marketObj;
       
	   Submarket__c newSubMarketObj =   new  Submarket__c(Name='test Sub-market',Market__c= marketObj.Id);
       insert newSubMarketObj;
        
       City__c newCityObj = new City__c(Name='test City',Submarket__c= newSubMarketObj.Id);
       insert newCityObj;
    }
    
    
     @isTest
    public static void saveVideoTest(){
       
       City__c newCityObj = [Select Id from City__c][0];
       Costar_Report__c newCostarReportObj = new Costar_Report__c(City__c=newCityObj.Id) ;
       NewCostarReportController.saveCostarReport(newCostarReportObj);
           
    }
    
    @isTest
    public static void attachFileTest(){
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'ab picture',
                    PathOnClient   = 'Pic12.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
            insert contentVersion;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
       City__c newCityObj = [Select Id from City__c][0];
       Costar_Report__c newCostarReportObj = new Costar_Report__c(City__c=newCityObj.Id) ;
        insert newCostarReportObj;
        
        if(documents.size()>0){
            NewCostarReportController.attachFile(newCostarReportObj, documents[0].Id);
        }
    }

}