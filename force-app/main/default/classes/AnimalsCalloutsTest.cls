@isTest
(seeAlldata = true)
private class AnimalsCalloutsTest {
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