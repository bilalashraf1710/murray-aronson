@isTest
public with sharing class TaskRecordPageControllerTest {
	@isTest
    public static void getTaskByIdTest(){
        Boolean exceptionOccurred = false;
        Task t1 = new Task();
        t1.Subject = 'test';
        insert t1;
        try{
            TaskRecordPageController.getTaskById(null);
        } catch(Exception e){
            //Set boolean to true to catch exception being thrown
            exceptionOccurred = true;
        }
        
        system.assertNotEquals(TaskRecordPageController.getTaskById(t1.Id), null);
        System.assertEquals(exceptionOccurred, true);
    }
    
    @isTest
    public static void getCurrentUserNameTest(){
        String userName = TaskRecordPageController.getCurrentUserName();
        system.AssertNotEquals(userName, null);
    }
    
    @isTest
    public static void getCurrentUserProfileTest(){
        String userProfile = TaskRecordPageController.getCurrentUserProfile();
        system.AssertNotEquals(userProfile, null);
    }
    
    @isTest
    public static void saveTaskTest(){
        Task t = new Task();
        t.Subject = 'test';
        TaskRecordPageController.saveTask(t);
        List<Task> listTask = [SELECT Subject FROM Task];
        system.assertEquals(listTask.size(), 1);
    }
    
    @isTest
    public static void getSObjectNameFromIdTest(){
        Boolean exceptionOccurred = false;
        Account ac = new Account();
        ac.Name = 'test';
        insert ac;
        Account ac2 = new Account();
        ac2 = (Account)TaskRecordPageController.getSObjectNameFromId(ac.Id);
        system.assertEquals(ac2.Name, ac.Name);
        try{
            TaskRecordPageController.getSObjectNameFromId(null);
        } catch(Exception e){
            //Set boolean to true to catch exception being thrown
            exceptionOccurred = true;
        }
        system.assertEquals(true, exceptionOccurred);
    }
    
    @isTest
    public static void getSObjectNameFromIdForAccountTaskPageTest(){
        Boolean exceptionOccurred = false;
        Account ac = new Account();
        ac.Name = 'test';
        insert ac;
        Account ac2 = new Account();
        ac2 = (Account)TaskRecordPageController.getSObjectNameFromIdForAccountTaskPage(ac.Id);
        system.assertEquals(ac2.Name, ac.Name);
        try{
            TaskRecordPageController.getSObjectNameFromIdForAccountTaskPage(null);
        } catch(Exception e){
            //Set boolean to true to catch exception being thrown
            exceptionOccurred = true;
        }
        system.assertEquals(true, exceptionOccurred);
    }
    
    
    @isTest
    public static void getSObjectTypeFromIdTest(){
        Boolean exceptionOccurred = false;
        Account ac = new Account();
        ac.Name = 'test';
        insert ac;
        String sobjectType = TaskRecordPageController.getSObjectTypeFromId(ac.Id);
        system.assertEquals('Account', sobjectType);
        try{
            TaskRecordPageController.getSObjectTypeFromId(null);
        } catch(Exception e){
            //Set boolean to true to catch exception being thrown
            exceptionOccurred = true;
        }
        system.assertEquals(true, exceptionOccurred);
    }
    
    @isTest
    public static void getCurrentUserIdTest(){
        system.assertNotEquals(null, TaskRecordPageController.getCurrentUserId());
    }
}