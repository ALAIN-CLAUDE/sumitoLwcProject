/**
 * @author          Cihan Fethi Hizar
 * @createdDate     22 August 2022
 * @description     This is created for these JIRA stories: SD-347 - SD-350 - SD-351 - SD-352.
 *                  This is the Apex controller for the "orderHistoryByProducts", "orderHistoryTracking", "orderSummaryProductsCustom" & "orderItemHistoryTracking" LWCs.
 */

public with sharing class ProductOrderController {
    
    @AuraEnabled(cacheable=false)
    public static List<List<OrderItem>> getProductOrderDetails(String productId){
        try {
            List<List<OrderItem>> finalList = new List<List<OrderItem>>();
            List<OrderItem> list1 = [SELECT Id, Order.EffectiveDate, Quantity, Product2.Name, Product2.Product_Image_Link__c, Product2.Description 
                                     FROM OrderItem WHERE Product2Id = :productId AND Order.EffectiveDate = THIS_MONTH
                                     ORDER BY Order.EffectiveDate DESC];
            List<OrderItem> list2 = [SELECT Id, Order.EffectiveDate, Quantity, Product2.Name, Product2.Product_Image_Link__c, Product2.Description 
                                     FROM OrderItem WHERE Product2Id = :productId AND Order.EffectiveDate != THIS_MONTH AND Order.EffectiveDate = LAST_N_MONTHS:1
                                     ORDER BY Order.EffectiveDate DESC];
            List<OrderItem> list3 = [SELECT Id, Order.EffectiveDate, Quantity, Product2.Name, Product2.Product_Image_Link__c, Product2.Description 
                                     FROM OrderItem WHERE Product2Id = :productId AND Order.EffectiveDate != LAST_N_MONTHS:1 AND Order.EffectiveDate = LAST_N_MONTHS:2
                                     ORDER BY Order.EffectiveDate DESC];
            List<OrderItem> list4 = [SELECT Id, Order.EffectiveDate, Quantity, Product2.Name, Product2.Product_Image_Link__c, Product2.Description 
                                     FROM OrderItem WHERE Product2Id = :productId AND Order.EffectiveDate != LAST_N_MONTHS:2 AND Order.EffectiveDate = LAST_N_MONTHS:3
                                     ORDER BY Order.EffectiveDate DESC];
            List<OrderItem> list5 = [SELECT Id, Order.EffectiveDate, Quantity, Product2.Name, Product2.Product_Image_Link__c, Product2.Description 
                                     FROM OrderItem WHERE Product2Id = :productId AND Order.EffectiveDate != LAST_N_MONTHS:3 AND Order.EffectiveDate = LAST_N_MONTHS:4
                                     ORDER BY Order.EffectiveDate DESC];   
            List<OrderItem> list6 = [SELECT Id, Order.EffectiveDate, Quantity, Product2.Name, Product2.Product_Image_Link__c, Product2.Description 
                                     FROM OrderItem WHERE Product2Id = :productId AND Order.EffectiveDate != LAST_N_MONTHS:4 AND Order.EffectiveDate = LAST_N_MONTHS:5
                                     ORDER BY Order.EffectiveDate DESC];  
            finalList.add(list1); finalList.add(list2); finalList.add(list3); finalList.add(list4); finalList.add(list5); finalList.add(list6);
            return finalList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static OrderItem getProductDetails(String productId){
        try {
            return [SELECT Id, Product2.Name, Product2.Product_Image_Link__c, Product2.Description FROM OrderItem WHERE Product2Id = :productId][0];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<Map<String,String>> getOrderHistory(String orderSummaryId){
        try {
            TimeZone tz = UserInfo.getTimeZone();
            List<Map<String,String>> resultList = new List<Map<String,String>>();
            Map<String,String> temp = new Map<String,String>();
            OrderSummary ordSum = [SELECT Id, OrderNumber, OriginalOrderId FROM OrderSummary WHERE Id = :orderSummaryId][0];
            List<OrderHistory> ohList = [SELECT Id, OrderId, CreatedDate, CreatedBy.Name, Field, OldValue, NewValue 
                                         FROM OrderHistory WHERE Field = 'Status' AND OrderId = :ordSum.OriginalOrderId 
                                         ORDER BY CreatedDate DESC];
            for(OrderHistory oh : ohList) {
                temp.put('Id',String.valueOf(oh.Id));
                temp.put('OrderId',String.valueOf(oh.OrderId));
                temp.put('CreatedDate',String.valueOf(oh.CreatedDate.format('dd/MM/yyyy HH:mm:ss',tz.toString())));
                temp.put('CreatedByName',String.valueOf(oh.CreatedBy.Name));
                temp.put('Field',String.valueOf(oh.Field));
                temp.put('OldValue',String.valueOf(oh.OldValue));
                temp.put('NewValue',String.valueOf(oh.NewValue));
                resultList.add(temp);
                temp = new Map<String,String>();
            }
            return resultList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static Order getOrderDetails(String orderSummaryId){
        try {
            OrderSummary ordSum = [SELECT Id, OriginalOrderId FROM OrderSummary WHERE Id = :orderSummaryId][0];
            return [SELECT Id, ShippingAddress, Type FROM Order WHERE Id = :ordSum.OriginalOrderId][0];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<Map<String, String>> getOrderItemSummariesWithTracking(String orderSummaryId){
        try {
            List<Map<String, String>> result = new List<Map<String, String>>();
            Map<String, String> resultItem = new Map<String, String>();
            Set<Id> oiIds = new Set<Id>();
            String tempStr = '';
            List<OrderItemSummary> oiSumList = [SELECT Id, OrderSummaryId, Name, OriginalOrderItemId, Status, TotalLineAmount, Quantity, ProductCode
                                                FROM OrderItemSummary WHERE OrderSummaryId = :orderSummaryId];
            for(OrderItemSummary ois : oiSumList)
                oiIds.add(ois.OriginalOrderItemId);
            List<OrderItem> oiList = [SELECT Id, Picked_Quantity__c, Billed_Quantity__c, Back_Ordered_Quantity__c, Shipped_Quantity__c,
                                      Product2Id, Product2.Product_Image_Link__c, Product2.Product_Image_Global_Key_Identifier__c, Order.AccountId, SAP_Item_Number__c
                                      FROM OrderItem WHERE Id IN :oiIds];
            List<OrderItemHistory> oihList = [SELECT Id, Field, NewValue, OldValue, CreatedBy.Name, CreatedDate, OrderItemId
                                              FROM OrderItemHistory WHERE OrderItemId IN :oiIds];

            for(OrderItemSummary oisum : oiSumList) {
                tempStr = String.valueOf(oisum.Name).replace('/','').replace('.','').replace(' ','_');
                resultItem.put('Name', String.valueOf(oisum.Name));
                resultItem.put('Status', String.valueOf(oisum.Status).toUpperCase());
                resultItem.put('TotalLineAmount', String.valueOf(oisum.TotalLineAmount));
                resultItem.put('Quantity', String.valueOf(oisum.Quantity));
                resultItem.put('ProductCode', String.valueOf(oisum.ProductCode));
                resultItem.put('orgDomain',URL.getSalesforceBaseUrl().toExternalForm().replace('my.site','lightning.force'));
                for(OrderItem oi : oiList)
                    if(oi.Id == oisum.OriginalOrderItemId) {
                        resultItem.put('OrderItemId', String.valueOf(oi.Id));
                        if(!String.isBlank(String.valueOf(oi.Picked_Quantity__c))) resultItem.put('Picked_Quantity__c', String.valueOf(oi.Picked_Quantity__c));
                        else resultItem.put('Picked_Quantity__c', '-');                        
                        if(!String.isBlank(String.valueOf(oi.Billed_Quantity__c))) resultItem.put('Billed_Quantity__c', String.valueOf(oi.Billed_Quantity__c));
                        else resultItem.put('Billed_Quantity__c', '-');                        
                        if(!String.isBlank(String.valueOf(oi.Shipped_Quantity__c))) resultItem.put('Shipped_Quantity__c', String.valueOf(oi.Shipped_Quantity__c));
                        else resultItem.put('Shipped_Quantity__c', '-');                        
                        if(!String.isBlank(String.valueOf(oi.Back_Ordered_Quantity__c))) resultItem.put('Back_Ordered_Quantity__c', String.valueOf(oi.Back_Ordered_Quantity__c));
                        else resultItem.put('Back_Ordered_Quantity__c', '-');  
                        if(!String.isBlank(String.valueOf(oi.SAP_Item_Number__c))) resultItem.put('SAP_Item_Number__c', String.valueOf(oi.SAP_Item_Number__c));
                        else resultItem.put('SAP_Item_Number__c', '-');                      
                        resultItem.put('ProductUrl', '/sumitomorubbersouthafrica/s/product/'+tempStr+'/'+String.valueOf(oi.Product2Id));
                        resultItem.put('Product_Image_Link__c_SF', String.valueOf(oi.Product2.Product_Image_Link__c));
                        resultItem.put('Product_Image_Link__c_Site', '/sumitomorubbersouthafrica/s/sfsites/c/cms/delivery/media/'+String.valueOf(oi.Product2.Product_Image_Global_Key_Identifier__c)+'?recordId='+String.valueOf(oi.Product2Id)+'&buyerId='+String.valueOf(oi.Order.AccountId));
                    }
                result.add(resultItem);
                resultItem = new Map<String, String>();
                tempStr = '';
            }
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<Map<String,String>> getOrderItemHistory(String orderItemId){
        try {
            List<Map<String,String>> resultList = new List<Map<String,String>>();
            Map<String,String> temp = new Map<String,String>();
            TimeZone tz = UserInfo.getTimeZone();
            List<OrderItemHistory> oihList = [SELECT Id, Field, NewValue, OldValue, CreatedBy.Name, CreatedDate, OrderItemId
                                              FROM OrderItemHistory WHERE OrderItemId = :orderItemId ORDER BY CreatedDate DESC];
            for(OrderItemHistory oih : oihList) {
                temp.put('Id',String.valueOf(oih.Id));
                temp.put('OrderItemId',String.valueOf(oih.OrderItemId));
                temp.put('CreatedDate',String.valueOf(oih.CreatedDate.format('dd/MM/yyyy HH:mm:ss',tz.toString())));
                temp.put('CreatedByName',String.valueOf(oih.CreatedBy.Name));
                temp.put('Field',String.valueOf(oih.Field));
                temp.put('OldValue',String.valueOf(oih.OldValue));
                temp.put('NewValue',String.valueOf(oih.NewValue));
                resultList.add(temp);
                temp = new Map<String,String>();
            }
            return resultList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=false)
    public static List<String> getOrderItemDetails(String orderItemId){
        try {
            List<String> result = new List<String>();
            List<Order_Item_Detail__c> oidList =  [SELECT Id, Order_Product__c, Document_Number__c
                                                   FROM Order_Item_Detail__c WHERE Order_Product__c = :orderItemId];
            for(Order_Item_Detail__c oid : oidList)
                result.add(String.valueOf(oid.Document_Number__c));
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}