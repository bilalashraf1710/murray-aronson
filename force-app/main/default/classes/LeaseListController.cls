public with sharing class LeaseListController {
    @AuraEnabled 
    public static List<Lease__c> getAllLeasesByAccountId(String accountId){
        
            List<Lease__c> leaseList = [SELECT Name, Account__c, cLease_Date_c__c, cLease_Document_Name__c FROM Lease__c WHERE Account__c =:accountId];
            return leaseList;
        
    }

    @AuraEnabled
    public static string getAccountNameFromId(Id accountId){
        
            String name = '';
            name = [SELECT Name FROM Account WHERE Id =: accountId].Name;
            system.debug('account id: ' + accountId);
            system.debug('name:: '+ name);
            return name;
        
    }
}