public with sharing class TaskRecordPageController {

    @AuraEnabled
    public static Task getTaskById(String taskId){
        try {
            Task t = [SELECT Subject, WhatId, ActivityDate, WhoId, Last_Completed__c, Type__c, Sub_Type__c,
                        Periodicity__c, OwnerId, Status, Priority, IsReminderSet, IsRecurrence, Description,
                        ReminderDateTime
                        FROM Task WHERE Id =: taskId LIMIT 1];
            return t;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getCurrentUserName(){
        try {
            String FirstName = UserInfo.getFirstName();//Returns the context user's first name.
            String LastName = UserInfo.getLastName();
            return FirstName + ' ' + LastName;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getCurrentUserProfile(){
        try {
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String MyProflieName = PROFILE[0].Name;
            return MyProflieName;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Task saveTask(Task task){
        try {
            // system.debug('before inserting: '+ task);
            upsert task;
            return task;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static sobject getSObjectNameFromId(Id recordId){
        try {
            String sobjectType = String.valueOf(recordId.getsobjecttype());
            system.debug('sobject type:: '+ sobjectType);
             List<sobject> sobjList  = Database.Query('SELECT Name FROM '+sobjectType+' WHERE Id=:recordId LIMIT 1');
             sobject objectName = sobjList[0];
             return objectName;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static sobject getSObjectNameFromIdForAccountTaskPage(Id recordId){
        try {
            String sobjectType = String.valueOf(recordId.getsobjecttype());
            system.debug('sobject type:: '+ sobjectType);
             List<sobject> sobjList  = Database.Query('SELECT Name, RecordType.Name FROM '+sobjectType+' WHERE Id=:recordId LIMIT 1');
             sobject objectName = sobjList[0];
             return objectName;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getSObjectTypeFromId(Id recordId){
        try {
            String sobjectType = String.valueOf(recordId.getsobjecttype());
             return sobjectType;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getCurrentUserId(){
        try {
            String UserId = UserInfo.getUserId();//Returns the context user's ID.
            // System.Debug('UserId-' + UserId);
            return UserId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}