/**
* Apex Enterprise Design Patterns
* Selector Layer for Account Documents object
* 
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2021-08-30
*/

public class AccountDocumentsSelector extends fflib_SObjectSelector {
//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Account_Document__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Account_Document__c.Id,
            Account_Document__c.Status__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    public List<Account_Document__c> selectById(Set<Id> idSet) {
        return (List<Account_Document__c>) Database.query(
            newQueryFactory()
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }
}