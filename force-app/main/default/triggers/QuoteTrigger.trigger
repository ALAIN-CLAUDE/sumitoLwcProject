trigger QuoteTrigger on SBQQ__Quote__c (before insert, before Update) {
    Map<String, Org_Variables__mdt> orgVariables = Org_Variables__mdt.getAll();

    if(orgVariables.get('Run_All_Triggers').Checkbox_Value__c){
        if(trigger.isInsert){
            QuoteTriggerHelper.handleAfterInsert(trigger.new);
        } else if(trigger.isUpdate){
            QuoteTriggerHelper.handleAfterUpdate(trigger.new, trigger.oldMap);
        }
    }
}