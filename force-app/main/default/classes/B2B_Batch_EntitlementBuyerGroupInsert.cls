global class B2B_Batch_EntitlementBuyerGroupInsert implements Database.Batchable<sObject> {
    private List<String> accSAPCustCodes;
    
    public B2B_Batch_EntitlementBuyerGroupInsert() {}

    public B2B_Batch_EntitlementBuyerGroupInsert(List<String> accSAPCustCodes) {
        this.accSAPCustCodes = accSAPCustCodes;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(accSAPCustCodes != null && accSAPCustCodes.size() > 0){
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM CommerceEntitlementPolicy
                WHERE IsActive = TRUE AND Account_SAP_Customer_Code__c IN: accSAPCustCodes
            ]);
        } else {
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM CommerceEntitlementPolicy
                WHERE IsActive = TRUE AND Account_SAP_Customer_Code__c LIKE '6%'
            ]);
        }
    }

    global void execute(Database.BatchableContext bc, List<CommerceEntitlementPolicy> scope) {
        List<CommerceEntitlementBuyerGroup> entitlementBuyerGroupToInsert = new List<CommerceEntitlementBuyerGroup>();
        Set<String> accountSAPCode = new Set<String>();

        if (!scope.isEmpty()) {
            for (CommerceEntitlementPolicy cep : scope) {
                accountSAPCode.add(cep.Account_SAP_Customer_Code__c);
            }

            for (CommerceEntitlementPolicy cePolicy : [SELECT Id, Account_SAP_Customer_Code__c, (SELECT Id FROM CommerceEntitlementBuyerGroups) FROM CommerceEntitlementPolicy WHERE Account_SAP_Customer_Code__c IN :accountSAPCode]) {
                if (cePolicy.CommerceEntitlementBuyerGroups.size() == 0) {
                    CommerceEntitlementBuyerGroup cebg = new CommerceEntitlementBuyerGroup();
                    BuyerGroup buyerGroupReference = new BuyerGroup(Account_SAP_Customer_Code__c = cePolicy.Account_SAP_Customer_Code__c);
                    cebg.BuyerGroup = buyerGroupReference;
                    cebg.PolicyId = cePolicy.Id;
                    cebg.Account_SAP_Customer_Code__c = cePolicy.Account_SAP_Customer_Code__c;
                    entitlementBuyerGroupToInsert.add(cebg);
                }
            }

            if (entitlementBuyerGroupToInsert.size() > 0) {
                Database.insert(entitlementBuyerGroupToInsert, false);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}