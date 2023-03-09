/**
 * @description       : Class used for updating the rejection reason on Quote Lines
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-03-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_UpdateQuoteLineRejection {

    @InvocableMethod(label='Update Quote Line Rejection Reason')
    public static List<String> updateQuoteLines(List<String> quoteLineDetails){
        String responseString = '';
        String quoteLineDetailString = quoteLineDetails.get(0);
        quoteLineDetailString = quoteLineDetailString.removeEnd(',');
        Set<Id> quoteLineIds = new Set<Id>();
        String [] quoteLineStrings = quoteLineDetailString.split(',');
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        SBQQ__QuoteLine__c updatedQuoteLine;
        Decimal originalQuantity = 0;
        Decimal originalNetPrice = 0;
        Map<Id, String> quoteIdRejReason = new Map<Id, String>();

        for(String quoteLine : quoteLineStrings){
            quoteLineIds.add(quoteLine.split('-')[0]);
            quoteIdRejReason.put(quoteLine.split('-')[0], quoteLine.split('-')[1]);
        }
        
        quoteLines = new QuoteLinesSelector().selectById(quoteLineIds);
        
        for(SBQQ__QuoteLine__c quoteLine : quoteLines){
            originalQuantity = quoteLine.SBQQ__Quantity__c;
            originalNetPrice = quoteLine.SBQQ__NetPrice__c;
            quoteLine.Rejection_Reason__c = quoteIdRejReason.get(quoteLine.Id);
            quoteLine.SBQQ__Quantity__c = 0;
            quoteLine.SBQQ__Discount__c = null;
            quoteLine.SBQQ__AdditionalDiscountAmount__c = null;
            quoteLine.SAP_Update_Flag__c = 'U';
            quoteLine.Rejected_Quantity__c = originalQuantity;
            quoteLine.Rejected_Net_Price__c = originalNetPrice;
        }

        try{
            update quoteLines;
            responseString = 'Quote Lines updated successfully.';
        } catch(Exception exc){
            responseString = 'An error has occured: ' + exc.getMessage();
        }

        return new List<String>{responseString};
    }
}