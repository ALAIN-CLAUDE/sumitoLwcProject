/**
 * @description       : Test class for AccViewSAPAccountDetailsCtrl apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class AccViewSAPAccountDetailsCtrlTest {
	@isTest
    public static void testGetAccount(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Test.startTest();
        AccViewSAPAccountDetailsCtrl.getAccount(acc.Id);
        Test.stopTest();
    }
    
	@isTest
    public static void testGetPicklistValues(){
        List<String> picklistFieldNameListP = new List<String>{'Customer_accgroup__c', 'Division__c', 'Enterprise_Development__c'};
        Test.startTest();
        AccViewSAPAccountDetailsCtrl.getPicklistValues(picklistFieldNameListP);
        Test.stopTest();
    }
}