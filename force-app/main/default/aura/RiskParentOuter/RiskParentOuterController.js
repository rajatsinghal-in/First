({
	callChildMethod : function(component, event, helper) {
        var objCompB = component.find('innerparent');
        objCompB.sampleMethod("Param1", "Param2");
    },
    handleCmpEvent: function(component, event) {
        console.log('inside handler');
        var message = event.getParam("message");
        component.set("v.messageTempp", message);
    }
})