/**
 * @description       : Test class for INV_UpdateMultiQuoteLineRejection apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class INV_UpdateMultiQuoteLineRejectionTest {
	@testSetup
    public static void createData(){
        Account account = new Account();
		account.Name = 'SRSA';
		insert account;
        
        List<Product2> prods = new List<Product2>();
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Product1';
        prod1.RIM_Size__c = '16';
        prod1.PDT_Code__c = 'Test753159';
        prod1.StockKeepingUnit = 'Test753159';
        prod1.ProductCode = 'Test753159';
        prods.add(prod1);

        Product2 prod2 = new Product2();
        prod2.Name = 'Product2';
        prod2.RIM_Size__c = '14';
        prod2.PDT_Code__c = 'Test159753';
        prod2.StockKeepingUnit = 'Test159753';
        prod2.ProductCode = 'Test159753';
        prods.add(prod2);
        
        insert prods;

        List<PriceBookEntry> stdPbes = new List<PriceBookEntry>();
        stdPbes.add(new PriceBookEntry(Product2Id=prod1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=700));
        stdPbes.add(new PriceBookEntry(Product2Id=prod2.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=900));
        
        insert stdPbes;

        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = 'TestSAP142536';
        insert priceBook;
        
        List<PriceBookEntry> pbes = new List<PriceBookEntry>();
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Product2Id = prod1.Id;
        pbe1.IsActive = true;
        pbe1.UnitPrice = 750;
        pbe1.Pricebook2Id = priceBook.Id;
        pbes.add(pbe1);
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.Product2Id = prod2.Id;
        pbe2.IsActive = true;
        pbe2.UnitPrice = 750;
        pbe2.Pricebook2Id = priceBook.Id;
        pbes.add(pbe2);
        
        insert pbes;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = account.Id;
        quote.SBQQ__PricebookId__c = priceBook.Id;
        quote.SBQQ__Pricebook__c = priceBook.Id;
        insert quote;
        
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        
        SBQQ__QuoteLine__c quoteLine1 = new SBQQ__QuoteLine__c();
        quoteLine1.SBQQ__PricebookEntryId__c = pbe1.Id;
        quoteLine1.SBQQ__Product__c = prod1.Id;
        quoteLine1.SBQQ__Quantity__c = 1;
        quoteLine1.SBQQ__Number__c = 1;
        quoteLine1.SBQQ__Quote__c = quote.Id;
        quoteLines.add(quoteLine1);
        
        SBQQ__QuoteLine__c quoteLine2 = new SBQQ__QuoteLine__c();
        quoteLine2.SBQQ__PricebookEntryId__c = pbe1.Id;
        quoteLine2.SBQQ__Product__c = prod1.Id;
        quoteLine2.SBQQ__Quantity__c = 1;
        quoteLine2.SBQQ__Number__c = 2;
        quoteLine2.SBQQ__Quote__c = quote.Id;
        quoteLines.add(quoteLine2);
        
        SBQQ__QuoteLine__c quoteLine3 = new SBQQ__QuoteLine__c();
        quoteLine3.SBQQ__PricebookEntryId__c = pbe1.Id;
        quoteLine3.SBQQ__Product__c = prod1.Id;
        quoteLine3.SBQQ__Quantity__c = 1;
        quoteLine3.SBQQ__Number__c = 3;
        quoteLine3.SBQQ__Quote__c = quote.Id;
        quoteLines.add(quoteLine3);
        
        insert quoteLines;
    }

    @isTest
    public static void testUpdateQuoteLines(){
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT Id, DNU_Product_Description__c, SBQQ__Quote__c FROM SBQQ__QuoteLine__c LIMIT 2];
        String quoteLineDetails = 'Order Cancelled!' + quoteLines[0].DNU_Product_Description__c + ';' + quoteLines[1].DNU_Product_Description__c + '!' + quoteLines[0].SBQQ__Quote__c;
        //(2 - 195/65R15 91T FASTRESPONSE MO - G10491117DG - 8;4 - 185/65R15 88S EC300+ - G10491138DJ - 36!a173L0000003uHNQAY)
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFlowGear());
        List<String> responses = INV_UpdateMultiQuoteLineRejection.updateQuoteLines(new List<String>{quoteLineDetails});
        Test.stopTest();
        
        for(String response : responses){
            System.assert(response.equals('Quote lines rejected successfully.'));
        }
        
        quoteLines = [SELECT Id FROM SBQQ__QuoteLine__c WHERE Rejection_Reason__c = null];
        
        System.assert(quoteLines.size() == 1);
    }

    @isTest
    public static void testUpdateQuoteLinesAllLines(){
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT Id, DNU_Product_Description__c, SBQQ__Quote__c FROM SBQQ__QuoteLine__c];
        String quoteLineDetails = 'Order Cancelled!' + quoteLines[0].DNU_Product_Description__c + ';' + quoteLines[1].DNU_Product_Description__c + ';' + quoteLines[2].DNU_Product_Description__c + '!' + quoteLines[0].SBQQ__Quote__c;
        //(2 - 195/65R15 91T FASTRESPONSE MO - G10491117DG - 8;4 - 185/65R15 88S EC300+ - G10491138DJ - 36!a173L0000003uHNQAY)
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFlowGear());
        List<String> responses = INV_UpdateMultiQuoteLineRejection.updateQuoteLines(new List<String>{quoteLineDetails});
        Test.stopTest();
        
        for(String response : responses){
            System.assert(response.equals('Quote lines rejected successfully and quote updated to cancelled.'));
        }
        
        quoteLines = [SELECT Id FROM SBQQ__QuoteLine__c WHERE Rejection_Reason__c = null];
        
        System.assert(quoteLines.size() == 0);
    }
}