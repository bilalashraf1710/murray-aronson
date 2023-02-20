@isTest
(seeAlldata = true)
private class ScheduledTest {


	public static String TEST_SCH = '0 20 5 ? * *';

    static testmethod void testScheduledJob() {

            To_Do__c td = new To_Do__c();
                    
                    td.Access__c ='Public';
                    td.Due_Date__c= Date.today();
                    td.Type__c= 'Murray Aronson';
                    td.Name= 'Test';
                    td.Priority__c = 'High';
                    td.Periodicity__c= 'Daily';
                    
                    insert td;
	
		To_Do__c[] toDos = new List<To_Do__c>();
		// insert 200 compensations to arleccino
		Date created_date = Date.today().addDays(-2);
		for (Integer i = 0; i < 5; i++) {
			toDos.add(new To_Do__c(name='Testing toDo ' + i,
				Access__c ='Public',Due_Date__c= Date.today(),
				Priority__c = 'High', 
				Type__c= 'Murray Aronson',
				Periodicity__c= 'Daily'));
		}
		insert toDos;

        Test.startTest();
        // Schedule the test job
        String schtestwk = System.schedule('ScheduledApexTest',
            TEST_SCH,
            new ToDosSchedule());
        // Verify the scheduled job has not run yet. All compensations are not submitted
        Integer tod = [SELECT COUNT()
		              FROM To_Do__c
					  WHERE Name = 'Test' AND
					        Periodicity__c= 'Daily'];
        System.assertEquals(1, tod);
        // Stopping the test will run the job synchronously
        Test.stopTest();

		CronTrigger job = [SELECT State FROM CronTrigger WHERE Id = :schtestwk];

        System.assert((job.State=='COMPLETED')||(job.State=='WAITING'));
    }
    
     @isTest static  void testGetCallout() {
        // Create the mock response based on a static resource
      
        
        // Call method to test
            
    }   
    
@isTest static void testPostCallout() {
List<To_Do__c> todos = [
   SELECT 
      Id 
   FROM 
      To_Do__c
];
List<Id> todosIds = new List<Id>();
for(To_Do__c TD:todos){
   todosIds.add(TD.Id);
}
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
mock.setStaticResource('GetAnimalResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);

    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new ToDosCallOutMock()); 
    // This causes a fake response to be sent
    // from the class that implements HttpCalloutMock. 
    HttpResponse response = MyToDosBellNotification.makePostCallout();
    // Verify that the response received contains fake values
    String contentType = response.getHeader('Content-Type');
    System.assert(contentType == 'application/json');
    String actualValue = response.getBody();
    System.debug(response.getBody());
    String expectedValue = '{"ToDos": ["first toDo", "second toDo", "third toDo"]}';
    System.assertEquals(actualValue, expectedValue);
    System.assertEquals(200, response.getStatusCode());
}
}