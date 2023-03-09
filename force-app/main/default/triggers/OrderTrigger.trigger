trigger OrderTrigger on Order (before update) {
    if(trigger.isBefore && trigger.isUpdate){
        OrderTriggerHelper.handleBeforeUpdate(trigger.new, trigger.oldMap);
    }
}