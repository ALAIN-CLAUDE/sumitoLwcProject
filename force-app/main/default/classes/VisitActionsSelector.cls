/**
* Apex Enterprise Design Patterns
* Selector Layer for Visit_Action__c object
*
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2021-10-13
*/

public class VisitActionsSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Visit_Action__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Visit_Action__c.Id,
            Visit_Action__c.Contact_Person__c,
            Visit_Action__c.CreatedById,
            Visit_Action__c.Date_of_Visit__c,
            Visit_Action__c.Meeting_Notes__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    public List<Visit_Action__c> selectById(Set<Id> idSet) {
        return (List<Visit_Action__c>) Database.query(
            newQueryFactory()
            .selectField('Contact_Person__r.Name')
            .selectField('CreatedBy.Email')
            .selectField('CreatedBy.MobilePhone')
            .selectField('CreatedBy.Name')
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }
}