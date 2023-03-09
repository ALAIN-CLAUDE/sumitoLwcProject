/**
 * @description       : Test class for IBCreditLimitsCtrl
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class IBCreditLimitsCtrlTest {
	
    @isTest
    public static void testGetAccountDetails(){
        Profile customerProfile = [SELECT Id FROM Profile WHERE Name='B2B Customer Community Plus'];
       	UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile sysAdminProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner = new User();
        portalAccountOwner.UserRoleId = portalRole.Id;
        portalAccountOwner.ProfileId = sysAdminProfile.Id;
        portalAccountOwner.Username = 'srsab2btestuserPorOwner@srsa.co.za';
        portalAccountOwner.Alias = 'PrtlOwn';
        portalAccountOwner.Email='srsab2btestuserPorOwner@srsa.co.za';
        portalAccountOwner.EmailEncodingKey='UTF-8';
        portalAccountOwner.Firstname='TestPortal';
        portalAccountOwner.Lastname='Owner';
        portalAccountOwner.LanguageLocaleKey='en_US';
        portalAccountOwner.LocaleSidKey='en_US';
        portalAccountOwner.TimeZoneSidKey='America/Chicago';
 		insert portalAccountOwner;
        
        System.runAs(portalAccountOwner) {
            Account account = new Account();
            account.Name = 'SRSA';
            account.Stage__c = 'Active';
            account.SAP_Customer_Code__c = '6TestSAP142536';
            insert account;
            
            Contact contact = new Contact();
            contact.FirstName = 'FirstName';
            contact.LastName = 'LastName';
            contact.Email = 'firstname.lastname@srsa.co.za';
            contact.AccountId = account.Id;
            insert contact;
            
            User user = new User();
            user.Alias = 'test123';
            user.Email = 'firstname.lastname@srsa.co.za';
            user.EmailEncodingKey = 'UTF-8';
            user.FirstName = 'FirstName';
            user.LastName = 'LastName';
            user.ContactId = contact.Id;
            user.LanguageLocaleKey = 'en_US';
            user.LocalesIdKey = 'en_US';
            user.ProfileId = customerProfile.Id;
            user.TimezoneSidKey = 'America/Los_Angeles';
            user.Country = 'South Africa';
            user.Username = 'firstname.lastname@srsa.co.za';
            user.IsActive = true;
        	insert user;
            
            Account returnResult;
            
            system.runAs(user) {
                Test.startTest();
                returnResult = IBCreditLimitsCtrl.getAccountDetails(account.Id);
                Test.stopTest();
            }
            
            System.assertNotEquals(returnResult, null);
        }
    }
}