public with sharing class currentPastLocationController {

  @AuraEnabled(cacheable=true)
  public static List<Account> getAccountsList(
    String recordId
  ) {
        List<Account> accList = new List<Account>();
        accList = [Select Id, Name,RecordType.Name, Location_Status__c, Location_Type__c, Tenancy_Type__c, RSF__c, LEXP__c from Account
                    where ParentId =:recordId AND RecordType.Name IN ('Location', 'Prospect Location')];
        return accList;
    }

    @AuraEnabled(cacheable=true)
  public static List<Portfolio_Relationships__c> getPortfolioRelationRecords(
    String recordId
  ) {
        List<Portfolio_Relationships__c> prList = new List<Portfolio_Relationships__c>();
        prList = [Select Id, Name,Company__c, 
                  Investment_Status__c, Company_lookup_Name__c, Stake__c, PE_Acquisition_Date__c, 
                  PE_Disposition_Date__c from Portfolio_Relationships__c where Portfolio_Company__c =:recordId];
                  return prList;
    }
    

}