/**
 * @description       : (User_After_Save) Class used for sending an email to account team on a SBQQ__Quote__c record
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2023-03-07   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_SendEmailToQuoteAccountTeam {
    @InvocableMethod(label='Send email to quote account team.')
    public static void sendEmailToQuoteAccountTeam(List<String> quoteIds){
        SBQQ__Quote__c quote = [SELECT Id, CreatedBy.Name, SBQQ__Account__c, SBQQ__Account__r.Name FROM SBQQ__Quote__c WHERE Id =: quoteIds.get(0)];
        List<AccountTeamMember> accountTeamMembers = [SELECT Id, User.Email FROM AccountTeamMember WHERE AccountId =: quote.SBQQ__Account__c AND User.isActive = true];

        if(accountTeamMembers != null && accountTeamMembers.size() > 0 ){
            EmailTemplate emailTemplate = [SELECT Id, Body FROM EmailTemplate WHERE DeveloperName =: 'Quote_New_B2B_Quote'];

            List<string> toAddresses = new List<string>();

            for(AccountTeamMember accountTeamMember : accountTeamMembers){
                toAddresses.add(accountTeamMember.User.Email);
            }

        	Map<String, Org_Variables__mdt> orgVariables = Org_Variables__mdt.getAll();
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            String accountName = quote.SBQQ__Account__r.Name;
            String quoteURL = orgVariables.get('SRSA_URL').Text_Value__c + quote.Id;
            String emailBody = updateEmailBody(emailTemplate.Body, accountName, quote.CreatedBy.Name, quoteURL);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(emailTemplate.Id);
            mail.setHtmlBody(emailBody);
            mail.setToAddresses(toAddresses);
            mail.setSubject('New Quote Requested By Customer');
            mail.setWhatId(quoteIds.get(0));
            mail.setSaveAsActivity(true);
            mail.setUseSignature(false);
            mails.add(mail);

            try {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
        }
    }
    
    public static String updateEmailBody(String emailBody, String accountName, String createdBy, String quoteURL){
        emailBody = emailBody.replace('Recipient_Placeholder', accountName + ' Team<br><br>');
        emailBody = emailBody.replace('Quote_Requester_Placeholder', createdBy + '.<br><br>');
        emailBody = emailBody.replace('Link_To_Quote_Placeholder', quoteURL + '<br><br>');
        emailBody = emailBody.replace('Regards_Placeholder', '<br>Sumitomo Admin');
        return emailBody;
    }
}