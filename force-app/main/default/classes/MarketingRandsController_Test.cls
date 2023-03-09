@IsTest
public class MarketingRandsController_Test {
    @IsTest
    private static void getAccountDetails_Test(){
        UserRole userRoleAdmin = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName = 'SF_Admin' LIMIT 1];
        User adminUser = new User(Id=UserInfo.getUserId());
        adminUser.UserRoleId = userRoleAdmin.Id;
        update adminUser;
        System.runAs(adminUser){
            Account acc = new Account(Name = 'B2B Test Account', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest123');
            insert acc;
            Contact con = new Contact(FirstName = 'B2B', LastName = 'Test Contact', AccountId = acc.Id);
            insert con;
        }
        Contact c = [SELECT Id FROM Contact WHERE FirstName = 'B2B'];
        Profile p = [SELECT Id FROM Profile WHERE Name='B2B Customer Community Plus' LIMIT 1];
        User testUser = new User(
                FirstName = 'Test',
                LastName = 'User',
                ProfileId = p.Id,
                Username = 'testUser@b2b.test',
                Email = 'testUser@b2b.test',
                Alias = 'tuser',
                ContactId = c.Id,
                EmailEncodingKey = 'UTF-8',
                TimeZoneSidKey = 'Africa/Johannesburg',
                LocaleSidKey = 'en_ZA',
                LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        System.runAs(testUser){
            Account accDetails = MarketingRandsController.getAccountDetails();
            System.debug(accDetails);
        }
    }

}