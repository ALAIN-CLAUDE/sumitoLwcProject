/**
* Apex Enterprise Design Patterns
* Selector Layer for SBQQ__QuoteLine__c object
*
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2022-03-18
*/

public class QuoteLinesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return SBQQ__QuoteLine__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            SBQQ__QuoteLine__c.Id,
            SBQQ__QuoteLine__c.SBQQ__NetPrice__c,
            SBQQ__QuoteLine__c.SBQQ__Number__c,
            SBQQ__QuoteLine__c.SBQQ__Product__c,
            SBQQ__QuoteLine__c.SBQQ__Quantity__c,
            SBQQ__QuoteLine__c.SBQQ__Quote__c,
            SBQQ__QuoteLine__c.Rejection_Reason__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    public List<SBQQ__QuoteLine__c> selectById(Set<Id> idSet) {
        return (List<SBQQ__QuoteLine__c>) Database.query(
            newQueryFactory()
            .selectField('SBQQ__Quote__r.SBQQ__Status__c')
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }

    public List<SBQQ__QuoteLine__c> selectByQuoteId(Set<Id> idSet) {
        return (List<SBQQ__QuoteLine__c>) Database.query(
            newQueryFactory()
            .selectField('SBQQ__Quote__r.SBQQ__Status__c')
            .setCondition('SBQQ__Quote__c IN: idSet')
            .toSOQL()
        );
    }

    public List<SBQQ__QuoteLine__c> selectByIdAndNullRejectionReason(Set<Id> idSet) {
        return (List<SBQQ__QuoteLine__c>) Database.query(
            newQueryFactory()
            .selectField('SBQQ__Quote__r.SBQQ__Status__c')
            .setCondition('Id IN: idSet AND Rejection_Reason__c = null')
            .toSOQL()
        );
    }

    public List<SBQQ__QuoteLine__c> selectByQuoteIdAndNullRejectionReason(Set<Id> idSet) {
        String sapUpdateFlag = 'U';
        
        return (List<SBQQ__QuoteLine__c>) Database.query(
            newQueryFactory()
            .setCondition('SBQQ__Quote__c IN: idSet AND SAP_Update_Flag__c =: sapUpdateFlag')
            .toSOQL()
        );
    }
    
    public List<SBQQ__QuoteLine__c> selectByQuoteIdAndNumber(Set<Id> idSet, Set<Integer> quoteLineNums){
        return (List<SBQQ__QuoteLine__c>) Database.query(
            newQueryFactory()
            .setCondition('SBQQ__Quote__c IN: idSet AND SBQQ__Number__c IN: quoteLineNums')
            .toSOQL()
        );
    } 
}