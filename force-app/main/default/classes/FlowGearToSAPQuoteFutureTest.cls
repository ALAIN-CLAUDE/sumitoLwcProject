/**
 * @description       : Test class for FlowGearToSAPQuoteFuture apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class FlowGearToSAPQuoteFutureTest {
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
        
        SBQQ__QuoteLine__c quoteLine = new SBQQ__QuoteLine__c();
        quoteLine.SBQQ__PricebookEntryId__c = pbe1.Id;
        quoteLine.SBQQ__Product__c = prod1.Id;
        quoteLine.SBQQ__Quantity__c = 1;
        quoteLine.SBQQ__Quote__c = quote.Id;
        insert quoteLine;
    }
    
    @isTest
    public static void testQuoteToSAP(){
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        FlowGearToSAPQuoteFuture.quoteToSAP(new List<String>{quote.Id});
        Test.stopTest();
    }
    
    @isTest
    public static void testQuoteToSAPNegative(){
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFlowGearNegative());
        FlowGearToSAPQuoteFuture.quoteToSAP(new List<String>{quote.Id});
        Test.stopTest();
    }
    
    @isTest
    public static void testQuoteToSAPPositive(){
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFlowGear());
        FlowGearToSAPQuoteFuture.quoteToSAP(new List<String>{quote.Id});
        Test.stopTest();
    }
    
    @isTest
    public static void testCallFlowGearFuture(){
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c LIMIT 1];
        String quoteToSAP = 'https://srisynchronous.flowgear.net/';
        String key = 'Key=soDIkqFuioadyfhadfgauiydgfasJbHjg';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        FlowGearToSAPQuoteFuture.callFlowGearFuture(key, quoteToSAP, quote.Id);
        Test.stopTest();
    }
    
    @isTest 
    public static void testGetFlowGearValues(){
        Test.startTest();
        FlowGearToSAPQuoteFuture.getFlowGearValues();
        Test.stopTest();
    }
}