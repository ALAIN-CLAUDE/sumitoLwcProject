/**
 * @description       : Test class for B2B_Batch_UpsertShippingPriceBookEntries
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class B2B_Batch_UpsertShippingPriceBookEntTest {
	@testSetup
    public static void createData(){
        List<Product2> prods = new List<Product2>();
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Standard Shipping Charge';
        prod1.RIM_Size__c = '11';
        prod1.PDT_Code__c = 'Test1';
        prod1.StockKeepingUnit = 'Test1';
        prod1.ProductCode = 'Test1';
        prod1.x_distr_chain_status_code__c = 'ON';
        prod1.MatGRP2_Description__c = 'Car Steel';
        prod1.IsActive = true;
        insert prod1;

        List<PriceBookEntry> stdPbes = new List<PriceBookEntry>();
        stdPbes.add(new PriceBookEntry(Product2Id=prod1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=100));
        
        insert stdPbes;

        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = '6TestSAP142536';
        insert priceBook;
    }
    
    @isTest
    public static void testBatch(){
        Test.startTest();
        B2B_Batch_UpsertShippingPriceBookEntries batchClass = new B2B_Batch_UpsertShippingPriceBookEntries();
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<PriceBookEntry> prodCatProds = [SELECT Id FROM PriceBookEntry];
        System.assert(prodCatProds.size() > 0);
    }
}