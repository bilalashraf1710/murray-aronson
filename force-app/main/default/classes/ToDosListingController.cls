public class ToDosListingController {
    
    private static final string BASEQUERY=  'SELECT ID, Name, Subject__c, Due_Date__c, Type__c, Priority_Order__c, Priority__c '+
        'FROM To_Do__c :whereClause';
    
    @AuraEnabled
    public static List<To_Do__c> getToDosList( String filterOrder, boolean publicTodos, String toDosearch) {
        filterOrder.toLowerCase();
        System.debug(filterOrder+ ' ' + publicTodos + toDosearch);
        
        List<To_Do__c> filteredToDoS = new List<To_Do__c>();
        String query = BASEQUERY;
        String searchClause = '';
        //with search field term
        if(toDosearch != null && toDosearch.length() >= 1){
            
            if(filterOrder == 'high' && publicTodos == false){
                searchClause += 'Where Name like \'%' + toDosearch + '%\''+  '  AND Access__c= \'Public\'  AND  OwnerId=\'' +UserInfo.getUserId() +'\''+' ORDER BY Priority_Order__c ASC, Priority__c ASC';
                String    target= ':whereClause'; 
                system.debug('got here c1');
                
                query= query.replace(target, searchClause);
                filteredToDos = Database.query(query);
                System.debug(filteredToDos);
            }
            if(filterOrder == 'low' && publicTodos == false){
                searchClause += 'Where Name like \'%' + toDosearch + '%\' '+ '  AND Access__c= \'Public\'  AND  OwnerId=\'' +UserInfo.getUserId() +'\''+' ORDER BY Priority_Order__c DESC, Priority__c ASC';
                String    target= ':whereClause'; 
                
                query= query.replace(target, searchClause);
                filteredToDos = Database.query(query);
                System.debug(query);
            }
            
            if (filterOrder == 'high' && publicTodos == true ){
                searchClause += 'Where Name like \'%' + toDosearch + '%\''+ '  AND Access__c= \'Public\'' +' ORDER BY Priority_Order__c ASC, Priority__c ASC';
                String    target= ':whereClause'; 
                
                query= query.replace(target, searchClause);
                filteredToDos = Database.query(query);
                System.debug(query);
            }
            if (filterOrder == 'low' && publicTodos == true ){
                searchClause += 'Where Name like \'%' + toDosearch + '%\''+ '  AND Access__c= \'Public\'' +' ORDER BY Priority__c DESC, Priority_Order__c ASC';
                String    target= ':whereClause'; 
                
                query= query.replace(target, searchClause);
                filteredToDos = Database.query(query);
                System.debug(query);
            }
            return filteredToDos; 
            
        }
        
        
        if(toDosearch == null || String.isBlank(toDosearch)){
            
            if (filterOrder == 'high' && publicTodos == false ){
                searchClause += 'Where Due_Date__c= today AND Access__c= \'Public\'  AND  OwnerId=\'' +UserInfo.getUserId() +'\''+'ORDER BY Priority_Order__c ASC, Priority__c ASC';
                String    target= ':whereClause'; 
                
                query= query.replace(target, searchClause);
                System.debug(query);
            }
            if (filterOrder == 'low' && publicTodos == false ){
                searchClause += 'Where Due_Date__c= today AND Access__c= \'Public\'  AND  OwnerId=\'' +UserInfo.getUserId() +'\''+'ORDER BY Priority__c DESC, Priority_Order__c ASC';
                String    target= ':whereClause'; 
                
                query= query.replace(target, searchClause);
                System.debug(query);
            }
            if (filterOrder == 'high' && publicTodos == true ){
                searchClause += 'Where Due_Date__c= today AND Access__c= \'Public\'' +'ORDER BY Priority_Order__c ASC, Priority__c ASC';
                String    target= ':whereClause'; 
                
                query= query.replace(target, searchClause);
                System.debug(query);
            }
            if (filterOrder == 'low' && publicTodos == true ){
                searchClause += 'Where Due_Date__c= today AND Access__c= \'Public\'' +'ORDER BY Priority__c DESC, Priority_Order__c ASC';
                String    target= ':whereClause'; 
                
                query= query.replace(target, searchClause);
                System.debug(query);
                filteredToDos = Database.query(query);
                
            }
            if(filterOrder != null ){
                searchClause += 'Where Due_Date__c= today AND Access__c= \'Public\' AND  OwnerId=\'' + UserInfo.getUserId() +'\''+ ' ORDER BY Priority_Order__c ASC';
                
                String    target= ':whereClause'; 
                
                query= query.replace(target, searchClause);
                filteredToDos = Database.query(query);
            }	        
            
            
            
            
        }
        return filteredToDos; 
    }
    
}