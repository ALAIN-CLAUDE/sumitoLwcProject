({
	handleSaveRecord : function(component) {
		var action = component.get("c.submitForApproval");
        var accountId = component.get("v.recordId");
        var comments = component.get("v.comments");

        action.setParams({
            "accId": accountId,
            "comments": comments
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                this.showToast('Success!', 'Account submitted for approval successfully', 'success');
                setTimeout(function() {location.reload();}, 2000);
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