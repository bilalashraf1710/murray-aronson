@isTest
private class TestRentScheduleController {
    
    @isTest
    public static void testGetAccountName()
    {
        Account acc = new Account(Name = 'Test Account');
        Insert acc;
        String Name = NewRentSchedulesController.getAccountNameFromId(acc.Id);
        System.assertEquals('Test Account', Name, 'Name should be equal');
    }
    
     @isTest
    public static void testSaveRentSchedule()
    {
        Account acc = new Account(Name = 'Test Account');
        Insert acc;
        Rent_Schedule__c newRent = new Rent_Schedule__c(Account__c = acc.Id,
                                                        RS_Start_Date__c = date.newInstance(2023,01,31),
                                                        RS_End_Date__c = date.newInstance(2023,12,31),
                                                       Rent_per_Month__c = Decimal.valueOf('100'));
        Rent_Schedule__c rent = NewRentSchedulesController.saveRentSchedule(newRent);
        System.assertEquals(newRent, rent, 'Object should be equal');
    }
    
     @isTest
    public static void TestCheckRentScheduleExists()
    {
        Account acc = new Account(Name = 'Test Account');
        Insert acc;
        Rent_Schedule__c newRent = new Rent_Schedule__c(Account__c = acc.Id,
                                                        RS_Start_Date__c = date.newInstance(2023,01,31),
                                                        RS_End_Date__c = date.newInstance(2023,12,31),
                                                       Rent_per_Month__c = Decimal.valueOf('100'));
        Insert newRent;       
        System.assertEquals(NewRentSchedulesController.CheckRentScheduleExists(acc.Id), true, 'Value Should be true.');
    }

}