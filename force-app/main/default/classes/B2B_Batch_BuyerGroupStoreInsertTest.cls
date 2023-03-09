/**
 * @description       : Test class for B2B_Batch_BuyerGroupStoreInsert
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class B2B_Batch_BuyerGroupStoreInsertTest {
	@testSetup
    public static void createData(){
        WebStore store = new WebStore();
        store.Name = 'Sumitomo Rubber South Africa';
        insert store;
        
        Account account = new Account();
		account.Name = 'SRSA';
        account.Stage__c = 'Active';
        account.SAP_Customer_Code__c = '6TestSAP142536';
		insert account;
        
        BuyerGroup bg = new BuyerGroup();
        bg.Name = '6TestSAP142536';
        bg.Account_SAP_Customer_Code__c = '6TestSAP142536';
        insert bg;
    }
    
    @isTest
    public static void testBatch(){
        Test.startTest();
        B2B_Batch_BuyerGroupStoreInsert batchClass = new B2B_Batch_BuyerGroupStoreInsert();
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<WebStoreBuyerGroup> webStoreBuyerGroups = [SELECT Id FROM WebStoreBuyerGroup];
        System.assertEquals(1, webStoreBuyerGroups.size());
    }
    
    @isTest
    public static void testBatchWithCustCodes(){
        Test.startTest();
        B2B_Batch_BuyerGroupStoreInsert batchClass = new B2B_Batch_BuyerGroupStoreInsert(new List<String>{'6TestSAP142536'});
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<WebStoreBuyerGroup> webStoreBuyerGroups = [SELECT Id FROM WebStoreBuyerGroup];
        System.assertEquals(1, webStoreBuyerGroups.size());
    }
}