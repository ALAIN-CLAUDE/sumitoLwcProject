public with sharing class termsConditionsController {

    @AuraEnabled
    public static void userAccepted(){
        String userId = UserInfo.getUserId();
        User u = [SELECT Id, TaC_Accepted__c, TaC_Accepted_Date__c from User where Id = :userId];
        u.TaC_Accepted__c = true;
        u.TaC_Accepted_Date__c = Datetime.now();
        update u;
    }

    @AuraEnabled
    public static Boolean getUserStatus(){
        String userId = UserInfo.getUserId();
        User u = [SELECT Id, TaC_Accepted__c from User where Id = :userId];
        return u.TaC_Accepted__c;
    }

    @AuraEnabled
    public static String getUserGroup(){
        String userId = UserInfo.getUserId();
        User u = [SELECT Id, Account_Id__c from User where Id = :userId];
        Account a = [SELECT Id, Distribution_Channel__c from Account where Id = :u.Account_Id__c];
        return a.Distribution_Channel__c;
    }
}