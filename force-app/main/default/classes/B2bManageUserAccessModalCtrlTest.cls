/**
 * @description       : Test class for B2bManageUserAccessModalCtrl
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2023-02-27   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class B2bManageUserAccessModalCtrlTest {
	@testSetup
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

            List<Contact> contacts = new List<Contact>();
            Contact contact1 = new Contact();
            contact1.FirstName = 'FirstName';
            contact1.LastName = 'LastName';
            contact1.Email = 'firstname.lastname@srsa.co.za';
            contact1.AccountId = account.Id;
            contacts.add(contact1);

            Contact contact2 = new Contact();
            contact2.FirstName = 'FirstName2';
            contact2.LastName = 'LastName2';
            contact2.Email = 'firstname2.lastname2@srsa.co.za';
            contact2.AccountId = account.Id;
            contacts.add(contact2);

            insert contacts;

            List<User> users = new List<User>();
            User user1 = new User();
            user1.Alias = 'test123';
            user1.Email = 'firstname.lastname@srsa.co.za';
            user1.EmailEncodingKey = 'UTF-8';
            user1.FirstName = 'FirstName';
            user1.LastName = 'LastName';
            user1.ContactId = contact1.Id;
            user1.LanguageLocaleKey = 'en_US';
            user1.LocalesIdKey = 'en_US';
            user1.ProfileId = customerProfile.Id;
            user1.TimezoneSidKey = 'America/Los_Angeles';
            user1.Country = 'South Africa';
            user1.Username = 'firstname.lastname@srsa.co.za';
            user1.IsActive = true;
            users.add(user1);

            User user2 = new User();
            user2.Alias = 'test1232';
            user2.Email = 'firstname2.lastname2@srsa.co.za';
            user2.EmailEncodingKey = 'UTF-8';
            user2.FirstName = 'FirstName2';
            user2.LastName = 'LastName2';
            user2.ContactId = contact2.Id;
            user2.LanguageLocaleKey = 'en_US';
            user2.LocalesIdKey = 'en_US';
            user2.ProfileId = customerProfile.Id;
            user2.TimezoneSidKey = 'America/Los_Angeles';
            user2.Country = 'South Africa';
            user2.Username = 'firstname2.lastname2@srsa.co.za';
            user2.IsActive = true;
            users.add(user2);

        	insert users;
        }
    }

    @isTest
    public static void testResetUserPassword(){
        User user = [SELECT Id, FirstName, LastName FROM User WHERE Username = 'firstname.lastname@srsa.co.za'];
        String userName;
        
        System.runAs(user) {
        	userName = B2bManageUserAccessModalCtrl.resetUserPassword(user.Id);
        }

        System.assertEquals(userName, user.FirstName + ' ' + user.LastName);
    }

    @isTest
    public static void testUpdateUserActiveStatus(){
        User user = [SELECT Id, FirstName, LastName FROM User WHERE Username = 'firstname.lastname@srsa.co.za'];
        String userName;
        
        System.runAs(user) {
        	userName = B2bManageUserAccessModalCtrl.updateUserActiveStatus(user.Id, true);
        }

        System.assertEquals(userName, user.FirstName + ' ' + user.LastName);
    }
}