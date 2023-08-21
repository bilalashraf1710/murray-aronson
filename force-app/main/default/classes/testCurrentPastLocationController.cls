@isTest
private class testCurrentPastLocationController {
    
    @isTest
    public static void testGetAccountList()
    {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Portfolio Company'].Id;
        Account acc1 = new Account(Name = 'Test Account1',RecordTypeId = strRecordTypeId);
        Insert acc1;
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Location'].Id;
        Account acc2 = new Account(Name = 'Test Account2',ParentId = acc1.Id, RecordTypeId = strRecordTypeId1);
        Insert acc2;
        List<Account> accList = currentPastLocationController.getAccountsList(acc1.Id);
        System.assertEquals(1, accList.size(), 'Number should be 1');
    }
    
    
    @isTest
    public static void testGetPortfolioRelationshipList()
    {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Portfolio Company'].Id;
        Account acc1 = new Account(Name = 'Test Account1',RecordTypeId = strRecordTypeId);
        Insert acc1;
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Company'].Id;
        Account acc2 = new Account(Name = 'Test Account2',ParentId = acc1.Id, RecordTypeId = strRecordTypeId1);
        Insert acc2;
        Portfolio_Relationships__c pr = new Portfolio_Relationships__c(Portfolio_Company__c = acc1.Id, Company__c = acc2.Id);
        Insert pr;
        List<Portfolio_Relationships__c> PrList = currentPastLocationController.getPortfolioRelationRecords(acc1.Id);
        System.assertEquals(1, PrList.size(), 'Number should be 1');
    }
   
    
}