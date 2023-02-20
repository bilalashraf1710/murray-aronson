@isTest
private class NewVideoControllerTest {
    
    @isTest
    public static void getSuiteNameFromIdTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        Suites__c s1 = new Suites__c();
        s1.Building__c = b.Id;
        Insert s1;
        Suites__c SuiteName = NewVideoController.getSuiteNameFromId(s1.Id);
        Suites__c s2 = [Select Id , Name from Suites__c ORDER BY CreatedDate DESC LIMIT 1];
        system.assertEquals(s2.Name, SuiteName.Name);
    }
    
     @isTest
    public static void saveVideoTest(){
        Building__c b= new Building__c(Name='test building');
        insert b;
        Suites__c s1 = new Suites__c();
        s1.Building__c = b.Id;
        Insert s1;
        Video__c video = new Video__c(Suites__c=s1.Id);
        NewVideoController.saveVideo(video);
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
        Building__c b= new Building__c(Name='test building');
        insert b;
        Suites__c s1 = new Suites__c();
        s1.Building__c = b.Id;
        Insert s1;
        Video__c video = new Video__c(Suites__c=s1.Id);
        insert video;
        
        
        if(documents.size()>0){
            NewVideoController.attachFile(video, documents[0].Id);
        }
    }

}