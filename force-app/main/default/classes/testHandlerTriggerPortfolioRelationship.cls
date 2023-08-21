@isTest
private class testHandlerTriggerPortfolioRelationship {
    
     @isTest
    public static void testupdatePrRelationFieldAccount()
    {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Portfolio Company'].Id;
        Account acc1 = new Account(Name = 'K1 Investment Management LLC',RecordTypeId = strRecordTypeId);
        Insert acc1;
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Company'].Id;
        Account acc2 = new Account(Name = 'Test Account2',ParentId = acc1.Id, RecordTypeId = strRecordTypeId1);
        Insert acc2;
        Portfolio_Relationships__c pr = new Portfolio_Relationships__c(Portfolio_Company__c = acc1.Id, Company__c = acc2.Id);
        Database.SaveResult result = Database.Insert(pr, false);
    	System.assert(result.isSuccess());
    }

     @isTest
    public static void testupdatePrRelationFieldAccountElseCond()
    {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Portfolio Company'].Id;
        Account acc1 = new Account(Name = 'Account test 1',RecordTypeId = strRecordTypeId);
        Insert acc1;
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Company'].Id;
        Account acc2 = new Account(Name = 'Test Account2',ParentId = acc1.Id, RecordTypeId = strRecordTypeId1);
        Insert acc2;
        Portfolio_Relationships__c pr = new Portfolio_Relationships__c(Portfolio_Company__c = acc1.Id, Company__c = acc2.Id);
        Database.SaveResult result = Database.Insert(pr, false);
    	System.assert(result.isSuccess());
    }
    
    @isTest
    public static void testupdatePrRelationFieldAccountonDelete()
    {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Portfolio Company'].Id;
        Account acc1 = new Account(Name = 'K1 Investment Management LLC',RecordTypeId = strRecordTypeId);
        Insert acc1;
        String strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Company'].Id;
        Account acc2 = new Account(Name = 'Test Account2',ParentId = acc1.Id, RecordTypeId = strRecordTypeId1);
        Insert acc2;
        Portfolio_Relationships__c pr = new Portfolio_Relationships__c(Portfolio_Company__c = acc1.Id, Company__c = acc2.Id);
        Insert pr;
        Database.DeleteResult result = Database.Delete(pr, false);
    	System.assert(result.isSuccess());
    }

}