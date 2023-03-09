/**
 * @author          Cihan Fethi Hizar
 * @createdDate     23 August 2022
 * @description     Test class for ProductOrderController Apex Class.
 */

@isTest
public class ProductOrderControllerTest {
    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 standardPricebook = new Pricebook2(    Id = pricebookId,    IsActive = true, CurrencyIsoCode='ZAR');
        update standardPricebook;

        Product2 product = new Product2(
                                Name = 'Test Product', 
                                Description = 'test description'
                            );
        insert product;

        PricebookEntry pbe = [SELECT Id, CurrencyIsoCode, UnitPrice FROM PricebookEntry WHERE Product2Id = :product.Id AND Pricebook2Id = :standardPricebook.Id][0];
        
        Order ord = new Order(
                        AccountId = acc.Id, 
                        EffectiveDate =  Date.valueOf('2022-04-08'), 
                        ByPassValidationRules__c = true, 
                        Status = 'Draft',
                        Name = 'Order 1001',
                        Pricebook2Id = standardPricebook.Id
                    );
        insert ord;
        Order ord2 = [SELECT AccountId, EffectiveDate, ByPassValidationRules__c, Status, Name, Pricebook2Id, CurrencyIsoCode
                      FROM Order WHERE Id = :ord.Id];
        ord2.CurrencyIsoCode = pbe.CurrencyIsoCode;
        update ord2;
        
        OrderItem ordItem = new OrderItem(
                                Product2Id = product.Id, 
                                OrderId = ord.Id, 
                                Quantity = 5,
                                Billed_Quantity__c = 5, 
                                Picked_Quantity__c = 5,
                                Shipped_Quantity__c = 5,
                                ListPrice = pbe.UnitPrice,
                                UnitPrice = 2.3,
                                TotalLineAmount = 8.0,
                                SBQQ__Status__c = 'Draft',
                                PricebookEntryId = pbe.Id
                            );
        insert ordItem;

        Order_Item_Detail__c oid = new Order_Item_Detail__c(
                                        Order_Product__c = ordItem.Id,
                                        Document_Number__c = 'D324521355'
                                    );
        insert oid;
    }

    @isTest
    static void getProductOrderDetailsTest() {
        Product2 pro = [SELECT Id FROM Product2][0];
        Test.startTest();
            ProductOrderController.getProductOrderDetails(pro.Id);
            try {
                OrderItem oi = [SELECT Id FROM OrderItem][0];
                delete oi;
                ProductOrderController.getProductOrderDetails('xyz');
            } catch(Exception e) {}
        Test.stopTest();
    }   

    @isTest
    static void getProductDetailsTest() {
        Product2 pro = [SELECT Id FROM Product2][0];
        Test.startTest();
            ProductOrderController.getProductDetails(pro.Id);
            try {
                ProductOrderController.getProductDetails('xyz');
            } catch(Exception e) {}
        Test.stopTest();
    }

    @isTest
    static void getOrderItemHistoryTest() {
        OrderItem oi = [SELECT Id FROM OrderItem][0];
        Test.startTest();
            ProductOrderController.getOrderItemHistory(oi.Id);
            try {
                ProductOrderController.getOrderItemHistory('xyz');
            } catch(Exception e) {}
        Test.stopTest();
    }

    @isTest
    static void getOrderItemDetailsTest() {
        OrderItem oi = [SELECT Id FROM OrderItem][0];
        Test.startTest();
            ProductOrderController.getOrderItemDetails(oi.Id);
            try {
                ProductOrderController.getOrderItemDetails('xyz');
            } catch(Exception e) {}
        Test.stopTest();
    }
}