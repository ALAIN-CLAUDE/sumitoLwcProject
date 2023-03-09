global class B2B_Batch_InsertNewProductEntitlements implements Database.Batchable<sObject> {
    private static final String WEB_STORE_NAME = Label.B2B_Store_Name;
    private DateTime lastB2BPriceBookUpdateInsert;
    
    public B2B_Batch_InsertNewProductEntitlements(DateTime lastB2BPriceBookUpdateInsert) {
        this.lastB2BPriceBookUpdateInsert = lastB2BPriceBookUpdateInsert;
    }
    
	global Database.QueryLocator start(Database.BatchableContext bc) {
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
            	AND CreatedDate >: lastB2BPriceBookUpdateInsert
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<PricebookEntry> priceBookEntries) {
        Map<String, CommerceEntitlementPolicy> entitlementPolicyMap = new Map<String, CommerceEntitlementPolicy>();
        List<CommerceEntitlementProduct> entitlementProductsToUpsert = new List<CommerceEntitlementProduct>();
        Set<String> entitlementPolicySAPCodes = new set<String>();
        
        if (!priceBookEntries.isEmpty()) {
            for(PricebookEntry priceBookEntry : priceBookEntries){
                entitlementPolicySAPCodes.add(priceBookEntry.PriceBook2.Account_SAP_Customer_Code__c);
            }
            
            List<CommerceEntitlementPolicy> entitlementPolicies = [SELECT Id, Name, Account_SAP_Customer_Code__c FROM CommerceEntitlementPolicy WHERE Account_SAP_Customer_Code__c IN: entitlementPolicySAPCodes];
            CommerceEntitlementProduct ceProduct;
            
            if(entitlementPolicies != null && entitlementPolicies.size() > 0){
                for(CommerceEntitlementPolicy entitlementPolicy : entitlementPolicies){
                    entitlementPolicyMap.put(entitlementPolicy.Account_SAP_Customer_Code__c, entitlementPolicy);
                }
                
                CommerceEntitlementPolicy entitlementPolicy;
                
                for(PricebookEntry priceBookEntry : priceBookEntries){
                    entitlementPolicy = entitlementPolicyMap.get(priceBookEntry.PriceBook2.Account_SAP_Customer_Code__c);
                    
                    if(entitlementPolicy != null){
                        ceProduct = new CommerceEntitlementProduct();
                        ceProduct.Entitlement_Name__c = entitlementPolicy.Name;
                        ceProduct.Entitlement_Name_Product_Code__c = entitlementPolicy.Name + priceBookEntry.Product2.ProductCode;
                        ceProduct.PolicyId = entitlementPolicy.Id;
                        ceProduct.ProductId = priceBookEntry.Product2Id;
                        ceProduct.Product_Code__c = priceBookEntry.Product2.ProductCode;
                        entitlementProductsToUpsert.add(ceProduct);
                    }
                }
                
                if(entitlementProductsToUpsert != null && entitlementProductsToUpsert.size() > 0){
                    Database.insert(entitlementProductsToUpsert, false);
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc) {
        if (!Test.isRunningTest()) {
            WebStore store = [SELECT Id FROM WebStore WHERE Name =: WEB_STORE_NAME];
            ConnectApi.CommerceSearchSettings.createCommerceSearchIndex(store.Id);
        }
    }
}