/**
 * @description       : Test class for OrderTriggerHelper apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class OrderTriggerHelperTest {
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
        orderProd2.Product2Id = prod1.Id;
        orderProd2.PricebookEntryId = pbe1.Id;
        orderProd2.Quantity = 1;
        orderProd2.UnitPrice = 750;
        orderProd2.SBQQ__Status__c = 'Draft';
        orderItems.add(orderProd2);
        
        insert orderItems;
    }
    
    @isTest
    public static void testOrderTrigger(){
        Order orderRec = [SELECT Id FROM Order LIMIT 1];
        orderRec.Status = 'Being Fulfilled';
        update orderRec;
        
        OrderItem orderProd = [SELECT Id, SBQQ__Status__c FROM OrderItem LIMIT 1];
        orderProd.SBQQ__Status__c = 'Completed';
        
        Test.startTest();
        update orderProd;
        Test.stopTest();
        
        orderRec = [SELECT Id, Status FROM Order LIMIT 1];
        System.assert(orderRec.Status.equals('Being Fulfilled'));
    }
    
    @isTest
    public static void testOrderTriggerMultipleOrderItems(){
        Order orderRec = [SELECT Id FROM Order LIMIT 1];
        orderRec.Status = 'Being Fulfilled';
        update orderRec;
        
        List<OrderItem> orderProds = [SELECT Id, SBQQ__Status__c FROM OrderItem];
        
        for(OrderItem orderProd : orderProds){
            orderProd.SBQQ__Status__c = 'Completed';
        }
        
        Test.startTest();
        update orderProds;
        Test.stopTest();
        
        orderRec = [SELECT Id, Status FROM Order LIMIT 1];
        System.assert(orderRec.Status.equals('Completed'));
    }
    
    @isTest
    public static void testOrderTriggerMultipleOrderItemsBeingFulfilled(){
        Order orderRec = [SELECT Id FROM Order LIMIT 1];
        orderRec.Status = 'Draft';
        
        update orderRec;
        
        List<OrderItem> orderProds = [SELECT Id, SBQQ__Status__c FROM OrderItem];
        
        for(OrderItem orderProd : orderProds){
            orderProd.Picked_Quantity__c = 1;
        }
        
        Test.startTest();
        update orderProds;
        Test.stopTest();
        
        orderRec = [SELECT Id, Status FROM Order LIMIT 1];
        //System.assert(orderRec.Status.equals('Being Fulfilled'));
    }
}