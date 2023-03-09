public with sharing class CartCheckoutController {

    @AuraEnabled
    public static Map<String, Object> getCartData(String cartId, String effectiveAccountId) {
        Map<String, Object> out = new Map<String, Object>();

        clearUserFlowType();

        Account account = [
                SELECT Id, Credit_Limit_Available__c, Block_Central_Billing__c,
                        Block_Central_Delivery__c, Block_Central_Order__c, Delivering_Plant__c
                FROM Account
                WHERE Id = :effectiveAccountId
        ];

        WebCart cart = [
                SELECT Id, TotalAmount, UniqueProductCount, (
                        SELECT Id, Quantity, Product2Id, Product2.ProductCode, Product2.Name
                        FROM CartItems
                        WHERE Type != 'Charge'
                )
                FROM WebCart
                WHERE Id = :cartId
        ];

        out.put('errorsQuick', evaluateCartQuickErrors(cart, account));
        out.put('errorsNew', evaluateCartNewErrors(cart, account));
        out.put('errorsReqQuote',evaluateCartSubmitQuote()); 
        out.put('errorsLockout',evaluateCartLockout());

        return out;
    }

    @AuraEnabled
    public static void setFlowType(String type) {
        User user = [
                SELECT Id
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];

        user.Checkout_Flow_Type__c = type;
        update user;
    }

    private static List<String> evaluateCartQuickErrors(WebCart cart, Account account) {
        List<String> errors = new List<String>();
        User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()]; 
        String cartItemQuantity = 'Quick order qty over 4: ';
        String cartItemStock = 'No stock for quick order: ';

        if(currentUser.Profile.Name.equals('B2B Customer Community Plus - Counter Hand') || currentUser.Profile.Name.equals('B2B Customer Community Plus - Accounts')){
            errors.add(Label.Cart_Error_Profile_Counter_Hand);
            return errors;
        }
        
        B2B_Custom_Variables__mdt QQ_Limited_Cart_Item_Quantity = [
                SELECT Id, Numeric_Value__c
                FROM B2B_Custom_Variables__mdt
                WHERE DeveloperName = 'QQ_Limited_Cart_Item_Quantity'
        ];
        B2B_Custom_Variables__mdt QQ_Limited_Number_of_Cart_Items = [
                SELECT Id, Numeric_Value__c
                FROM B2B_Custom_Variables__mdt
                WHERE DeveloperName = 'QQ_Limited_Number_of_Cart_Items'
        ];

        if (cart.TotalAmount > account.Credit_Limit_Available__c) {
            errors.add(Label.Cart_Error_NoCredit);
        }

        if (String.isNotEmpty(account.Block_Central_Order__c)) {
            errors.add(Label.Cart_Error_OrderingBlocked);
        }

        if (QQ_Limited_Number_of_Cart_Items.Numeric_Value__c < Cart.UniqueProductCount) {
            errors.add(Label.Cart_Error_TooManyCartItems);
            return errors;
        }
        
        Map<Id, CartItem> cartItemsStockMap = new Map<Id, CartItem>();
        Map<Id, Decimal> stockMap = new Map<Id, Decimal>();
        for (CartItem ci : cart.CartItems) {
            if (ci.Quantity > QQ_Limited_Cart_Item_Quantity.Numeric_Value__c) {
                //cartItemQuantity += ci.Product2.Name + ' - ' + ci.Product2.ProductCode + ', ';
                cartItemQuantity += ci.Product2.ProductCode + ', ';
            }

            cartItemsStockMap.put(ci.Product2Id, ci);
        }
        
        if(!cartItemQuantity.equals('Quick order qty over 4: ')){
            errors.add(cartItemQuantity);
        }
        
        List<Stock__c> stockList = [
                SELECT Id, Product__c, Quantity__c
                FROM Stock__c
                WHERE Plant__c = :account.Delivering_Plant__c 
                AND Product__c IN :cartItemsStockMap.keySet()
        ];
        
        for (Stock__c stock : stockList) {
            stockMap.put(stock.Product__c, stock.Quantity__c);
        }

        for (Id productId : cartItemsStockMap.keySet()) {
            Decimal requestedQuantity = cartItemsStockMap.get(productId).Quantity;
            Decimal foundQuantity = stockMap.get(productId);
            
            if (foundQuantity == null || foundQuantity < requestedQuantity) {
                //cartItemStock += cartItemsStockMap.get(productId).Product2.Name + ' - ' + cartItemsStockMap.get(productId).product2.ProductCode + ', ';
                cartItemStock += cartItemsStockMap.get(productId).product2.ProductCode + ', ';
            }
        }
		
        if(!cartItemStock.equals('No stock for quick order: ')){
            errors.add(cartItemStock);
        }
        
        return errors;
    }

    private static List<String> evaluateCartNewErrors(WebCart cart, Account account) {
        
        List<String> errors = new List<String>();
        List<String> blockedBlockCentral = new List<String>{'LM', 'SB'};

        User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()]; 
        
        if(currentUser.Profile.Name.equals('B2B Customer Community Plus - Counter Hand') || currentUser.Profile.Name.equals('B2B Customer Community Plus - Accounts')){
            errors.add(Label.Cart_Error_Profile_Counter_Hand);
            return errors;
        }
        
        if (String.isNotEmpty(account.Block_Central_Order__c) || String.isNotEmpty(account.Block_Central_Billing__c) ||
            blockedBlockCentral.contains(account.Block_Central_Delivery__c)) {
            errors.add(Label.Cart_Error_OrderingBlocked);
        }

        return errors;
    }
     
    private static List<String> evaluateCartSubmitQuote(){
        List<String> errors = new List<String>();
        User currentUser = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()]; 

        if(currentUser.Profile.Name.equals('B2B Customer Community Plus - Counter Hand') || currentUser.Profile.Name.equals('B2B Customer Community Plus - Accounts')){
            errors.add(Label.Cart_Error_Profile_Counter_Hand);
        }
        
        return errors;
    }

    private static List<String> evaluateCartLockout(){
        Map<String, Org_Variables__mdt> orgVariables = Org_Variables__mdt.getAll();
        List<String> errors = new List<String>();

        if(orgVariables.get('B2B_Order_Lockout').Checkbox_Value__c){
            errors.add(Label.Cart_Error_Lockout_B2B);
        }

        return errors;
    }

    /**
     * removing flow type parameter, so user has to pick one again
    */
    private static void clearUserFlowType() {
        User user = [
                SELECT Id
                FROM User
                WHERE Id = :UserInfo.getUserId()
        ];
        user.Checkout_Flow_Type__c = null;

        update user;
    }

}