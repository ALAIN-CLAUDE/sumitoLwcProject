/**
 * @description       : Trigger Handler class for ContentDocumentLink SObject
 * @author            : ephetehe.mokgopanyane@tetrad.co.za 
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
public class TriggerHandlerContentDocumentLink extends TriggerHandler {
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
        Set<Id> parentIds = new Set<Id>();

        for(Id recordId : newRecords.keySet()){
            ContentDocumentLink att = (ContentDocumentLink) newRecords.get(recordId);
            parentIds.add(att.LinkedEntityId);
        }

        List<Account_Document__c> accDocs = new AccountDocumentsSelector().selectById(parentIds);

        if(accDocs != null && accDocs.size() > 0){
            Boolean isAnyUpdated = false;
            for(Account_Document__c accDoc : accDocs){
                if(!accDoc.Status__c.EqualsIgnoreCase('Submitted')){
                    accDoc.status__c = 'Submitted';
                    isAnyUpdated = true;
                }
            }

            if(isAnyUpdated){
                update accDocs;
            }
        } else {
           	
            List<SBQQ__Quote__c> quotes = [select Id FROM SBQQ__Quote__c WHERE Id IN: parentIds];
            
            
            if(quotes != null && quotes.size() > 0){
                Map<Id, Id> quoteIdContDocLinkId = new Map<Id, Id>();
                
                for(Id recordId : newRecords.keySet()){
                    ContentDocumentLink att = (ContentDocumentLink) newRecords.get(recordId);
                    quoteIdContDocLinkId.put(att.LinkedEntityId, att.ContentDocumentId);
                }
                
                Set<Id> quoteIds = new Set<Id>();
                List<ContentDocumentLink> contDocLinks = new List<ContentDocumentLink>();
                ContentDocumentLink contDocLink;
                
                for(SBQQ__Quote__c quote : quotes){
                	quoteIds.add(quote.Id);
                }
                
                List<B2B_Quote__c> b2bQuotes = [SELECT Id, Quote__c FROM B2B_Quote__c WHERE Quote__c IN: quoteIds];
                
                if(b2bQuotes != null && b2bQuotes.size() > 0){
                    Map<Id, Id> quoteIdB2BQuoteIdMap = new Map<Id, Id>();
                    for(B2B_Quote__c b2bQuote : b2bQuotes){
                        quoteIdB2BQuoteIdMap.put(b2bQuote.Quote__c, b2bQuote.Id);
                    }
                    
                    for(SBQQ__Quote__c quote : quotes){
                        contDocLink = new ContentDocumentLink();
                        contDocLink.LinkedEntityId = quoteIdB2BQuoteIdMap.get(quote.Id);
                        contDocLink.ContentDocumentId = quoteIdContDocLinkId.get(quote.Id);
                        contDocLink.ShareType = 'V';
                        contDocLink.Visibility = 'AllUsers';
                        contDocLinks.add(contDocLink);
                    }
                }
                
                if(contDocLinks != null && contDocLinks.size() > 0){
                    insert contDocLinks;
                }
            }
        }
    }
}