global class B2B_Batch_DoNotDeployOrUseThis implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
        List<Account> accounts = [SELECT Id, SAP_Customer_Code__c FROM Account WHERE Stage__c <> 'Active' AND SAP_Customer_Code__c LIKE '6%'];
        Set<String> accSapCustCodes = new Set<String>();
        Set<Id> priceBookIds = new Set<Id>();
        
        for(Account acc : accounts){
            accSapCustCodes.add(acc.SAP_Customer_Code__c);
        }
        
        List<PriceBook2> priceBooks = [SELECT Id FROM PriceBook2 WHERE Account_SAP_Customer_Code__c in: accSapCustCodes];
        
        for(PriceBook2 acc : priceBooks){
            priceBookIds.add(acc.Id);
        }
        
        return Database.getQueryLocator([
        	SELECT Id FROM PriceBookEntry
            WHERE PriceBook2Id IN: priceBookIds
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<PriceBookEntry> scope) {
        Database.DeleteResult[] DR_Dels = Database.delete(scope, false);
        //delete scope;
    }

    global void finish(Database.BatchableContext bc) {}
}