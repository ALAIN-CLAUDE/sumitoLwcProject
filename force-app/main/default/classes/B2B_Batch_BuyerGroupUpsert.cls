global class B2B_Batch_BuyerGroupUpsert implements Database.Batchable<sObject> {
    private List<String> accSAPCustCodes;
    
    public B2B_Batch_BuyerGroupUpsert() {}
    
    public B2B_Batch_BuyerGroupUpsert(List<String> accSAPCustCodes) {
        this.accSAPCustCodes = accSAPCustCodes;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(accSAPCustCodes != null && accSAPCustCodes.size() > 0){
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM Pricebook2
                WHERE Account_SAP_Customer_Code__c IN: (accSAPCustCodes)
            ]);
        } else {
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM Pricebook2
                WHERE Account_SAP_Customer_Code__c LIKE '6%'
            ]);
        }
    }

    global void execute(Database.BatchableContext bc, List<Pricebook2> scope) {
        List<String> pricebookSAPCode = new List<String>();
        List<BuyerGroup> listBuyerGroupToUpsert = new List<BuyerGroup>();
        if (!scope.isEmpty()) {
            for (Pricebook2 pb : scope) {
                pricebookSAPCode.add(pb.Account_SAP_Customer_Code__c);
            }

            List<Account> matchingAccountList = [SELECT Id, Name, SAP_Customer_Code__c FROM Account WHERE SAP_Customer_Code__c IN:pricebookSAPCode];

            if (!matchingAccountList.isEmpty()) {
                for (Account acc : matchingAccountList) {
                    BuyerGroup bg = new BuyerGroup();
                    bg.Name = acc.SAP_Customer_Code__c;
                    bg.Description = acc.Name;
                    bg.Account_SAP_Customer_Code__c = acc.SAP_Customer_Code__c;
                    listBuyerGroupToUpsert.add(bg);
                }

                if (listBuyerGroupToUpsert.size() > 0) {
                    Database.upsert(listBuyerGroupToUpsert, BuyerGroup.Account_SAP_Customer_Code__c, false);
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}