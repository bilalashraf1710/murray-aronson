public class myToDosBellNotification {
       	public static HttpCalloutMock mock = null;
 public static HttpResponse makePostCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"name":"mighty moose"}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;
    }        

    public static void notifyCurrentUser(List<Id> recipients, String message, ID toDoId)
    {
		 if (test.isRunningTest()) Test.setMock(HTTPCalloutMock.class, new ToDosCallOutMock());
		CustomNotificationType custNotificationId = [SELECT Id, DeveloperName FROM CustomNotificationType];
        List<Id> OrgUsers = new List <Id>();
        for(Id currentReceipt:recipients){
            Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
            + '/services/data/v46.0/actions/standard/customNotificationAction');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        CustomNotificationActionInput input = new CustomNotificationActionInput();
        input.customNotifTypeId = custNotificationId.Id;
        input.recipientIds = recipients;
        input.title = 'New To Do';
        input.body = message;
        input.targetId = todoId;
        CustomNotificationAction action = new CustomNotificationAction();
        action.inputs = new List<CustomNotificationActionInput>{input};
        req.setBody(JSON.serialize(action));
        HttpResponse res = h.send(req);
        System.debug(res.getBody());
         if (test.isRunningTest()) Test.setMock(HTTPCalloutMock.class, new ToDosCallOutMock());  
        }
        
    }

    public class CustomNotificationAction
    {
        public List<CustomNotificationActionInput> inputs { get; set; }
    }

    public class CustomNotificationActionInput
    {
        public String customNotifTypeId { get; set; }
        public List<String> recipientIds { get; set; }
        public String title { get; set; }
        public String body { get; set; }
        public String targetId { get; set; }
    }
}