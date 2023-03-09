({
	doInit : function(component, event, helper) {
		helper.handleInit(component);
	},

    manfctrChanged : function(component, event, helper) {
    	helper.handleManfctrChanged(component);
    },

    typeChanged : function(component, event, helper) {
    	helper.handleTypeChanged(component);
    },

    modelYearChanged : function(component, event, helper) {
    	helper.handleModelYearChanged(component);
    },

    modelChanged : function(component, event, helper) {
        var model = component.find("model").get("v.value");

        if(model){
            component.set("v.isSearchDisabled", false);
        }
    },

    closeModel : function(component, event, helper) {
    	component.set("v.isOpen", false);
    },

    search : function(component, event, helper) {
    	helper.handleSearch(component);
    }
})