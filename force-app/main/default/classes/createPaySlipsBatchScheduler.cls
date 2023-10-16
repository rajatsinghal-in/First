global class createPaySlipsBatchScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx){
        Database.executeBatch(new createPaySlipsBatch(), 200);
    }
}