({
	handleInit : function(component) {
		var action = component.get("c.getRecordTypeName");
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;

        action.setParams({
            "recordTypeId": recordTypeId,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue){
                    var recordTypeName = response.getReturnValue();
                    component.set("v.accRcrdTypeName", recordTypeName);
                    this.getPicklistVals(component);
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

	handleSaveRecord : function(component) {
		var action = component.get("c.saveAccount");
        var account = component.get("v.account");
        var recTypeName = component.get("v.accRcrdTypeName");
        var recordTypeId = component.get("v.pageReference").state.recordTypeId;
		component.set("v.showSpinner", true);
        
        action.setParams({
            "account": account,
            "recordTypeId": recordTypeId,
            "recTypeName": recTypeName
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue){
                    this.showToast('Success!', 'Account saved successfully', 'success');
                    var homeEvt = $A.get("e.force:navigateToObjectHome");
                    
                    homeEvt.setParams({
                        "scope": "Account"
                    });
                    
                    homeEvt.fire();
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
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
	},
	
    getPicklistVals : function(component){
        var action = component.get("c.getPicklistValues");
        var selectOptionFields = component.get("v.selectOptionFields");
        var accRcrdTypeName = component.get("v.accRcrdTypeName");

        action.setParams({
            "picklistFieldNameListP": selectOptionFields
        });

        action.setCallback(this, function(response) {
        	var state = response.getState();
            
            if (state === "SUCCESS") {
                if(response.getReturnValue){
                    var responseValue = response.getReturnValue();
                    // Set Picklist Values
                    // No Index required because we remove the item from the array after each iteration
                    for(var i = 0; i < selectOptionFields.length; i++){
                      	var recTypeFieldOpts;
                        var fieldName = '';

                        if(accRcrdTypeName == 'International Business'){
                            fieldName = 'v.options_' + selectOptionFields[i] + 'IB';
                            recTypeFieldOpts = component.get(fieldName);
                        } else if(accRcrdTypeName == 'Domestic'){
                            fieldName = 'v.options_' + selectOptionFields[i] + 'Dom';
                            recTypeFieldOpts = component.get(fieldName);
                        } else if(accRcrdTypeName == 'Fleet'){
                            fieldName = 'v.options_' + selectOptionFields[i] + 'Flt';
                            recTypeFieldOpts = component.get(fieldName);
                        } else if(accRcrdTypeName == 'Group'){
                            fieldName = 'v.options_' + selectOptionFields[i] + 'Grp';
                            recTypeFieldOpts = component.get(fieldName);
                        }

                        if(recTypeFieldOpts && responseValue[selectOptionFields[i]] && !String(responseValue[selectOptionFields[i]]).includes('Values')){
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
            label: "--- None ---",
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