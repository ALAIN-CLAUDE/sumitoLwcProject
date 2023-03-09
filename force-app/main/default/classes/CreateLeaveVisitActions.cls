/**
 * @description       : Integration class to create visit actions when a leave event is created
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-28   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class CreateLeaveVisitActions {

    @InvocableMethod
    public static List<String> createVisitActions(List<String> eventIds){
        Contact cnt = [SELECT Id, AccountId FROM Contact WHERE Name =: 'SRSA'];
        Event eventRec = [SELECT Id, StartDateTime, EndDateTime, DurationInMinutes FROM Event WHERE Id IN: eventIds][0];

        String startDateString = eventRec.StartDateTime.format('yyyy/MM/dd');
        String endDateString = eventRec.EndDateTime.format('yyyy/MM/dd');

        Date startDate = Date.parse(startDateString);
        Date endDate = Date.parse(endDateString);

        List<Holiday> holidays = [SELECT Id, ActivityDate FROM Holiday WHERE ActivityDate <=: endDate OR ActivityDate >=: startDate];
        List<Visit_Action__c> visitActions = new List<Visit_Action__c>();
        Visit_Action__c visitAction;
        Integer numLeaveDays = eventRec.StartDateTime.date().daysBetween(eventRec.EndDateTime.date());
        Integer i = 1;
        String endOfStartDayString = String.valueOf(startDate).split(' ')[0] + ' 16:00:00';
        String startOfStartDayString = String.valueOf(startDate).split(' ')[0] + ' 08:00:00';
        Boolean isDayHoliday = false;
        DateTime durationStartDateTime;
        DateTime durationEndDateTime;
        Long leaveDurationMilSecs = 0;

        while(startDate <= endDate){
            for(Holiday hldy : holidays){
                if(startDate == hldy.ActivityDate){
                    isDayHoliday = true;
                }
            }

            if(!isDayHoliday){
                String startOfDayString = String.valueOf(startDate).split(' ')[0] + ' 08:00:00';
                String dayOfWeek = DateTime.valueOf(startOfDayString).format('E');

                if(!dayOfWeek.equals('Sat') && !dayOfWeek.equals('Sun')){
                    visitAction = new Visit_Action__c();
                    visitAction.Account_Name__c = cnt.AccountId;
                    visitAction.Contact_Person__c = cnt.Id;
                    visitAction.Visit_Type__c = 'Leave';
                    visitAction.Status__c = 'Completed';
                    visitAction.Date_of_Visit__c = startDate;
                    
                    if(i == 1){
                        Long timeBetween = eventRec.StartDateTime.getTime() - DateTime.valueOf(startOfStartDayString).getTime();

                        if((timeBetween/60000) < 0){
                            visitAction.Start_Date__c = DateTime.valueOf(startOfStartDayString);
                        } else {
                            visitAction.Start_Date__c = eventRec.StartDateTime;
                        }

                        visitAction.End_Date__c = DateTime.valueOf(endOfStartDayString);

                        leaveDurationMilSecs += visitAction.End_Date__c.getTime() - visitAction.Start_Date__c.getTime();
                    } else if(i == numLeaveDays + 1){
                        visitAction.Start_Date__c = DateTime.valueOf(startOfDayString);
                        String endOfDayString = String.valueOf(startDate).split(' ')[0] + ' 16:00:00';
                        Long timeBetween = DateTime.valueOf(endOfDayString).getTime() - eventRec.EndDateTime.getTime();

                        if((timeBetween/60000) < 0){
                            visitAction.End_Date__c = DateTime.valueOf(endOfDayString);
                        } else {
                            visitAction.End_Date__c = eventRec.EndDateTime;
                        }

                        leaveDurationMilSecs += visitAction.End_Date__c.getTime() - visitAction.Start_Date__c.getTime();
                    } else {
                        String endOfDayString = String.valueOf(startDate).split(' ')[0] + ' 16:00:00';

                        visitAction.Start_Date__c = DateTime.valueOf(startOfDayString);
                        visitAction.End_Date__c = DateTime.valueOf(endOfDayString);

                        leaveDurationMilSecs += visitAction.End_Date__c.getTime() - visitAction.Start_Date__c.getTime();
                    }

                    visitActions.add(visitAction);
                }
            }

            i++;
            startDate = startDate.addDays(1);
        }
        
        try{
            insert visitActions;
            
            calcLeaveDuration(leaveDurationMilSecs);
            return new List<String>{'Visit Actions created successfully!'};
        } catch(Exception exc){
            return new List<String>{exc.getMessage()};
        }
    }
    
    public static void calcLeaveDuration(Long leaveDurationMilSecs){
		Decimal minsBetwn = leaveDurationMilSecs/60000;
        Decimal hrsBetwn = minsBetwn/60;
        Decimal daysBetwn = hrsBetwn/8;
		
		Id crntUserId = UserInfo.getUserId();
        User crntUser = new UsersSelector().selectById(new Set<Id>{crntUserId})[0];
        
        Decimal crntNumWorkDays = crntUser.Number_of_Working_Days__c;
        crntNumWorkDays -= daysBetwn;
        crntUser.Number_of_Working_Days__c = crntNumWorkDays;
        
        try{
            update crntUser;
        } catch(Exception exc){
            throw new AuraHandledException(exc.getMessage());
        }
    }
}