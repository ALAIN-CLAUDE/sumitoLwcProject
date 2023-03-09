@IsTest
public with sharing class CartCheckoutController_Test {
    @IsTest
    static void getCartData_Test(){
        String storeName = Label.B2B_Store_Name;
        Account acc = new Account(Name = 'B2B Test Account', Block_Central_Billing__c = '01', Block_Central_Delivery__c = 'LM', Block_Central_Order__c = '01', Delivering_Plant__c = 'JP01');
        insert acc;
        WebStore ws = new WebStore(Name = storeName);
        insert ws;
        WebCart wc = new WebCart(Name = 'B2B Test WebCart', AccountId = acc.Id, Status = 'Active', TaxType = 'Net', Type = 'Cart', WebStoreId = ws.Id);
        insert wc;
        CartDeliveryGroup cdg = new CartDeliveryGroup(Name = 'B2B Test CartDeliveryGroup', CartId = wc.Id);
        insert cdg;
        CartItem ci = new CartItem(Name = 'B2B Test CartItem', CartId = wc.Id, CartDeliveryGroupId = cdg.Id);
        insert ci;
        CartCheckoutController.getCartData(wc.Id, acc.Id);
    }

    @IsTest
    static void setFlowType_Test(){
        CartCheckoutController.setFlowType('Quote');
    }
}