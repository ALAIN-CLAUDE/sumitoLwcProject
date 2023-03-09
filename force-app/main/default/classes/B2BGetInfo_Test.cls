@IsTest
public with sharing class B2BGetInfo_Test {
    @IsTest(SeeAllData = true)
    static void getCartSummary_Test(){
        Account acc = new Account(Name = 'B2B Test Account', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest123');
        insert acc;
        Pricebook2 pb = new Pricebook2(Name = 'B2B Test PriceBook', IsActive = true, Account_SAP_Customer_Code__c = 'B2BTest123');
        insert pb;
        Product2 p = new Product2(Name = 'B2B Test Product 1711', IsActive = true, ProductCode = 'TestCode1711', PDT_Code__c = 'TestPDTCode123');
        insert p;
        PricebookEntry spbe = new PricebookEntry(Product2Id = p.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 0);
        insert spbe;
        PricebookEntry pbe = new PricebookEntry(IsActive = true, Product2Id = p.Id, Pricebook2Id = pb.Id, Net_Price__c = 1, UnitPrice = 1, UseStandardPrice = false);
        insert pbe;
        BuyerGroup bg = new BuyerGroup(Name = 'B2B Test BuyerGroup', Account_SAP_Customer_Code__c = 'B2BTest123');
        insert bg;
        BuyerAccount buyerAccount = new BuyerAccount(BuyerId = acc.Id, Name = 'B2B Test BuyerAccount', IsActive = true);
        insert buyerAccount;
        BuyerGroupMember bgm = new BuyerGroupMember(BuyerGroupId = bg.Id, BuyerId = acc.Id);
        insert bgm;
        BuyerGroupPricebook bgpb = new BuyerGroupPricebook(Pricebook2Id = pb.Id, BuyerGroupId = bg.Id);
        insert bgpb;
        OrgWideEmailAddress[] addresses = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
        system.debug(addresses);
        WebStore store = new WebStore();
        store.Name = 'Sumitomo Rubber South Africa';
        insert store;
        WebCart wc = new WebCart(Name = 'B2B Test WebCart', AccountId = acc.Id, Status = 'Active', TaxType = 'Net', Type = 'Cart', WebStoreId = store.Id);
        insert wc;
        String communityId = [SELECT Id FROM Network WHERE Name LIKE 'Sumitomo%' LIMIT 1].Id;
        Test.startTest();
        try{
            B2BGetInfo.getCartSummary(communityId, acc.Id);
        }catch(Exception e){}

        Test.stopTest();
    }
    @IsTest
    static void checkProductIsInStock_Test(){
        Test.setMock(HttpCalloutMock.class, new httpMockResponse());
        Product2 p = new Product2(Name = 'B2B Test Product 123', IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode01',PDT_Code__c = 'TestPDTCode');
        insert p;
        Test.startTest();
        B2BGetInfo.checkProductIsInStock(p.Id);
        Test.stopTest();
    }

    @IsTest(SeeAllData = true)
    private static void getProduct_Test(){
        Account acc = new Account(Name = 'B2B Test Account 1234', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest1234', Delivering_Plant__c = 'DU01');
        insert acc;
        Product2 p = new Product2(Name = 'B2B Test Product 1234', IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode01',PDT_Code__c = 'TestPDTCode');
        insert p;
        String communityId = [SELECT Id FROM Network WHERE Name like 'Sumitomo%' LIMIT 1].Id;
        Test.startTest();
        try {
            B2BGetInfo.getProduct(communityId, p.Id, acc.Id);
        } catch(Exception e) {
            System.debug('Exception is - ' +e);
        }
        Test.stopTest();
    }

    @IsTest(SeeAllData = true)
    private static void addToCart_Test(){
        Account acc = new Account(Name = 'B2B Test Account 1234', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest1234', Delivering_Plant__c = 'DU01');
        insert acc;
        Product2 p = new Product2(Name = 'B2B Test Product 1234', IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode01',PDT_Code__c = 'TestPDTCode');
        insert p;
        String communityId = [SELECT Id FROM Network WHERE Name like 'Sumitomo%' LIMIT 1].Id;
        Test.startTest();
        try {
            B2BGetInfo.addToCart(communityId, p.Id, '1', acc.Id);
        } catch(Exception e) {
            System.debug('Exception is - ' +e);
        }
        Test.stopTest();
    }

    @IsTest(SeeAllData = true)
    private static void createAndAddToList_Test(){
        Account acc = new Account(Name = 'B2B Test Account 1234', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest1234', Delivering_Plant__c = 'DU01');
        insert acc;
        Product2 p = new Product2(Name = 'B2B Test Product 1234', IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode01',PDT_Code__c = 'TestPDTCode');
        insert p;
        String communityId = [SELECT Id FROM Network WHERE Name like 'Sumitomo%' LIMIT 1].Id;
        Test.startTest();
        try {
            B2BGetInfo.createAndAddToList(communityId, p.Id, 'Test Wishlist', acc.Id);
        } catch(Exception e) {
            System.debug('Exception is - ' +e);
        }
        Test.stopTest();
    }

    @IsTest(SeeAllData = true)
    private static void getProductPrice_Test(){
        Account acc = new Account(Name = 'B2B Test Account 1234', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest1234', Delivering_Plant__c = 'DU01');
        insert acc;
        Product2 p = new Product2(Name = 'B2B Test Product 1234', IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode01',PDT_Code__c = 'TestPDTCode');
        insert p;
        String communityId = [SELECT Id FROM Network WHERE Name like 'Sumitomo%' LIMIT 1].Id;
        Test.startTest();
        try {
            B2BGetInfo.getProductPrice(communityId, p.Id, acc.Id);
        } catch(Exception e) {
            System.debug('Exception is - ' +e);
        }
        Test.stopTest();
    }

    public class httpMockResponse implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatus('OK');
            res.setBody('{"productsPage" : {"products" : [{"id" : "B2BTest1234"}]}}');
            res.setStatusCode(200);
            return res;
        }
    }
}