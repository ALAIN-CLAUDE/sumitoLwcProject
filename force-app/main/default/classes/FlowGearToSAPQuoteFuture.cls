/**
* @description       : Integration class to sync quote data to SAP
* @author            : ephetehe.mokgopanyane@tetrad.co.za
* Ver   Date         Author                       			Modification
* 1.0   2021-01-06   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
**/

public class FlowGearToSAPQuoteFuture {
    private static String flowGearAPIKey = '';
    private static String flowGearEndPoint = '';
    
    @InvocableMethod(label='Sync quote to FlowGear - Future method')
    public static List<String> quoteToSAP(List<String> quoteIds){
        SBQQ__Quote__c quote = new QuotesSelector().selectById(new Set<Id>{quoteIds[0]})[0];
        getFlowGearValues();
        
        String quoteToSAP = flowGearEndPoint + 'QuoteToSAP?quoteId=' + quoteIds[0];
        callFlowGearFuture(flowGearAPIKey, quoteToSAP, quoteIds[0]);
        
        return new List<String>{'Quote submitted to SAP successfully.'};
	}
    
    @future(callout=true)
    public static void callFlowGearFuture(String flowGearAPIKey, String quoteToSAP, Id quoteId){
        SBQQ__Quote__c quote = new QuotesSelector().selectById(new Set<Id>{quoteId})[0];
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        String notifTitle = '';
        
        try{
            req.setEndpoint(quoteToSAP);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('Authorization', flowGearAPIKey);
            req.setHeader('Content-Length', '0');
            res = h.send(req);
            
            Integer respStatCode = res.getStatusCode();
            String jsonResp = res.getBody();
            jsonResp = jsonResp.unescapeJava();
            
            if(respStatCode == 200){
                if(!jsonResp.contains('SRSA_Replacement Ord ')){
                    notifTitle = 'Quote submit error: ' + quote.Name + ' (' + quote.SAP_Order_Number__c + ')';
                    sendCustomNotification(quoteId, notifTitle, 'An error has occured: \n' + jsonResp, quote.SBQQ__SalesRep__c);
                    updateQuoteStatus(quoteId, 'Quote Sync Required	');
                } else{
                    notifTitle = 'Quote submitted successfully: ' + quote.Name + ' (' + quote.SAP_Order_Number__c + ')';
                    sendCustomNotification(quoteId, notifTitle, 'Quote submitted successfully to SAP.', quote.SBQQ__SalesRep__c);
                }
            } else {
                String respMsg = JSON.serializePretty(res.getBody());
                respMsg = respMsg.unescapeJava();
                respMsg = respMsg.replace('"', '');
                notifTitle = 'Quote submit error: ' + quote.Name + ' (' + quote.SAP_Order_Number__c + ')';
                sendCustomNotification(quoteId, notifTitle, 'An error has occured: \n' + respMsg, quote.SBQQ__SalesRep__c);
                updateQuoteStatus(quoteId, 'Quote Sync Required	');
            }
        } catch(Exception exc){
            notifTitle = 'Quote submit error: ' + quote.Name + ' (' + quote.SAP_Order_Number__c + ')';
            sendCustomNotification(quoteId, notifTitle, 'An error has occured: \n' + exc.getMessage(), quote.SBQQ__SalesRep__c);
            updateQuoteStatus(quoteId, 'Quote Sync Required	');
        }
    }
    
    public static void sendCustomNotification(Id quoteId, String title, String message, Id salesRepId){
        CustomNotificationType custNotifType = [SELECT Id, DeveloperName FROM CustomNotificationType WHERE DeveloperName = 'General_Notification'];
        Messaging.CustomNotification custNotif = new Messaging.CustomNotification();
        custNotif.setTitle(title);
        custNotif.setBody(message);
        custNotif.setNotificationTypeId(custNotifType.Id);
        custNotif.setTargetId(quoteId);
        custNotif.send(new Set<String>{salesRepId});
    }
    
    public static void updateQuoteStatus(Id quoteId, String quoteStatus){
        SBQQ__Quote__c quote = new SBQQ__Quote__c(Id= quoteId);
        quote.SBQQ__Status__c = 'Quote Sync Required';
        update quote;
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