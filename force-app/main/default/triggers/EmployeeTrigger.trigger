trigger EmployeeTrigger on Employee__c (before insert) {
    TriggerFramework.executeHandler(new EmployeeTriggerHandler());
}