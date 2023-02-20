public with sharing class FlyersListController {
    @AuraEnabled 
    public static List<Flyers__c> getAllFlyersByAccountId(String accountId){
        
            List<Flyer_Account__c> flyerList = [SELECT Account__c, Building_Flyer__c FROM Flyer_Account__c WHERE Account__c =:accountId];
            List<Id> flyersIds = new List<Id>();
            for(Flyer_Account__c flyer : flyerList) {
                flyersIds.add(flyer.Building_Flyer__c);
            }

            List<Flyers__c> flyersListToReturn = [SELECT Id, Name, 	Flyer_Date__c, 	Flyer_Type__c, 	Active_or_Inactive__c, 	File__c, File_Name__c, File_Location__c FROM Flyers__c WHERE Id IN:flyersIds];
            return flyersListToReturn;
        
    }

    @AuraEnabled 
    public static List<Flyers__c> getAllFlyersBySuiteId(String suiteId){
        
            List<Flyer_Suite__c> flyerList = [SELECT Suites__c, Building_Flyer__c FROM Flyer_Suite__c WHERE Suites__c =:suiteId];
            List<Id> flyersIds = new List<Id>();
            for(Flyer_Suite__c flyer : flyerList) {
                flyersIds.add(flyer.Building_Flyer__c);
            }

            List<Flyers__c> flyersListToReturn = [SELECT Id, Name, 	Flyer_Date__c, 	Flyer_Type__c, 	Active_or_Inactive__c, 	File__c, File_Name__c, File_Location__c FROM Flyers__c WHERE Id IN:flyersIds];
            return flyersListToReturn;
        
    }

    @AuraEnabled 
    public static List<Flyers__c> getAllFlyersByBuildingId(String buildingId){
        // List<Flyer_Suite__c> flyerList = [SELECT Suites__c, Building_Flyer__c FROM Flyers__c WHERE Suites__c =:buildingId];
        // List<Id> flyersIds = new List<Id>();
        // for(Flyer_Suite__c flyer : flyerList) {
        //     flyersIds.add(flyer.Building_Flyer__c);
        // }

        List<Flyers__c> flyersListToReturn = [SELECT Id, Name, 	Flyer_Date__c, 	Flyer_Type__c, 	Active_or_Inactive__c, 	File__c, File_Name__c, File_Location__c FROM Flyers__c WHERE 	Building__c =:buildingId];
        return flyersListToReturn;
    }

    @AuraEnabled
    public static string getAccountNameFromId(Id accountId){
        
            String name = '';
            name = [SELECT Name FROM Account WHERE Id =: accountId].Name;
            system.debug('account id: ' + accountId);
            system.debug('name:: '+ name);
            return name;
        
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
    public static List<ContentDocumentLink> getAllRelatedFilesById(List<String> recordIds){
        try { 
            List<ContentDocumentLink> CDLs = [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds];
            // List <Id> CDIdList = new List <Id> ();
            // if (CDLs.size() < 1) {
            //     return new List<ContentDocument>(); 
            // }
                
            // else {
            //     for(ContentDocumentLink cdl : CDLs) {
            //         CDIdList.add(cdl.ContentDocumentId);
            //     }
            // }
                return CDLs;
            
            // List<ContentDocument> entries = [SELECT Id, Title, ContentSize, CreatedDate, FileType FROM ContentDocument WHERE Id IN :CDIdList];
            // List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE ContentDocument.Id IN (SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :leaseId)];
            // return entries;         
        
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class ContentDocumentWithFileName {
        @AuraEnabled
        public string ContentDocumentId;
        @AuraEnabled
        public string RelatedRecordId;
    }

    @AuraEnabled
    public static string getBuildingNameById(String buildingId){
        try {
            Building__c bld = [SELECT Name FROM Building__c WHERE Id=:buildingId LIMIT 1];
            return bld.Name;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Building__c getBuildingNameAndIdByAccountId(String accountId){
        try {
            building_account__c buildingAccount = [SELECT Building_Account__c, Building_BA__c FROM building_account__c WHERE Building_Account__c =: accountId LIMIT 1];
            String buildingId = buildingAccount.Building_BA__c;
            Building__c building = new Building__c();
            if(buildingId != '' || !String.isBlank(buildingId)){
                building = [SELECT Name, Id FROM Building__c WHERE Id=:buildingId LIMIT 1];
                return building;
            }
            return building;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Building__c getBuildingNameAndIdBySuiteId(String suiteId){
        try {
            Suites__c buildingAccount = [SELECT Id, Building__c FROM Suites__c WHERE Id =: suiteId LIMIT 1];
            String buildingId = buildingAccount.Building__c;
            Building__c building = new Building__c();
            if(buildingId != '' || !String.isBlank(buildingId)){
                building = [SELECT Name, Id FROM Building__c WHERE Id=:buildingId LIMIT 1];
                return building;
            }
            return building;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}