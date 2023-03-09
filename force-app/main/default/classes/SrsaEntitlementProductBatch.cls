@RestResource(urlMapping='/SrsaEntitlementProductBatch/*')
global class SrsaEntitlementProductBatch {
	@HttpGet
    global static String startBatchJob() {
        Map<String, Org_Variables__mdt> orgVars = Org_Variables__mdt.getAll();
        
        B2B_Batch_InsertNewProductEntitlements batchObject = new B2B_Batch_InsertNewProductEntitlements(orgVars.get('Last_B2B_Price_Book_Update_Insert').Date_Time_Value__c);
        String batchId = Database.executeBatch(batchObject);
        
        B2B_Batch_DeleteProductEntitlements delteBatchObject = new B2B_Batch_DeleteProductEntitlements(orgVars.get('Last_B2B_Price_Book_Update_Delete').Date_Time_Value__c);
        batchId += ', ' + Database.executeBatch(delteBatchObject);

        UpdateMDTLastB2BPriceBookDate.updateCustomMetadata('Last_B2B_Price_Book_Update_Insert');
        UpdateMDTLastB2BPriceBookDate.updateCustomMetadata('Last_B2B_Price_Book_Update_Delete');
        return batchId;
    }
}