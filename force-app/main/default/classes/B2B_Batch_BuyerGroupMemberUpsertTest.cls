/**
 * @description       : Test class for B2B_Batch_BuyerGroupMemberUpsert
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class B2B_Batch_BuyerGroupMemberUpsertTest {
	@testSetup
    public static void createData(){
        Account account = new Account();
		account.Name = 'SRSA';
        account.Stage__c = 'Active';
        account.SAP_Customer_Code__c = '6TestSAP142536';
		insert account;
        
        BuyerGroup bg = new BuyerGroup();
        bg.Name = '6TestSAP142536';
        bg.Account_SAP_Customer_Code__c = '6TestSAP142536';
        insert bg;
        
        BuyerAccount ba = new BuyerAccount();
        ba.BuyerId = account.Id;
        ba.IsActive = true;
        ba.Name = 'SRSA';
        ba.Buyer_SAP_Customer_Code__c = '6TestSAP142536';
        ba.BuyerStatus = 'Active';
        insert ba;
    }
    
    @isTest
    public static void testBatch(){
        Test.startTest();
        B2B_Batch_BuyerGroupMemberUpsert batchClass = new B2B_Batch_BuyerGroupMemberUpsert();
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<BuyerGroupMember> buyerGroupMembers = [SELECT Id FROM BuyerGroupMember];
        System.assertEquals(1, buyerGroupMembers.size());
    }
    
    @isTest
    public static void testBatchWithCustCodes(){
        Test.startTest();
        B2B_Batch_BuyerGroupMemberUpsert batchClass = new B2B_Batch_BuyerGroupMemberUpsert(new List<String>{'6TestSAP142536'});
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
        
        List<BuyerGroupMember> buyerGroupMembers = [SELECT Id FROM BuyerGroupMember];
        System.assertEquals(1, buyerGroupMembers.size());
    }
}