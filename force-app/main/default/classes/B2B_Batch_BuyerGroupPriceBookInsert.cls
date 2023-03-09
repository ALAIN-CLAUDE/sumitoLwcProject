global class B2B_Batch_BuyerGroupPriceBookInsert implements Database.Batchable<sObject> {
    private static final String WEB_STORE_NAME = Label.B2B_Store_Name;
    private List<String> accSAPCustCodes;
    
    public B2B_Batch_BuyerGroupPriceBookInsert() {}

    public B2B_Batch_BuyerGroupPriceBookInsert(List<String> accSAPCustCodes) {
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
        List<BuyerGroupPricebook> buyerGroupPricebookToInsert = new List<BuyerGroupPricebook>();
        List<Pricebook2> priceBooks = [SELECT Id, Account_SAP_Customer_Code__c, (SELECT Id FROM BuyerGroupPricebooks) FROM Pricebook2 WHERE Account_SAP_Customer_Code__c LIKE '6%'];
        Map<String, BuyerGroup> buyerGroupMap = new Map<String, BuyerGroup>();

        for (BuyerGroup bg : scope) {
            buyerGroupMap.put(bg.Account_SAP_Customer_Code__c, bg);
        }
        
        
        if (!scope.isEmpty()) {
            BuyerGroup bg;
            Pricebook2 priceBookReference;
            BuyerGroupPricebook bgpb;

            for (Pricebook2 pb : priceBooks) {
                if (pb.BuyerGroupPricebooks.size() == 0) {
                    bg = buyerGroupMap.get(pb.Account_SAP_Customer_Code__c);
                    
                    if(bg != null){
                        bgpb = new BuyerGroupPricebook();
                        priceBookReference = new Pricebook2(Account_SAP_Customer_Code__c = bg.Account_SAP_Customer_Code__c);
                        bgpb.BuyerGroupId = bg.Id;
                        bgpb.Pricebook2 = priceBookReference;
                        bgpb.Account_SAP_Customer_Code__c = bg.Account_SAP_Customer_Code__c;
                        bgpb.isActive = true;
                        buyerGroupPricebookToInsert.add(bgpb);
                    }
                }
            }
            
            if (buyerGroupPricebookToInsert.size() > 0) {
                Database.insert(buyerGroupPricebookToInsert, false);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }

}