({
    fireComponentEvent : function(component, event) {
        console.log('before fire');
        var compEvent = component.getEvent("RiskComponentEvent");
        compEvent.setParams({
            "message" : "Hello " +
            "World!" });
        compEvent.fire();
    },
    
    fireApplicationEvent : function(cmp, event,helper) { 
        //Get the event using event name. 
        var appEvent = $A.get("e.c:RiskApplicationEvent"); 
        //Set event attribute value
        appEvent.setParams({"message" : "Welcome "}); 
        appEvent.fire(); 
    }
})