public class createPaySlipsBatch implements Database.Batchable<Job_Card__c>{

    public createPaySlipsBatch(){
        
    }
    
     public Iterable<Job_Card__c> start(Database.BatchableContext bc) {
         List<Job_Card__c> jobCards = new List<Job_Card__c>();
         Date today = System.today();
         Date firstDate = today.toStartOfMonth();
         Date middleDate = firstDate.addDays(14);
         Date middleDatePastMonth = today.addMonths(-1);
         middleDatePastMonth = middleDatePastMonth.addDays(14);
         Integer day = today.day();
         if(day == 1){
            jobCards = [Select id, Employee__c, Cleaning_Date__c, Booking__r.Amount_per_cleaner__c  from Job_Card__c where Completed__c = true and Cleaning_Date__c >=: middleDatePastMonth and Cleaning_Date__c<: firstDate];
         }
         else{
            jobCards = [Select id, Employee__c, Cleaning_Date__c, Booking__r.Amount_per_cleaner__c  from Job_Card__c where Completed__c = true and Cleaning_Date__c >=: firstDate and Cleaning_Date__c <: middleDate];
         }
         return jobCards;
     }
     
     public void execute (Database.BatchableContext BC, List<Job_Card__c> scope) {
        List<Payment_Slip__c> paySlips = new List<Payment_Slip__c>();
        for(Job_Card__c jobCard: scope){
            Payment_Slip__c payslip = new Payment_Slip__c();
            payslip.Amount__c = jobCard.Booking__r.Amount_per_cleaner__c/2;
            payslip.Employee__c = jobCard.Employee__c;
            payslip.Job_Card__c = jobCard.id;
            paySlips.add(payslip);
        }
        if(paySlips.size()>0)
        insert paySlips;
     }
     
     public void finish(Database.BatchableContext BC){
     
     }

}