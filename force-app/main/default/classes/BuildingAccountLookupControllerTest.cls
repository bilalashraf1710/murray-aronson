@isTest
public class BuildingAccountLookupControllerTest {
    
	@isTest 
    public static void GetRecentRecordsTest(){
         List <String> returnFields = new List<String> ();
        returnFields.add('Name');
        Account ac1 = new Account(Name='test');
        Account ac2 = new Account(Name='test2');
        Building__c b= new Building__c(Name='test building');
        insert ac1;
        insert ac2;
        insert b;
        List<String> includedIds = new List<String>();
        includedIds.add(ac1.Id);
        
        List<String> excludedIdsList=new List<String>();
        excludedIdsList.add(ac2.Id);
        String relatedRecordId = b.Id;
        String relatedRecordAPIName = 'Building__c';
        BuildingAccountLookupController.GetRecentRecords(includedIds, excludedIdsList, relatedRecordId, relatedRecordAPIName, 'Account', returnFields, 5 );
    }
	
    	@isTest 
    public static void GetRecentRecordsTestNullQuery(){
        Account ac1 = new Account(Name='test');
        Account ac2 = new Account(Name='test2');
        Building__c b= new Building__c(Name='test building');
        insert ac1;
        insert ac2;
        insert b;
        List<String> includedIds = new List<String>();
        includedIds.add(ac1.Id);
        
        List<String> excludedIdsList=new List<String>();
        excludedIdsList.add(ac2.Id);
        String relatedRecordId = b.Id;
        String relatedRecordAPIName = 'Building__c';
        List <String> returnFields = new List<String> ();
        BuildingAccountLookupController.GetRecentRecords(includedIds, excludedIdsList, relatedRecordId, relatedRecordAPIName, 'Account', returnFields, 5 );
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
        Account ac1 = new Account(Name='test');
        Account ac2 = new Account(Name='test2');
        Building__c b= new Building__c(Name='test building');
        insert ac1;
        insert ac2;
        insert b;
        List<String> includedIds = new List<String>();
        includedIds.add(ac1.Id);
        
        List<String> excludedIdsList=new List<String>();
        excludedIdsList.add(ac2.Id);
        String relatedRecordId = b.Id;
        String relatedRecordAPIName = 'Building__c';
        BuildingAccountLookupController.SearchRecords(includedIds, excludedIdsList, relatedRecordId, relatedRecordAPIName, ObjectName, returnFields, QueryFields, SearchText, SortColumn, SortOrder, MaxResults, Filter);
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
        BuildingAccountLookupController.getObjectDetails('Account');
    }
    
    @isTest 
    public static void getRecordTest(){
        Account ac = new Account(Name='123');
        insert ac;
        List <String> returnFields = new List<String> ();
        returnFields.add('Name');
        returnFields.add('Phone');
        returnFields.add('Website');
        BuildingAccountLookupController.getRecord('Account',returnFields, ac.id);
    }
	
}