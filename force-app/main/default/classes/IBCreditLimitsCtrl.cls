/**
 * @description       : Controller class for IBCreditLimits aura component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-07-15   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public with sharing class IBCreditLimitsCtrl {
	@AuraEnabled
    public static Account getAccountDetails(Id accountId){
        Id userId = UserInfo.getUserId();
        User crntUser = [SELECT Id, Contact.AccountId FROM User WHERE Id =: userId];
        List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{crntUser.Contact.AccountId});

        return accounts[0];
    }
}