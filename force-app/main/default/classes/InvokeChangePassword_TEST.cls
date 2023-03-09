@isTest
public class InvokeChangePassword_TEST {
	  @istest
    Public static void ChangePassword () {

        Profile p = [ SELECT id FROM Profile WHERE name = 'Standard User' ];

        Test.startTest();   
        User u = new User ();
        u.firstName = 'test1';
        u.lastName = 'test2';
        u.ProfileId = p.Id ;
        u.Username = 'test@email4x.com' ;
        u.Email = 'test@email.com';
        u.Alias = 't1';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LocaleSidKey = 'en_US' ;
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LanguageLocaleKey = 'en_US' ;
        Insert u ;
        list<id> lstId = new list<id>();
        lstId.Add(u.Id);
        //system.resetPassword(u.Id, true);
        //System.debug('DONE: ' + u.Id);
        InvokeChangePassword.getUserIDs(lstId);
        Test.stopTest();

    }
    }