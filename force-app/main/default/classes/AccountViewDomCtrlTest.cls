/**
 * @description       : Test class for AccountViewDomCtrl apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class AccountViewDomCtrlTest {
	@isTest
    public static void testGetAccount(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Test.startTest();
        AccountViewDomCtrl.getAccount(acc.Id);
        Test.stopTest();
    }

	@isTest
    public static void testGetPicklistValues(){
        List<String> picklistFieldNameListP = new List<String>();
        picklistFieldNameListP.add('Stage__c');
        
        Test.startTest();
        AccountViewDomCtrl.getPicklistValues(picklistFieldNameListP);
        Test.stopTest();
    }
}