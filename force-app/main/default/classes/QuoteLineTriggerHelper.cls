public class QuoteLineTriggerHelper {
	public static void handleBeforeDelete(List<SBQQ__QuoteLine__c> quoteLines){
    	
        for(SBQQ__QuoteLine__c quoteLine : quoteLines){
            if(quoteLine.Quote_SAP_Order_Number__c != null){
                quoteLine.addError('You cannot delete item ' + quoteLine.SBQQ__Number__c + ' - ' + quoteLine.SBQQ__ProductName__c + ' with quantity ' + quoteLine.SBQQ__Quantity__c + ' as the quote has already been submitted to SAP. \nPlease remove the quote line using the "Remove Quote Lines" button on the Quote. \nFor now, click the "Cancel" button to cancel the deletion of the product.');
            }
        }
    }
}