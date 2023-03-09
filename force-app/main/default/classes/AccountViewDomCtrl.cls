/**
 * @description       : Controller class for AccountViewDom aura component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za 
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class AccountViewDomCtrl {
	@AuraEnabled
    public static Account getAccount(String accId){
        return new AccountsSelector().selectById(new Set<Id>{accId})[0];
    }

    @AuraEnabled
    public static Map<String, String> getPicklistValues(List<String> picklistFieldNameListP){
        Map<String, String> returnMap = new Map<String, String>();

        //Get Select Options
        for(String picklistFieldName : picklistFieldNameListP){
            String allOpts = '';
            String allOptsValues = '';

            Schema.sObjectType objType = Account.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

            map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

            list <Schema.PicklistEntry> values = fieldMap.get(picklistFieldName).getDescribe().getPickListValues();

            for (Schema.PicklistEntry a: values) {
                allOpts += a.getLabel() + ';';
                allOptsValues += a.getValue() + ';';
            }
            
            allOptsValues = allOptsValues.removeEnd(';');
            allOpts = allOpts.removeEnd(';');
            returnMap.put(picklistFieldName, allOpts);
            returnMap.put(picklistFieldName + 'Values', allOptsValues);
        }
        
        return returnMap;
    }
}