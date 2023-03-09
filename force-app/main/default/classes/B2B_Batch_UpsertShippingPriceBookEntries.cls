global class B2B_Batch_UpsertShippingPriceBookEntries implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c, CurrencyISOCode
                FROM Pricebook2
                WHERE isStandard = false AND Account_SAP_Customer_Code__c LIKE '6%'
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Pricebook2> scope) {
        if (!scope.isEmpty()) {
            List<Product2> products = [SELECT Id FROM Product2 WHERE Name = 'Standard Shipping Charge'];
            List<PriceBookEntry> priceBookEntries = new List<PriceBookEntry>();
            PriceBookEntry priceBookEnt;
            
            if(products != null && products.size() > 0){
                for(Pricebook2 priceBook : scope){
                    priceBookEnt = new PriceBookEntry();
                    priceBookEnt.Product2Id = products[0].Id;
                    priceBookEnt.IsActive = true;
                    priceBookEnt.UnitPrice = 0;
                    priceBookEnt.Pricebook2Id = priceBook.Id;
                    priceBookEnt.Key__c = priceBook.Account_SAP_Customer_Code__c + '-SSC';
                    priceBookEntries.add(priceBookEnt);
                }
                
                if (priceBookEntries.size() > 0) {
                    Database.upsert(priceBookEntries, PriceBookEntry.Key__c, false);
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}