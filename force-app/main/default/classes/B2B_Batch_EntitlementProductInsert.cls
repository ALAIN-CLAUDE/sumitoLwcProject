global class B2B_Batch_EntitlementProductInsert implements Database.Batchable<sObject> {
    private List<String> accSAPCustCodes;
    
    public B2B_Batch_EntitlementProductInsert() {}

    public B2B_Batch_EntitlementProductInsert(List<String> accSAPCustCodes) {
        this.accSAPCustCodes = accSAPCustCodes;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(accSAPCustCodes != null && accSAPCustCodes.size() > 0){
            return Database.getQueryLocator([
                SELECT Id, Product2Id, Product2.ProductCode, Pricebook2Id, PriceBook2.Account_SAP_Customer_Code__c 
            	FROM PricebookEntry 
            	WHERE UnitPrice > 0 AND Product2.IsActive = TRUE AND IsActive = TRUE 
            	AND (Product2.x_distr_chain_status_code__c = 'ON' OR Product2.x_distr_chain_status_code__c = 'SQ' OR Product2.x_distr_chain_status_code__c = 'FS')
            	AND PriceBook2.Account_SAP_Customer_Code__c IN: accSAPCustCodes
            ]);
        } else {
            List<Account> accounts = [SELECT Id, SAP_Customer_Code__c FROM Account WHERE Stage__c = 'Active' AND SAP_Customer_Code__c LIKE '6%'];
            Set<String> accSapCustCodes = new Set<String>();
            
            for(Account acc : accounts){
                accSapCustCodes.add(acc.SAP_Customer_Code__c);
            }
            
            return Database.getQueryLocator([
                SELECT Id, Product2Id, Product2.ProductCode, Pricebook2Id, PriceBook2.Account_SAP_Customer_Code__c 
                FROM PricebookEntry 
                WHERE UnitPrice > 0 AND Product2.IsActive = TRUE AND IsActive = TRUE 
                AND (Product2.x_distr_chain_status_code__c = 'ON' OR Product2.x_distr_chain_status_code__c = 'SQ' OR Product2.x_distr_chain_status_code__c = 'FS')
                AND PriceBook2.Account_SAP_Customer_Code__c IN: accSapCustCodes
            ]);
        }
    }

    global void execute(Database.BatchableContext bc, List<PricebookEntry> scope) {
        List<CommerceEntitlementPolicy> entitlementPolicies = [SELECT Id, Name, Account_SAP_Customer_Code__c FROM CommerceEntitlementPolicy WHERE Account_SAP_Customer_Code__c != NULL AND IsActive = TRUE];
        List<CommerceEntitlementProduct> entitlementProductsToUpsert = new List<CommerceEntitlementProduct>();
        Map<String, CommerceEntitlementPolicy> entPolicyMap = new Map<String, CommerceEntitlementPolicy>();
		CommerceEntitlementProduct ceProduct;
        
        for(CommerceEntitlementPolicy entitlementPolicy : entitlementPolicies){
            entPolicyMap.put(entitlementPolicy.Account_SAP_Customer_Code__c, entitlementPolicy);
        }
        
        if (!scope.isEmpty()) {
            CommerceEntitlementPolicy entitlementPolicy;
            
        	for (PricebookEntry priceBookEnt : scope) {
            	entitlementPolicy = entPolicyMap.get(priceBookEnt.PriceBook2.Account_SAP_Customer_Code__c);
                
                if(entitlementPolicy != null){
                    ceProduct = new CommerceEntitlementProduct();
                    ceProduct.Entitlement_Name__c = entitlementPolicy.Name;
                    ceProduct.Entitlement_Name_Product_Code__c = entitlementPolicy.Name + priceBookEnt.Product2.ProductCode;
                    ceProduct.PolicyId = entitlementPolicy.Id;
                    ceProduct.ProductId = priceBookEnt.Product2Id;
                    ceProduct.Product_Code__c = priceBookEnt.Product2.ProductCode;
                    entitlementProductsToUpsert.add(ceProduct);
                }
            }

            if (entitlementProductsToUpsert != null && entitlementProductsToUpsert.size() > 0) {
                Database.insert(entitlementProductsToUpsert, false);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}