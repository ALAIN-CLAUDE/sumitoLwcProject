/**
 * @description       : Test class for B2B_Batch_ContactPointAddressesUpsert
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class B2B_Batch_ContactPointAddressesUpsTest {
	
	@testSetup
    public static void createData(){
        Account account = new Account();
		account.Name = 'SRSA';
        account.Stage__c = 'Active';
        account.SAP_Customer_Code__c = '6TestSAP142536';
		insert account;
        
        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = '6TestSAP142536';
        insert priceBook;
        
        Schema.Location loc = new Schema.Location();
        loc.Name = 'Test Location';
        loc.SAP_Customer_Code__c = '00659005';
        loc.Street_Address__c = '5 Libertas Road';
        loc.City__c = 'Sandton';
        loc.Province__c = 'Gauteng';
        loc.Country__c = 'South Africa';
        loc.Postal_Code__c = '2191';
        insert loc;

        AssociatedLocation assocLocation = new AssociatedLocation();
        assocLocation.ParentRecordId = account.Id;
        assocLocation.LocationId = loc.Id;
        insert assocLocation;
    }
    
    @isTest
    public static void testBatch(){
        Test.startTest();
        B2B_Batch_ContactPointAddressesUpsert batchClass = new B2B_Batch_ContactPointAddressesUpsert();
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
    }
    
    @isTest
    public static void testBatchWithCustCodes(){
        Test.startTest();
        B2B_Batch_ContactPointAddressesUpsert batchClass = new B2B_Batch_ContactPointAddressesUpsert();
        Id batchId = Database.executeBatch(batchClass);
        Test.stopTest();
    }
}