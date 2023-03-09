/**
 * @description       : Test class for INV_AssignB2BPermissionSets apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-07   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class INV_AssignB2BPermissionSetsTest {
	@isTest
    public static void testAssignB2BPermissionSets(){
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
        
        System.runAs (portalAccountOwner) {
            //Create account
            Account account = new Account();
            account.Name = 'SRSA';
            account.OwnerId = portalAccountOwner.Id;
            insert account;
            
            List<Contact> b2bContacts = new List<Contact>();
            Contact b2bContact = new Contact();
            b2bContact.Email = 'srsab2btestuser@amamama.com';
            b2bContact.FirstName = 'TestFirstName';
            b2bContact.LastName = 'TestLastName';
            b2bContact.AccountId = account.Id;
            b2bContacts.add(b2bContact);
            
            Contact b2bLoginContact = new Contact();
            b2bLoginContact.Email = 'srsab2btestuserLogin@amamama.com';
            b2bLoginContact.FirstName = 'TestFirstNameLogin';
            b2bLoginContact.LastName = 'TestLastNameLogin';
            b2bLoginContact.AccountId = account.Id;
            b2bContacts.add(b2bLoginContact);
            
            insert b2bContacts;
            
            List<User> b2bUsers = new List<User>();
            User b2bUser = new User();
            b2bUser.ContactId = b2bContact.Id;
            b2bUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'B2B Customer Community Plus - Dealer Principle'].Id;
            b2bUser.LastName = 'last';
            b2bUser.Email = 'srsab2btestuser@srsa.co.za';
            b2bUser.Username = 'srsab2btestuser@srsa.co.za';
            b2bUser.CompanyName = 'TEST';
            b2bUser.Title = 'title';
            b2bUser.Alias = 'alias';
            b2bUser.TimeZoneSidKey = 'America/Los_Angeles';
            b2bUser.EmailEncodingKey = 'UTF-8';
            b2bUser.LanguageLocaleKey = 'en_US';
            b2bUser.LocaleSidKey = 'en_US';
            b2bUser.CommunityNickname = 'TestNickName';
            b2bUsers.add(b2bUser);
            
            User b2bLoginUser = new User();
            b2bLoginUser.ContactId = b2bLoginContact.Id;
            b2bLoginUser.ProfileId = [SELECT Id FROM Profile WHERE Name = 'B2B Customer Community Plus Login - Dealer Principle'].Id;
            b2bLoginUser.LastName = 'lastLogin';
            b2bLoginUser.Email = 'srsab2btestuserLogin@srsa.co.za';
            b2bLoginUser.Username = 'srsab2btestuserLogin@srsa.co.za';
            b2bLoginUser.CompanyName = 'TESTLogin';
            b2bLoginUser.Title = 'titleLogin';
            b2bLoginUser.Alias = 'aLogin';
            b2bLoginUser.TimeZoneSidKey = 'America/Los_Angeles';
            b2bLoginUser.EmailEncodingKey = 'UTF-8';
            b2bLoginUser.LanguageLocaleKey = 'en_US';
            b2bLoginUser.LocaleSidKey = 'en_US';
            b2bLoginUser.CommunityNickname = 'TestNickNameLogin';
            b2bUsers.add(b2bLoginUser);
            
            insert b2bUsers;
            
            //List<String> userIds = new List<String>{b2bUser.Id, b2bLoginUser.Id};
            //INV_AssignB2BPermissionSets.assignB2BPermissionSets(userIds);
        }
    }
}