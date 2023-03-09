/**
 * @author          Cihan Fethi Hizar
 * @createdDate     29 August 2022
 * @description     Test class for ProductOrderController Apex Class, using all data in the org.
 */

@isTest
public class ProductOrderControllerTest2 {
    @isTest(seeAllData=true)
    static void getOrderHistoryTest() {

        Order o = [SELECT Id, AccountId, EffectiveDate, Status, Name, OrderNumber FROM Order WHERE Status = 'Activated'][0];
        OrderSummary os = [SELECT Id, OrderNumber FROM OrderSummary WHERE OrderNumber = :o.OrderNumber][0];
      
        Test.startTest();
            ProductOrderController.getOrderHistory(os.Id);
            try {
                ProductOrderController.getOrderHistory('xyz');
            } catch(Exception e) {}
        Test.stopTest();
    }

    @isTest(seeAllData=true)
    static void getOrderDetailsTest() {

        Order o = [SELECT Id, AccountId, EffectiveDate, Status, Name, OrderNumber FROM Order WHERE Status = 'Activated'][0];
        OrderSummary os = [SELECT Id, OrderNumber FROM OrderSummary WHERE OrderNumber = :o.OrderNumber][0];
      
        Test.startTest();
            ProductOrderController.getOrderDetails(os.Id);
            try {
                ProductOrderController.getOrderDetails('xyz');
            } catch(Exception e) {}
        Test.stopTest();
    }

    @isTest(seeAllData=true)
    static void getOrderItemSummariesWithTest() {

        Set<Id> oSet = new Set<Id>(); Set<Id> osSet = new Set<Id>(); Set<Id> oiSet = new Set<Id>();
        List<Order> oList = [SELECT Id, AccountId, EffectiveDate, Status, Name, OrderNumber FROM Order WHERE Status = 'Activated' LIMIT 20];
        for(Order o : oList) oSet.add(o.Id);
        List<OrderSummary> osList = [SELECT Id, OrderNumber, OriginalOrderId FROM OrderSummary WHERE OriginalOrderId IN :oSet];
        for(OrderSummary os : osList) osSet.add(os.Id);
        List<OrderItemSummary> oisList = [SELECT Id, OrderSummaryId, Name, OriginalOrderItemId, Status, TotalLineAmount, Quantity, ProductCode
                                FROM OrderItemSummary WHERE OrderSummaryId IN :osSet];
        for(OrderItemSummary ois : oisList) oiSet.add(ois.OriginalOrderItemId);
        List<OrderItem> oiList = [SELECT Id, Picked_Quantity__c, Billed_Quantity__c, Back_Ordered_Quantity__c, Shipped_Quantity__c,
                                  Product2Id, Product2.Product_Image_Link__c, Order.AccountId, SAP_Item_Number__c
                                  FROM OrderItem WHERE Id IN :oiSet];
        List<OrderItemHistory> oihList = [SELECT Id, Field, NewValue, OldValue, CreatedBy.Name, CreatedDate, OrderItemId
                                          FROM OrderItemHistory WHERE OrderItemId IN :oiSet];
      
        Test.startTest();
            for(OrderSummary os2 : osList)
                ProductOrderController.getOrderItemSummariesWithTracking(os2.Id);
            try {
                ProductOrderController.getOrderItemSummariesWithTracking('xyz');
            } catch(Exception e) {}
        Test.stopTest();
    }
}