/**
 * @description       : Class for creating task records
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * @date 			  :	October 2021
 **/

public class CreateTask {
	@InvocableMethod
    public static void createTaskRecord(List<Id> visitActionIds){
        Set<Id> vaIds = new Set<Id>();
        vaIds.addAll(visitActionIds);
        List<Visit_Action__c> visActions = new VisitActionsSelector().selectById(vaIds);
        List<Task> tasks = new List<Task>();
        Task newTask = new Task();
        
        for(Visit_Action__c visAction : visActions){
            newTask = new Task();
            newTask.Description = 'Dear ' + visAction.Contact_Person__r.Name + '\n\n' + 'This is to confirm the site visit on ' + visAction.Date_of_Visit__c + '\n\n' + 'Please find included the notes of the meeting:\n\n' +
                visAction.Meeting_Notes__c + '\n\n' + 'Regards\n' + visAction.CreatedBy.Name + '\n' + visAction.CreatedBy.Email + '\n' + visAction.CreatedBy.MobilePhone;
            
            newTask.WhoId = visAction.Contact_Person__c;
            newTask.OwnerId = visAction.CreatedById;
            newTask.Priority = 'Normal';
            newTask.Status = 'Completed';
            newTask.Subject = 'Visit Action Completion Email';
            newTask.WhatId = visAction.Id;
            tasks.add(newTask);
        }
        
        insert tasks;
    }
}