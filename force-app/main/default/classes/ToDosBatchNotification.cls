global class ToDosBatchNotification implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
global Database.QueryLocator start(Database.BatchableContext bc) {
    
        return Database.getQueryLocator(
            'SELECT ID, Name, OwnerId FROM To_Do__c WHERE Due_Date__c = Today'
        );
	}

      
    
     global void execute(Database.BatchableContext bc, List<To_Do__c> scope){
        
        List<To_Do__c> td = new List<To_Do__c>();
        for (To_Do__c newToDo : scope) {
             list<Id> recipients = new List<Id>();
            if( newToDo.OwnerId != null){
				recipients.add(newToDo.OwnerId);
             td.add(newToDo);
                myToDosBellNotification.notifyCurrentUser(recipients, newToDo.Name, newToDo.Id);
         }
            System.debug(td);
		System.debug('Executed');

        }   
       
    }    

	global void finish(Database.BatchableContext BC) {
		System.debug('Finished');
	}
    
   

}