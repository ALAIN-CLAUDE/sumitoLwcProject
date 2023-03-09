trigger OrderItemTrigger on OrderItem (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            OrderItemTriggerHelper.handleBeforeInsert(trigger.new);
        } else if(trigger.isUpdate){
            OrderItemTriggerHelper.handleBeforeUpdate(trigger.new, trigger.oldMap);
        }
    }
}