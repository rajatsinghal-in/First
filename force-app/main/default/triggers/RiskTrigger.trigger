trigger RiskTrigger on Risk__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
	OTriggerHandler.executeHandler(new RiskTriggerHandler());
}