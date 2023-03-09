/**
 * @description       : Test class for AccountViewNewAccCtrl apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class AccountViewNewAccCtrlTest {
    
	@isTest
    public static void testGetRecordTypeName(){
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Domestic').getRecordTypeId();

        Test.startTest();
        AccountViewNewAccCtrl.getRecordTypeName(recordTypeId);
        Test.stopTest();
    }

	@isTest
    public static void testSaveAccount(){
        String recordTypeName = 'Domestic';

        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();

        Account acc = new Account();
		acc.Name = 'Dom Account';
        acc.RecordTypeId = recordTypeId;
        
        Test.startTest();
        AccountViewNewAccCtrl.saveAccount(acc,recordTypeId,recordTypeName);
		acc.Stage__c = 'Dom Account';
        try{
            AccountViewNewAccCtrl.saveAccount(acc,recordTypeId,recordTypeName);
        } catch(Exception exc){}
        Test.stopTest();
    }
    
	@isTest
    public static void testGetPicklistValues(){
        List<String> picklistFieldNameListP = new List<String>();
        picklistFieldNameListP.add('Stage__c');
        
        Test.startTest();
        AccountViewNewAccCtrl.getPicklistValues(picklistFieldNameListP);
        Test.stopTest();
    }
}