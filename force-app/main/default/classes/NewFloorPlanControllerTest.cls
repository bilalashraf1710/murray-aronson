@isTest
public with sharing class NewFloorPlanControllerTest {
    @testSetup
    public static void testSetup(){
        Date d = Date.newInstance(2023,01,01);
        Floor_Plan__c fp = new Floor_Plan__c(Floor_Plan_Type__c='MA Branded', Floor_Plan_Date__c=d);
        insert fp;
        
        ContentVersion contentVersion = new ContentVersion(
        Title          = 'a picture',
        PathOnClient   = 'Pic.jpg',
        VersionData    = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = fp.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
    }
    
    @isTest
    public static void getBuildingIdBySuiteIdTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        Suites__c suite = new Suites__c(Building__c = b.Id);
        insert suite;
        String suiteId = NewFloorPlanController.getBuildingIdFromSuiteId(suite.Id);
        system.assert(suiteId != null);
        
    }
    
    @isTest
    public static void saveFloorPlanTest() {
        Date d = Date.newInstance(2023,01,01);
        Floor_Plan__c fp = new Floor_Plan__c(Floor_Plan_Type__c='MA Branded', Floor_Plan_Date__c=d);
        NewFloorPlanController.saveFloorPlan(fp);
        
        Floor_Plan__c[] fpList = [SELECT Id FROM Floor_Plan__c];
        system.Assert(fpList.size()>0);
    }
    
    @isTest
    public static void getContentDocumentByIdTest(){
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        if(documents.size()>0){
            Id contentDocId = documents[0].Id;
            NewFloorPlanController.getContentDocumentById(contentDocId);
        }
        
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

        Date d = Date.newInstance(2023,01,01);
        Floor_Plan__c fp = new Floor_Plan__c(Floor_Plan_Type__c='MA Branded', Floor_Plan_Date__c=d);
        insert fp;
        
        if(documents.size()>0){
            NewFloorPlanController.attachFile(fp, documents[0].Id);
        }
    }
    
    @isTest
    public static void getFloorPlanTypeValuesTest(){
        Map<String, String> pickListMap = new Map<String,String>();
        pickListMap = NewFloorPlanController.getFloorPlanTypeValues();
        system.Assert(pickListMap.size()>0);
    }
}