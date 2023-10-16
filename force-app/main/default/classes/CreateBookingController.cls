public class CreateBookingController{
    
    @AuraEnabled(Cacheable=false)
    public static void createBookings(String contractId){        
        Contract con = [select id, Discount__c, Frequency__c, Home_Office__c, Number_of_cleaners__c, AccountId, Account.Name, StartDate from Contract where id =: Id.valueof(contractId)];
        Booking__c booking = new Booking__c();
        booking.Name = con.Account.Name + ' '+ String.valueOf(con.StartDate);
        booking.Account__c = con.AccountId;
        booking.Cleaning_Date__c = con.StartDate;
        booking.Contract__c = con.id;
        booking.Discount__c = con.Discount__c != null ? con.Discount__c:0;
        booking.Number_of_cleaners__c = con.Number_of_cleaners__c != null ? con.Number_of_cleaners__c : 0;
        booking.Amount_per_cleaner__c = Integer.valueOf(Label.Standard_Price_in_USD) * ((100-booking.Discount__c)/100);
        booking.Amount_Payable__c = booking.Amount_per_cleaner__c*booking.Number_of_cleaners__c;
        insertBooking(JSON.serialize(booking));
    }
    
    @future
    public static void insertBooking(String booking){
        Booking__c bookingRec = (Booking__c)JSON.deserialize(booking,Booking__c.class);
        system.debug('bookingRec-=-=-='+bookingRec);
        insert bookingRec;
        Notification__c notification = new Notification__c();
        List<Job_Card__c> jobs = createJobCard(bookingRec);
        if(jobs.size() == 0){
            bookingRec.Message__c = 'Resources not available for the day. Please inform the customer.';
            notification.Booking__c = bookingRec.id;
            update bookingRec;
            insert notification;
        }
        else{
            if(bookingRec.Number_of_cleaners__c > jobs.size()){
                bookingRec.Message__c = Integer.valueOf(bookingRec.Number_of_cleaners__c - jobs.size()) + ' ' + 'Resources not available for the day. Please inform the customer.';
                notification.Booking__c = bookingRec.id;
                update bookingRec;
                insert notification;
            }
            insert jobs;
        }
    }
    
    public static List<Job_Card__c> createJobCard(Booking__c booking){
        List<Job_Card__c> jobcards = new List<Job_Card__c>();
        List<Employee__c> employeeList = new List<Employee__c>();
        if(booking.Home_Office__c == 'Home'){
            employeeList = [select id, (select id from Job_Cards__r where Cleaning_Date__c =: booking.Cleaning_Date__c) from Employee__c];
        }
        else{
            employeeList = [select id, (select id from Job_Cards__r where Cleaning_Date__c =: booking.Cleaning_Date__c) from Employee__c where  Company__c!=null order by   Company__c];
        }
        Integer numberOfJobs = 0;
        for(Employee__c employee : employeeList){
            if(employee.Job_Cards__r.size() < 1){
                Job_Card__c jobCard = new Job_Card__c();
                numberOfJobs++;
                jobCard.Name = booking.Name + ' ' + numberOfJobs;
                jobCard.Booking__c = booking.id;
                jobCard.Employee__c = employee.id;
                jobCard.Amount__c = booking.Amount_per_cleaner__c;
                jobcards.add(jobcard);
            }
            if(numberOfJobs == booking.Number_of_cleaners__c)
            break;
        }
        return jobcards;
    }

}