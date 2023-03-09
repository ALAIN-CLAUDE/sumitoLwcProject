/**
 * @author          Cihan Fethi Hizar
 * @createdDate     27 October 2022
 * @description     This is created for these JIRA stories: SD-484 - SD-485
 *                  This is the Apex controller for the "quoteThankYou" LWC.
 */

public without sharing class QuoteController {
    
    @AuraEnabled
    public static string getQuote(String id){
        try {
            SBQQ__Quote__c q = [SELECT Id, Name FROM SBQQ__Quote__c WHERE Id = :id WITH SYSTEM_MODE][0];
            return q.Name;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}