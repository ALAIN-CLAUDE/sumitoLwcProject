({
	handleInit : function(component) {
		var action = component.get("c.getAccountDetails");
        var accountId = component.get("v.accountId");
        
        action.setParams({
            "accountId": accountId,
        });

        action.setCallback(this, function (response) {
             var state = response.getState();

            if (state === "SUCCESS") {
                if(response.getReturnValue){
                	
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Error!", errors[0].message, "error");
                    }
                } else {
                    this.showToast("Error!", "unknown error", "error");
                }
            }
        });
        $A.enqueueAction(action);
	},

    showToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
        });

        toastEvent.fire();
    }
})