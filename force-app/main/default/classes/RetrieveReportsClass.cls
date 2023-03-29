public class RetrieveReportsClass  implements Queueable,  Database.AllowsCallouts{
    
    private String rsNumber;
    public RetrieveReportsClass(String rsNumber)
    {
        this.rsNumber = rsNumber;
    }
    public void execute(QueueableContext context) {
        
        List<Report> recentCreatedReports = [SELECT Id, Name FROM Report ORDER BY CreatedDate DESC LIMIT 6];
        ReportsListJSOSN obj = new ReportsListJSOSN(recentCreatedReports);
        String jsonString = JSON.serialize(obj);

        List<Rent_Schedule__c> updateRecord = new List<Rent_Schedule__c>();
        Rent_Schedule__c newobj = new Rent_Schedule__c();
     updateRecord = [Select Id, Name from Rent_Schedule__c where Name =:rsNumber];
		if(updateRecord.size() > 0)
        {
          newobj = updateRecord[0];
          newobj.ReportsLinks__c = jsonString;
          StopUpdateRecursion.isfutureupdate=true;
          update newobj;
        }
        
      	}

}