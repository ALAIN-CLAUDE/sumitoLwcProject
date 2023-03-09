/**
 * @description       : Integration class to sync order data to SAP
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-01-06   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class FlowGearToSAPOrderFuture {
	private static String flowGearAPIKey = '';
    private static String flowGearEndPoint = '';

    @InvocableMethod(label='Sync Order to SAP - Future Method')
    public static void orderToSAP(List<String> orderIds){
        getFlowGearValues();
        String orderToSAP = flowGearEndPoint + 'OrderToSAP?orderId=' + orderIds[0];
        callFlowGearFuture(orderIds[0], flowGearAPIKey, orderToSAP);
    }
    
    @future(callout=true)
    public static void callFlowGearFuture(String orderId, String flowGearAPIKey, String orderToSAP){
        Order order = new OrdersSelector().selectById(new Set<Id>{orderId})[0];
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
 
        try{
            req.setEndpoint(orderToSAP);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('Authorization', flowGearAPIKey);
            req.setHeader('Content-Length', '0');
            res = h.send(req);
            
            Integer respStatCode = res.getStatusCode();
            String jsonResp = res.getBody();
            jsonResp = jsonResp.unescapeJava();
            String sapAction = 'created';
            
            if(order.SAP_Order_Number__c != null){
                sapAction = 'updated';
            }
            
            if(respStatCode == 200){
                if(jsonResp.contains('SRSA_Replacement Ord ')){
                    String[] respArray = jsonResp.split('SRSA_Replacement Ord ');
                    String sapOrdNum = respArray[1].replace(' has been saved', '');
                    sapOrdNum = sapOrdNum.replace('"', '');
                    sapOrdNum = sapOrdNum.replace('}', '');
                    sapOrdNum = sapOrdNum.replace('\n', '');
                    sapOrdNum = sapOrdNum.replace('\r', '');
                    sapOrdNum = sapOrdNum.split(',')[0];
                    order.SAP_Order_Number__c = sapOrdNum;
                    order.Integration_Response__c = '';
                    update order;
                } else {
                    order.Status = 'Draft';
                    order.Integration_Response__c = jsonResp;
                    update order;
                }
            } else {
                String respMsg = JSON.serializePretty(res.getBody());
                respMsg = respMsg.unescapeJava();
                respMsg = respMsg.replace('"', '');
                
                order.Status = 'Draft';
                order.Integration_Response__c = respMsg;
                update order;
            }
        } catch(Exception exc){
        	order.Status = 'Draft';
            order.Integration_Response__c = 'An integration error has occured. Please contact your System Administrator or try again later.\n\n' + exc.getMessage();
            update order;
        }
    }
    
    public static void getFlowGearValues(){
        Map<String, String> flowGearValues = new Map<String, String>();
        List<Org_Variables__mdt> orgVars = [SELECT Id, DeveloperName, Text_Value__c FROM Org_Variables__mdt WHERE DeveloperName IN ('Flow_Gear_API_End_Point', 'Flow_Gear_API_Key')];
        
        for(Org_Variables__mdt orgVar : orgVars){
            if(orgVar.DeveloperName.equals('Flow_Gear_API_End_Point')){
                flowGearEndPoint = orgVar.Text_Value__c;
            } else if(orgVar.DeveloperName.equals('Flow_Gear_API_Key')){
                flowGearAPIKey = orgVar.Text_Value__c;
            }
        }
    }
}