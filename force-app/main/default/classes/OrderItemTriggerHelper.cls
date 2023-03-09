/**
 * @description       : Trigger helper class for Order sObject
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-07-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class OrderItemTriggerHelper {
    public static void handleBeforeInsert(List<OrderItem> orderItems){
        Set<Id> productIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        List<OrderItem> updatedOrderItems = new List<OrderItem>();
        Map<Id, Id> orderMap = new Map<Id, Id>();
        Map<String, PriceBookEntry> priceBookEntryMap;
        String priceBookEntryKey = '';

        for(OrderItem orderItem : orderItems){
            if(orderItem.PricebookEntryId == null){
                productIds.add(orderItem.Product2Id);
                orderIds.add(orderItem.OrderId);
                updatedOrderItems.add(orderItem);
            }
        }

        if(productIds != null && productIds.size() > 0 && orderIds != null && orderIds.size() > 0){
        	List<Order> orders = [SELECT Id, PriceBook2Id FROM Order WHERE Id IN: orderIds];
            
            for(Order order : orders){
                orderMap.put(order.Id, order.Pricebook2Id);
            }
            
            priceBookEntryMap = setOrderItemPriceBookEntry(productIds, orders);

            if(priceBookEntryMap != null){
                for(OrderItem orderItem : updatedOrderItems){
                    priceBookEntryKey = orderMap.get(orderItem.OrderId) + '-' + orderItem.Product2Id;
                    
                    if(priceBookEntryMap.get(priceBookEntryKey) != null){
                        orderItem.PriceBookEntryId = priceBookEntryMap.get(priceBookEntryKey).Id;
                        orderItem.ListPrice = priceBookEntryMap.get(priceBookEntryKey).UnitPrice;
                    }
                }
            }
        }
    }
    
    public static Map<String, PriceBookEntry> setOrderItemPriceBookEntry(Set<Id> productIds, List<Order> orders){
        Set<Id> priceBookIds = new Set<Id>();

        for(Order order : orders){
            priceBookIds.add(order.PriceBook2Id);
        }

        List<PriceBookEntry> priceBookEntries = [SELECT Id, PriceBook2Id, Product2Id, UnitPrice FROM PriceBookEntry WHERE Product2Id IN: productIds AND PriceBook2Id IN: priceBookIds];

        Map<String, PriceBookEntry> priceBookEntryMap = new Map<String, PriceBookEntry>();
        String priceBookEntryKey = '';
        
        for(PriceBookEntry priceBookEntry : priceBookEntries){
            priceBookEntryKey = priceBookEntry.PriceBook2Id + '-' + priceBookEntry.Product2Id;
            priceBookEntryMap.put(priceBookEntryKey, priceBookEntry);
        }
        
        return priceBookEntryMap;
    }
    
	public static void handleBeforeUpdate(List<OrderItem> orderItemRecords, Map<Id, OrderItem> oldOrderItemsMap){
        Set<Id> orderIds = new Set<Id>();
        OrderItem oldOrderItem = new OrderItem();
        
        for(OrderItem orderItemRec : orderItemRecords){
            oldOrderItem = oldOrderItemsMap.get(orderItemRec.Id);

            if(orderItemRec.Billed_Quantity__c != oldOrderItem.Billed_Quantity__c && orderItemRec.Quantity != null && orderItemRec.Quantity != 0 && orderItemRec.Quantity == orderItemRec.Billed_Quantity__c){
                orderItemRec.SBQQ__Status__c = 'Completed';
                orderItemRec.Back_Ordered_Quantity__c = 0;
            } else {
                if(orderItemRec.SBQQ__Status__c.equals('Draft') && (orderItemRec.Billed_Quantity__c != oldOrderItem.Billed_Quantity__c || orderItemRec.Picked_Quantity__c != oldOrderItem.Picked_Quantity__c || orderItemRec.Shipped_Quantity__c != oldOrderItem.Shipped_Quantity__c)){
                    orderItemRec.SBQQ__Status__c = 'Being Fulfilled';
                    orderIds.add(orderItemRec.OrderId);
                }
            }
        }
        
        if(orderIds != null && orderIds.size() > 0){
            updateOrders(orderIds);
        }
    }

    public static void updateOrders(Set<Id> orderIds){
        List<Order> orders = new List<Order>();
        Order order;
        
        for(Id orderId : orderIds){
            order = new Order(Id = orderId);
            order.Status = 'Being Fulfilled';
            orders.add(order);
        }
        
        if(orders != null && orders.size() > 0){
            update orders;
        }
    }
}