public class EmployeeTriggerHandler implements TriggerHandlerI {

    public void beforeInsert(){
        EmployeeBL.beforeInsert(Trigger.new);
    }
    
    public void afterInsert(){}
    
    public void beforeUpdate(){}
    
    public void afterUpdate(){}
    
    public void beforeDelete(){}
    
    public void afterDelete(){}


}