/**
 * @description       : Trigger Helper class for Quote Trigger
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-05   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class QuoteTriggerHelper {
	static QuoteTriggerHelper quoteTH = new QuoteTriggerHelper();

    public static void handleAfterInsert(List<SBQQ__Quote__c> quotes){
        List<SBQQ__Quote__c> quotesToUpdate = new List<SBQQ__Quote__c>();
        Map<Id, Account> accMap = getAccVals(quotes);

        for(SBQQ__Quote__c quote : quotes){

            if(quote.SBQQ__PaymentTerms__c != null || quote.Delivering_Plant__c != null){
                quotesToUpdate.add(quote);
            }
        }

        if(!quotes.isEmpty()){
            updateFieldsWithLabels(quotesToUpdate, accMap);
        }
    }

    public static void handleAfterUpdate(List<SBQQ__Quote__c> quotes, Map<Id, SBQQ__Quote__c> oldQuotesMap){
        List<SBQQ__Quote__c> quotesToUpdate = new List<SBQQ__Quote__c>();
        SBQQ__Quote__c oldQuote;
        
        for(SBQQ__Quote__c quote : quotes){
            oldQuote = oldQuotesMap.get(quote.Id);
            
            if(quote.SBQQ__PaymentTerms__c != oldQuote.SBQQ__PaymentTerms__c || quote.Delivering_Plant__c != oldQuote.Delivering_Plant__c ){
                quotesToUpdate.add(quote);
            }
        }
        
        if(!quotes.isEmpty()){
            updateFieldsWithLabels(quotesToUpdate);
        }
    }

    public static void updateFieldsWithLabels(List<SBQQ__Quote__c> quotes, Map<Id, Account> accMap){
    	Schema.DescribeFieldResult salesOfficeDesc = Account.Sales_Office__c.getDescribe();
        List<Schema.PicklistEntry> salesOfficeVals = salesOfficeDesc.getPickListValues();

        Schema.DescribeFieldResult payTermsDesc = SBQQ__Quote__c.SBQQ__PaymentTerms__c.getDescribe();
        List<Schema.PicklistEntry> payTermsVals = payTermsDesc.getPickListValues();

        Schema.DescribeFieldResult delPlantDesc = SBQQ__Quote__c.Delivering_Plant__c.getDescribe();
        List<Schema.PicklistEntry> delPlantVals = delPlantDesc.getPickListValues();

        Account acc;
        
        for(SBQQ__Quote__c quote : quotes){
            acc = accMap.get(quote.SBQQ__Account__c);

            for (Schema.PicklistEntry salesOfficeVal : salesOfficeVals) {

                //System.debug('Value = ' +objPickList.getValue() +' , Label = ' +objPickList.getLabel());
                if(salesOfficeVal.getValue().equals(acc.Sales_Office__c)){
                    quote.Account_Sales_Office_Label__c = salesOfficeVal.getLabel();
                }
            }
            
            for (Schema.PicklistEntry payTermsVal : payTermsVals) {

                if(payTermsVal.getValue().equals(quote.SBQQ__PaymentTerms__c)){
                    quote.Payment_Terms_Label__c = payTermsVal.getLabel();
                }
            }
            
            for (Schema.PicklistEntry delPlantVal : delPlantVals) {

                if(delPlantVal.getValue().equals(quote.Delivering_Plant__c)){
                    quote.Delivering_Plant_Label__c = delPlantVal.getLabel();
                }
            }
        }
    }

    public static void updateFieldsWithLabels(List<SBQQ__Quote__c> quotes){
        Schema.DescribeFieldResult salesOfficeDesc = Account.Sales_Office__c.getDescribe();
        List<Schema.PicklistEntry> salesOfficeVals = salesOfficeDesc.getPickListValues();

        Schema.DescribeFieldResult payTermsDesc = SBQQ__Quote__c.SBQQ__PaymentTerms__c.getDescribe();
        List<Schema.PicklistEntry> payTermsVals = payTermsDesc.getPickListValues();

        Schema.DescribeFieldResult delPlantDesc = SBQQ__Quote__c.Delivering_Plant__c.getDescribe();
        List<Schema.PicklistEntry> delPlantVals = delPlantDesc.getPickListValues();

        for(SBQQ__Quote__c quote : quotes){
            
            for (Schema.PicklistEntry salesOfficeVal : salesOfficeVals) {

                if(salesOfficeVal.getValue().equals(quote.Customer_Sales_Office__c)){
                    quote.Account_Sales_Office_Label__c = salesOfficeVal.getLabel();
                }
            }
            
            for (Schema.PicklistEntry payTermsVal : payTermsVals) {

                if(payTermsVal.getValue().equals(quote.SBQQ__PaymentTerms__c)){
                    quote.Payment_Terms_Label__c = payTermsVal.getLabel();
                }
            }
            
            for (Schema.PicklistEntry delPlantVal : delPlantVals) {

                if(delPlantVal.getValue().equals(quote.Delivering_Plant__c)){
                    quote.Delivering_Plant_Label__c = delPlantVal.getLabel();
                }
            }
        }
    }
    
    public static Map<Id, Account> getAccVals(List<SBQQ__Quote__c> quotes){
        Map<Id, Account> accMap = new Map<Id, Account>();
        Set<Id> accIds = new Set<Id>();
        
        for(SBQQ__Quote__c quote : quotes){
            accIds.add(quote.SBQQ__Account__c);
        }
        
        List<Account> accounts = [SELECT Id, Sales_Office__c FROM Account WHERE Id IN: accIds];
        
        for(Account acc : accounts){
            accMap.put(acc.Id, acc);
        }
        
        return accMap;
    }
}