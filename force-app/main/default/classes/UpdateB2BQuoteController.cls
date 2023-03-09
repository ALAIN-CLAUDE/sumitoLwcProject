/**
 * @description       : 
 * @author            : Gaurav Agrawal
 * @group             : 
 * @last modified on  : 11-11-2022
 * @last modified by  : 
**/
public with sharing class UpdateB2BQuoteController {

    @AuraEnabled
    public static string UpdateQuoteStatus(String quoteId){
        B2B_Quote__c b2bQuote = [select Id, Quote__c, Sales_Rep__r.FirstName, Sales_Rep__r.LastName, Status__c from B2B_Quote__c where id =: quoteId];
        String returnString = '';

        if(!b2bQuote.Status__c.equals('Submitted to Customer')){
            if(b2bQuote.Status__c.equals('Customer Accepted')){
                return 'You order has already been placed. Please contact ' + b2bQuote.Sales_Rep__r.FirstName + ' ' + b2bQuote.Sales_Rep__r.LastName + ' for assistance.';
            } else {
                return 'Cannot accept quote as it has not been submitted to you yet. Please contact ' + b2bQuote.Sales_Rep__r.FirstName + ' ' + b2bQuote.Sales_Rep__r.LastName + ' for assistance.';
            }
        }
        
        try {
            HttpRequest req = new HttpRequest();
            Map<String, Org_Variables__mdt> orgVars = Org_Variables__mdt.getAll();

            String postBody = 'grant_type=' + orgVars.get('Grant_Type').Text_Value__c + '&client_id=' + orgVars.get('Client_Id').Text_Value__c + '&client_secret='+ orgVars.get('Client_Secret').Text_Value__c +'&username=' + orgVars.get('Integration_Username').Text_Value__c + '&password=' + orgVars.get('Integration_Token').Text_Value__c;
            req.setBody(postBody);
            req.setEndpoint(orgVars.get('Integration_URL').Text_Value__c);
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            HttpResponse res = new Http().send(req);
            
            if(res.getStatusCode() == 200){
                Map<String, Object> authRespMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                
                req = new HttpRequest();
                req.setEndpoint(authRespMap.get('instance_url') + '/services/data/v55.0/sobjects/SBQQ__Quote__c/' + b2bQuote.Quote__c);
                req.setHeader('Authorization', 'Authorization: Bearer ' + authRespMap.get('access_token'));
                req.setMethod('PATCH');
                req.setTimeout(120000);
                req.setHeader('Content-Type', 'application/json');
                req.setBody('{"SBQQ__Status__c": "Customer Accepted", "Is_Order_Placed_By_Customer__c": true}');
                res = new Http().send(req);
                
                if(res.getStatusCode() == 200 || res.getStatusCode() == 204){
                	returnString = 'Order Placed Successfully.';
                } else{
                    returnString = res.getStatusCode() + ' - ' + res.getBody();
                }
            }
        } catch(Exception e) {
            returnString = e.getMessage();
        }
        
        return returnString;
    }
}