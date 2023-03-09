/**
 * @description       : Test class for INV_UpdateOrderItemStockLevels
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-09-06   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class INV_UpdateOrderItemStockLevelsTest {

	@testSetup
    public static void createData(){
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
        prods.add(prod1);

        Product2 prod2 = new Product2();
        prod2.Name = 'Product2';
        prod2.RIM_Size__c = '12';
        prod2.PDT_Code__c = 'Test2';
        prod2.StockKeepingUnit = 'Test2';
        prod2.ProductCode = 'Test2';
        prods.add(prod2);

        Product2 prod3 = new Product2();
        prod3.Name = 'Product3';
        prod3.RIM_Size__c = '13';
        prod3.PDT_Code__c = 'Test3';
        prod3.StockKeepingUnit = 'Test3';
        prod3.ProductCode = 'Test3';
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
        priceBook.Account_SAP_Customer_Code__c = 'TestSAP142536';
        insert priceBook;
        
        List<PriceBookEntry> pbes = new List<PriceBookEntry>();
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Product2Id = prod1.Id;
        pbe1.IsActive = true;
        pbe1.UnitPrice = 150;
        pbe1.Pricebook2Id = priceBook.Id;
        pbes.add(pbe1);
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.Product2Id = prod2.Id;
        pbe2.IsActive = true;
        pbe2.UnitPrice = 250;
        pbe2.Pricebook2Id = priceBook.Id;
        pbes.add(pbe2);
        
        PriceBookEntry pbe3 = new PriceBookEntry();
        pbe3.Product2Id = prod3.Id;
        pbe3.IsActive = true;
        pbe3.UnitPrice = 350;
        pbe3.Pricebook2Id = priceBook.Id;
        pbes.add(pbe3);
        
        insert pbes;
        
        Order orderRec = new Order();
        orderRec.AccountId = account.Id;
        orderRec.Status = 'Draft';
        orderRec.Pricebook2Id = priceBook.Id;
        orderRec.EffectiveDate = System.today();
        orderRec.Delivering_Plant__c = 'CT01';
        insert orderRec;
        
        List<OrderItem> orderItems = new List<OrderItem>();
        
        OrderItem orderProd1 = new OrderItem();
        orderProd1.OrderId = orderRec.Id;
        orderProd1.Product2Id = prod1.Id;
        orderProd1.PricebookEntryId = pbe1.Id;
        orderProd1.Quantity = 1;
        orderProd1.UnitPrice = 750;
        orderProd1.SBQQ__Status__c = 'Draft';
        orderItems.add(orderProd1);
        
        OrderItem orderProd2 = new OrderItem();
        orderProd2.OrderId = orderRec.Id;
        orderProd2.Product2Id = prod2.Id;
        orderProd2.PricebookEntryId = pbe2.Id;
        orderProd2.Quantity = 1;
        orderProd2.UnitPrice = 750;
        orderProd2.SBQQ__Status__c = 'Draft';
        orderItems.add(orderProd2);
        
        OrderItem orderProd3 = new OrderItem();
        orderProd3.OrderId = orderRec.Id;
        orderProd3.Product2Id = prod3.Id;
        orderProd3.PricebookEntryId = pbe3.Id;
        orderProd3.Quantity = 1;
        orderProd3.UnitPrice = 750;
        orderProd3.SBQQ__Status__c = 'Draft';
        orderItems.add(orderProd3);
        
        OrderItem orderProd4 = new OrderItem();
        orderProd4.OrderId = orderRec.Id;
        orderProd4.Product2Id = prod3.Id;
        orderProd4.PricebookEntryId = pbe3.Id;
        orderProd4.Quantity = 1;
        orderProd4.UnitPrice = 750;
        orderProd4.SBQQ__Status__c = 'Draft';
        orderItems.add(orderProd4);

        insert orderItems;
    }
    
    @isTest
    public static void testUpdateProductStockLevels(){
        List<Order> orders = [SELECT Id FROM Order];
        List<String> orderIdStrings = new List<String>();
        Set<Id> prodIds = new Set<Id>();
        
        for(Order order : orders){
            orderIdStrings.add(order.Id);
        }
        
        List<OrderItem> orderItems = [SELECT Id, Product2Id FROM OrderItem WHERE OrderId IN: orderIdStrings];
        
        for(OrderItem orderItem : orderItems){
            prodIds.add(orderItem.Product2Id);
        }
        
        List<Stock__c> stocks = [SELECT Id, Quantity__c FROM Stock__c WHERE Product__c IN: prodIds AND Plant__c = 'CT01'];
        
        for(Stock__c stock : stocks){
            stock.Quantity__c = 100;
        }
        
        update stocks;
        
        Test.startTest();
        INV_UpdateOrderItemStockLevels.updateProductStockLevels(orderIdStrings);
        Test.stopTest();
    }
}