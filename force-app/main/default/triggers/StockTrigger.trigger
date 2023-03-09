trigger StockTrigger on Stock__c (After Insert, After Update, After Delete, After Undelete) {
/*StockTriggerHelper cth =new StockTriggerHelper();
    set<id> pids = new set<id>();
    if(trigger.isAfter && (trigger.isInsert||trigger.isUpdate))
    {
       cth.updateTotalQuantity((list<Stock__c>)Trigger.new);
       cth.updateStockQuantity((list<Stock__c>)Trigger.new);
    }
    if(trigger.isAfter && (trigger.isUpdate||trigger.isDelete))
    {
        for(Stock__c st : trigger.old)
        {
            if(st.Product__c !=Null)
                pids.add(st.Product__c);
        }
        //cth.updateTotalQuantity(pids);
    }*/
    
}