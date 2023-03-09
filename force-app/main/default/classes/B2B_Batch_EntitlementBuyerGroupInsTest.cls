/**
 * @description       : Test class for B2B_Batch_EntitlementBuyerGroupInsert
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class B2B_Batch_EntitlementBuyerGroupInsTest {
	@testSetup
    public static void createData(){
        WebStore store = new WebStore();
        store.Name = 'Sumitomo Rubber South Africa';
        insert store;
        
        Account account = new Account();
		account.Name = 'SRSA';
		insert account;
        
        List<Product2> prods = new List<Product2>();
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Product1';
        prod1.RIM_Size__c = '11';
        prod1.PDT_Code__c = 'Test1';
        prod1.StockKeepingUnit = 'Test1';
        prod1.ProductCode = 'Test1';
        prod1.x_distr_chain_status_code__c = 'ON';
        prod1.IsActive = true;
        prods.add(prod1);

        Product2 prod2 = new Product2();
        prod2.Name = 'Product2';
        prod2.RIM_Size__c = '12';
        prod2.PDT_Code__c = 'Test2';
        prod2.StockKeepingUnit = 'Test2';
        prod2.ProductCode = 'Test2';
        prod2.x_distr_chain_status_code__c = 'ON';
        prod2.IsActive = true;
        prods.add(prod2);

        Product2 prod3 = new Product2();
        prod3.Name = 'Product3';
        prod3.RIM_Size__c = '13';
        prod3.PDT_Code__c = 'Test3';
        prod3.StockKeepingUnit = 'Test3';
        prod3.ProductCode = 'Test3';
        prod3.x_distr_chain_status_code__c = 'ON';
        prod3.IsActive = true;
        prods.add(prod3);
        
        insert prods;

        List<PriceBookEntry> stdPbes = new List<PriceBookEntry>();
        stdPbes.add(new PriceBookEntry(Product2Id=prod1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=100));
        stdPbes.add(new PriceBookEntry(Product2Id=prod2.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=200));
        stdPbes.add(new PriceBookEntry(Product2Id=prod3.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        
        insert stdPbes;

        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = '6TestSAP142536';
        insert priceBook;
        
        List<PriceBookEntry> pbes = new List<PriceBookEntry>();
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Product2Id = prod1.Id;
        pbe1.IsActive = true;
        pbe1.UnitPrice = 150;
        pbe1.Net_Price__c = 150;
        pbe1.Pricebook2Id = priceBook.Id;
        pbes.add(pbe1);
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.Product2Id = prod2.Id;
        pbe2.IsActive = false;
        pbe2.UnitPrice = 250;
        pbe2.Net_Price__c = 250;
        pbe2.Pricebook2Id = priceBook.Id;
        pbes.add(pbe2);
        
        PriceBookEntry pbe3 = new PriceBookEntry();
        pbe3.Product2Id = prod3.Id;
        pbe3.IsActive = true;
        pbe3.UnitPrice = 0;
        pbe3.Net_Price__c = 350;
        pbe3.Pricebook2Id = priceBook.Id;
        pbes.add(pbe3);
        
        insert pbes;
        
        CommerceEntitlementPolicy comEntPolicy = new CommerceEntitlementPolicy();
        comEntPolicy.Account_SAP_Customer_Code__c = '6TestSAP142536';
        comEntPolicy.Name = '6TestSAP142536';
        comEntPolicy.IsActive = true;
        comEntPolicy.Description = '6TestSAP142536';
        insert comEntPolicy;
        
        BuyerGroup bg = new BuyerGroup();
        bg.Name = '6TestSAP142536';
        bg.Account_SAP_Customer_Code__c = '6TestSAP142536';
        insert bg;
    }
    
    @isTest
    public static void testBatch(){
        Test.startTest();
        B2B_Batch_EntitlementBuyerGroupInsert batchClass = new B2B_Batch_EntitlementBuyerGroupInsert();
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<CommerceEntitlementBuyerGroup> comEntBuyerGroups = [SELECT Id FROM CommerceEntitlementBuyerGroup];
        System.assertEquals(1, comEntBuyerGroups.size());
    }
    
    @isTest
    public static void testBatchWithCustCodes(){
        Test.startTest();
        B2B_Batch_EntitlementBuyerGroupInsert batchClass = new B2B_Batch_EntitlementBuyerGroupInsert(new List<String>{'6TestSAP142536'});
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<CommerceEntitlementBuyerGroup> comEntBuyerGroups = [SELECT Id FROM CommerceEntitlementBuyerGroup];
        System.assertEquals(1, comEntBuyerGroups.size());
    }
}