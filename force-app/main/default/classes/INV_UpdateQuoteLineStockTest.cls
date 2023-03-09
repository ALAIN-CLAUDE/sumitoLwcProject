/**
 * @description       : Test class for INV_UpdateQuoteLineStock apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class INV_UpdateQuoteLineStockTest {
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
        
        Stock__c stock = new Stock__c();
        stock.Product__c = prod1.Id;
        stock.Quantity__c = 15;
        stock.Storage_Location__c = 'WH01';
        stock.Plant__c = 'DU01';
        insert stock;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = account.Id;
        quote.SBQQ__PricebookId__c = priceBook.Id;
        quote.SBQQ__Pricebook__c = priceBook.Id;
        quote.Delivering_Plant__c = 'DU01';
        insert quote;
        
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        
        SBQQ__QuoteLine__c quoteLine1 = new SBQQ__QuoteLine__c();
        quoteLine1.SBQQ__PricebookEntryId__c = pbe1.Id;
        quoteLine1.SBQQ__Product__c = prod1.Id;
        quoteLine1.SBQQ__Quantity__c = 1;
        quoteLine1.SBQQ__Quote__c = quote.Id;
        quoteLines.add(quoteLine1);
        
        SBQQ__QuoteLine__c quoteLine2 = new SBQQ__QuoteLine__c();
        quoteLine2.SBQQ__PricebookEntryId__c = pbe1.Id;
        quoteLine2.SBQQ__Product__c = prod1.Id;
        quoteLine2.SBQQ__Quantity__c = 1;
        quoteLine2.SBQQ__Quote__c = quote.Id;
        quoteLines.add(quoteLine2);
        insert quoteLines;
    }
    
    @isTest
    public static void testUpdateQuoteLineStock(){
        SBQQ__Quote__c quote = [SELECT Id, Delivering_Plant__c FROM SBQQ__Quote__c];
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT Id FROM SBQQ__QuoteLine__c];
        String quoteLineString = quote.Delivering_Plant__c + ';';
        
        for(SBQQ__QuoteLine__c quoteLine : quoteLines){
            quoteLineString += quoteLine.Id + ';';
        }
        
        Test.startTest();
        List<String> responses = INV_UpdateQuoteLineStock.updateQuoteLineStock(new List<String>{quoteLineString});
        Test.stopTest();
        
        for(String response : responses){
            System.assert(!response.contains('error'));
        }
    }
}