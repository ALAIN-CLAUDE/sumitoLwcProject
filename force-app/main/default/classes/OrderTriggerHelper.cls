/**
* @description       : Trigger helper class for Order sObject
* @author            : ephetehe.mokgopanyane@tetrad.co.za
* Ver   Date         Author                       			Modification
* 1.0   2022-07-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
**/

public class OrderTriggerHelper {
    public static void handleBeforeUpdate(List<Order> orderRecords, Map<Id, Order> oldOrdersMap){
        Set<Id> orderIds = new Set<Id>();
        Order oldOrder = new Order();
        
        for(Order orderRec : orderRecords){
            oldOrder = oldOrdersMap.get(orderRec.Id);
            
            if((!orderRec.Status.equals('Completed') || !orderRec.Status.equals('Cancelled By Agent') || !orderRec.Status.equals('Cancelled By Customer')) && orderRec.Incomplete_Line_Items__c == 0 && orderRec.Incomplete_Line_Items__c != oldOrder.Incomplete_Line_Items__c){
                orderRec.Status = 'Completed';
            } 
            
            if(orderRec.SF_PO_Number__c != null && !orderRec.SF_PO_Number__c.equals(oldOrder.SF_PO_Number__c)){
                orderIds.add(orderRec.Id);
            }
        }
        
        if(orderIds != null && orderIds.size() > 0){
            updateB2BOrder(orderIds);
            
        }
    }
    
    @future(callout=false)
    public static void updateB2BOrder(Set<Id> orderIds){
        List<OrderSummary> orderSummaries = [SELECT Id, OriginalOrder.SF_PO_Number__c FROM OrderSummary WHERE OriginalOrderId IN: orderIds];
        
        for(OrderSummary orderSum : orderSummaries){
            orderSum.PONumber = orderSum.OriginalOrder.SF_PO_Number__c;
        }
        
        update orderSummaries;	
    }
    
}