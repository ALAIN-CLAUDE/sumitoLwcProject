/**
 * @description       : Class used for rejecting multiple quote lines
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-03-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_UpdateMultiQuoteLineRejection {

    @InvocableMethod(label='Reject Multiple Quote Lines')
    public static List<String> updateQuoteLines(List<String> quoteLineDetails){
        String quoteLineDetail = quoteLineDetails[0];
        String rejectionReason = getPicklistAPIValue(quoteLineDetail.split('!')[0]);
        String quoteLines = quoteLineDetail.split('!')[1];
        String responseString = '';
        Set<Integer> quoteLineNums = new Set<Integer>();

        for(String quoteLine : quoteLines.split(';')){
            System.debug(quoteLine);
            quoteLineNums.add(Integer.valueOf(quoteLine.split('-')[0].trim()));
        }

        List<SBQQ__QuoteLine__c> rejQuoteLines = new QuoteLinesSelector().selectByQuoteIdAndNumber(new Set<Id>{quoteLineDetail.split('!')[2]}, quoteLineNums);

        if(rejQuoteLines != null && rejQuoteLines.size() > 0){
            Decimal originalQuantity = 0;
            Decimal originalNetPrice = 0;

            for(SBQQ__QuoteLine__c rejQuoteLine : rejQuoteLines){
                rejQuoteLine.Rejection_Reason__c = rejectionReason;
                originalQuantity = rejQuoteLine.SBQQ__Quantity__c;
                originalNetPrice = rejQuoteLine.SBQQ__NetPrice__c;
                //rejQuoteLine.SBQQ__Quantity__c = 0;
                rejQuoteLine.SBQQ__Discount__c = null;
                rejQuoteLine.SBQQ__AdditionalDiscountAmount__c = null;
                rejQuoteLine.SAP_Update_Flag__c = 'U';
                rejQuoteLine.Rejected_Quantity__c = originalQuantity;
                rejQuoteLine.Rejected_Net_Price__c = originalNetPrice;
            }

            try{
                update rejQuoteLines;
                Boolean quoteUpdateComplete = setQuoteToRejectedIfAllQuoteLinesRejected(quoteLineDetail.split('!')[2]);

                if(quoteUpdateComplete){
                    responseString = 'Quote lines rejected successfully and quote updated to cancelled.';
                } else {
                    responseString = 'Quote lines rejected successfully.';
                }
            } catch(Exception exc){
                responseString = 'Error: ' + exc + '. Please contact your system administrator.';
            }
        }

        return new List<String>{responseString};
    }

    public static Boolean setQuoteToRejectedIfAllQuoteLinesRejected(Id quoteId){
        Boolean quoteUpdateComplete = false;
        Boolean activeQuoteLinesExist = false;
        List<SBQQ__QuoteLine__c> quoteLines = new QuoteLinesSelector().selectByQuoteId(new Set<Id>{quoteId});

        for(SBQQ__QuoteLine__c quoteLine : quoteLines){
            if(quoteLine.Rejection_Reason__c == null){
                activeQuoteLinesExist = true;
            }
        }

        if(!activeQuoteLinesExist){
            SBQQ__Quote__c quote = new SBQQ__Quote__c(Id = quoteId);
            quote.SBQQ__Status__c = 'Quote Cancelled';
            update quote;
            quoteUpdateComplete = true;
            FlowGearToSAPQuoteFuture.quoteToSAP(new List<String>{quoteId});
        }

        return quoteUpdateComplete;
    }

    public static String getPicklistAPIValue(String picklistLabel){
        String picklistAPIValue = '';
        Schema.DescribeFieldResult fieldResult = SBQQ__QuoteLine__c.Rejection_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            if(pickListVal.getLabel().equals(picklistLabel)){
                picklistAPIValue = pickListVal.getValue();
            }
        }    

        return picklistAPIValue;
    }
}