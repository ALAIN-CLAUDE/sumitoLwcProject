({
	handleInit : function(component) {
		var action = component.get("c.getManufacturers");
        component.set("v.isLoadingOpen", true);
        
        action.setParams({
        });

        action.setCallback(this, function (response) {
             var state = response.getState();

            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                	component.set("v.manufacturers", response.getReturnValue());
                    console.log('manufaturers: ',response.getReturnValue() )
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
            component.set("v.isLoadingOpen", false);
        });
        $A.enqueueAction(action);
	},

    handleManfctrChanged : function(component) {
		var action = component.get("c.getTypes");
        var manufacturer = component.find("manufacturer").get("v.value");
        var blankArray = [];
        component.set("v.types", blankArray);
        component.set("v.modelYears", blankArray);
        component.set("v.models", blankArray);
        component.set("v.isSearchDisabled", true);
        component.set("v.isLoadingOpen", true);

        action.setParams({
            "manufacturer": manufacturer
        });

        action.setCallback(this, function (response) {
             var state = response.getState();

            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                	component.set("v.types", response.getReturnValue());
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
            component.set("v.isLoadingOpen", false);
        });
        
        if(manufacturer){
            $A.enqueueAction(action);
        }
	},

    handleTypeChanged : function(component) {
		var action = component.get("c.getModelYears");
        var manufacturer = component.find("manufacturer").get("v.value");
        var type = component.find("type").get("v.value");
        var blankArray = [];
        component.set("v.modelYears", blankArray);
        component.set("v.models", blankArray);
        component.set("v.isSearchDisabled", true);
        component.set("v.isLoadingOpen", true);
        
        action.setParams({
            "manufacturer" : manufacturer,
            "type": type
        });

        action.setCallback(this, function (response) {
             var state = response.getState();

            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                	component.set("v.modelYears", response.getReturnValue());
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
            component.set("v.isLoadingOpen", false);
        });
        
        if(manufacturer){
            $A.enqueueAction(action);
        }
	},

    handleModelYearChanged : function(component) {
		var action = component.get("c.getModels");
        var manufacturer = component.find("manufacturer").get("v.value");
        var type = component.find("type").get("v.value");
        var modelYear = component.find("modelYear").get("v.value");
        var blankArray = [];
        component.set("v.models", blankArray);
        component.set("v.isSearchDisabled", true);
        component.set("v.isLoadingOpen", true);
        
        action.setParams({
            "manufacturer" : manufacturer,
            "type": type,
            "modelYear" : modelYear
        });

        action.setCallback(this, function (response) {
             var state = response.getState();

            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                	component.set("v.models", response.getReturnValue());
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
            component.set("v.isLoadingOpen", false);
        });
        
        if(manufacturer){
            $A.enqueueAction(action);
        }
	},
    
    handleSearch : function(component) {
		var action = component.get("c.getVehicles");
        var manufacturer = component.find("manufacturer").get("v.value");
        var type = component.find("type").get("v.value");
        var modelYear = component.find("modelYear").get("v.value");
        var model = component.find("model").get("v.value");
        component.set("v.isLoadingOpen", true);

        action.setParams({
            "manufacturer" : manufacturer,
            "type" : type,
            "modelYear" : modelYear,
            "model" : model
        });

        action.setCallback(this, function (response) {
             var state = response.getState();

            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                	component.set("v.vehicles", response.getReturnValue());
                    this.handleSearchProducts(component);
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
    
    handleSearchProducts : function(component) {
		var action = component.get("c.getProducts");
        var vehicles = component.get("v.vehicles");
		var frntTyreSize = vehicles[0].Tyre_Size_Front__c;
        var rearTyreSize = vehicles[0].Tyre_Size_Rear__c;

        action.setParams({
            "frntTyreSize" : frntTyreSize,
            "rearTyreSize" : rearTyreSize
        });

        action.setCallback(this, function (response) {
             var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()){
                	component.set("v.products", response.getReturnValue());
                    component.set("v.isOpen", false);
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
            component.set("v.isLoadingOpen", false);
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