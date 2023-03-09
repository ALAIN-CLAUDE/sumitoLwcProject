/**
 * @description       : Controller class for b2bManageUserAccessModal Lightning Web Component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2023-02-15   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public without sharing class B2bManageUserAccessModalCtrl {
    
    @AuraEnabled
    public static String resetUserPassword(Id userId){
        User user = [SELECT Id, FirstName, LastName FROM User WHERE Id =: userId];
		String userName = user.FirstName + ' ' + user.LastName;
        
        try{
            System.resetPassword(user.Id, true);
            return userName;
        } catch(Exception exc){
            throw new AuraHandledException(String.valueOf(exc));
        }
    }
    
    @AuraEnabled
    public static String updateUserActiveStatus(Id userId, Boolean userActiveStatus){
        User user = [SELECT Id, FirstName, LastName, isActive FROM User WHERE Id =: userId];
		String userName = user.FirstName + ' ' + user.LastName;
        
        try{
            user.isActive = userActiveStatus;
            update user;
            return userName;
        } catch(Exception exc){
            throw new AuraHandledException(String.valueOf(exc));
        }
    }
}