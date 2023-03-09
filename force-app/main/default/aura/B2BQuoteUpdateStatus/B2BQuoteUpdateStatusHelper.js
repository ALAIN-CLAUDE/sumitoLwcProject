({
    handleInit : function(component) {
		var action = component.get("c.UpdateQuoteStatus");
        var quoteId = component.get("v.recordId");
        action.setParams({
            "quoteId": quoteId,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state = "SUCCESS") {
                var responseData = response.getReturnValue();
                
                if(response.getReturnValue() != 'Order Placed Successfully.'){
                    this.showToast("error","Quote Update Error!", response.getReturnValue());
                } else {
                    this.showToast("success","Quote Updated!", response.getReturnValue());
                }
                
                setTimeout(() => {$A.get("e.force:closeQuickAction").fire(); }, 5000);
            } else if (state === "ERROR") {
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("error","Update Quote Error!",errors[0].message);
                        setTimeout(() => {$A.get("e.force:closeQuickAction").fire(); }, 5000);
                    }
                } else {
                    this.showToast("error","Update Quote Error!","Consumer Bureau unknown error");
                    setTimeout(() => {$A.get("e.force:closeQuickAction").fire(); }, 5000);
                }
            }        
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire(); 
    }
})