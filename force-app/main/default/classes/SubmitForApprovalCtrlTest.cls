/**
 * @description       : Test class for SubmitForApprovalCtrl apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class SubmitForApprovalCtrlTest {

	@testSetup
    public static void createData(){
        List<Account> accounts = new List<Account>();
        Account acc = new Account();
		acc.Name = 'Dom Account';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Domestic').getRecordTypeId();
        accounts.add(acc);

        acc = new Account();
		acc.Name = 'IB Account';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('International_Business').getRecordTypeId();
        accounts.add(acc);

        Account accDom = new Account();
		accDom.Name = 'Dom Account With Docs';
        accDom.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Domestic').getRecordTypeId();
        accounts.add(accDom);

        Account accIB = new Account();
		accIB.Name = 'IB Account With Docs';
        accIB.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('International_Business').getRecordTypeId();
        accounts.add(accIB);

		insert accounts;

        List<Account_Document__c> accDocs = new List<Account_Document__c>();
        Account_Document__c accDoc = new Account_Document__c();
        accDoc.Account__c = accDom.Id;
        accDoc.Document_Type__c = 'Company documents';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accDom.Id;
        accDoc.Document_Type__c = 'Credit agreement';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accDom.Id;
        accDoc.Document_Type__c = 'Identification documents';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accDom.Id;
        accDoc.Document_Type__c = 'Master data form';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accIB.Id;
        accDoc.Document_Type__c = 'Audited financials';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accIB.Id;
        accDoc.Document_Type__c = 'Company documents';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accIB.Id;
        accDoc.Document_Type__c = 'Confirmation of banking details';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accIB.Id;
        accDoc.Document_Type__c = 'Credit agreement';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accIB.Id;
        accDoc.Document_Type__c = 'Debtor questionnaire';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accIB.Id;
        accDoc.Document_Type__c = 'Identification documents';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        accDoc = new Account_Document__c();
        accDoc.Account__c = accIB.Id;
        accDoc.Document_Type__c = 'Master data form';
        accDoc.Status__c = 'Submitted';
        accDocs.add(accDoc);
        
        insert accDocs;
        
        User userManRec = new User();
        userManRec.Email = 'standarduserTest@testorg.com';
        userManRec.CommunityNickname = '';
        userManRec.FirstName = 'standarduser';
        userManRec.LastName = 'Test';
        userManRec.username = userManRec.Email +'.sri';
        userManRec.IsActive = true;
        userManRec.EmailEncodingKey = 'UTF-8';
        userManRec.LocaleSidKey = 'en_ZA';
        userManRec.TimeZoneSidKey = 'Africa/Johannesburg';
        userManRec.LanguageLocaleKey = 'en_US';
        userManRec.ProfileId = UTL_Profile.getProfileId('Standard User');
        userManRec.CommunityNickname = 'nickname';
        userManRec.Alias = 'theAlias';
        insert userManRec;
        
        User userRec = new User();
        userRec.Email = 'standardManuserTest@testorg.com';
        userRec.CommunityNickname = '';
        userRec.FirstName = 'standardManuser';
        userRec.LastName = 'Test';
        userRec.username = userRec.Email +'.sri';
        userRec.IsActive = true;
        userRec.EmailEncodingKey = 'UTF-8';
        userRec.LocaleSidKey = 'en_ZA';
        userRec.TimeZoneSidKey = 'Africa/Johannesburg';
        userRec.LanguageLocaleKey = 'en_US';
        userRec.ProfileId = UTL_Profile.getProfileId('Standard User');
        userRec.ManagerId = userManRec.Id;
        userRec.CommunityNickname = 'Mannickname';
        userRec.Alias = 'theMan';
        insert userRec;
    }

    @isTest
    public static void testSubmitForApproval(){
        Account accDom = [SELECT Id FROM Account WHERE Name = 'Dom Account' LIMIT 1];
        Account accIB = [SELECT Id FROM Account WHERE Name = 'IB Account' LIMIT 1];
        Account accDomDocs = [SELECT Id FROM Account WHERE Name = 'Dom Account With Docs' LIMIT 1];
        Account accIBDocs = [SELECT Id FROM Account WHERE Name = 'IB Account With Docs' LIMIT 1];
        
        Test.startTest();
        try{
            SubmitForApprovalCtrl.submitForApproval('Test', accDom.Id);
        } catch(Exception exc){}
        
        try{
            SubmitForApprovalCtrl.submitForApproval('Test', accIB.Id);
        } catch(Exception exc){}
        
        try{
            SubmitForApprovalCtrl.submitForApproval('Test', accDomDocs.Id);
        } catch(Exception exc){}
        
        try{
            SubmitForApprovalCtrl.submitForApproval('Test', accIBDocs.Id);
        } catch(Exception exc){}
        Test.stopTest();
    }
}