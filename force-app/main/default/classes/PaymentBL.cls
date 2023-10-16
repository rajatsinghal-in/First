public class PaymentBL{
    
    public static void afterinsert(List< blng__Payment__c > paymentList){
        updateAccount(paymentList);
    }
    
    public static void updateAccount(List< blng__Payment__c > paymentList){
        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Integer> accountIdMapByAmount = new Map<Id, Integer>();
        
        for(blng__Payment__c payment: paymentList){
            if(payment.blng__Amount__c != null){
                if(!accountIdMapByAmount.containsKey(payment.blng__Account__c)){
                    accountIdMapByAmount.put(payment.blng__Account__c, Integer.valueOf(payment.blng__Amount__c));
                }
                else{
                    Integer sum = accountIdMapByAmount.get(payment.blng__Account__c) + Integer.valueOf(payment.blng__Amount__c);
                    accountIdMapByAmount.put(payment.blng__Account__c, sum);
                }
            }
        }
        
        for(Account acc : [select id, Amount_Paid__c from Account where id IN: accountIdMapByAmount.keyset()]){
            acc.Amount_Paid__c = acc.Amount_Paid__c!=null?acc.Amount_Paid__c:0;
            acc.Amount_Paid__c += accountIdMapByAmount.get(acc.Id);
            accountsToUpdate.add(acc);
        }
        
        if (accountsToUpdate.size()>0)
        update accountsToUpdate;
    }

}