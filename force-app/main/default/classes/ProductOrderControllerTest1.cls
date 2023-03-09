/**
* @author :         Alain Claude
* @createdDate :    21 November 2022
* @description :    Test class for ProductOrderController                
*/

@isTest
public class ProductOrderControllerTest1 {
    
    @isTest(seeAllData=true)
    static void getOrderHistory(){
        Product2 pro = [SELECT Id FROM Product2][0];     
        OrderSummary os = [SELECT Id, OrderNumber FROM OrderSummary WHERE OrderNumber != null][0];
        Order o = [SELECT Id, AccountId, EffectiveDate, Status, Name, OrderNumber FROM Order WHERE OrderNumber =: os.OrderNumber][0];
        OrderItem oiL = [SELECT Id,OrderId, Picked_Quantity__c, Billed_Quantity__c, Back_Ordered_Quantity__c, Shipped_Quantity__c,
                         Product2Id, Product2.Product_Image_Link__c, Order.AccountId, SAP_Item_Number__c
                         FROM OrderItem WHERE OrderId =: o.Id];
        Test.startTest();
        ProductOrderController.getOrderHistory(os.Id);
        ProductOrderController.getOrderDetails(os.Id);
        ProductOrderController.getOrderItemSummariesWithTracking(os.Id);
        ProductOrderController.getProductOrderDetails(pro.Id);
        ProductOrderController.getOrderItemHistory(oiL.id);
        ProductOrderController.getOrderItemDetails(oiL.id);
        
        try {
            
            ProductOrderController.getOrderHistory('xyz');
            ProductOrderController.getOrderDetails('xyz');
            ProductOrderController.getOrderItemSummariesWithTracking('xyz');
            ProductOrderController.getProductOrderDetails('xyz');      
            ProductOrderController.getOrderItemHistory('xyz');
            ProductOrderController.getOrderItemDetails('xyz');
            
        } catch(Exception e) {}
        
        Test.stopTest();
    }
    
    
}