global class B2B_Batch_EntitlementPolicyUpsert implements Database.Batchable<sObject> {
    private List<String> accSAPCustCodes;
    
    public B2B_Batch_EntitlementPolicyUpsert() {}

    public B2B_Batch_EntitlementPolicyUpsert(List<String> accSAPCustCodes) {
        this.accSAPCustCodes = accSAPCustCodes;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(accSAPCustCodes != null && accSAPCustCodes.size() > 0){
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM Pricebook2
                WHERE IsActive = TRUE AND isStandard = FALSE AND Account_SAP_Customer_Code__c IN: accSAPCustCodes
            ]);
        } else {
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM Pricebook2
                WHERE IsActive = TRUE AND isStandard = FALSE AND Account_SAP_Customer_Code__c LIKE '6%'
            ]);
        }
    }

    global void execute(Database.BatchableContext bc, List<Pricebook2> scope) {
        Set<String> pricebookSAPCode = new Set<String>();
        List<CommerceEntitlementPolicy> commerceEntitlementPolicyToUpsert = new List<CommerceEntitlementPolicy>();

        if (!scope.isEmpty()) {
            for (Pricebook2 pb : scope) {
                pricebookSAPCode.add(pb.Account_SAP_Customer_Code__c);
            }

            List<Account> matchingAccountList = [SELECT Id, Name, SAP_Customer_Code__c FROM Account WHERE SAP_Customer_Code__c IN:pricebookSAPCode];
            CommerceEntitlementPolicy cep;

            if (!matchingAccountList.isEmpty()) {
                for (Account acc : matchingAccountList) {
                    cep = new CommerceEntitlementPolicy();
                    cep.IsActive = true;
                    cep.CanViewPrice = true;
                    cep.CanViewProduct = true;
                    cep.Name = acc.SAP_Customer_Code__c;
                    cep.Account_SAP_Customer_Code__c = acc.SAP_Customer_Code__c;
                    commerceEntitlementPolicyToUpsert.add(cep);
                }

                if (commerceEntitlementPolicyToUpsert.size() > 0) {
                    Database.upsert(commerceEntitlementPolicyToUpsert, CommerceEntitlementPolicy.Account_SAP_Customer_Code__c, false);
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}