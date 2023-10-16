public class RiskBatch implements Database.Batchable<Risk__c>, Database.stateful, Database.allowscallouts {
	
    Integer count = 0;
    
    public List<Risk__c> start(Database.BatchableContext BC){
        List<Risk__c> riskList = new List<Risk__c>();
        riskList = [Select id, Status__c from Risk__c];
        return riskList;
    }
    public void execute(Database.BatchableContext BC, List<Risk__c> scope){
        for(Risk__c risk : scope){
            risk.Status__c = 'Closed';
            count++; 
        }
        Database.update(scope,false);
    }
    public void finish(Database.BatchableContext BC){
        Risk__c risk = new Risk__c();
        risk.Id = 'a2X5g000000aQYy';
        risk.Stateful_count__c = count;
        update risk;
    }
}