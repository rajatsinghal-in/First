public class PaymentTriggerHandler implements TriggerHandlerI {

    public void beforeInsert(){}
    
    public void afterInsert(){
        PaymentBL.afterinsert(Trigger.new);
    }
    
    public void beforeUpdate(){}
    
    public void afterUpdate(){}
    
    public void beforeDelete(){}
    
    public void afterDelete(){}


}