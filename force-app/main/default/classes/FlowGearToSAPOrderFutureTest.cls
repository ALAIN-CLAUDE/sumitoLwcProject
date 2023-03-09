/**
 * @description       : Test class for FlowGearToSAPOrderFuture apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class FlowGearToSAPOrderFutureTest {
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
        
        OrderItem orderProd = new OrderItem();
        orderProd.OrderId = orderRec.Id;
        orderProd.Product2Id = prod1.Id;
        orderProd.PricebookEntryId = pbe1.Id;
        orderProd.Quantity = 1;
        orderProd.UnitPrice = 750;
        insert orderProd;
    }
	
    @isTest
    public static void testOrderToSAP(){
        Order order = [SELECT Id FROM Order LIMIT 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFlowGear());
        FlowGearToSAPOrderFuture.orderToSAP(new List<String>{order.Id});
        Test.stopTest();
    }
    
    @isTest
    public static void testOrderToSAPStatusCode(){
        Order order = [SELECT Id FROM Order LIMIT 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFlowGearStatCode());
        FlowGearToSAPOrderFuture.orderToSAP(new List<String>{order.Id});
        Test.stopTest();
    }
    
    @isTest
    public static void testOrderToSAPNegative(){
        Order order = [SELECT Id FROM Order LIMIT 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFlowGearNegative());
        FlowGearToSAPOrderFuture.orderToSAP(new List<String>{order.Id});
        Test.stopTest();
    }
    
    @isTest
    public static void testOrderToSAPUpdatedOrder(){
        Order order = [SELECT Id FROM Order LIMIT 1];
        order.SAP_Order_Number__c = '2024903005';
        update order;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFlowGear());
        FlowGearToSAPOrderFuture.orderToSAP(new List<String>{order.Id});
        Test.stopTest();
    }
    
    @isTest
    public static void testGetFlowGearValues(){
        Test.startTest();
        FlowGearToSAPOrderFuture.getFlowGearValues();
        Test.stopTest();  
    }
}