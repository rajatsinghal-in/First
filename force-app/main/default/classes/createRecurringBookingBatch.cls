public class createRecurringBookingBatch implements Database.Batchable<Contract>{
    
    map<String, String> frequencyMap = new Map<String, String>();
    
    public createRecurringBookingBatch(){
        
    }
    
     public Iterable<Contract> start(Database.BatchableContext bc) {
         List<Contract> recurringContracts = new List<Contract>();
         recurringContracts = [Select id, Discount__c, Frequency__c, Home_Office__c, Number_of_cleaners__c, AccountId, Account.Name, StartDate, (select id, Cleaning_Date__c from Bookings__r order by Cleaning_Date__c desc limit 1)  from Contract where Frequency__c != null and End_Date__c>TODAY];
         return recurringContracts;
     }
     
     public void execute (Database.BatchableContext BC, List<Contract> scope) {
         List<Booking__c> bookingToInsert = new List<Booking__c>();
        for(Contract con : scope){
            if(con.Bookings__r.size()>0){
                for(Booking__c lastbooking : con.Bookings__r){
                    if(lastbooking.Cleaning_Date__c < System.today()){
                        Booking__c booking = new Booking__c();
                        booking.Account__c = con.AccountId;
                        if(con.Frequency__c == 'Monthly'){
                            booking.Cleaning_Date__c = lastbooking.Cleaning_Date__c.addMonths(1);
                        }
                        else if(con.Frequency__c == 'Weekly'){
                            booking.Cleaning_Date__c = lastbooking.Cleaning_Date__c.addDays(7);
                        }
                        else{
                            booking.Cleaning_Date__c = lastbooking.Cleaning_Date__c.addDays(14);    
                        }
                        booking.Name = con.Account.Name + ' '+ booking.Cleaning_Date__c;
                        booking.Contract__c = con.id;
                        booking.Discount__c = con.Discount__c != null ? con.Discount__c:0;
                        booking.Number_of_cleaners__c = con.Number_of_cleaners__c != null ? con.Number_of_cleaners__c : 0;
                        booking.Amount_per_cleaner__c = Integer.valueOf(Label.Standard_Price_in_USD) * ((100-booking.Discount__c)/100);
                        booking.Amount_Payable__c = booking.Amount_per_cleaner__c*booking.Number_of_cleaners__c;
                        bookingToInsert.add(booking);
                    }
                }
            }
        }
        if(bookingToInsert.size()>0){
            insert bookingToInsert;
            List<Notification__c> notifications = new List<Notification__c>();
            List<Job_Card__c> jobsToInsert = new List<Job_Card__c>();
            for(Booking__c bookingRec: bookingToInsert){
                List<Job_Card__c> jobs = CreateBookingController.createJobCard(bookingRec);                
                if(jobs.size() == 0){
                    bookingRec.Message__c = 'Resources not available for the day. Please inform the customer.';
                    Notification__c notification = new Notification__c();
                    notification.Booking__c = bookingRec.id;
                    //update bookingRec;
                    notifications.add(notification);
                }
                else{
                    if(bookingRec.Number_of_cleaners__c > jobs.size()){
                        bookingRec.Message__c = Integer.valueOf(bookingRec.Number_of_cleaners__c - jobs.size()) + ' ' + 'Resources not available for the day. Please inform the customer.';
                        Notification__c notification = new Notification__c();
                        notification.Booking__c = bookingRec.id;
                        //update bookingRec;
                        notifications.add(notification);
                    }
                    jobsToInsert.addAll(jobs);
                }
            }
            if(jobsToInsert.size()>0){
                insert jobsToInsert;
            }
            if(notifications.size()>0){
                insert notifications;
                update bookingToInsert;
            }
        }
     }
     
     public void finish(Database.BatchableContext BC){
     
     }

}