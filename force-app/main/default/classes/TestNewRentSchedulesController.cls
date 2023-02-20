@isTest
private class TestNewRentSchedulesController {
    
	@isTest
    public static void getAccountNameByIdTest(){
        Account b= new Account(Name='test Account');
        insert b;
        String AccountName = NewRentSchedulesController.getAccountNameFromId(b.Id);
        system.assertEquals('test Account', AccountName);
    }
    
    @isTest
    public static void TestInsertRentSchedule()
    {
        Account newacc = new Account(Name='test Account');
        insert newacc;
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        NewRentSchedulesController.saveRentSchedule(newRS);
    }
}