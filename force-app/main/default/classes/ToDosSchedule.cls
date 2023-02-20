global class ToDosSchedule implements Schedulable {

   global void execute(SchedulableContext ctx) {
      ToDosBatchNotification SchedTD = new ToDosBatchNotification();
        database.executeBatch(SchedTD);
      
   }   
   
}