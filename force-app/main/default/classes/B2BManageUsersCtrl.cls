/**
 * @description       : Controller class for b2bManageUsers Lightning Web Component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2023-02-15   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public without sharing class B2BManageUsersCtrl {
    @AuraEnabled(cacheable=true)
    public static List<User> getRelatedUsers(){
        Id userId = UserInfo.getUserId();
        User currentUser = [SELECT Id, AccountId FROM User WHERE Id =: userId];
        List<User> relatedUsers = [SELECT Id, Email, FirstName, isActive, LastLoginDate, LastName, Name, ProfileId, Profile.Name, Profile.UserLicenseId FROM User WHERE AccountId =: currentUser.AccountId and Id <>: userId];

        if(relatedusers == null || relatedUsers.size() == 0){
            throw new AuraHandledException('You have not added any users yet.');
        }

        return relatedUsers;
    }
}