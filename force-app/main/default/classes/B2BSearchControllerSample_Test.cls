@IsTest
public with sharing class B2BSearchControllerSample_Test {

    @IsTest(SeeAllData = true)
    static void productSearch_Test(){
        Account acc = new Account(Name = 'B2B Test Account 123', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest1234', Delivering_Plant__c = 'DU01');
        insert acc;
        Pricebook2 pb = new Pricebook2(Name = 'B2B Test PriceBook 123', IsActive = true, Account_SAP_Customer_Code__c = 'B2BTest1234');
        insert pb;
        List<Product2> prods = new List<Product2>();
        Product2 prod1 = new Product2(Name = 'B2B Test Product 123' + System.now(), IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode01' + System.now(),PDT_Code__c = 'TestPDTCode' + System.now());
        Product2 prod2 = new Product2(Name = 'B2B Test Product 456' + System.now(), IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode02' + System.now(),PDT_Code__c = 'TestPDTCode2' + System.now());
        prods.add(prod1);
        prods.add(prod2);
        insert prods;
        
        List<PriceBookEntry> spbes = new List<PriceBookEntry>();
        spbes.add(new PricebookEntry(Product2Id = prod1.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 0));
        spbes.add(new PricebookEntry(Product2Id = prod2.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 0));
        insert spbes;
        
        List<PriceBookEntry> pbes = new List<PriceBookEntry>();
        pbes.add(new PricebookEntry(IsActive = true, Product2Id = prod1.Id, Pricebook2Id = pb.Id, Net_Price__c = 1, UnitPrice = 1, UseStandardPrice = false));
        pbes.add(new PricebookEntry(IsActive = true, Product2Id = prod2.Id, Pricebook2Id = pb.Id, Net_Price__c = 1, UnitPrice = 1, UseStandardPrice = false));
        insert pbes;

        Stock__c stock = new Stock__c();
        stock.Product__c = prod1.Id;
        stock.Quantity__c = 15;
        stock.Storage_Location__c = 'WH01';
        stock.Plant__c = 'DU01';
        insert stock;
        
        List<Product2> products = [SELECT Id FROM Product2 WHERE Id IN: new Set<Id>{prod1.Id, prod2.Id}];
        
        String communityId = [SELECT Id FROM Network WHERE Name like 'Sumitomo%' LIMIT 1].Id;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new httpMockResponse(products));
        B2BSearchControllerSample.productSearch(communityId, 'Test', acc.Id);
        Test.stopTest();
    }

    @IsTest
    static void getStockAvailabilityPDP_Test(){
        Map<String, String> pdpFields = new Map<String, String>();
        Account acc = new Account(Name = 'B2B Test Account 123', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest1234', Delivering_Plant__c = 'DU01');
        insert acc;
        Product2 prod1 = new Product2(Name = 'B2B Test Product 123', IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode01',PDT_Code__c = 'TestPDTCode');
        insert prod1;
        
        List<PriceBookEntry> stdPbes = new List<PriceBookEntry>();
        stdPbes.add(new PriceBookEntry(Product2Id=prod1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=700));
        insert stdPbes;

        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = 'TestSAP142536';
        insert priceBook;
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Product2Id = prod1.Id;
        pbe1.IsActive = true;
        pbe1.UnitPrice = 750;
        pbe1.Pricebook2Id = priceBook.Id;
        insert pbe1;
        
        Stock__c stock = new Stock__c();
        stock.Product__c = prod1.Id;
        stock.Quantity__c = 15;
        stock.Storage_Location__c = 'WH01';
        stock.Plant__c = 'DU01';
        insert stock;
        
        B2BSearchControllerSample.PDPWrapper pdp = new B2BSearchControllerSample.PDPWrapper();
        pdp.ID = prod1.Id;
        pdp.fields = pdpFields;
        Test.startTest();
        B2BSearchControllerSample.getStockAvailabilityPDP(pdp, acc.Id);
        Test.stopTest();
    }

    @IsTest
    static void getStockAvailabilityPDP_TestWithPriceBook(){
        Map<String, String> pdpFields = new Map<String, String>();
        Account acc = new Account(Name = 'B2B Test Account 123', Stage__c = 'Active', SAP_Customer_Code__c = 'B2BTest1234', Delivering_Plant__c = 'DU01');
        insert acc;
        Product2 prod1 = new Product2(Name = 'B2B Test Product 123', IsActive = true, x_distr_chain_status_code__c = 'ON', MatGRP2_Description__c = 'Products', ProductCode = 'TestCode01',PDT_Code__c = 'TestPDTCode');
        insert prod1;
        
        List<PriceBookEntry> stdPbes = new List<PriceBookEntry>();
        stdPbes.add(new PriceBookEntry(Product2Id=prod1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=700));
        
        insert stdPbes;

        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = 'B2BTest1234';
        insert priceBook;
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Product2Id = prod1.Id;
        pbe1.IsActive = true;
        pbe1.UnitPrice = 750;
        pbe1.Pricebook2Id = priceBook.Id;
        insert pbe1;
        
        Stock__c stock = new Stock__c();
        stock.Product__c = prod1.Id;
        stock.Quantity__c = 15;
        stock.Storage_Location__c = 'WH01';
        stock.Plant__c = 'DU01';
        insert stock;
        
        Expected_Delivery_Date__c expDelDate = new Expected_Delivery_Date__c();
        expDelDate.Inbound_Date__c = System.today() + 7;
        expDelDate.Stock_Name__c = stock.Id;
        expDelDate.Inbound_Qty__c = 20;
        insert expDelDate;
        
        B2BSearchControllerSample.PDPWrapper pdp = new B2BSearchControllerSample.PDPWrapper();
        pdp.ID = prod1.Id;
        pdp.fields = pdpFields;
        Test.startTest();
        B2BSearchControllerSample.getStockAvailabilityPDP(pdp, acc.Id);
        Test.stopTest();
    }

    @IsTest
    static void calcDeliveryMessage_Test(){
        List<ETA_Messages__mdt> etaMessages = [SELECT Id, DeveloperName, Message__c FROM ETA_Messages__mdt];
        B2BSearchControllerSample.calcDeliveryMessage(System.today(), 1, etaMessages);
    }

    @IsTest
    static void calcStockMessage_Test1(){
        List<Stock_Message__mdt> etaMessages = [SELECT Id, Message__c FROM Stock_Message__mdt LIMIT 1];
        Map<String, Stock_Message__mdt> mapFromEtaMessages = new Map<String, Stock_Message__mdt>();
        for(Stock_Message__mdt sm :etaMessages){
            mapFromEtaMessages.put('First_Level',sm);
        }
        B2BSearchControllerSample.calcStockMessage(mapFromEtaMessages, 1);
    }

    @IsTest
    static void calcStockMessage_Test2(){
        List<Stock_Message__mdt> etaMessages = [SELECT Id, Message__c FROM Stock_Message__mdt LIMIT 1];
        Map<String, Stock_Message__mdt> mapFromEtaMessages = new Map<String, Stock_Message__mdt>();
        for(Stock_Message__mdt sm :etaMessages){
            mapFromEtaMessages.put('Second_Level',sm);
        }
        B2BSearchControllerSample.calcStockMessage(mapFromEtaMessages, 69);
    }

    public class httpMockResponse implements HttpCalloutMock{
        List<Product2> products;
        public httpMockResponse(List<Product2> products) {
            this.products = products;
        }
        
        public HttpResponse respond(HttpRequest req) {
            String jsonBody = '{"productsPage" : {"products" : [';
            Integer i = 1;
            for(Product2 prod : products){
                if(i == products.size()){
                    jsonBody += '{"id" : "' + prod.Id + '", "fields" : {"Tyre_Size_Description__c":{"value":"235/35R19"}}}';
                } else {
                    jsonBody += '{"id" : "' + prod.Id + '", "fields" : {"Tyre_Size_Description__c":{"value":"235/35R19"}}},';
                }
                i++;
            }
            
            jsonBody += ']}}';
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatus('OK');
            res.setBody(jsonBody);
            res.setStatusCode(200);
            return res;
        }
    }
}