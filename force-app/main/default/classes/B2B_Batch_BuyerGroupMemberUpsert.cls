global class B2B_Batch_BuyerGroupMemberUpsert implements Database.Batchable<sObject> {
    private static final String WEB_STORE_NAME = Label.B2B_Store_Name;
    private List<String> accSAPCustCodes;
    
    public B2B_Batch_BuyerGroupMemberUpsert() {}

    public B2B_Batch_BuyerGroupMemberUpsert(List<String> accSAPCustCodes) {
        this.accSAPCustCodes = accSAPCustCodes;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
		if(accSAPCustCodes != null && accSAPCustCodes.size() > 0){
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM BuyerGroup
                WHERE Account_SAP_Customer_Code__c IN: accSAPCustCodes
            ]);
        } else {
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM BuyerGroup
                WHERE Account_SAP_Customer_Code__c LIKE '6%'
            ]);
        }
    }

    global void execute(Database.BatchableContext bc, List<BuyerGroup> scope) {
        List<BuyerGroupMember> buyerGroupMemberToUpsert = new List<BuyerGroupMember>();
        Map<String, BuyerGroup> buyerGroupMap = new Map<String, BuyerGroup>();
        Set<String> buyerSAPCustCodes = new Set<String>();

        for (BuyerGroup bg : scope) {
        	buyerSAPCustCodes.add(bg.Account_SAP_Customer_Code__c);
            buyerGroupMap.put(bg.Account_SAP_Customer_Code__c, bg);
        }

        List<BuyerAccount> buyerAccounts = [SELECT Id, Buyer_SAP_Customer_Code__c, BuyerId FROM BuyerAccount WHERE Buyer_SAP_Customer_Code__c IN: buyerSAPCustCodes];

        if (!scope.isEmpty()) {
            BuyerGroup bg;

            for (BuyerAccount bac : buyerAccounts) {
                if (buyerGroupMap.get(bac.Buyer_SAP_Customer_Code__c) != null) {
                    bg = buyerGroupMap.get(bac.Buyer_SAP_Customer_Code__c);
                    BuyerGroupMember bgm = new BuyerGroupMember();
                    BuyerGroup buyerGroupReference = new BuyerGroup(Account_SAP_Customer_Code__c = bg.Account_SAP_Customer_Code__c);
                    bgm.BuyerGroup = buyerGroupReference;
                    bgm.BuyerId = bac.BuyerId;
                    bgm.Account_SAP_Customer_Code__c = bg.Account_SAP_Customer_Code__c;
                    buyerGroupMemberToUpsert.add(bgm);
                }
            }

            if (buyerGroupMemberToUpsert.size() > 0) {
                Database.upsert(buyerGroupMemberToUpsert, BuyerGroupMember.Account_SAP_Customer_Code__c, false);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}