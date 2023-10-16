public class OTriggerHandler {
    
    public static void executeHandler(OTriggerInterface handler){
        if(Trigger.isBefore && Trigger.isInsert){
            handler.beforeinsert();
        }
        if(Trigger.isAfter && Trigger.isInsert){
            handler.afterinsert();
        }
        if(Trigger.isBefore && Trigger.isUpdate){
            handler.beforeupdate();
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            handler.afterupdate();
        }
        
    }
    
}