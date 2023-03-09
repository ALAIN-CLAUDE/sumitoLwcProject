trigger OrderItemDetailTrigger on Order_Item_Detail__c (after insert, after update) {
	if(trigger.isAfter){
        if(trigger.isInsert){
            OrderItemDetailTriggerHelper.handleAfterInsert(trigger.new);
        } else if(trigger.isUpdate){
            OrderItemDetailTriggerHelper.handleAfterUpdate(trigger.new, trigger.oldMap);
        }
    }
}