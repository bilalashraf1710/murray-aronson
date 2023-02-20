public with sharing class FlyersRelatedListController {
    @AuraEnabled
    public static List<Account> getFlyerRelatedAccountsById(String flyerId){
        try {
            List<Flyer_Account__c> flyerAccounts = [SELECT 	Account__c, Building_Flyer__c FROM Flyer_Account__c WHERE Building_Flyer__c =:flyerId];
            List<Id> accountIds = new List<Id>();
            for(Flyer_Account__c flyerAccount : flyerAccounts){
                accountIds.add(flyerAccount.Account__c);
            }

            List<Account> listAccount = [SELECT Name FROM Account WHERE Id IN: accountIds];
            return listAccount;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Suites__c> getFlyerRelatedSuitesById(String flyerId){
        try {
            List<Flyer_Suite__c> flyerAccounts = [SELECT 	Suites__c, Building_Flyer__c FROM Flyer_Suite__c WHERE Building_Flyer__c =:flyerId];
            List<Id> suiteIds = new List<Id>();
            for(Flyer_Suite__c flyerAccount : flyerAccounts){
                suiteIds.add(flyerAccount.Suites__c);
            }

            List<Suites__c> listAccount = [SELECT Name FROM Suites__c WHERE Id IN: suiteIds];
            return listAccount;
        } catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }
    }
}