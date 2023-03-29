public class RemainingObligationController {
    
    @AuraEnabled
    public static List<Rents__c> getRelatedRentObj(String recordId)
    {       
        List<Rent_Schedule__c> RentScheduleList = [Select Id,Name from Rent_Schedule__c where Account__c =:recordId]; 
        List<Rents__c> rentObj = new List<Rents__c>();
        if(RentScheduleList.size()>0)
        {
			rentObj = [Select Rent_Start_Date__c,Rent_per_Month__c from Rents__c where Account__c=:recordId AND Rent_Schedule__c =:RentScheduleList[0].Id];
    	}  
       		return rentObj;  
    }
    
    
     @AuraEnabled
    public static List<Rent_Schedule__c> getRentScheduleSummary(String recordId)
    {
        
        List<Rent_Schedule__c> RentSchedule = new List<Rent_Schedule__c>();
        RentSchedule = [Select Id,Data_Summary__c,ReportsLinks__c from Rent_Schedule__c where Account__c =:recordId]; 
	    return RentSchedule;  		  
    }
    
      @AuraEnabled
    public static List<Rent_Schedule__c> getRentScheduleSummaryForRecordPage(String recordId)
    { 
        List<Rent_Schedule__c> RentSchedule = new List<Rent_Schedule__c>();
        RentSchedule = [Select Id,Data_Summary__c,ReportsLinks__c from Rent_Schedule__c where Id =:recordId]; 
	    return RentSchedule;     		  
    }
    @AuraEnabled
    public static void createReports(String recordId)
    {
        List<Rent_Schedule__c> RentScheduleList = [Select Id,Name from Rent_Schedule__c where Account__c =:recordId];
        String name = RentScheduleList[0].Name;
        MyReportCreator queueable = new MyReportCreator(name);
		System.enqueueJob(queueable);
   		  
    }

}