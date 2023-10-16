public class getJobCards{
    
    @AuraEnabled
    public static List<jobCardWrapper> getJobCardDetails(String userId, Boolean assigned){
        List<jobCardWrapper> jobCards = new List<jobCardWrapper>();
        List<Job_Card__c> jobCardList = new List<Job_Card__c>();
        if(assigned == true){
            jobCardList = [select id, Booking__c, Booking__r.Name, Cleaning_Date__c, Completed__c, Employee__c, Address__c from Job_Card__c where Employee__r.User__c =: userId];
        }
        else{
            jobCardList = [select id, Booking__c, Booking__r.Name, Cleaning_Date__c, Completed__c, Employee__c, Address__c from Job_Card__c where Employee__r.User__c =: userId and Cleaning_Date__c<TODAY and Completed__c =false];
        }
        for(Job_Card__c jobCard : jobCardList){
            jobCards.add(new jobCardWrapper(jobCard));
        }
        return jobCards;
        //return JSON.serialize(jobCards);
    }
    
    public class jobCardWrapper{
        @AuraEnabled
        public String bookingName{get; set;}        
        @AuraEnabled
        public Date bookingDate{get; set;}
        @AuraEnabled
        public String bookingAddress{get; set;}
        @AuraEnabled
        public Id bookingId{get; set;}
        @AuraEnabled
        public String bookingLink{get; set;}
    
        public jobCardWrapper(Job_Card__c jobCard){
            this.bookingName = jobCard.Booking__r.Name;
            this.bookingDate = jobCard.Cleaning_Date__c;
            this.bookingAddress = jobCard.Address__c;
            this.bookingId = jobCard.Id;
            this.bookingLink = '/' + jobCard.Id;
        }
    }
    
    @AuraEnabled
    public static void updateJobCards(String jobCardIdString){
        List<Id> jobCardIds = (List<Id>)JSON.deserialize(jobCardIdString, List<Id>.class);
        List<Job_Card__c> jobCardList = new List<Job_Card__c>();
        for(Id jobId : jobCardIds){
            Job_Card__c jobCard = new Job_Card__c();
            jobCard.Id = jobId;
            jobCard.Completed__c = true;
            jobCardList.add(jobCard);
        }
        update jobCardList;
    }
   
}