@isTest
public class LeaseListControllerTest {
	@isTest
    public static void getAllLeasesByAccountIdTest(){
        //LeaseListController.getAllLeasesByAccountId(null);
        Account ac = new Account(Name='test');
        insert ac;
        //LeaseListController.getAllLeasesByAccountId('');
        LeaseListController.getAllLeasesByAccountId(ac.Id);
        //LeaseListController.getAccountNameFromId(null);
        LeaseListController.getAccountNameFromId(ac.Id);
    }
    
    @isTest
    public static void getAllLeasesByAccountIdTestException(){
        //LeaseListController.getAllLeasesByAccountId(null);
        //LeaseListController.getAccountNameFromId(null);
    }
}