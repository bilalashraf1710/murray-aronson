public with sharing class RentScheduleListController {
    
     @AuraEnabled 
    public static List<Rent_Schedule__c> getAllRSByAccountId(String accountId){
        
            List<Rent_Schedule__c> RSList = [SELECT Id, Name FROM Rent_Schedule__c WHERE Account__c =:accountId];
            return RSList;
        
    }
    
     @AuraEnabled
    public static string getAccountNameFromId(Id accountId){
        
            String name = '';
            name = [SELECT Name FROM Account WHERE Id =: accountId].Name;
            return name;
        
    }
    
    @AuraEnabled
    public static Boolean deleteRS(String recordId) {
        Rent_Schedule__c RSObj = [SELECT Id, Name FROM Rent_Schedule__c WHERE Id =:recordId];
        delete RSObj;   
        return true;
        
    }

}