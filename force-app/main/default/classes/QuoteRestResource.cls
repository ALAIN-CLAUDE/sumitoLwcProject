@RestResource(urlMapping='/QuoteRestResource/*')
global class QuoteRestResource {
	@HttpPatch
    global static void startBatchJob(String quoteId) {
        RestResponse res = RestContext.response ;
Savepoint sp = Database.setSavepoint();
        
        try {
            //validations
            if (String.isBlank(quoteId)) {
                res.responseBody = Blob.valueOf(JSON.serialize(new errorMessageWrapperClass('Missing Required fields', 'Quote Id is required!!')));
                res.statusCode = 400; return ;
            }
            
            List<SBQQ__Quote__c> quotes = [SELECT Id, SBQQ__Status__c FROM SBQQ__Quote__c WHERE Id =: quoteId];
            
            if(quotes != null && !quotes.isEmpty()){
                quotes.get(0).SBQQ__Status__c = 'Customer Accepted';
                update quotes;
                
                res.responseBody = Blob.valueOf(JSON.serialize(new SuccessResponse(quotes.get(0).Name, quotes.get(0).Id)));
                res.statusCode = 200;
            } else {
                res.responseBody = Blob.valueOf(JSON.serialize(new errorMessageWrapperClass('Not Found:', 'NOT Found')));
                res.statusCode = 404;
            }
        } catch(Exception e) {
            res.responseBody = Blob.valueOf(JSON.serialize(new errorMessageWrapperClass('Unknown Error: ', e.getMessage())));
            res.statusCode = 500;
        }
        
        /*
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Status__c = 'Customer Accepted';
        String returnString = '';
        try{
            update quote;
            returnString = 'Quote updated successfully.';
        }catch(Exception exc){
            returnString = exc.getMessage();
        }*/
        //return returnString;
    }
    
    global class errorMessageWrapperClass {
        public String errorType {get;set;}
        public String errorMessage {get;set;}
        
        public errorMessageWrapperClass (String errorType, String errorMessage){
            this.errorType = errorType ;
            this.errorMessage = errorMessage ;
        }
    }
    
    //Wrapper class for response
    global class SuccessResponse {
        public String Name {get;set;}
        public String SfId {get;set;}
        
        public SuccessResponse (String Name, String SfId){
            this.Name = Name ;
            this.SfId = SfId ;
        }
    }
}