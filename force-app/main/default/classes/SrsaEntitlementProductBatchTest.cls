/**
 * @description       : Test class for SrsaEntitlementProductBatch
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class SrsaEntitlementProductBatchTest {

    @testSetup
    public static void createData(){
        WebStore store = new WebStore();
        store.Name = 'Sumitomo Rubber South Africa';
        insert store;
        
        Account account = new Account();
		account.Name = 'SRSA';
        account.Stage__c = 'Active';
        account.SAP_Customer_Code__c = '6TestSAP142536';
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
        
        List<CommerceEntitlementProduct> comEntProds = new List<CommerceEntitlementProduct>();
        
        CommerceEntitlementProduct comEntProd1 = new CommerceEntitlementProduct();
        comEntProd1.Entitlement_Name__c = comEntPolicy.Name;
        comEntProd1.Entitlement_Name_Product_Code__c = comEntPolicy.Name + prod1.ProductCode;
        comEntProd1.PolicyId = comEntPolicy.Id;
        comEntProd1.ProductId = prod1.Id;
        comEntProd1.Product_Code__c = prod1.ProductCode;
        comEntProds.add(comEntProd1);
        
        CommerceEntitlementProduct comEntProd2 = new CommerceEntitlementProduct();
        comEntProd2.Entitlement_Name__c = comEntPolicy.Name;
        comEntProd2.Entitlement_Name_Product_Code__c = comEntPolicy.Name + prod2.ProductCode;
        comEntProd2.PolicyId = comEntPolicy.Id;
        comEntProd2.ProductId = prod2.Id;
        comEntProd2.Product_Code__c = prod2.ProductCode;
        comEntProds.add(comEntProd2);
        
        CommerceEntitlementProduct comEntProd3 = new CommerceEntitlementProduct();
        comEntProd3.Entitlement_Name__c = comEntPolicy.Name;
        comEntProd3.Entitlement_Name_Product_Code__c = comEntPolicy.Name + prod3.ProductCode;
        comEntProd3.PolicyId = comEntPolicy.Id;
        comEntProd3.ProductId = prod3.Id;
        comEntProd3.Product_Code__c = prod3.ProductCode;
        comEntProds.add(comEntProd3);
        
        insert comEntProds;
    }
    
    @isTest
    public static void testStartBatchJob(){
        Test.startTest();
        SrsaEntitlementProductBatch.startBatchJob();
        Test.stopTest();
    }
}