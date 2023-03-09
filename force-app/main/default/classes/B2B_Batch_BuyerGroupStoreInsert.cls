global class B2B_Batch_BuyerGroupStoreInsert implements Database.Batchable<sObject> {
    private static final String WEB_STORE_NAME = Label.B2B_Store_Name;
    private List<String> accSAPCustCodes;
    
    public B2B_Batch_BuyerGroupStoreInsert() {}

    public B2B_Batch_BuyerGroupStoreInsert(List<String> accSAPCustCodes) {
        this.accSAPCustCodes = accSAPCustCodes;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(accSAPCustCodes != null && accSAPCustCodes.size() > 0){
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c, (SELECT Id FROM WebStoreBuyerGroups)
                FROM BuyerGroup
                WHERE Account_SAP_Customer_Code__c LIKE '6%' AND Account_SAP_Customer_Code__c IN: accSapCustCodes
            ]);
        } else {
            List<Account> accounts = [SELECT Id, SAP_Customer_Code__c FROM Account WHERE Stage__c = 'Active' AND SAP_Customer_Code__c LIKE '6%'];
            Set<String> accSapCustCodes = new Set<String>();

            for(Account acc : accounts){
                accSapCustCodes.add(acc.SAP_Customer_Code__c);
            }

            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c, (SELECT Id FROM WebStoreBuyerGroups)
                FROM BuyerGroup
                WHERE Account_SAP_Customer_Code__c LIKE '6%' AND Account_SAP_Customer_Code__c IN: accSapCustCodes
            ]);
        }
    }

    global void execute(Database.BatchableContext bc, List<BuyerGroup> scope) {
        List<WebStoreBuyerGroup> buyerGroupStoreToInsert = new List<WebStoreBuyerGroup>();
        Id webStoreId = [SELECT Id FROM WebStore WHERE Name =: WEB_STORE_NAME].Id;
        
        if (!scope.isEmpty()) {
            for (BuyerGroup bg : scope) {
                if (bg.WebStoreBuyerGroups.size() == 0) {
                    WebStoreBuyerGroup sbg = new WebStoreBuyerGroup();
                    sbg.BuyerGroupId = bg.Id;
                    sbg.WebStoreId = webStoreId;
                    sbg.Account_SAP_Customer_Code__c = bg.Account_SAP_Customer_Code__c;
                    buyerGroupStoreToInsert.add(sbg);
                }
            }
            if (buyerGroupStoreToInsert.size() > 0) {
                Database.insert(buyerGroupStoreToInsert, false);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }

}