trigger QuoteLineTrigger on SBQQ__QuoteLine__c (before delete, after delete) {
    if(Trigger.isBefore){
        QuoteLineTriggerHelper.handleBeforeDelete(trigger.old);
    } 
}