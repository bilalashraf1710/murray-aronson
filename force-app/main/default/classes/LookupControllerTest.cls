@isTest
public class LookupControllerTest {
    
	@isTest 
    public static void GetRecentRecordsTest(){
                                        //returnFields="['Name','Phone','Website']" 
                                //queryFields="['Name','Phone','Website']"
         List <String> returnFields = new List<String> ();
        returnFields.add('Name');
        returnFields.add('Phone');
        returnFields.add('Website');
        LookupController.GetRecentRecords('Account',returnFields, 5 );
    }
	
    	@isTest 
    public static void GetRecentRecordsTestNullQuery(){
        List <String> returnFields = new List<String> ();
        LookupController.GetRecentRecords('Account',returnFields, 5 );
    }
    
    @isTest 
    public static void SearchRecordsTest(){
        List <String> returnFields = new List<String> ();
        returnFields.add('Name');
        returnFields.add('Phone');
        returnFields.add('Website');
        String ObjectName = 'Account';
        List<String> QueryFields = returnFields; 
        String SearchText = 'test';
        String SortColumn = 'Name';
        String SortOrder ; 
        Integer MaxResults;
        String Filter ;
        LookupController.SearchRecords(ObjectName, returnFields, QueryFields, SearchText, SortColumn, SortOrder, MaxResults, Filter);
    }

/*    
    @isTest 
    public static void SearchRecordsTestWithNullMax(){
        List <String> returnFields = new List<String> ();
        returnFields.add('Name');
        returnFields.add('Phone');
        returnFields.add('Website');
        String ObjectName = 'Account';
        List<String> QueryFields = returnFields; 
        String SearchText = 'test';
        String SortColumn = 'Name';
        String SortOrder = '1'; 
        Integer MaxResults = 0;
        String Filter = '';
        LookupController.SearchRecords(ObjectName, returnFields, QueryFields, SearchText, SortColumn, SortOrder, MaxResults, Filter);
    }
    */
    
    @isTest 
    public static void getObjectDetailsTest(){
        LookupController.getObjectDetails('Account');
    }
    
    @isTest 
    public static void getRecordTest(){
        Account ac = new Account(Name='123');
        insert ac;
        List <String> returnFields = new List<String> ();
        returnFields.add('Name');
        returnFields.add('Phone');
        returnFields.add('Website');
        LookupController.getRecord('Account',returnFields, ac.id);
    }
	
}