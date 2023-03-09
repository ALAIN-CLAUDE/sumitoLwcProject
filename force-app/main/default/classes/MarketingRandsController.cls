public with sharing class MarketingRandsController {

    @AuraEnabled
    public static Account getAccountDetails(){
        Id userId = UserInfo.getUserId();
        User user = [SELECT AccountId from User where Id =: userId];
        if (user.AccountId != null){
            Account acc = [SELECT Id, Marketing_Rands_Balance__c, Marketing_Rands_Expiring__c from Account where Id =: user.AccountId];
            return acc;
        }
        else {
            return null;
        }
    }

}