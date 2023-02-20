@isTest
public with sharing class CompleteAndCloneControllerTest {
    @isTest
    public static void getTaskByIdTest(){
        Boolean exceptionOccurred = false;
        Task t1 = new Task();
        t1.Subject = 'test';
        insert t1;
        try{
            CompleteAndCloneController.getTaskById(null);
        } catch(Exception e){
            //Set boolean to true to catch exception being thrown
            exceptionOccurred = true;
        }
        
        system.assertNotEquals(CompleteAndCloneController.getTaskById(t1.Id), null);
        System.assertEquals(exceptionOccurred, true);
    }
    
    @isTest
    public static void saveTaskTest(){
        Task t = new Task();
        t.Subject = 'test';
        CompleteAndCloneController.saveTask(t);
        List<Task> listTask = [SELECT Subject FROM Task];
        system.assertEquals(listTask.size(), 1);
    }
    
    
    @isTest
    public static void testCloneAttachment(){
        Task t1 = new Task();
        t1.Subject = 'test';
        insert t1;
        
        Task t2 = new Task();
        t2.Subject = 'test2';
        insert t2;
        
        ContentVersion contentVersion = new ContentVersion(
        Title          = 'a picture',
        PathOnClient   = 'Pic.jpg',
        VersionData    = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = t1.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        CompleteAndCloneController.cloneAttachments(t1.Id, t2.Id);
    }
}