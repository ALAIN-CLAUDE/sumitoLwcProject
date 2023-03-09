/**
* Apex Enterprise Design Patterns
* Selector Layer for User object
*
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2021-07-18
*/

public class UsersSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return User.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            User.Id,
            User.Account_Name__c,
            User.ContactId,
            User.Customer_Group__c,
            User.Email,
            User.FirstName,
            User.LastLoginDate,
            User.LastName,
            User.Name,
            User.Region__c,
            User.Sales_District__c,
            User.Sales_Group__c,
            User.Sales_Office__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    public List<User> selectById(Set<Id> idSet) {
        return (List<User>) Database.query(
            newQueryFactory()
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }
}