/**
 * @description       : Class used for updating the order product time fields because this cannot be done using the flow.
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-03-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_UpdateOrderProductTime {

    @InvocableMethod(label='Update Order Product Time')
    public static List<String> updateOrderProductTime(List<String> orderProdTimeMapStrings){
        List<String> results = new List<String>();
        List<OrderItem> orderItems = new List<OrderItem>();
        Map<Id, OrderItem> orderItemsMap = new Map<Id, OrderItem>();
        
        for(String orderProdTimeMapString : orderProdTimeMapStrings){
            Map<String, String> orderProdTimeMap = (Map<String, String>) JSON.deserialize(orderProdTimeMapString, Map<String, String>.class);
            
            if(orderProdTimeMap.get('orderItemId') != null && !orderProdTimeMap.get('orderItemId').equals('')){
                OrderItem orderProd = new OrderItem(Id = orderProdTimeMap.get('orderItemId'));
                String [] timeString;
                
                if(orderProdTimeMap.get('billed') != null && !orderProdTimeMap.get('billed').equals('')){
                    timeString = orderProdTimeMap.get('billed').split(':');
                    orderProd.Billed_Time__c = Time.newInstance(Integer.valueOf(timeString[0]), Integer.valueOf(timeString[1]), Integer.valueOf(timeString[2]), 0);
                }
                
                if(orderProdTimeMap.get('invoiced') != null && !orderProdTimeMap.get('invoiced').equals('')){
                    timeString = orderProdTimeMap.get('invoiced').split(':');
                    orderProd.Invoiced_Time__c = Time.newInstance(Integer.valueOf(timeString[0]), Integer.valueOf(timeString[1]), Integer.valueOf(timeString[2]), 0);
                }
                
                if(orderProdTimeMap.get('picked') != null && !orderProdTimeMap.get('picked').equals('')){
                    timeString = orderProdTimeMap.get('picked').split(':');
                    orderProd.Picked_Time__c = Time.newInstance(Integer.valueOf(timeString[0]), Integer.valueOf(timeString[1]), Integer.valueOf(timeString[2]), 0);
                }
                
                if(orderProdTimeMap.get('shipped') != null && !orderProdTimeMap.get('shipped').equals('')){
                    timeString = orderProdTimeMap.get('shipped').split(':');
                    orderProd.Shipped_Time__c = Time.newInstance(Integer.valueOf(timeString[0]), Integer.valueOf(timeString[1]), Integer.valueOf(timeString[2]), 0);
                }
                
                orderItems.add(orderProd);
                results.add(orderProd.Id);
            }
        }
        
        if(orderItems != null && orderItems.size() > 0){
            orderItemsMap.putAll(orderItems);
            
            if(orderItemsMap != null && orderItemsMap.size() > 0){
                try{
                    update orderItemsMap.values();
                } catch(Exception exc){}
            }
        }

        Return results;
    }
}