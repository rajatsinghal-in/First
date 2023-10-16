({
	calledFromOuterParent : function(cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.param1;
            var param2 = params.param2;
            console.log('param 1-=-='+param1);
            console.log('param 2-=-='+param2);
        }
    },
    
    handleCmpEvent: function(component, event) {
        console.log('inside handler');
        var message = event.getParam("message");
        component.set("v.messageTemp", message);
        event.stoppropogation();
    }
})