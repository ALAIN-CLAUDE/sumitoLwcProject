global class B2B_Batch_UpdateProductNTFields implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
                SELECT Id, NT_Tyre_Size__c, Tyre_Size_Description__c
                FROM Product2
                WHERE NT_Tyre_Size__c = null AND Tyre_Size_Description__c <> null
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Product2> products) {
        if (!products.isEmpty()) {
            for(Product2 prod : products){
                prod.NT_Tyre_Size__c = prod.Tyre_Size_Description__c;
            }

            Database.update(products, false);
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}