global class CriticalDatesEmailNotificationsScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      	CriticalDatesBatch myBatchObject = new CriticalDatesBatch();
		Id batchId = Database.executeBatch(myBatchObject);
   }
}