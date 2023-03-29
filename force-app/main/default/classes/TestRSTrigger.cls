@isTest
private class TestRSTrigger {
    
    @isTest
    public static void testInsertRentSchedule()
    {
        Account newacc = new Account(Name='test Account');
        insert newacc;
        Rent_Schedule__c newRS1 = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        insert newRS1;
        Rent_Schedule__c newRS2 = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        insert newRS2;

    }
    

}