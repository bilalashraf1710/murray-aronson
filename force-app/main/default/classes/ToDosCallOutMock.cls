@isTest
global class ToDosCallOutMock implements HttpCalloutMock {
    
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"ToDos": ["first toDo", "second toDo", "third toDo"]}');
        response.setStatusCode(200);
        return response; 
    
    }
}