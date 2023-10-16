@RestResource(urlMapping='/Account/*')
global with sharing class englishQuotes {

    /*@HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account;
    }*/
  
    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String quot = Quotess__c.getValues('quote 2').Quote__c;
        return quot;
    }
  
    @HttpPost
    global static String doPost(String name) {
        Quotess__c quotess = new Quotess__c();
        quotess.Name = 'quote 2';
        quotess.Number__c = 2;
        quotess.Quote__c = name;
        insert quotess;
        return 'Input Success';
    }
}