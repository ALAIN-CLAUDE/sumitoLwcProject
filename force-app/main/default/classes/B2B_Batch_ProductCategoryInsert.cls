global class B2B_Batch_ProductCategoryInsert implements Database.Batchable<sObject>{
    private static final String WEB_STORE_NAME = Label.B2B_Store_Name;
    private static final String WEB_STORE_CATALOG_NAME = Label.B2B_Store_Catalog_Name;
    public Database.SaveResult[] saveResults;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
                SELECT Id, MatGRP2_Description__c
                FROM Product2
                WHERE IsActive = TRUE AND MatGRP2_Description__c <> null
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Product2> scope) {
        Map<String, Id> prodCategoryIdMap = new Map<String, Id>();
        Set<String> productMatGrpDesc = new Set<String>();
        Set<Id> productIds = new Set<Id>();

        if(!scope.isEmpty()){
            for(Product2 product : scope){
                productIds.add(product.Id);
                productMatGrpDesc.add(product.MatGRP2_Description__c);
            }

            List<ProductCategory> prodCategories = [SELECT Id, Name FROM ProductCategory WHERE Name IN: productMatGrpDesc];
            
            if(!prodCategories.isEmpty()){
                for(ProductCategory prodCategory : prodCategories){
                    prodCategoryIdMap.put(prodCategory.Name, prodCategory.Id);
                }
                
                List<ProductCategoryProduct> prodCategoryProductToInserts = new List<ProductCategoryProduct>();
                ProductCategoryProduct prodCategoryProductToInsert;
                
                for(Product2 product : scope){
                    prodCategoryProductToInsert = new ProductCategoryProduct();
                    prodCategoryProductToInsert.IsPrimaryCategory = false;
                    prodCategoryProductToInsert.ProductCategoryId = prodCategoryIdMap.get(product.MatGRP2_Description__c);
                    prodCategoryProductToInsert.ProductId = product.Id;
                    prodCategoryProductToInserts.add(prodCategoryProductToInsert);
                }
                
                if(prodCategoryProductToInserts != null && prodCategoryProductToInserts.size() > 0){
                    saveResults = Database.insert(prodCategoryProductToInserts, false);
                }
            }
        }
    }

    global void finish(Database.BatchableContext bc) {
        
    }
}