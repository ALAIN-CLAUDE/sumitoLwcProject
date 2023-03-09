/**
 * @author          Cihan Fethi Hizar
 * @createdDate     28 October 2022
 * @description     Test class for QuoteController Apex Class.
 */

 @isTest
 public with sharing class QuoteControllerTest {
 
    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        SBQQ__Quote__c q = new SBQQ__Quote__c(SBQQ__Account__c = acc.Id);
        insert q;
    }

    @isTest
    static void getQuoteTest() {
        SBQQ__Quote__c q = [SELECT Id, Name FROM SBQQ__Quote__c][0];
        QuoteController.getQuote(q.Id);
        try {
            QuoteController.getQuote('');
        } catch(Exception e) {}
    }
}