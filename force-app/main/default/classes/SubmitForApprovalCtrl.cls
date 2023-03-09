/**
 * @description       : Controller class for SubmitForApproval aura component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-08-31   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class SubmitForApprovalCtrl {
	@AuraEnabled
    public static void submitForApproval(String comments, String accId){
        Id userId = UserInfo.getUserId();
        User user = new UsersSelector().selectById(new Set<Id>{userId})[0];
        Account acc = new AccountsSelector().selectById(new Set<Id>{accId})[0];

        if(acc.RecordType.Name.EqualsIgnoreCase('Domestic')){
            if(acc.Domestic_Require_Documents_Count__c < 4){
                throw new AuraHandledException('Please attach all required documents for a Domestic Account (Company documents, Credit agreement, Identification documents, Master data form)');
            }
        } else if(acc.RecordType.Name.EqualsIgnoreCase('International Business')){
            if(acc.IB_Require_Documents_Count__c < 7){
                throw new AuraHandledException('Please attach all required documents for an International Business Account (Audited financials, Company documents, Confirmation of banking details, Credit agreement, Debtor questionnaire, Identification documents, Master data form)');
            }
        }

        try{
            Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
            request.setComments(comments);
            request.setObjectId(acc.id);
            request.setSubmitterId(user.Id);
            request.setProcessDefinitionNameOrId('Onboarding_Approval_Process_Domestic');
            request.setSkipEntryCriteria(true);
            Approval.ProcessResult result = Approval.process(request);
        } catch(Exception exc){
            throw new AuraHandledException(String.valueOf(exc));
        }
    }
}