({
	handleInit : function(component) {
		var action = component.get("c.getAccountCreditLimits");


        action.setCallback(this, function (response) {
             var state = response.getState();

            if (state === "SUCCESS") {
                if(response.getReturnValue){
                	component.set("v.account", response.getReturnValue());

                    var account = response.getReturnValue();
                    var creditLimitAvailablePrc = 100 - response.getReturnValue().Credit_Limit_used__c;
                    component.set("v.creditLimitAvailablePrc", creditLimitAvailablePrc);
                    component.set("v.isLoaded", true);

                    if(account){
                        if(account.Block_Central_Order__c || account.Block_Central_Billing__c || account.Block_Central_Delivery__c){
                            component.set("v.isAccountBlocked", true);
                        }
                    }
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.isLoaded", true);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Error!", errors[0].message, "error");
                        console.log(errors[0].message);
                    }
                } else {
                    this.showToast("Error!", "unknown error", "error");
                }
            }
        });
        $A.enqueueAction(action);
	}
})