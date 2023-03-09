/**
 * @description       : Test class for B2B_Batch_UpdateProductNTFields
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class B2B_Batch_UpdateProductNTFieldsTest {
	@testSetup
    public static void createData(){
        List<Product2> prods = new List<Product2>();
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Product1';
        prod1.RIM_Size__c = '11';
        prod1.PDT_Code__c = 'Test1';
        prod1.StockKeepingUnit = 'Test1';
        prod1.ProductCode = 'Test1';
        prod1.x_distr_chain_status_code__c = 'ON';
        prod1.IsActive = true;
        prod1.Tyre_Size_Description__c = '145/80R10';
        prods.add(prod1);

        Product2 prod2 = new Product2();
        prod2.Name = 'Product2';
        prod2.RIM_Size__c = '12';
        prod2.PDT_Code__c = 'Test2';
        prod2.StockKeepingUnit = 'Test2';
        prod2.ProductCode = 'Test2';
        prod2.x_distr_chain_status_code__c = 'ON';
        prod2.IsActive = true;
        prod2.Tyre_Size_Description__c = '145/80R10';
        prods.add(prod2);

        Product2 prod3 = new Product2();
        prod3.Name = 'Product3';
        prod3.RIM_Size__c = '13';
        prod3.PDT_Code__c = 'Test3';
        prod3.StockKeepingUnit = 'Test3';
        prod3.ProductCode = 'Test3';
        prod3.x_distr_chain_status_code__c = 'ON';
        prod3.IsActive = true;
        prod3.Tyre_Size_Description__c = '145/80R10';
        prods.add(prod3);
        
        insert prods;
    }
    
    @isTest
    public static void testBatch(){
        List<Product2> prods = [SELECT Id, NT_Tyre_Size__c FROM Product2];
        
        for(Product2 prod : prods){
            prod.NT_Tyre_Size__c = null;
        }
        
        update prods;
        
        Test.startTest();
        B2B_Batch_UpdateProductNTFields batchClass = new B2B_Batch_UpdateProductNTFields();
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
        
        prods = [SELECT Id FROM Product2 WHERE NT_Tyre_Size__c = null];
        System.assertEquals(0, prods.size());
    }
}