public with sharing class NewFlyerController {

    @AuraEnabled
    public static string getBuildingNameFromId(Id buildingId){
        try {
            Building__c building = [SELECT Name FROM Building__c WHERE Id=:buildingId LIMIT 1];
            String buildingName = building.Name;
            return buildingName;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static ContentDocument getContentDocumentById(String contentDocumentId){
        // ContentDocument cd = [SELECT Id, Title, ContentSize, CreatedDate, FileType FROM ContentDocument WHERE Id =:contentDocumentId LIMIT 1];
        List<ContentDocument> contentDocList = new List<ContentDocument>();
        contentDocList = [SELECT Id, Title, ContentSize, CreatedDate, FileType FROM ContentDocument WHERE Id =:contentDocumentId LIMIT 1];
        if(contentDocList.size()>1){
            return contentDocList[0];
        } else{
            return new ContentDocument();
        }
    }
    @AuraEnabled
    public static Flyers__c saveFlyer( Flyers__c flyer) {
        upsert flyer;   
        return flyer;   
    }
    @AuraEnabled
    public static Boolean attachFile( Flyers__c flyer, String docId) {
        try{
            String fileName = '';
            List<ContentDocument> CDList = [SELECT Title FROM ContentDocument WHERE Id =: docId LIMIT 1];
            if(CDList.size()>0){
                fileName = CDList[0].Title;
            }
            flyer.File_Location__c = '/lightning/r/ContentDocument/'+docId+'/view';
            flyer.File_Name__c = fileName;
            update flyer;
			// String VersId = [SELECT contentDocumentId FROM contentVersion WHERE Id =:DocVer.id].contentDocumentId;
			ContentDocumentLink docLink = new ContentDocumentLink();
			doclink.ContentDocumentId = docId;
			doclink.linkedEntityId = flyer.Id;
			doclink.sharetype = 'I';
			doclink.visibility = 'AllUsers';
			upsert doclink;

            // Lease__c lease = [SELECT Id, Lease_Document_Name__c FROM Lease__c WHERE Id =:leaseId];
            ContentDocument cd = [SELECT Title FROM ContentDocument WHERE Id =: docId];
            cd.Title = flyer.Name;
            update cd;
            return true;
        }
        catch(Exception e){
            return false;
        }
	
    }

    @AuraEnabled
    public static List<String> getBuildingAccountIds(String buildingId){
        try {
            List<building_account__c> buildingAccounts = [SELECT Building_Account__c, Building_BA__c FROM building_account__c WHERE Building_BA__c =: buildingId];
            List<String> buildingAccountIds = new List<String> ();
            for(building_account__c BA : buildingAccounts){
                buildingAccountIds.add(BA.Building_Account__c);
            }
            system.debug('building Accounts' + buildingAccountIds);
            return buildingAccountIds;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addFlyerRelationshipWithAccounts(Id flyerId, List<Id> accountIds){
        try {
            // List<Account> accountList = [SELECT Id FROM Account WHERE Id IN:accountIds];
            // for(Account ac : accountList){
            //     ac.Building_Flyer__c = flyerId;
            // }
            // update accountList;
            List<Flyer_Account__c> flyersList = new List<Flyer_Account__c>();
            for(Id accountId : accountIds){
                Flyer_Account__c flyerAccount = new Flyer_Account__c();
                flyerAccount.Building_Flyer__c = flyerId;
                flyerAccount.Account__c = accountId;
                flyersList.add(flyerAccount);
            }
            insert flyersList;
            // Flyer_Account__c 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void addFlyerRelationshipWithSuites(Id flyerId, List<Id> suiteIds){
        try {
            // List<Suites__c> suiteList = [SELECT Id FROM Suites__c WHERE Id IN:suitesIds];
            // for(Suites__c suite : suiteList){
            //     suite.Building_Flyer__c = flyerId;
            // }
            // update suiteList;
            system.debug('suites IDds : ' + suiteIds);
            system.debug('flyer id : ' + flyerId);
            List<Flyer_Suite__c> flyersList = new List<Flyer_Suite__c>();
            for(Id suiteId : suiteIds){
                Flyer_Suite__c flyerSuite = new Flyer_Suite__c();
                flyerSuite.Building_Flyer__c = flyerId;
                flyerSuite.Suites__c = suiteId;
                flyersList.add(flyerSuite);
            }
            insert flyersList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getBuildingIdByFlyerId(String flyerId){
        try {
            Flyers__c flyer = [SELECT Building__c FROM Flyers__c WHERE Id =:flyerId LIMIT 1];
            return flyer.Building__c;
        } catch (Exception e) {
            system.debug('Error: ' + e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}