/**
* Apex Enterprise Design Patterns
* Selector Layer for Stock__c object
*
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2021-07-18
*/

public class StocksSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Stock__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Stock__c.Id,
                Stock__c.National_Stock__c,
                Stock__c.Plant__c,
                Stock__c.Product__c,
                Stock__c.Quantity__c,
                Stock__c.Storage_Location__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    public List<Stock__c> selectByProductId(Set<Id> idSet) {
        return (List<Stock__c>) Database.query(
            newQueryFactory()
            .selectField('Product__r.Family')
            .selectField('Product__r.Milage_Warrentee__c')
            .selectField('Product__r.Name')
            .selectField('Product__r.Pattern_Desc__c')
            .selectField('Product__r.ProductCode')
            .selectField('Product__r.RIM_Size__c')
            .selectField('Product__r.Tyre_Insurance__c')
            .setCondition('Product__c IN: idSet')
            .toSOQL()
        );
    }
    public List<Stock__c> selectByProductIdAndPlant(Set<Id> idSet, Set<String> plants) {
        return (List<Stock__c>) Database.query(
            newQueryFactory()
            .selectField('Product__r.Family')
            .selectField('Product__r.Milage_Warrentee__c')
            .selectField('Product__r.Name')
            .selectField('Product__r.Pattern_Desc__c')
            .selectField('Product__r.ProductCode')
            .selectField('Product__r.RIM_Size__c')
            .selectField('Product__r.Tyre_Insurance__c')
            .setCondition('Product__c IN: idSet AND Plant__c IN: plants')
            .toSOQL()
        );
    }
}