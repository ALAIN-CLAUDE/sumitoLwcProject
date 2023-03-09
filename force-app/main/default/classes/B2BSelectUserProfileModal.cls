/**
 * @description       : Controller class for b2bSelectUserProfileModal Lightning Web Component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2023-02-15   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public without sharing class B2BSelectUserProfileModal {
    @AuraEnabled(cacheable=false)
    public static List<String> getUserProfiles(String currentUserProfileName){
        Map<String, Org_Variables__mdt> orgVariables = Org_Variables__mdt.getAll();
        List<String> userProfileNames = new List<String>();

        for(String userProfileName : orgVariables.get('Profile_Types').Text_Area_Value__c.split(';')){

            if(!userProfileName.trim().equalsIgnoreCase(currentUserProfileName)){
                userProfileNames.add(userProfileName.trim());
            }
        }

        return userProfileNames;
    }
    
    @AuraEnabled(cacheable=false)
    public static String updateUserProfile(String userId, String userProfileName){
        User user = [SELECT Id, FirstName, LastName, Profile.UserLicenseId FROM User WHERE Id =: userId];
        String userProfileNameSearchString = '%' + userProfileName;
        Profile userProfile = [SELECT Id, Name FROM Profile WHERE Name LIKE: userProfileNameSearchString AND UserLicenseId =: user.Profile.UserLicenseId];

        user.ProfileId = userProfile.Id;

        try{
            update user;
        } catch(Exception exc){
            throw new AuraHandledException(String.valueOf(exc));
        }

        return 'Profile for user ' + user.FirstName + ' ' + user.LastName + ' has been updated successfully.';
    }
}