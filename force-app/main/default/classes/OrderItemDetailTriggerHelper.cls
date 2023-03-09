/**
 * @description       : Trigger helper class for Order_Item_Detail__c sObject
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-07-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class OrderItemDetailTriggerHelper {
	public static void handleAfterInsert(List<Order_Item_Detail__c> orderItemDetRecords){
        Map<Id, Map<String, Object>> recordsToUpdate = new Map<Id, Map<String, Object>>();
        Map<String, Object> ordProdTime;

        for(Order_Item_Detail__c orderItemDetRec : orderItemDetRecords){
            if(orderItemDetRec.Billed_Quantity__c != null){
                if(recordsToUpdate.get(orderItemDetRec.Order_Product__c) == null){
                    ordProdTime = new Map<String, Object>();
                    ordProdTime = getBilledMap(ordProdTime, orderItemDetRec);

                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                } else {
                    ordProdTime = recordsToUpdate.get(orderItemDetRec.Order_Product__c);
                    ordProdTime = getBilledMap(ordProdTime, orderItemDetRec);

                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                }
            }

            if(orderItemDetRec.Picked_Quantity__c != null){
				if(recordsToUpdate.get(orderItemDetRec.Order_Product__c) == null){
                    ordProdTime = new Map<String, Object>();
                    ordProdTime = getPickedMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                } else {
                    ordProdTime = recordsToUpdate.get(orderItemDetRec.Order_Product__c);
                    ordProdTime = getPickedMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                }
            }

            if(orderItemDetRec.Shipped_Quantity__c != null){
            	if(recordsToUpdate.get(orderItemDetRec.Order_Product__c) == null){
                    ordProdTime = new Map<String, Object>();
                    ordProdTime = getShippedMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                } else {
                    ordProdTime = recordsToUpdate.get(orderItemDetRec.Order_Product__c);
                    ordProdTime = getShippedMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                }
            }
        }

        if(recordsToUpdate != null || !recordsToUpdate.isEmpty()){
            updateOrderItems(recordsToUpdate);
        }
    }
    
	public static void handleAfterUpdate(List<Order_Item_Detail__c> orderItemDetRecords, Map<Id, Order_Item_Detail__c> oldOrderItemDetsMap){
        Map<Id, Map<String, Object>> recordsToUpdate = new Map<Id, Map<String, Object>>();
        Order_Item_Detail__c oldOrderItemDetail;
        Map<String, Object> ordProdTime;

        for(Order_Item_Detail__c orderItemDetRec : orderItemDetRecords){
            oldOrderItemDetail = oldOrderItemDetsMap.get(orderItemDetRec.Id);

            if(orderItemDetRec.Billed_Quantity__c != null && orderItemDetRec.Billed_Quantity__c != oldOrderItemDetail.Billed_Quantity__c){
                if(recordsToUpdate.get(orderItemDetRec.Order_Product__c) == null){
                    ordProdTime = new Map<String, Object>();
                    ordProdTime = getBilledMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                } else {
                    ordProdTime = recordsToUpdate.get(orderItemDetRec.Order_Product__c);
                    ordProdTime = getBilledMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                }
            }

            if(orderItemDetRec.Picked_Quantity__c != null && orderItemDetRec.Picked_Quantity__c != oldOrderItemDetail.Picked_Quantity__c){
                if(recordsToUpdate.get(orderItemDetRec.Order_Product__c) == null){
                    ordProdTime = new Map<String, Object>();
                    ordProdTime = getPickedMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                } else {
                    ordProdTime = recordsToUpdate.get(orderItemDetRec.Order_Product__c);
                    ordProdTime = getPickedMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                }
            }

            if(orderItemDetRec.Shipped_Quantity__c != null && orderItemDetRec.Shipped_Quantity__c != oldOrderItemDetail.Shipped_Quantity__c){
                if(recordsToUpdate.get(orderItemDetRec.Order_Product__c) == null){
                    ordProdTime = new Map<String, Object>();
                    ordProdTime = getShippedMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                } else {
                    ordProdTime = recordsToUpdate.get(orderItemDetRec.Order_Product__c);
                    ordProdTime = getShippedMap(ordProdTime, orderItemDetRec);
                    
                    recordsToUpdate.put(orderItemDetRec.Order_Product__c, ordProdTime);
                }
            }
        }

        if(recordsToUpdate != null || !recordsToUpdate.isEmpty()){
            updateOrderItems(recordsToUpdate);
        }
    }
    
    public static Map<String, Object> getBilledMap(Map<String, Object> ordProdTime, Order_Item_Detail__c orderItemDetRec){
        ordProdTime.put('billedTime', orderItemDetRec.Billed_Time__c);
        ordProdTime.put('billedDate', orderItemDetRec.Billed_Date__c);
        ordProdTime.put('currentBilledQuantity', orderItemDetRec.Order_Product_Billed_Quantity__c == null ? 0 : orderItemDetRec.Order_Product_Billed_Quantity__c);
        ordProdTime.put('billedQuantity', ordProdTime.get('billedQuantity') != null ? orderItemDetRec.Billed_Quantity__c + ((Decimal) ordProdTime.get('billedQuantity')) : orderItemDetRec.Billed_Quantity__c);

        return ordProdTime;
    }
    
    public static Map<String, Object> getPickedMap(Map<String, Object> ordProdTime, Order_Item_Detail__c orderItemDetRec){
        ordProdTime.put('pickedTime', orderItemDetRec.Picked_Time__c);
        ordProdTime.put('pickedDate', orderItemDetRec.Picked_Date__c);
        ordProdTime.put('currentPickedQuantity', orderItemDetRec.Order_Product_Picked_Quantity__c == null ? 0 : orderItemDetRec.Order_Product_Picked_Quantity__c);
        ordProdTime.put('pickedQuantity', ordProdTime.get('pickedQuantity') != null ? orderItemDetRec.Picked_Quantity__c + ((Decimal) ordProdTime.get('pickedQuantity')) : orderItemDetRec.Picked_Quantity__c);

        return ordProdTime;
    }
    
    public static Map<String, Object> getShippedMap(Map<String, Object> ordProdTime, Order_Item_Detail__c orderItemDetRec){
        ordProdTime.put('shippedTime', orderItemDetRec.Shipped_Time__c);
        ordProdTime.put('shippedDate', orderItemDetRec.Shipped_Date__c);
        ordProdTime.put('currentShippedQuantity', orderItemDetRec.Order_Product_Shipped_Quantity__c == null ? 0 : orderItemDetRec.Order_Product_Shipped_Quantity__c);
        ordProdTime.put('shippedQuantity', ordProdTime.get('shippedQuantity') != null ? orderItemDetRec.Shipped_Quantity__c + ((Decimal) ordProdTime.get('shippedQuantity')) : orderItemDetRec.Shipped_Quantity__c);

        return ordProdTime;
    }
    
    public static void updateOrderItems(Map<Id, Map<String, Object>> recordsToUpdate){
        List<OrderItem> orderProds = new List<OrderItem>();
        Map<String, Object> orderProdTimes;
        OrderItem orderProd;

        for (Id key : recordsToUpdate.keySet()) {
            orderProd = new OrderItem(Id=key);
            orderProdTimes = recordsToUpdate.get(key);

            if(orderProdTimes.get('billedQuantity') != null){
                orderProd.Billed_Quantity__c = (Decimal) orderProdTimes.get('billedQuantity') + (Decimal) orderProdTimes.get('currentBilledQuantity');
            }

            if(orderProdTimes.get('billedDate') != null){
                orderProd.Billed_Date__c = (Date) orderProdTimes.get('billedDate');
            }

            if(orderProdTimes.get('billedTime') != null){
                orderProd.Billed_Time__c = (Time) orderProdTimes.get('billedTime');
            }

            if(orderProdTimes.get('pickedQuantity') != null){
                orderProd.Picked_Quantity__c = (Decimal) orderProdTimes.get('pickedQuantity') + (Decimal) orderProdTimes.get('currentPickedQuantity');
            }

            if(orderProdTimes.get('pickedDate') != null){
                orderProd.Picked_Date__c = (Date) orderProdTimes.get('pickedDate');
            }

            if(orderProdTimes.get('pickedTime') != null){
                orderProd.Picked_Time__c = (Time) orderProdTimes.get('pickedTime');
            }

            if(orderProdTimes.get('shippedQuantity') != null){
                orderProd.Shipped_Quantity__c = (Decimal) orderProdTimes.get('shippedQuantity') + (Decimal) orderProdTimes.get('currentShippedQuantity');
            }

            if(orderProdTimes.get('shippedDate') != null){
                orderProd.Shipped_Date__c = (Date) orderProdTimes.get('shippedDate');
            }

            if(orderProdTimes.get('shippedTime') != null){
                orderProd.Shipped_Time__c = (Time) orderProdTimes.get('shippedTime');
            }

            orderProds.add(orderProd);
        }

        if(orderProds != null && orderProds.size() > 0){
            updateOrderProducts(JSON.serialize(orderProds));
        }
    }
    
    @future
    public static void updateOrderProducts(String orderProdsString){
        List<OrderItem> orderProds = (List<OrderItem>) JSON.deserialize(orderProdsString, List<OrderItem>.class);
        update orderProds;
    }
}