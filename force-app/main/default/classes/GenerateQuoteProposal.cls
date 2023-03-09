/**
 * @description       : Class used for generating Quote Document
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-03-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public with sharing class GenerateQuoteProposal {
    
    @InvocableMethod(label='Generate Quote Document Record')
    public static List<String> generateQuoteDocRecord(List<String> quoteIds){
        String response = 'You quote document is being generated. You will receive a notification once it has been generated.';
        QuoteProposalModel model = new QuoteProposalModel();
        SBQQ__Quote__c quote = new SBQQ__Quote__c(Id = quoteIds[0]);
        model.quoteId = quoteIds[0];
        model.templateId = getDefaultQuoteTemplate();
        
        try{
            quote.SBQQ__Status__c = 'Submitted To Customer';
            update Quote;
            save(model);
        } catch(Exception exc){
            response = 'Error: ' + exc.getMessage();
        }
        
        return new List<String>{response};
    }
    
	public static String save(QuoteProposalModel context) {
        if(!test.isRunningTest()){
            return SBQQ.ServiceRouter.save('SBQQ.QuoteDocumentAPI.Save', JSON.serialize(context));
        } else {
            return null;
        }
    }
    
    public static Id getDefaultQuoteTemplate(){
        SBQQ__QuoteTemplate__c quoteTemp = [SELECT Id FROM SBQQ__QuoteTemplate__c WHERE SBQQ__Default__c = true LIMIT 1];
        
        return quoteTemp.Id;
    }
}