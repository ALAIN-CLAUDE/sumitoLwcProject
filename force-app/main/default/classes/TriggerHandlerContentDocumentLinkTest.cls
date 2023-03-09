/**
 * @description       : Test class for TriggerHandlerContentDocumentLink apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za 
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class TriggerHandlerContentDocumentLinkTest {
    @isTest
    public static void testAfterInsert(){
        Blob bodyBlob = Blob.valueOf('Unit Test ContentVersion Body'); 
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Account_Document__c accDoc = new Account_Document__c();
        accDoc.Account__c = acc.Id;
        accDoc.Status__c = 'New';
        accDoc.Document_Type__c = 'Credit agreement';
        insert accDoc;
        
        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = 'TestSAP142536';
        insert priceBook;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__Account__c = acc.Id;
        quote.SBQQ__PricebookId__c = priceBook.Id;
        quote.SBQQ__Pricebook__c = priceBook.Id;
        insert quote;
        
        B2B_Quote__c b2bQuote = new B2B_Quote__c();
        b2bQuote.Quote__c = quote.Id;
        b2bQuote.Account__c = acc.Id;
        insert b2bQuote;
        
        ContentVersion content = new ContentVersion();
        content.Title = 'Header_Picture1';
        content.PathOnClient = '/' + content.Title + '.jpg';
        content.VersionData = bodyBlob; 
        content.origin = 'H';
        insert content;
        
        ContentDocumentLink contentLink = new ContentDocumentLink();
        contentLink.LinkedEntityId = accDoc.Id;
        contentLink.ContentDocumentId = [select ContentDocumentId FROM ContentVersion WHERE Id =: content.Id].ContentDocumentId;
        contentLink.ShareType = 'V';
        contentLink.Visibility = 'AllUsers';
        insert contentLink;
        
        ContentDocumentLink contentLinkQuote = new ContentDocumentLink();
        contentLinkQuote.LinkedEntityId = quote.Id;
        contentLinkQuote.ContentDocumentId = [select ContentDocumentId FROM ContentVersion WHERE Id =: content.Id].ContentDocumentId;
        contentLinkQuote.ShareType = 'V';
        contentLinkQuote.Visibility = 'AllUsers';
        insert contentLinkQuote;
    }
}