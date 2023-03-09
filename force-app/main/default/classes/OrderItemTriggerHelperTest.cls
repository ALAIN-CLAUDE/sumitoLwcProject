/**
 * @description       : Test class for OrderItemTriggerHelper
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-07-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class OrderItemTriggerHelperTest {
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

        Product2 prod4 = new Product2();
        prod4.Name = 'Product4';
        prod4.RIM_Size__c = '14';
        prod4.PDT_Code__c = 'Test4';
        prod4.StockKeepingUnit = 'Test4';
        prod4.ProductCode = 'Test4';
        prods.add(prod4);

        Product2 prod5 = new Product2();
        prod5.Name = 'Product5';
        prod5.RIM_Size__c = '15';
        prod5.PDT_Code__c = 'Test5';
        prod5.StockKeepingUnit = 'Test5';
        prod5.ProductCode = 'Test5';
        prods.add(prod5);

        Product2 prod6 = new Product2();
        prod6.Name = 'Product6';
        prod6.RIM_Size__c = '16';
        prod6.PDT_Code__c = 'Test6';
        prod6.StockKeepingUnit = 'Test6';
        prod6.ProductCode = 'Test6';
        prods.add(prod6);

        Product2 prod7 = new Product2();
        prod7.Name = 'Product7';
        prod7.RIM_Size__c = '17';
        prod7.PDT_Code__c = 'Test7';
        prod7.StockKeepingUnit = 'Test7';
        prod7.ProductCode = 'Test7';
        prods.add(prod7);

        Product2 prod8 = new Product2();
        prod8.Name = 'Product8';
        prod8.RIM_Size__c = '18';
        prod8.PDT_Code__c = 'Test8';
        prod8.StockKeepingUnit = 'Test8';
        prod8.ProductCode = 'Test8';
        prods.add(prod8);

        Product2 prod9 = new Product2();
        prod9.Name = 'Product9';
        prod9.RIM_Size__c = '19';
        prod9.PDT_Code__c = 'Test9';
        prod9.StockKeepingUnit = 'Test9';
        prod9.ProductCode = 'Test9';
        prods.add(prod9);

        Product2 prod10 = new Product2();
        prod10.Name = 'Product10';
        prod10.RIM_Size__c = '10';
        prod10.PDT_Code__c = 'Test10';
        prod10.StockKeepingUnit = 'Test10';
        prod10.ProductCode = 'Test10';
        prods.add(prod10);

        Product2 prod11 = new Product2();
        prod11.Name = 'Product11';
        prod11.RIM_Size__c = '11';
        prod11.PDT_Code__c = 'Test11';
        prod11.StockKeepingUnit = 'Test11';
        prod11.ProductCode = 'Test11';
        prods.add(prod11);

        Product2 prod12 = new Product2();
        prod12.Name = 'Product12';
        prod12.RIM_Size__c = '12';
        prod12.PDT_Code__c = 'Test12';
        prod12.StockKeepingUnit = 'Test12';
        prod12.ProductCode = 'Test12';
        prods.add(prod12);

        Product2 prod13 = new Product2();
        prod13.Name = 'Product13';
        prod13.RIM_Size__c = '13';
        prod13.PDT_Code__c = 'Test13';
        prod13.StockKeepingUnit = 'Test13';
        prod13.ProductCode = 'Test13';
        prods.add(prod13);

        Product2 prod14 = new Product2();
        prod14.Name = 'Product14';
        prod14.RIM_Size__c = '14';
        prod14.PDT_Code__c = 'Test14';
        prod14.StockKeepingUnit = 'Test14';
        prod14.ProductCode = 'Test14';
        prods.add(prod14);

        Product2 prod15 = new Product2();
        prod15.Name = 'Product15';
        prod15.RIM_Size__c = '15';
        prod15.PDT_Code__c = 'Test15';
        prod15.StockKeepingUnit = 'Test15';
        prod15.ProductCode = 'Test15';
        prods.add(prod15);
        
        insert prods;

        List<PriceBookEntry> stdPbes = new List<PriceBookEntry>();
        stdPbes.add(new PriceBookEntry(Product2Id=prod1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=100));
        stdPbes.add(new PriceBookEntry(Product2Id=prod2.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=200));
        stdPbes.add(new PriceBookEntry(Product2Id=prod3.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod4.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=400));
        stdPbes.add(new PriceBookEntry(Product2Id=prod5.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=500));
        stdPbes.add(new PriceBookEntry(Product2Id=prod6.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=600));
        stdPbes.add(new PriceBookEntry(Product2Id=prod7.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=700));
        stdPbes.add(new PriceBookEntry(Product2Id=prod8.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=800));
        stdPbes.add(new PriceBookEntry(Product2Id=prod9.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=900));
        stdPbes.add(new PriceBookEntry(Product2Id=prod10.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=1000));
        stdPbes.add(new PriceBookEntry(Product2Id=prod11.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=1100));
        stdPbes.add(new PriceBookEntry(Product2Id=prod12.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=1200));
        stdPbes.add(new PriceBookEntry(Product2Id=prod13.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=1300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod14.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=1400));
        stdPbes.add(new PriceBookEntry(Product2Id=prod15.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=1500));
        
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
        
        PriceBookEntry pbe4 = new PriceBookEntry();
        pbe4.Product2Id = prod4.Id;
        pbe4.IsActive = true;
        pbe4.UnitPrice = 450;
        pbe4.Pricebook2Id = priceBook.Id;
        pbes.add(pbe4);
        
        PriceBookEntry pbe5 = new PriceBookEntry();
        pbe5.Product2Id = prod5.Id;
        pbe5.IsActive = true;
        pbe5.UnitPrice = 550;
        pbe5.Pricebook2Id = priceBook.Id;
        pbes.add(pbe5);
        
        PriceBookEntry pbe6 = new PriceBookEntry();
        pbe6.Product2Id = prod6.Id;
        pbe6.IsActive = true;
        pbe6.UnitPrice = 650;
        pbe6.Pricebook2Id = priceBook.Id;
        pbes.add(pbe6);
        
        PriceBookEntry pbe7 = new PriceBookEntry();
        pbe7.Product2Id = prod7.Id;
        pbe7.IsActive = true;
        pbe7.UnitPrice = 750;
        pbe7.Pricebook2Id = priceBook.Id;
        pbes.add(pbe7);
        
        PriceBookEntry pbe8 = new PriceBookEntry();
        pbe8.Product2Id = prod8.Id;
        pbe8.IsActive = true;
        pbe8.UnitPrice = 850;
        pbe8.Pricebook2Id = priceBook.Id;
        pbes.add(pbe8);
        
        PriceBookEntry pbe9 = new PriceBookEntry();
        pbe9.Product2Id = prod9.Id;
        pbe9.IsActive = true;
        pbe9.UnitPrice = 950;
        pbe9.Pricebook2Id = priceBook.Id;
        pbes.add(pbe9);
        
        PriceBookEntry pbe10 = new PriceBookEntry();
        pbe10.Product2Id = prod10.Id;
        pbe10.IsActive = true;
        pbe10.UnitPrice = 1050;
        pbe10.Pricebook2Id = priceBook.Id;
        pbes.add(pbe10);
        
        PriceBookEntry pbe11 = new PriceBookEntry();
        pbe11.Product2Id = prod11.Id;
        pbe11.IsActive = true;
        pbe11.UnitPrice = 1150;
        pbe11.Pricebook2Id = priceBook.Id;
        pbes.add(pbe11);
        
        PriceBookEntry pbe12 = new PriceBookEntry();
        pbe12.Product2Id = prod12.Id;
        pbe12.IsActive = true;
        pbe12.UnitPrice = 1250;
        pbe12.Pricebook2Id = priceBook.Id;
        pbes.add(pbe12);
        
        PriceBookEntry pbe13 = new PriceBookEntry();
        pbe13.Product2Id = prod13.Id;
        pbe13.IsActive = true;
        pbe13.UnitPrice = 1350;
        pbe13.Pricebook2Id = priceBook.Id;
        pbes.add(pbe13);
        
        PriceBookEntry pbe14 = new PriceBookEntry();
        pbe14.Product2Id = prod14.Id;
        pbe14.IsActive = true;
        pbe14.UnitPrice = 1450;
        pbe14.Pricebook2Id = priceBook.Id;
        pbes.add(pbe14);
        
        PriceBookEntry pbe15 = new PriceBookEntry();
        pbe15.Product2Id = prod15.Id;
        pbe15.IsActive = true;
        pbe15.UnitPrice = 1550;
        pbe15.Pricebook2Id = priceBook.Id;
        pbes.add(pbe15);
        
        insert pbes;
        
        Order orderRec = new Order();
        orderRec.AccountId = account.Id;
        orderRec.Status = 'Draft';
        orderRec.Pricebook2Id = priceBook.Id;
        orderRec.EffectiveDate = System.today();
        insert orderRec;
        
        List<OrderItem> orderItems = new List<OrderItem>();
        
        OrderItem orderProd1 = new OrderItem();
        orderProd1.OrderId = orderRec.Id;
        orderProd1.Product2Id = prod1.Id;
        orderProd1.PricebookEntryId = pbe1.Id;
        orderProd1.Quantity = 1;
        orderProd1.UnitPrice = 750;
        orderItems.add(orderProd1);
        
        OrderItem orderProd2 = new OrderItem();
        orderProd2.OrderId = orderRec.Id;
        orderProd2.Product2Id = prod2.Id;
        orderProd2.PricebookEntryId = pbe2.Id;
        orderProd2.Quantity = 1;
        orderProd2.UnitPrice = 750;
        orderItems.add(orderProd2);
        
        OrderItem orderProd3 = new OrderItem();
        orderProd3.OrderId = orderRec.Id;
        orderProd3.Product2Id = prod3.Id;
        orderProd3.PricebookEntryId = pbe3.Id;
        orderProd3.Quantity = 1;
        orderProd3.UnitPrice = 750;
        orderItems.add(orderProd3);
        
        OrderItem orderProd4 = new OrderItem();
        orderProd4.OrderId = orderRec.Id;
        orderProd4.Product2Id = prod4.Id;
        orderProd4.PricebookEntryId = pbe4.Id;
        orderProd4.Quantity = 1;
        orderProd4.UnitPrice = 750;
        orderItems.add(orderProd4);
        
        OrderItem orderProd5 = new OrderItem();
        orderProd5.OrderId = orderRec.Id;
        orderProd5.Product2Id = prod5.Id;
        orderProd5.PricebookEntryId = pbe5.Id;
        orderProd5.Quantity = 1;
        orderProd5.UnitPrice = 750;
        orderItems.add(orderProd5);
        
        OrderItem orderProd6 = new OrderItem();
        orderProd6.OrderId = orderRec.Id;
        orderProd6.Product2Id = prod6.Id;
        orderProd6.PricebookEntryId = pbe6.Id;
        orderProd6.Quantity = 1;
        orderProd6.UnitPrice = 750;
        orderItems.add(orderProd6);
        
        OrderItem orderProd7 = new OrderItem();
        orderProd7.OrderId = orderRec.Id;
        orderProd7.Product2Id = prod7.Id;
        orderProd7.PricebookEntryId = pbe7.Id;
        orderProd7.Quantity = 1;
        orderProd7.UnitPrice = 750;
        orderItems.add(orderProd7);
        
        OrderItem orderProd8 = new OrderItem();
        orderProd8.OrderId = orderRec.Id;
        orderProd8.Product2Id = prod8.Id;
        orderProd8.PricebookEntryId = pbe8.Id;
        orderProd8.Quantity = 1;
        orderProd8.UnitPrice = 750;
        orderItems.add(orderProd8);
        
        OrderItem orderProd9 = new OrderItem();
        orderProd9.OrderId = orderRec.Id;
        orderProd9.Product2Id = prod9.Id;
        orderProd9.PricebookEntryId = pbe9.Id;
        orderProd9.Quantity = 1;
        orderProd9.UnitPrice = 750;
        orderItems.add(orderProd9);
        
        OrderItem orderProd10 = new OrderItem();
        orderProd10.OrderId = orderRec.Id;
        orderProd10.Product2Id = prod10.Id;
        orderProd10.PricebookEntryId = pbe10.Id;
        orderProd10.Quantity = 13;
        orderProd10.UnitPrice = 750;
        orderItems.add(orderProd10);
        
        OrderItem orderProd11 = new OrderItem();
        orderProd11.OrderId = orderRec.Id;
        orderProd11.Product2Id = prod11.Id;
        orderProd11.PricebookEntryId = pbe11.Id;
        orderProd11.Quantity = 13;
        orderProd11.UnitPrice = 750;
        orderItems.add(orderProd11);
        
        OrderItem orderProd12 = new OrderItem();
        orderProd12.OrderId = orderRec.Id;
        orderProd12.Product2Id = prod12.Id;
        orderProd12.PricebookEntryId = pbe12.Id;
        orderProd12.Quantity = 13;
        orderProd12.UnitPrice = 750;
        orderItems.add(orderProd12);
        
        OrderItem orderProd13 = new OrderItem();
        orderProd13.OrderId = orderRec.Id;
        orderProd13.Product2Id = prod13.Id;
        orderProd13.PricebookEntryId = pbe13.Id;
        orderProd13.Quantity = 13;
        orderProd13.UnitPrice = 750;
        orderItems.add(orderProd13);
        
        OrderItem orderProd14 = new OrderItem();
        orderProd14.OrderId = orderRec.Id;
        orderProd14.Product2Id = prod14.Id;
        orderProd14.PricebookEntryId = pbe14.Id;
        orderProd14.Quantity = 13;
        orderProd14.UnitPrice = 750;
        orderItems.add(orderProd14);
        
        OrderItem orderProd15 = new OrderItem();
        orderProd15.OrderId = orderRec.Id;
        orderProd15.Product2Id = prod15.Id;
        orderProd15.PricebookEntryId = pbe15.Id;
        orderProd15.Quantity = 13;
        orderProd15.UnitPrice = 750;
        orderItems.add(orderProd15);
        
        OrderItem orderProdNoPB1 = new OrderItem();
        orderProdNoPB1.OrderId = orderRec.Id;
        orderProdNoPB1.Product2Id = prod1.Id;
        orderProdNoPB1.Quantity = 1;
        orderProdNoPB1.UnitPrice = 750;
        orderItems.add(orderProdNoPB1);
        
        OrderItem orderProdNoPB2 = new OrderItem();
        orderProdNoPB2.OrderId = orderRec.Id;
        orderProdNoPB2.Product2Id = prod2.Id;
        orderProdNoPB2.Quantity = 1;
        orderProdNoPB2.UnitPrice = 750;
        orderItems.add(orderProdNoPB2);
        
        OrderItem orderProdNoPB3 = new OrderItem();
        orderProdNoPB3.OrderId = orderRec.Id;
        orderProdNoPB3.Product2Id = prod3.Id;
        orderProdNoPB3.Quantity = 1;
        orderProdNoPB3.UnitPrice = 750;
        orderItems.add(orderProdNoPB3);
        
        insert orderItems;
    }
    
    @isTest
    public static void testOrderItemTrigger(){
        Order orderRec = [SELECT Id FROM Order LIMIT 1];
        orderRec.Status = 'Being Fulfilled';
        update orderRec;

        OrderItem orderProd = [SELECT Id, SBQQ__Status__c, Billed_Quantity__c, Quantity FROM OrderItem LIMIT 1];
        orderProd.Billed_Quantity__c = orderProd.Quantity;
        
        Test.startTest();
        update orderProd;
        Test.stopTest();

        orderProd = [SELECT Id, SBQQ__Status__c FROM OrderItem LIMIT 1];
        System.assert(orderProd.SBQQ__Status__c.equals('Completed'));

        orderRec = [SELECT Id, Status FROM Order LIMIT 1];
        System.assert(orderRec.Status.equals('Being Fulfilled'));
    }
    
    @isTest
    public static void testOrderItemTriggerMultipleOrderItems(){
        Order orderRec = [SELECT Id FROM Order LIMIT 1];
        orderRec.Status = 'Being Fulfilled';
        update orderRec;

        List<OrderItem> orderProds = [SELECT Id, SBQQ__Status__c, Billed_Quantity__c, Quantity, Product2.Name FROM OrderItem];
        
        for(OrderItem orderProd : orderProds){
            orderProd.Billed_Quantity__c = orderProd.Quantity;
        }
        
        Test.startTest();
        update orderProds;
        Test.stopTest();
        
        orderProds = [SELECT Id, SBQQ__Status__c, Billed_Quantity__c, Quantity, Product2.Name FROM OrderItem];
        
        for(OrderItem orderProd : orderProds){
            System.assert(orderProd.SBQQ__Status__c.equals('Completed'));
        }

        orderRec = [SELECT Id, Status FROM Order LIMIT 1];
        System.assert(orderRec.Status.equals('Completed'));
    }
    
    @isTest
    public static void testOrderItemTriggerDifferentQuantity(){
        OrderItem orderProd = [SELECT Id, SBQQ__Status__c, Billed_Quantity__c, Quantity FROM OrderItem LIMIT 1];
        orderProd.Billed_Quantity__c = 5;
        
        Test.startTest();
        update orderProd;
        Test.stopTest();
        
        orderProd = [SELECT Id, SBQQ__Status__c FROM OrderItem LIMIT 1];
        System.assert(orderProd.SBQQ__Status__c.equals('Being Fulfilled'));
    }
}