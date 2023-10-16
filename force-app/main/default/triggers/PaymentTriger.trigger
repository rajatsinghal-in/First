trigger PaymentTriger on blng__Payment__c (after insert) {
    TriggerFramework.executeHandler(new PaymentTriggerHandler());
}