/**
 * @description       : Integration class to sync quote data to SAP
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-01-06   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class FlowGearToSAPQuote {
	private static String flowGearAPIKey = '';
    private static String flowGearEndPoint = '';

    @InvocableMethod
    public static List<String> quoteToSAP(List<String> quoteIds){
        SBQQ__Quote__c quote = new QuotesSelector().selectById(new Set<Id>{quoteIds[0]})[0];
        List<String> resString = new List<String>();
        getFlowGearValues();
        String quoteToSAP = flowGearEndPoint + 'QuoteToSAP?quoteId=' + quoteIds[0];
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        String userResponse = '';
        String jsonResp = '';

        try{
            req.setEndpoint(quoteToSAP);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('Authorization', flowGearAPIKey);
            req.setHeader('Content-Length', '0');
            res = h.send(req);
			
            Integer respStatCode = res.getStatusCode();
            jsonResp = res.getBody();
            jsonResp = jsonResp.unescapeJava();
            String sapAction = 'created';
            if(quote.SAP_Order_Number__c != null){
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
                    quote.SAP_Order_Number__c = sapOrdNum;
                    update quote;
                    
                    String respMsg = 'Quote submitted to SAP successfully.\n\n' + sapOrdNum + ' has been ' + sapAction + ' in SAP.';
                    resString.add(respMsg);
                    
                    updateQuoteLineUpdateFlag(quoteIds[0]);
                } else {
                    resString.add('An error has occured: \n' + jsonResp);
                    update quote;
                }
            } else {
                String respMsg = JSON.serializePretty(res.getBody());
                respMsg = respMsg.unescapeJava();
                respMsg = respMsg.replace('"', '');
                
                resString.add('An error has occured: \n' + respMsg);
            }
        } catch(Exception exc){
            jsonResp = 'An integration error has occured. Please contact your System Administrator or try again later.\n\n' + exc.getMessage();
            resString.add(jsonResp);
        }

        return resString;
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
    
    public static void updateQuoteLineUpdateFlag(Id quoteId){
        List<SBQQ__QuoteLine__c> quoteLines = new QuoteLinesSelector().selectByQuoteIdAndNullRejectionReason(new Set<Id>{quoteId});
        
        if(quoteLines != null && quoteLines.size() > 0){
            for(SBQQ__QuoteLine__c quoteLine : quoteLines){
                quoteLine.SAP_Update_Flag__c = 'S';
            }
            
            update quoteLines;
        }
    }
}