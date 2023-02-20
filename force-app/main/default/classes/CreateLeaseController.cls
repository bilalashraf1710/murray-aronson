public with sharing class CreateLeaseController {
    @AuraEnabled
    public static Lease__c saveLease( Lease__c lease) {
  
        upsert lease;   
        return lease;
        
    }
    @AuraEnabled
    public static string getAccountNameFromId(Id accountId){
        
            String name = '';
            name = [SELECT Name FROM Account WHERE Id =: accountId].Name;
            return name;
        
    }
    @AuraEnabled
    public static Boolean attachFile( Lease__c lease, String docId) {
    
        try{
            
        
            system.debug('lease:: ' + lease);
			// String VersId = [SELECT contentDocumentId FROM contentVersion WHERE Id =:DocVer.id].contentDocumentId;
			ContentDocumentLink docLink = new ContentDocumentLink();
			doclink.ContentDocumentId = docId;
			doclink.linkedEntityId = lease.Id;
			doclink.sharetype = 'I';
			doclink.visibility = 'AllUsers';
			upsert doclink;

            // Lease__c lease = [SELECT Id, Lease_Document_Name__c FROM Lease__c WHERE Id =:leaseId];
            ContentDocument cd = [SELECT Title FROM ContentDocument WHERE Id =: docId];
            cd.Title = lease.Lease_Document_Name__c;
            update cd;
            return true;
            }
        catch(Exception e){
            return false;
        }
	
    }

    @AuraEnabled
    public static void deleteFileById(String documentId){
        
            // Lease__c lease = [SELECT Id, Lease_Document_Name__c FROM Lease__c WHERE Id =:leaseId];
            ContentDocument cd = [SELECT Id, Title FROM ContentDocument WHERE Id =: documentId];
            // cd.Title = lease.Lease_Document_Name__c;
            delete cd;
        
    }

    @AuraEnabled
    public static List<Lease__c> getLeasesListByAccountId(Id accountId){
        try {
            List<Lease__c> leasesList = [SELECT cLease_Document_Name__c, Lease_Date__c FROM Lease__c WHERE Account__c =: accountId];
            return leasesList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteLeasesByNameFromAccount(Id accountId, String docName){
        try {
            List<Lease__c> leasesList = [SELECT cLease_Document_Name__c FROM Lease__c WHERE Account__c=:accountId AND cLease_Document_Name__c =: docName];
            delete leasesList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteLeasesByDateAndNameFromAccount(Id accountId, String docName, Date leaseDate){
        try {
            List<Lease__c> leasesList = [SELECT cLease_Document_Name__c FROM Lease__c WHERE Account__c=:accountId AND cLease_Document_Name__c =: docName AND Lease_Date__c =:leaseDate];
            delete leasesList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}