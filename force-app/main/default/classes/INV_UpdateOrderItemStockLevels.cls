/**
 * @description       : Class used for updating quote line local stock 
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-09-06   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_UpdateOrderItemStockLevels {
	
    @InvocableMethod(label='Update Order Item Stock Level')
    public static void updateProductStockLevels(List<String> orderIdStrings){
        Set<Id> orderIds = new Set<Id>();
        
        for(String orderIdString : orderIdStrings){
            orderIds.add(orderIdString);
        }
        
        if(orderIds != null && orderIds.size() > 0){
            updateStocks(orderIds);
        }
    }
    
    @future(callout=false)
    public static void updateStocks(Set<Id> orderIds){
        Map<String, Map<Id, Decimal>> plantProdIdQuant = new Map<String, Map<Id, Decimal>>();
        Map<Id, Decimal> prodIdQuant = new Map<Id, Decimal>();
        List<Stock__c> updatedStocks = new List<Stock__c>();
        Set<Id> productIds = new Set<Id>();
        Set<String> orderDelPlants = new Set<String>();
        Decimal quantity = 0;
        
        
        List<OrderItem> orderItems = [SELECT Id, Quantity, Product2Id, Order.Delivering_Plant__c FROM OrderItem WHERE OrderId IN: orderIds];
        
        for(OrderItem orderItem : orderItems){
            quantity = 0;
            productIds.add(orderItem.Product2Id);
            orderDelPlants.add(orderItem.Order.Delivering_Plant__c);
            
            if(plantProdIdQuant.get(orderItem.Order.Delivering_Plant__c) != null){
                prodIdQuant = plantProdIdQuant.get(orderItem.Order.Delivering_Plant__c);
                
                if(prodIdQuant.get(orderItem.Product2Id) != null){
                    quantity = prodIdQuant.get(orderItem.Product2Id);
                    quantity += orderItem.Quantity;
                    prodIdQuant.put(orderItem.Product2Id, quantity);
                } else {
                    quantity = 0;
                    quantity += orderItem.Quantity;
                    prodIdQuant.put(orderItem.Product2Id, quantity);
                }
            } else {
                prodIdQuant = new Map<Id, Decimal>();
                quantity = 0;
                quantity += orderItem.Quantity;
                prodIdQuant.put(orderItem.Product2Id, quantity);
                plantProdIdQuant.put(orderItem.Order.Delivering_Plant__c, prodIdQuant);
            }
        }
        
        List<Stock__c> stocks = [SELECT Id, Quantity__c, Plant__c, Product__c FROM Stock__c WHERE Product__c IN: productIds AND Plant__c IN: orderDelPlants];
        
        for(Stock__c stock : stocks){
            if(plantProdIdQuant.get(stock.Plant__c) != null){
                prodIdQuant = plantProdIdQuant.get(stock.Plant__c);
                
                if(prodIdQuant.get(stock.Product__c) != null){
                    stock.Quantity__c -= prodIdQuant.get(stock.Product__c);
                    updatedStocks.add(stock);
                }
            }
        }
        
        update updatedStocks;
    }
}