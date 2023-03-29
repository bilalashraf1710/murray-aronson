public class NewRentSchedulesController {
    
    @AuraEnabled
    public static string getAccountNameFromId(Id accountId){
        
            String name = '';
            name = [SELECT Name FROM Account WHERE Id =: accountId].Name;
            return name;
        
    }
    
    @AuraEnabled
    public static Rent_Schedule__c saveRentSchedule( Rent_Schedule__c rentSchedule) {
        upsert rentSchedule;   
        return rentSchedule;   
    }
    
    @AuraEnabled
    public static Boolean CheckRentScheduleExists(String recordId)
    {
        
        List<Rent_Schedule__c> RentScheduleList = [Select Id,Name from Rent_Schedule__c where Account__c =:recordId]; 
        if(RentScheduleList.size()>0)
        {
			return true;
    	}  

       		return false;
    }
    

}