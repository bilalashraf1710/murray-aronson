@isTest public class TodoListingTest {
    @isTest public static  void ToDosListTest() {
        
        
        
        To_Do__c td = new To_Do__c();
        
        td.Access__c ='Public';
        td.Due_Date__c= Date.today();
        td.Type__c= 'Murray Aronson';
        td.Name= 'Test';
        td.Priority__c = 'High';
        td.Periodicity__c= 'Daily';
        
        insert td;
        
        List<To_Do__c>  getToDos = ToDosListingController.getToDosList('Low', true, null);
        List<To_Do__c>  getTodoWithPriorityWithOutOwnerWithNullQuery = ToDosListingController.getToDosList('Low', true, 'hen');
        List<To_Do__c>  getToDosWithNullQuery = ToDosListingController.getToDosList('Low', false, null);
        List<To_Do__c>  getToDosOwner = ToDosListingController.getToDosList('Low', false, 'hen');      
        
        List<To_Do__c>  getTodo = ToDosListingController.getToDosList('High', true, 'hj');
        List<To_Do__c>  getTodoOwnerWithNullQuery = ToDosListingController.getToDosList('High', false, null);
        List<To_Do__c>  getTodoWithPriorityOwnerWithNullQuery = ToDosListingController.getToDosList('High', true, null);
        List<To_Do__c>  getTodoOwner = ToDosListingController.getToDosList('High', false, 'hen');
        
        
    }         
    
}