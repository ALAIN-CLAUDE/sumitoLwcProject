/**
* Apex Enterprise Design Patterns
* Selector Layer for SBQQ__Quote__c object
*
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2021-07-18
*/

public class QuotesSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return SBQQ__Quote__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            SBQQ__Quote__c.Id,
            SBQQ__Quote__c.Delivering_Plant__c,
            SBQQ__Quote__c.Max_Line_Item_Number__c,
            SBQQ__Quote__c.Name,
            SBQQ__Quote__c.SAP_Order_Number__c,
            SBQQ__Quote__c.SBQQ__Account__c,
            SBQQ__Quote__c.SBQQ__ExpirationDate__c,
            SBQQ__Quote__c.SBQQ__PriceBook__c,
            SBQQ__Quote__c.SBQQ__PrimaryContact__c,
            SBQQ__Quote__c.SBQQ__SalesRep__c,
            SBQQ__Quote__c.SBQQ__Status__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    public List<SBQQ__Quote__c> selectById(Set<Id> idSet) {
        return (List<SBQQ__Quote__c>) Database.query(
            newQueryFactory()
            .selectField('Associated_Location__r.Location_Delivery_Plant__c')
            .selectField('Associated_Location__r.LocationId')
            .selectField('SBQQ__Account__r.Delivering_Plant__c')
            .selectField('SBQQ__Account__r.Name')
            .selectField('SBQQ__Account__r.SAP_Customer_Code__c')
            .selectField('SBQQ__PrimaryContact__r.Email')
            .selectField('SBQQ__PrimaryContact__r.Name')
            .selectField('SBQQ__SalesRep__r.Email')
            .selectField('SBQQ__SalesRep__r.Name')
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }
}