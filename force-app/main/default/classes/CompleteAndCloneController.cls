public with sharing class CompleteAndCloneController {

    @AuraEnabled
    public static Task getTaskById(String taskId){
        try {
            Task t = [SELECT Subject, WhatId, ActivityDate, WhoId, Last_Completed__c, Type__c, Sub_Type__c,
                        Periodicity__c, OwnerId, Status, Priority, IsReminderSet, IsRecurrence, Description,
                        ReminderDateTime
                        FROM Task WHERE Id =: taskId LIMIT 1];
            return t;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Task saveTask(Task task){
        try {
            upsert task;
            return task;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void cloneAttachments(String object1Id, String object2Id){
        try {

            List<ContentDocumentLink> CDLsObject1 = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =:object1Id];
            List<Id> contentDocumentIds = new List<Id>();
            for(ContentDocumentLink CDLink : CDLsObject1){
                contentDocumentIds.add(CDLink.ContentDocumentId);
            }
            
            system.debug('ContentDocumentIds' +contentDocumentIds );
            List <ContentVersion> listToInsert =[SELECT Checksum,ContentDocumentId,ContentLocation,ContentSize,ContentUrl,Description,FileExtension,FileType,FirstPublishLocationId,Id,IsAssetEnabled,IsDeleted,Origin,OwnerId,PathOnClient,PublishStatus,RatingCount,ReasonForChange,SharingOption,Title,VersionData,VersionNumber FROM ContentVersion WHERE ContentDocumentId IN :contentDocumentIds];
            
            List<ContentVersion> newListToInsert = new List<ContentVersion>();
            for(ContentVersion CVList : listToInsert) {
                ContentVersion newcont = new ContentVersion();
                newcont.Title  = CVList.Title;
                newcont.PathOnClient  = CVList.PathOnClient;
                newcont.VersionData = CVList.VersionData;
                newListToInsert.add(newCont);
                system.debug('newListToInsert' + newListToInsert);
                Insert newListToInsert;
            }
            
            ContentDocument document = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument order by CreatedDate desc limit 1];
            system.debug('Document' + document);
            
            List <ContentDocumentLink> linkContentDocs = new List<ContentDocumentLink>();
            for(ContentVersion CVList : newListToInsert) {
                system.debug('contentdocid: '+ CVList.ContentDocumentId);
                ContentDocumentLink docLink = new ContentDocumentLink();
                doclink.ContentDocumentId = document.Id;
                doclink.linkedEntityId = object2Id;
                doclink.sharetype = 'I';
                doclink.visibility = 'AllUsers';
                linkContentDocs.add(doclink);
                system.debug('linkContentDocs' + linkContentDocs[0].LinkedEntityId);
            }
            insert linkContentDocs;
            
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}