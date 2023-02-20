@isTest
private class TestRemainingObligationController {

    @isTest
    public static void testRemainingObligationsForRentSchedule()
    {
        Account newacc = new Account(Name='test Account');
        insert newacc;
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        insert newRS;
        
        RemainingObligationController.getRelatedRentObj(newacc.Id);
    }
    
    
    @isTest
    public static void testGetRentScheduleSummary()
    {
         Account newacc = new Account(Name='test Account');
        insert newacc;
        
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
       
        RemainingObligationController.getRentScheduleSummary(newRS.Id);
    }
    
     @isTest
    public static void TestgetRentScheduleSummaryForRecordPage()
    {
         Account newacc = new Account(Name='test Account');
        insert newacc;
        
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        Insert newRS;
       
        RemainingObligationController.getRentScheduleSummaryForRecordPage(newRS.Id);
    }
   
}