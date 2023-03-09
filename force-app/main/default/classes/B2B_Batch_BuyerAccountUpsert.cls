global class B2B_Batch_BuyerAccountUpsert implements Database.Batchable<sObject> {
    private static final String statusActive = 'Active';
    private List<String> accSAPCustCodes;

    public B2B_Batch_BuyerAccountUpsert() {}
    
    public B2B_Batch_BuyerAccountUpsert(List<String> accSAPCustCodes) {
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
        List<BuyerAccount> listBuyerAccountToUpsert = new List<BuyerAccount>();
        if (!scope.isEmpty()) {
            for (Pricebook2 pb : scope) {
                pricebookSAPCode.add(pb.Account_SAP_Customer_Code__c);
            }
            List<Account> matchingAccountList = [SELECT Id, Name, SAP_Customer_Code__c FROM Account WHERE SAP_Customer_Code__c IN:pricebookSAPCode AND Stage__c = 'Active'];

            if (!matchingAccountList.isEmpty()) {
                for (Account acc : matchingAccountList) {
                    BuyerAccount ba = new BuyerAccount();
                    ba.BuyerId = acc.Id;
                    ba.IsActive = true;
                    ba.Name = acc.Name;
                    ba.Buyer_SAP_Customer_Code__c = acc.SAP_Customer_Code__c;
                    ba.BuyerStatus = statusActive;
                    listBuyerAccountToUpsert.add(ba);
                }
                if (listBuyerAccountToUpsert.size() > 0) {
                    Database.upsert(listBuyerAccountToUpsert, BuyerAccount.Buyer_SAP_Customer_Code__c, false);
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}