/**
 * @description       : Controller class for AccountViewNewAcc aura component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class AccountViewNewAccCtrl {
	@AuraEnabled
    public static String getRecordTypeName(String recordTypeId){
        return Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(recordTypeId).getName();
    }

    @AuraEnabled
    public static void saveAccount(Account account, String recordTypeId, String recTypeName){
        try{
            account.RecordTypeId = recordTypeId;

            if(recTypeName.equalsIgnoreCase('Domestic')){
                account.Country__c = 'South Africa';
            }

            insert account;
        } catch(Exception exc){
            throw new AuraHandledException(String.valueOf(exc));
        }
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