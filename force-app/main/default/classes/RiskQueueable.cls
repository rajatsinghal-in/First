public class RiskQueueable implements Queueable, Database.allowscallouts{
	
    List<Risk__c> riskList = new List<Risk__c>();
    
    public RiskQueueable(){
        this.riskList = [Select id, Status__c from Risk__c];
    }
    
    public void execute(QueueableContext context){
        if(this.riskList.size()>0){
            for(Risk__c risk : riskList){
                risk.status__c = 'In Progress';
            }
        }
        Database.update(riskList,false);
        system.debug('test commit');
    }
}