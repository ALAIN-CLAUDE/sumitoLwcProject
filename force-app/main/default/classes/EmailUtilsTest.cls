/**
 * @description       : Test class for EmailUtils
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class EmailUtilsTest {
	@isTest
    public static void testSendEmail(){
        Test.startTest();
        EmailUtils.sendEmail(new List<String>{'firstname.lastname@srsa.co.za'}, 'subject', 'message');
        Test.stopTest();
    }
    
    @isTest
    public static void testSendBatchSaveResultErrors(){
        Test.startTest();
        List<Account> accounts = new List<Account>();
        Account account = new Account();
        account.Name = 'SRSA';
        account.Stage__c = 'Active';
        account.SAP_Customer_Code__c = '6TestSAP142536';
        accounts.add(account);
        
        account = new Account();
        account.Name = 'SRSA';
        account.Stage__c = 'Active';
        account.SAP_Customer_Code__c = '6TestSAP142536';
        accounts.add(account);
        
        Database.SaveResult[] srList = Database.insert(accounts, false);
        EmailUtils.sendBatchSaveResultErrors(srList, 'subject');
        Test.stopTest();
    }
}