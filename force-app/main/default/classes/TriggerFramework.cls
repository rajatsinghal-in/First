public with sharing class TriggerFramework 
{    
    
    public static void executeHandler(TriggerHandlerI handler) 
    {
        if(Trigger.isBefore && Trigger.isInsert)
            handler.beforeInsert();
        else if (Trigger.isAfter && Trigger.isInsert) 
            handler.afterInsert();
        else if (Trigger.isBefore && Trigger.isUpdate)
            handler.beforeUpdate();
        else if (Trigger.isAfter && Trigger.isUpdate)
            handler.afterUpdate();
        else if (Trigger.isBefore && Trigger.isDelete)
            handler.beforeDelete();
        else if (Trigger.isAfter && Trigger.isDelete)
            handler.afterDelete();
    }
    
    
}