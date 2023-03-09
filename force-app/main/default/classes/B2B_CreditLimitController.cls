public with sharing class B2B_CreditLimitController {
    
    @AuraEnabled
    public static Account getAccountCreditLimits(){
        Id userId = UserInfo.getUserId();
        User user = [SELECT AccountId, Profile.Name from User where Id =: userId];
        Map<String, Org_Variables__mdt> orgVariables = Org_Variables__mdt.getAll();
        List<String> creditLimitExcludedProfiles = orgVariables.get('B2B_Credit_Limit_Excluded_Profiles').Text_Area_Value__c.split(';');
        
        if(creditLimitExcludedProfiles.contains(user.Profile.Name)){
            return null;
        } else{
            if (user.AccountId != null){
                Account acc = [SELECT Id, Block_Central_Billing__c, Block_Central_Delivery__c, Block_Central_Order__c, Currency_to_adopt__c, Credit_Limit__c, Credit_Exposure__c, Credit_Limit_Available__c, Credit_Last_Updated_Date__c  from Account where Id =: user.AccountId];
                return acc;
            }
            else {
                return null;
            }
        }
    }
}