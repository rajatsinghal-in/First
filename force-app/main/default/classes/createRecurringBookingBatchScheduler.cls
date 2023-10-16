global class createRecurringBookingBatchScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx){
        Database.executeBatch(new createRecurringBookingBatch(), 200);
    }
}