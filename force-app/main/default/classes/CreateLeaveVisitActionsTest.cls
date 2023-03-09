/**
 * @description       : Test class for CreateLeaveVisitActions apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-28   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class CreateLeaveVisitActionsTest {
	@testSetup
    public static void createData(){
        Account account = new Account();
		account.Name = 'SRSA';
		insert account;

        Contact contact = new Contact();
        contact.LastName = 'SRSA';
        contact.Email = 'standarduserTest@testorg.com';
        contact.AccountId = account.Id;
        insert contact;
        
        String startDate = String.valueOf(System.today()) + ' 08:00:00';
        String endDate = String.valueOf(System.today() + 7) + ' 16:00:00';
        
        Event eventRec = new Event();
        eventRec.StartDateTime = DateTime.valueOf(startDate);
        eventRec.EndDateTime = DateTime.valueOf(endDate);
        eventRec.OwnerId = UserInfo.getUserId();
        eventRec.Subject = 'Test';
        eventRec.Type = 'Leave';
        insert eventRec;
    }

	@isTest
    public static void testCreateVisitActions(){
        Event eventRec = [SELECT Id FROM Event LIMIT 1];
        
        CreateLeaveVisitActions.createVisitActions(new List<String>{eventRec.Id});
        
        String startDate = String.valueOf(System.today()) + ' 18:00:00';
        String endDate = String.valueOf(System.today() + 7) + ' 16:00:00';
        
        eventRec.StartDateTime = DateTime.valueOf(startDate);
        eventRec.EndDateTime = DateTime.valueOf(endDate);
        update eventRec;
        
        CreateLeaveVisitActions.createVisitActions(new List<String>{eventRec.Id});
        
        startDate = String.valueOf(System.today()) + ' 02:00:00';
        endDate = String.valueOf(System.today() + 7) + ' 18:00:00';
        
        eventRec.StartDateTime = DateTime.valueOf(startDate);
        eventRec.EndDateTime = DateTime.valueOf(endDate);
        update eventRec;
        
        CreateLeaveVisitActions.createVisitActions(new List<String>{eventRec.Id});
    }
}