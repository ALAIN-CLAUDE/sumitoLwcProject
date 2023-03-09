public class INV_VisitItemActions {
    
    @InvocableMethod(label='Update VA Field Label' description='Invocable method for Visit Actions')
    public static void updateVAFields(List<ID> ids) {
        /*Visit_Action__c visitActions = [SELECT Id,Account_Name__c,Visit_Action_Account__c FROM Visit_Action__c WHERE ID = :ids[0]];
string accountId = visitActions.Account_Name__c;
             system.debug('accountId: ' + accountId);
             system.debug('visitActions.Visit_Action_Account__c: ' + visitActions.Visit_Action_Account__c);
            system.debug('visitActions.Account_Name__c: ' + visitActions.Account_Name__c);
            Account acc = [SELECT toLabel(Group_Name__c) FROM 
                           Account where Id = :visitActions.Account_Name__c];
            Account memberacc = [SELECT SAP_Customer_Code__c FROM 
                                 Account where Name = :visitActions.Visit_Action_Account__c];
            visitActions.Visit_Site_Group_Name__c = acc.Group_Name__c;
            visitActions.Member_Account_Number__c = memberacc.SAP_Customer_Code__c;
            update visitActions;
        for (ID visitActionID : ids) {
            
        }      */
    } 
}