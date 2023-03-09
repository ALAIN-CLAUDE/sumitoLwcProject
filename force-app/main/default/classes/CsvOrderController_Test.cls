@IsTest
public class CsvOrderController_Test {
    @TestSetup
    private static void testDataSetup(){
        Account acc = new Account(Name = 'B2B Test Account', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest123');
        insert acc;
        Pricebook2 pb = new Pricebook2(Name = 'B2B Test PriceBook', IsActive = true, Account_SAP_Customer_Code__c = 'B2BTest123');
        insert pb;
        Product2 p = new Product2(Name = 'B2B Test Product', IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode');
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
    }

    @IsTest
    private static void sendStorePricebook_Test(){
        Account Acc = [SELECT Id FROM Account WHERE Name = 'B2B Test Account'];
        EmailTemplate et = new EmailTemplate();
        et.isActive = TRUE;
        et.Name = 'b2b_Pricebook';
        et.DeveloperName = 'b2b_Pricebook';
        et.TemplateType = 'text';
        et.FolderId = UserInfo.getUserId();
        insert et;
        CsvOrderController.sendStorePricebook(UserInfo.getUserId(), Acc.Id);
    }

    @IsTest
    private static void fillCartFromCSVTest(){
        Account Acc = [SELECT Id FROM Account WHERE Name = 'B2B Test Account'];
        String csvContent = 'ProductCode,Quantity,Name,UnitPrice,NetPrice\n' + 
        'TestCode,2,2';
        CsvOrderController.fillCartFromCSV(csvContent, Acc.Id, 'ProductCode', ',');
    }
}