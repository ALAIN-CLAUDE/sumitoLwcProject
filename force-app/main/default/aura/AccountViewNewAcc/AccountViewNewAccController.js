({
    doInit : function(component, event, helper) {
        helper.handleInit(component);
    },
    
    cancelDialog : function(component, helper) {
        var homeEvt = $A.get("e.force:navigateToObjectHome");

        homeEvt.setParams({
            "scope": "Account"
        });

        homeEvt.fire();
    },
    
    saveRecord : function(component, event, helper) {
        var account = component.get("v.account");
        var accRcrdTypeName = component.get("v.accRcrdTypeName");

        if((accRcrdTypeName == 'Domestic' || accRcrdTypeName == 'International Business') && 
           (account.Name == '' || account.Trading_As_Name__c == '' || account.Delivering_Plant__c == '' || 
            account.Distribution_Channel__c == '' || account.Currency_to_adopt__c == '' ||
            account.Group_4__c == '' || account.Group_5__c == '' || account.Delivery_Priority__c == '' ||
            account.Payment_terms__c == '' || !account.Price_group__c)){
            helper.showToast('Error!', 'Please capture all required fields.', 'error');
        } else if((accRcrdTypeName == 'Fleet') && (!account.Qty_Vehicles__c || !account.On_Road__c || !account.Route__c || !account.Average_Monthly_Km__c || !account.Name || !account.Main_Cargo__c)){
            helper.showToast('Error!', 'Please capture all required fields.', 'error');
        } else if((accRcrdTypeName == 'Group') && (!account.Name || !account.Phone || !account.Currency_to_adopt__c)){
            helper.showToast('Error!', 'Please capture all required fields.', 'error');
        } else {
            helper.handleSaveRecord(component);
        }
    }
})