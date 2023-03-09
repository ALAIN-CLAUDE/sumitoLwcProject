/**
 * @description       : Test class for CreateTask apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-07-15   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class CreateTask_Test {
	@testSetup
    public static void createData(){
        Account account = new Account();
		account.Name = 'Test Account';
		insert account;

        Contact contact = new Contact();
        contact.FirstName = 'FirstName';
        contact.LastName = 'LastName';
        contact.Email = 'standarduserTest@testorg.com';
        contact.AccountId = account.Id;
        insert contact;
        
        Visit_Action__c visAction = new Visit_Action__c();
        visAction.Account_Name__c = account.Id;
        visAction.Contact_Person__c = contact.Id;
        visAction.Date_of_Visit__c = System.today();
        visAction.Meeting_Notes__c = 'Test meeting notes';
        visAction.Visit_Type__c = 'Virtual';
        insert visAction;
    }
    
    @isTest
    public static void testCreateTaskRecord(){
        Visit_Action__c visAction = [SELECT Id FROM Visit_Action__c LIMIT 1];
        
        Test.startTest();
        CreateTask.createTaskRecord(new List<Id>{visAction.Id});
        Test.stopTest();
    }
}