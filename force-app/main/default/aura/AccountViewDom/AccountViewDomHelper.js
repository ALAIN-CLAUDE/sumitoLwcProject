({
	getAccountDetails : function(component) {
		var action = component.get("c.getAccount");
        var accountId = component.get("v.recordId");

        action.setParams({
            "accId": accountId,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                if(response.getReturnValue){
                    var account = response.getReturnValue();
                	component.set("v.account", account);

                    if(account){
                        this.getPicklistVals(component);

                        if(account.CreatedDate){
                            component.set("v.createdDate", this.convertDateTime(account.CreatedDate));
                        }

                        if(account.LastModifiedDate){
                            component.set("v.lastModifiedDate", this.convertDateTime(account.LastModifiedDate ));
                        }
                    }
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

    getPicklistVals : function(component){
        var action = component.get("c.getPicklistValues");
        var selectOptionFields = component.get("v.selectOptionFields");

        action.setParams({
            "picklistFieldNameListP": selectOptionFields
        });

        action.setCallback(this, function(response) {
        	var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue){
                    var responseValue = response.getReturnValue();

                    for(var i = 0; i < selectOptionFields.length; i++){
                        var fieldName = 'v.options_' + selectOptionFields[i] + 'Dom';
                      	var recTypeFieldOpts = component.get(fieldName);

                        if(responseValue[selectOptionFields[i]] && !String(responseValue[selectOptionFields[i]]).includes('Values')){
                        	var options = responseValue[selectOptionFields[i]].split(";");
                            var optionsValues = responseValue[selectOptionFields[i] + 'Values'].split(";");
                            var attributeId = "v.options_" + selectOptionFields[i];
                            component.set(attributeId, this.convertArrayToSelectOptions(options, optionsValues, recTypeFieldOpts));
                        }
                    }
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

    convertArrayToSelectOptions: function(optionsArray, optionsValuesArray, recTypeFieldOpts) {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "",
            value: ""
        });

        for (var i = 0; i < optionsArray.length; i++) {
            if(recTypeFieldOpts.includes(optionsArray[i])){
                opts.push({
                    class: "optionClass",
                    label: optionsArray[i],
                    value: optionsValuesArray[i]
                });
            }
        }
        return opts;
    },

    convertDateTime : function(dateTimeString){
        const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        const d = new Date(dateTimeString);
        var year = d.getFullYear();
        var month = d.getMonth();
        var day = d.getDate();
        var hours = d.getHours();
        var minutes = d.getMinutes();

        if(String(hours).length == 1){
            hours = '0' + hours;
        }

        if(String(minutes).length == 1){
            minutes = '0' + minutes;
        }

        var dateTimeVal = day + ' ' + months[month] + ' ' + year + ' ' + hours + ':' + minutes;
        return dateTimeVal;
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