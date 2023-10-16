({
	handleCmpEvent: function(component, event) {
        console.log('inside handler');
        var message = event.getParam("message");
        component.set("v.messageTemp", message);
    },
    
    handleapplicationevent : function(cmp, event) { 
        //Get the event message attribute
        var message = event.getParam("message"); 
        //Set the handler attributes based on event data 
        cmp.set("v.eventMessage", message + 'Biswajeet');         
    }
})