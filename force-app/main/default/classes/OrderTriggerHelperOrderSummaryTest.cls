/**
 * @description       : Test class for OrderTriggerHelper apex class - This is a secondary class because in order to test Order Summary (SeeAllData=true) is needed and it can't be used in the main test class becaues it has an @testSetup method
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest(SeeAllData=true)
public class OrderTriggerHelperOrderSummaryTest {
    @isTest
    public static void testOrderTrigger(){
        Account account = new Account();
		account.Name = 'SRSA';
		insert account;

        Product2 testProProduct =  new Product2(
        Name = 'Product1',
        RIM_Size__c = '16',
        PDT_Code__c = 'Test11112022',
        StockKeepingUnit = 'Test11112022',
        ProductCode = 'Test11112022');
        insert testProProduct;
        
        PriceBookEntry pbentry = [SELECT Id FROM PriceBookEntry WHERE Product2Id =: testProProduct.Id AND PriceBook2.isStandard = true AND CurrencyISOCode = 'ZAR'];
        
        Order orderRec = new Order(
            EffectiveDate = Date.today(),
            Status = 'Draft',
            AccountId = account.id,
            OrderedDate = Datetime.newInstance(2022, 1, 2, 3, 4, 5),
            Pricebook2Id = System.Test.getStandardPricebookId()
        );
        insert orderRec;
        
        OrderDeliveryMethod orderDeliveryMethod = new OrderDeliveryMethod(
            Name = 'software-shipping',
            ProductId = testProProduct.Id
        );
        
        insert orderDeliveryMethod;
        
        OrderDeliveryGroup orderDeliveryGroup = new OrderDeliveryGroup(
            DeliverToName = 'Buyer USer',
            DeliverToStreet = 'test Street',
            DeliverToCity = 'Minneapolis',
            DeliverToState = 'MN',
            DeliverToPostalCode = '55402',
            DeliverToCountry = 'US',
            OrderDeliveryMethodId = orderDeliveryMethod.Id,
            OrderId = orderRec.Id
        );
        
        insert orderDeliveryGroup;
        
        Product2 productShipping =  new Product2(
        Name = 'productShipping',
        PDT_Code__c = 'productShippingTest11112022',
        StockKeepingUnit = 'productShippingTest11112022',
        ProductCode = 'productShippingTest11112022');
        insert productShipping;
        
        OrderItem orderItem = new OrderItem(
            Product2Id = testProProduct.Id,
            Type = 'Order Product',
            Quantity = 1,
            ListPrice = 1,
            UnitPrice = 1,
            OrderId = orderRec.Id,
            OrderDeliveryGroupId = orderDeliveryGroup.Id,
            PricebookEntryId = pbentry.Id,
            TotalLineAmount = 1
        );
        
        insert orderItem;

        orderRec.Status = 'Activated';
        orderRec.SF_PO_Number__c = 'Test11112022';
        update orderRec;

        ConnectApi.OrderSummaryInputRepresentation osir = new ConnectApi.OrderSummaryInputRepresentation();
        osir.orderId = orderRec.Id;
        osir.orderLifeCycleType = 'UNMANAGED';
        ConnectApi.OrderSummaryOutputRepresentation osor = ConnectApi.OrderSummaryCreation.createOrderSummary(
            osir
        );
    }
}