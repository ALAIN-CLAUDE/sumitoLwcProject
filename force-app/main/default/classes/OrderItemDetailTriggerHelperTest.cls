/**
 * @description       : Test class for OrderItemDetailTriggerHelper
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-07-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class OrderItemDetailTriggerHelperTest {
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
        orderProd3.Quantity = 13;
        orderProd3.UnitPrice = 750;
        orderProd3.SBQQ__Status__c = 'Draft';
        orderItems.add(orderProd3);

        insert orderItems;
    }
    
    @isTest
    public static void testOrderItemDetailTrigger(){
        OrderItem ordItem = [SELECT Id, SBQQ__Status__c FROM OrderItem WHERE Quantity = 1 LIMIT 1];
        
        Test.startTest();

    	Order_Item_Detail__c ordItemDetail = new Order_Item_Detail__c();
        ordItemDetail.Billed_Date__c = System.today();
        ordItemDetail.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Billed_Quantity__c = 1;
        ordItemDetail.Order_Product__c = ordItem.Id;
        insert ordItemDetail;
        
        Test.stopTest();

        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Completed'));
    }
    
    @isTest
    public static void testOrderItemDetailTriggerLargeQuantity(){
        OrderItem ordItem = [SELECT Id, SBQQ__Status__c FROM OrderItem WHERE Quantity = 13 LIMIT 1];
        
        Test.startTest();
        
    	Order_Item_Detail__c ordItemDetail = new Order_Item_Detail__c();
        ordItemDetail.Billed_Date__c = System.today();
        ordItemDetail.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Billed_Quantity__c = 1;
        ordItemDetail.Order_Product__c = ordItem.Id;
        insert ordItemDetail;
        
        Test.stopTest();
        
        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Being Fulfilled'));
    }
    
    @isTest
    public static void testOrderItemDetailTriggerCompleteLargeQuantity(){
        OrderItem ordItem = [SELECT Id, SBQQ__Status__c FROM OrderItem WHERE Quantity = 13 LIMIT 1];
        List<Order_Item_Detail__c> ordItemDetails = new List<Order_Item_Detail__c>();
        
        Test.startTest();
        
    	Order_Item_Detail__c ordItemDetail1 = new Order_Item_Detail__c();
        ordItemDetail1.Billed_Date__c = System.today();
        ordItemDetail1.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail1.Billed_Quantity__c = 1;
        ordItemDetail1.Picked_Date__c = System.today();
        ordItemDetail1.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail1.Picked_Quantity__c = 1;
        ordItemDetail1.Shipped_Date__c = System.today();
        ordItemDetail1.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail1.Shipped_Quantity__c = 1;
        ordItemDetail1.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail1);
        
    	Order_Item_Detail__c ordItemDetail2 = new Order_Item_Detail__c();
        ordItemDetail2.Billed_Date__c = System.today();
        ordItemDetail2.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail2.Billed_Quantity__c = 1;
        ordItemDetail2.Picked_Date__c = System.today();
        ordItemDetail2.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail2.Picked_Quantity__c = 1;
        ordItemDetail2.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail2);
        
    	Order_Item_Detail__c ordItemDetail3 = new Order_Item_Detail__c();
        ordItemDetail3.Billed_Date__c = System.today();
        ordItemDetail3.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail3.Billed_Quantity__c = 1;
        ordItemDetail3.Shipped_Date__c = System.today();
        ordItemDetail3.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail3.Shipped_Quantity__c = 1;
        ordItemDetail3.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail3);
        
    	Order_Item_Detail__c ordItemDetail4 = new Order_Item_Detail__c();
        ordItemDetail4.Billed_Date__c = System.today();
        ordItemDetail4.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail4.Billed_Quantity__c = 1;
        ordItemDetail4.Picked_Date__c = System.today();
        ordItemDetail4.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail4.Picked_Quantity__c = 1;
        ordItemDetail4.Shipped_Date__c = System.today();
        ordItemDetail4.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail4.Shipped_Quantity__c = 1;
        ordItemDetail4.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail4);
        
    	Order_Item_Detail__c ordItemDetail5 = new Order_Item_Detail__c();
        ordItemDetail5.Billed_Date__c = System.today();
        ordItemDetail5.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail5.Billed_Quantity__c = 1;
        ordItemDetail5.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail5);
        
    	Order_Item_Detail__c ordItemDetail6 = new Order_Item_Detail__c();
        ordItemDetail6.Billed_Date__c = System.today();
        ordItemDetail6.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail6.Billed_Quantity__c = 1;
        ordItemDetail6.Picked_Date__c = System.today();
        ordItemDetail6.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail6.Picked_Quantity__c = 1;
        ordItemDetail6.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail6);
        
    	Order_Item_Detail__c ordItemDetail7 = new Order_Item_Detail__c();
        ordItemDetail7.Billed_Date__c = System.today();
        ordItemDetail7.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail7.Billed_Quantity__c = 1;
        ordItemDetail7.Shipped_Date__c = System.today();
        ordItemDetail7.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail7.Shipped_Quantity__c = 1;
        ordItemDetail7.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail7);
        
    	Order_Item_Detail__c ordItemDetail8 = new Order_Item_Detail__c();
        ordItemDetail8.Billed_Date__c = System.today();
        ordItemDetail8.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail8.Billed_Quantity__c = 1;
        ordItemDetail8.Picked_Date__c = System.today();
        ordItemDetail8.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail8.Picked_Quantity__c = 1;
        ordItemDetail8.Shipped_Date__c = System.today();
        ordItemDetail8.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail8.Shipped_Quantity__c = 1;
        ordItemDetail8.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail8);
        
    	Order_Item_Detail__c ordItemDetail9 = new Order_Item_Detail__c();
        ordItemDetail9.Billed_Date__c = System.today();
        ordItemDetail9.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail9.Billed_Quantity__c = 1;
        ordItemDetail9.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail9);
        
    	Order_Item_Detail__c ordItemDetail10 = new Order_Item_Detail__c();
        ordItemDetail10.Billed_Date__c = System.today();
        ordItemDetail10.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail10.Billed_Quantity__c = 1;
        ordItemDetail10.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail10);
        
    	Order_Item_Detail__c ordItemDetail11 = new Order_Item_Detail__c();
        ordItemDetail11.Billed_Date__c = System.today();
        ordItemDetail11.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail11.Billed_Quantity__c = 1;
        ordItemDetail11.Picked_Date__c = System.today();
        ordItemDetail11.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail11.Picked_Quantity__c = 1;
        ordItemDetail11.Shipped_Date__c = System.today();
        ordItemDetail11.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail11.Shipped_Quantity__c = 1;
        ordItemDetail11.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail11);
        
    	Order_Item_Detail__c ordItemDetail12 = new Order_Item_Detail__c();
        ordItemDetail12.Billed_Date__c = System.today();
        ordItemDetail12.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail12.Billed_Quantity__c = 1;
        ordItemDetail12.Picked_Date__c = System.today();
        ordItemDetail12.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail12.Picked_Quantity__c = 1;
        ordItemDetail12.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail12);
        
    	Order_Item_Detail__c ordItemDetail13 = new Order_Item_Detail__c();
        ordItemDetail13.Billed_Date__c = System.today();
        ordItemDetail13.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail13.Billed_Quantity__c = 1;
        ordItemDetail13.Shipped_Date__c = System.today();
        ordItemDetail13.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail13.Shipped_Quantity__c = 1;
        ordItemDetail13.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail13);
        
        insert ordItemDetails;
        
        Test.stopTest();
        
        Order_Item_Detail__c ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c, Order_Product__r.Quantity, Order_Product__r.Billed_Quantity__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail13.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Completed'));
    }
    
    @isTest
    public static void testOrderItemDetailTriggerShippedQuantity(){
        OrderItem ordItem = [SELECT Id, SBQQ__Status__c FROM OrderItem WHERE Quantity = 13 LIMIT 1];
        
        Test.startTest();
        
    	Order_Item_Detail__c ordItemDetail = new Order_Item_Detail__c();
        ordItemDetail.Shipped_Date__c = System.today();
        ordItemDetail.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Shipped_Quantity__c = 1;
        ordItemDetail.Order_Product__c = ordItem.Id;
        insert ordItemDetail;
        
        Test.stopTest();
        
        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Being Fulfilled'));
    }
    
    @isTest
    public static void testOrderItemDetailTriggerPickedQuantity(){
        OrderItem ordItem = [SELECT Id, SBQQ__Status__c FROM OrderItem WHERE Quantity = 13 LIMIT 1];
        
        Test.startTest();
        
    	Order_Item_Detail__c ordItemDetail = new Order_Item_Detail__c();
        ordItemDetail.Picked_Date__c = System.today();
        ordItemDetail.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Picked_Quantity__c = 1;
        ordItemDetail.Order_Product__c = ordItem.Id;
        insert ordItemDetail;
        
        Test.stopTest();
        
        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Being Fulfilled'));
    }
    
    @isTest
    public static void testOrderItemDetailTriggerUpdateBilledQuantity(){
        OrderItem ordItem = [SELECT Id, SBQQ__Status__c FROM OrderItem WHERE Quantity = 13 LIMIT 1];
        List<Order_Item_Detail__c> ordItemDetails = new List<Order_Item_Detail__c>();
        
        Test.startTest();
        
    	Order_Item_Detail__c ordItemDetail = new Order_Item_Detail__c();
        ordItemDetail.Picked_Date__c = System.today();
        ordItemDetail.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Picked_Quantity__c = 1;
        ordItemDetail.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail);
        
    	Order_Item_Detail__c ordItemDetail2 = new Order_Item_Detail__c();
        ordItemDetail.Shipped_Date__c = System.today();
        ordItemDetail.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Shipped_Quantity__c = 1;
        ordItemDetail2.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail2);
        
        insert ordItemDetails;
        
        
        ordItemDetails = new List<Order_Item_Detail__c>();
        
        ordItemDetail.Billed_Date__c = System.today();
        ordItemDetail.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Billed_Quantity__c = 3;
        ordItemDetails.add(ordItemDetail);
        
        ordItemDetail2.Billed_Date__c = System.today();
        ordItemDetail2.Billed_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail2.Billed_Quantity__c = 10;
        ordItemDetails.add(ordItemDetail2);
        
        update ordItemDetails;
        
        Test.stopTest();
        
        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Completed'));
    }
    
    @isTest
    public static void testOrderItemDetailTriggerUpdatePickedQuantity(){
        OrderItem ordItem = [SELECT Id, SBQQ__Status__c FROM OrderItem WHERE Quantity = 13 LIMIT 1];
        List<Order_Item_Detail__c> ordItemDetails = new List<Order_Item_Detail__c>();
        
        Test.startTest();
        
    	Order_Item_Detail__c ordItemDetail = new Order_Item_Detail__c();
        ordItemDetail.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail);
        
    	Order_Item_Detail__c ordItemDetail2 = new Order_Item_Detail__c();
        ordItemDetail2.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail2);
        insert ordItemDetails;
        
        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Draft'));
        
        ordItemDetails = new List<Order_Item_Detail__c>();
        
        ordItemDetail.Picked_Date__c = System.today();
        ordItemDetail.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Picked_Quantity__c = 1;
        ordItemDetails.add(ordItemDetail);
        
        ordItemDetail2.Picked_Date__c = System.today();
        ordItemDetail2.Picked_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail2.Picked_Quantity__c = 10;
        ordItemDetails.add(ordItemDetail2);
        
        update ordItemDetails;
        
        Test.stopTest();
        
        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Being Fulfilled'));
    }
    
    @isTest
    public static void testOrderItemDetailTriggerUpdateShippedQuantity(){
        OrderItem ordItem = [SELECT Id, SBQQ__Status__c FROM OrderItem WHERE Quantity = 13 LIMIT 1];
        List<Order_Item_Detail__c> ordItemDetails = new List<Order_Item_Detail__c>();
        
        Test.startTest();
    	Order_Item_Detail__c ordItemDetail = new Order_Item_Detail__c();
        ordItemDetail.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail);
        
    	Order_Item_Detail__c ordItemDetail2 = new Order_Item_Detail__c();
        ordItemDetail2.Order_Product__c = ordItem.Id;
        ordItemDetails.add(ordItemDetail2);
        insert ordItemDetails;
        
        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Draft'));

        ordItemDetails = new List<Order_Item_Detail__c>();
        
        ordItemDetail.Shipped_Date__c = System.today();
        ordItemDetail.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail.Shipped_Quantity__c = 1;
        ordItemDetails.add(ordItemDetail);
        
        ordItemDetail2.Shipped_Date__c = System.today();
        ordItemDetail2.Shipped_Time__c = Time.newInstance(3, 14, 15, 926);
        ordItemDetail2.Shipped_Quantity__c = 10;
        ordItemDetails.add(ordItemDetail2);
        
        update ordItemDetails;
        
        Test.stopTest();
        
        ordItemDetail = [SELECT Id, Order_Product__r.SBQQ__Status__c FROM Order_Item_Detail__c WHERE Id =: ordItemDetail.Id];
        System.assert(ordItemDetail.Order_Product__r.SBQQ__Status__c.equals('Being Fulfilled'));
    }
}