trigger AssociatedLocationTrigger on AssociatedLocation (after insert) {
	if(trigger.isAfter && trigger.isInsert){
        AssociatedLocationTriggerHelper.handleAfterInsert(trigger.new);
    }
}