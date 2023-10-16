public class RiskTriggerHandler implements OTriggerInterface{
    public void beforeinsert(){
        
    }
    public void  beforeupdate(){
        RiskTriggerHandler.updateRisk(Trigger.new, (Map<Id, Risk__c>)Trigger.newMap);
    }
    public void  afterinsert(){
        
    }
    public void  afterupdate(){
        
    }
    public void  afterdelete(){
        
    }
    public void  afterundelete(){
        
    }
    
    public static void updateRisk(List<Risk__c> newRiskList, Map<Id, Risk__c> newMap){
        for(Risk__c risk : newRiskList){
            risk.Closure_Date__c = system.today();
        }
    }
}