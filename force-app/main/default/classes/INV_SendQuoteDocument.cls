/**
 * @description       : Class used for sending email with Quote Document
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-03-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_SendQuoteDocument {
	
    @InvocableMethod
    public static void sendQuoteDocEmail(List<String> contentDocLinkIds){
        ContentDocumentLink cntnDocLink = [SELECT Id, ContentDocumentId, IsDeleted, LinkedEntityId, ShareType, Visibility FROM ContentDocumentLink WHERE Id =: contentDocLinkIds.get(0)];
        List<ContentVersion> cntntVrsns = [SELECT Id, ContentDocument.ParentId, FileExtension, VersionData FROM ContentVersion WHERE ContentDocumentId =: cntnDocLink.ContentDocumentId AND IsLatest = true];
        SBQQ__Quote__c quote = new QuotesSelector().selectById(new Set<Id>{cntnDocLink.LinkedEntityId})[0];
        EmailTemplate emailTemplate = [SELECT DeveloperName, Body, Subject, HtmlValue, Markup FROM EmailTemplate WHERE DeveloperName = 'Quote_Quote_Document_VF'];
        Blob quoteDocData = cntntVrsns.get(0).VersionData;
		String htmlBody = replaceEmailPlaceHolders(emailTemplate.Markup, quote);

        Messaging.EmailFileAttachment emailAtt = new Messaging.EmailFileAttachment();
        emailAtt.setFilename(quote.Name + ' - ' + quote.SBQQ__Account__r.Name + '.' + cntntVrsns.get(0).FileExtension);
        emailAtt.setBody(quoteDocData);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setHtmlBody(htmlBody);
        mail.setSubject(emailTemplate.Subject);
        mail.setSaveAsActivity(true);
        mail.setTargetObjectId(quote.SBQQ__PrimaryContact__c);
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setToAddresses(new List<String>{quote.SBQQ__PrimaryContact__r.Email});
        mail.setWhatId(quote.Id);
        mail.setEntityAttachments(new List<String>{cntntVrsns.get(0).Id});
        //mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        attachQuoteDocumentToB2BQuote(cntnDocLink);
    }
    
    public static void attachQuoteDocumentToB2BQuote(ContentDocumentLink toBeClonedContentDocumentLink){
        SBQQ__Quote__c quote = [SELECT Id, Is_B2B_Quote__c FROM SBQQ__Quote__c WHERE Id =: toBeClonedContentDocumentLink.LinkedEntityId];
        
        if(quote.Is_B2B_Quote__c){
            List<B2B_Quote__c> b2bQuote = [SELECT Id FROM B2B_Quote__c WHERE Id =: quote.Id];
            
            if(b2bQuote != Null && b2bQuote.size() > 0){
                toBeClonedContentDocumentLink.Id=null;
                toBeClonedContentDocumentLink.LinkedEntityId = b2bQuote.get(0).Id;
                insert toBeClonedContentDocumentLink;
            }
        }
    }
    
    private static String replaceEmailPlaceHolders(String htmlBody, SBQQ__Quote__c quote){
        Document SRSA_EmailBanner = [SELECT Id FROM Document WHERE DeveloperName = 'SRI_Letterhead_Headerer'];
        Document SRSA_EmailFooter = [SELECT Id FROM Document WHERE DeveloperName = 'SRI_Letterhead_Footer'];
        Org_Variables__mdt orgVars = [SELECT Id, Text_Value__c FROM Org_Variables__mdt WHERE DeveloperName = 'SRSA_URL'];
        String SRSA_EmailBanner_ImageLink = orgVars.Text_Value__c + '/servlet/servlet.ImageServer?id=' +SRSA_EmailBanner.Id + '&oid=' + UserInfo.getOrganizationId();
        String SRSA_EmailFooter_ImageLink = orgVars.Text_Value__c + '/servlet/servlet.ImageServer?id=' +SRSA_EmailFooter.Id + '&oid=' + UserInfo.getOrganizationId();
        
        htmlBody = htmlBody.replace('SRSA_FirstName', quote.SBQQ__PrimaryContact__r.Name);
        htmlBody = htmlBody.replace('SRSA_ClientName', quote.SBQQ__Account__r.Name);
        htmlBody = htmlBody.replace('SRSA_QuoteExpiryDate', String.valueOf(quote.SBQQ__ExpirationDate__c));
        htmlBody = htmlBody.replace('SRSA_SalesRep', quote.SBQQ__SalesRep__r.Name);
        htmlBody = htmlBody.replace('SRSA_RepEmail', quote.SBQQ__SalesRep__r.Email);
        htmlBody = htmlBody.replace('SRSA_EmailBanner', SRSA_EmailBanner_ImageLink);
        htmlBody = htmlBody.replace('SRSA_EmailFooter', SRSA_EmailFooter_ImageLink);

        return htmlBody;
    }
}