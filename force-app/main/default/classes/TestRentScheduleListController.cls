@isTest
private class TestRentScheduleListController {
    
    @isTest
    public static void testgetAllRSByAccountId()
    {
        Test.setMock(HttpCalloutMock.class, new ToDosCallOutMock());
        Account newacc = new Account(Name='test Account');
        insert newacc;
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        insert newRS;
        List<Rent_Schedule__c> RSList = RentScheduleListController.getAllRSByAccountId(newacc.Id);
        System.assertEquals(RSList.size(), 1);
    }
    
    @isTest
    public static void testgetAccountNameFromId()
    {
        Test.setMock(HttpCalloutMock.class, new ToDosCallOutMock());
        Account newacc = new Account(Name='test Account');
        insert newacc;
        System.assertEquals(RentScheduleListController.getAccountNameFromId(newacc.Id), 'test Account');
    }
    
    @isTest
    public static void testdeleteRS()
    {
        Test.setMock(HttpCalloutMock.class, new ToDosCallOutMock());
        Account newacc = new Account(Name='test Account');
        insert newacc;
        Rent_Schedule__c newRS = new Rent_Schedule__c(Account__c=newacc.Id,
                                                      RS_Start_Date__c=date.newInstance(2023,01,01),
                                                      RS_End_Date__c=date.newInstance(2023,12,31),
                                                      Rent_per_Month__c=decimal.valueof('10')
                                                               		);
        insert newRS;
        System.assertEquals(RentScheduleListController.deleteRS(newRS.Id), true);
    }
    

}