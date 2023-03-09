@IsTest
public class termsConditionsController_test {
    @TestSetup
    private static void testDataSetup(){
        UserRole userRoleAdmin = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'SF_Admin' LIMIT 1];
        User adminUser = new User(Id=UserInfo.getUserId());
        adminUser.UserRoleId = userRoleAdmin.Id;
        update adminUser;
        System.runAs(adminUser){
            Account acc = new Account(Name = 'B2B Test Account', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest123', Distribution_Channel__c = 'DM');
            insert acc;
            Contact con = new Contact(FirstName = 'B2B', LastName = 'Test Contact', AccountId = acc.Id);
            insert con;
        }
        Contact c = [SELECT Id FROM Contact WHERE FirstName = 'B2B'];
        Profile p = [SELECT Id FROM Profile WHERE Name='B2B Customer Community Plus'];
        User testUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                ProfileId = p.Id,
                ContactId = c.Id,
                Username = 'testUser@b2b.test',
                Email = 'testUser@b2b.test',
                Alias = 'tuser',
                EmailEncodingKey = 'UTF-8',
                TimeZoneSidKey = 'Africa/Johannesburg',
                LocaleSidKey = 'en_ZA',
                LanguageLocaleKey = 'en_US',
                TaC_Accepted__c = false
        );
        insert testUser;
    }

    @IsTest
    private static void getUserStatus_Test(){
        User u = [SELECT Id FROM User WHERE Username = 'testUser@b2b.test'];
        System.runAs(u){
            Boolean TaC_Status = termsConditionsController.getUserStatus();
            System.assertEquals(TaC_Status, false);
        }
    }

    @IsTest
    private static void userAccepted_Test(){
        User u = [SELECT Id FROM User WHERE Username = 'testUser@b2b.test'];
        System.runAs(u){
            termsConditionsController.userAccepted();
        }
        User user = [SELECT Id,TaC_Accepted__c FROM User WHERE Username = 'testUser@b2b.test'];
        System.assertEquals(user.TaC_Accepted__c, true);
    }

    @IsTest
    private static void getUserGroup_Test(){
        User u = [SELECT Id FROM User WHERE Username = 'testUser@b2b.test'];
        System.runAs(u){
            String channel = termsConditionsController.getUserGroup();
            System.assertEquals(channel, 'DM');
        }
    }
}