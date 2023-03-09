global class B2B_Batch_DeleteProductEntitlements implements Database.Batchable<sObject> {
    private static final String WEB_STORE_NAME = Label.B2B_Store_Name;
    private DateTime lastB2BPriceBookUpdateDelete;
    
    public B2B_Batch_DeleteProductEntitlements(DateTime lastB2BPriceBookUpdateDelete) {
        this.lastB2BPriceBookUpdateDelete = lastB2BPriceBookUpdateDelete;
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
            	WHERE (IsActive = FALSE OR UnitPrice = 0)
                AND PriceBook2.Account_SAP_Customer_Code__c IN: accSapCustCodes 
            	AND LastModifiedDate >: lastB2BPriceBookUpdateDelete
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<PricebookEntry> priceBookEntries) {
        Set<String> entitlementPolicyNameProdCodes = new set<String>();
        
        if (!priceBookEntries.isEmpty()) {
            for(PricebookEntry priceBookEntry : priceBookEntries){
                entitlementPolicyNameProdCodes.add(priceBookEntry.PriceBook2.Account_SAP_Customer_Code__c + priceBookEntry.Product2.ProductCode);
            }
            
            List<CommerceEntitlementProduct> entitlementPolicyProds = [SELECT Id FROM CommerceEntitlementProduct WHERE Entitlement_Name_Product_Code__c IN: entitlementPolicyNameProdCodes];

            if(entitlementPolicyProds != null && entitlementPolicyProds.size() > 0){
                delete entitlementPolicyProds;
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