({
	getInfo : function(component, event, helper) {
		var acc = component.get("c.getAccountCreditLimits");

        acc.setCallback(this, function(data){
            if(data.getReturnValue()){
                component.set("v.account", data.getReturnValue());
                component.set("v.isLoaded", true);
                var account = data.getReturnValue();
                
                if(account){
                    if(account.Block_Central_Order__c || account.Block_Central_Billing__c || account.Block_Central_Delivery__c){
                        component.set("v.isAccountBlocked", true);
                    }
                } else {
                    component.set("v.isLoaded", false);
                }
            }
        });
        $A.enqueueAction(acc);
	}
})