global class Batch_InsertProductStandardPrices implements Database.Batchable<sObject>, Database.Stateful{
    public Database.SaveResult[] saveResults;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Product2]);
    }

    global void execute(Database.BatchableContext bc, List<Product2> products) {
        PriceBook2 priceBook = [SELECT Id FROM PriceBook2 WHERE isStandard = true];
        List<PriceBookEntry> priceBookEntries = new List<PriceBookEntry>();
        List<CurrencyType> currencTypes = [SELECT IsoCode FROM CurrencyType WHERE isActive = true];
        PriceBookEntry priceBookEntry;
        
        for(Product2 product : products){
            for(CurrencyType currencType : currencTypes){
                priceBookEntry = new PriceBookEntry();
                priceBookEntry.Product2Id = product.Id;
                priceBookEntry.IsActive = true;
                priceBookEntry.UnitPrice = 150;
                priceBookEntry.Pricebook2Id = priceBook.Id;
                priceBookEntry.currencyisocode = currencType.IsoCode;
                priceBookEntries.add(priceBookEntry);
            }
        }
        
        saveResults = Database.Insert(priceBookEntries, false);
    }
    
    global void finish(Database.BatchableContext bc) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'ephetehe.mokgopanyane@tetrad.co.za'}; 
            mail.setToAddresses(toAddresses);
        mail.setSubject('Kgops');
        mail.setPlainTextBody('Hello: ' + JSON.serializePretty(saveResults));
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}