/**
 * @description       : Class used for updating quote line local stock 
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-03-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_UpdateQuoteLineStock {

    @InvocableMethod(label='Update Quote Line Local Stock')
    public static List<String> updateQuoteLineStock(List<String> productIdStrings){
        Map<Id, SBQQ__QuoteLine__c> quoteLinesMap = new Map<Id, SBQQ__QuoteLine__c>();
        List<String> response = new List<String>();
        String prodIdString = productIdStrings[0].removeEnd(';');
        Set<Id> quoteLineIds = new Set<Id>();
        Set<Id> prodIds = new Set<Id>();
        String delPlant = '';
        Integer i = 0;
        
        for(String quoteLineId : prodIdString.split(';')){
            if(i == 0){
                delPlant = quoteLineId;
            } else {
                quoteLineIds.add(quoteLineId);
            }
            i++;
        }
        
        List<SBQQ__QuoteLine__c> quoteLines = new QuoteLinesSelector().selectById(quoteLineIds);
        List<SBQQ__QuoteLine__c> updatedQuoteLines = new List<SBQQ__QuoteLine__c>();
        
        for(SBQQ__QuoteLine__c quoteLine : quoteLines){
            prodIds.add(quoteLine.SBQQ__Product__c);
        }
        
        List<Stock__c> stocks = new StocksSelector().selectByProductIdAndPlant(prodIds, new Set<String>{delPlant});
        
        for(Stock__c stock : stocks){
            for(SBQQ__QuoteLine__c quoteLine : quoteLines){
                if(stock.Product__c.equals(quoteLine.SBQQ__Product__c)){
                    quoteLine.Local_Stock__c = stock.Quantity__c;
                    updatedQuoteLines.add(quoteLine);
                }
            }
        }
        
        if(updatedQuoteLines != null && updatedQuoteLines.size() > 0){
            try{
                quoteLinesMap.putAll(updatedQuoteLines);
                
                if(quoteLinesMap != null && quoteLinesMap.size() > 0){
                    update quoteLinesMap.values();
                }
                response.add('Quote Line Stock Updated Successfully!');
            } catch(Exception exc){
                response.add('Error: ' + exc);
            }
        }
        
        return response;
    }
}