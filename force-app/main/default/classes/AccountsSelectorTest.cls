/**
 * @description       : Test class for AccountsSelector apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class AccountsSelectorTest {
	
	@isTest
    public static void testSelectById(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Test.startTest();
        new AccountsSelector().selectById(new Set<Id>{acc.Id});
        Test.stopTest();
    }
}