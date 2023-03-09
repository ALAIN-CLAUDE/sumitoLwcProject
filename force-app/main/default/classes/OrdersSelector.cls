/**
* Apex Enterprise Design Patterns
* Selector Layer for Order object
*
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2022-03-18
*/

public class OrdersSelector extends fflib_SObjectSelector {
    
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Order.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Order.Id,
            Order.SAP_Order_Number__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    public List<Order> selectById(Set<Id> idSet) {
        return (List<Order>) Database.query(
            newQueryFactory()
            .selectField('Associated_Location__r.Location_Delivery_Plant__c')
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }
}