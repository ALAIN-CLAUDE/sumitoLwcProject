/**
 * @description       : Test class for INV_UpdatePriceBookEntryInvoicePrice apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-06   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class INV_UpdatePriceBookEntryInvoicePriceTest {
	@testSetup
    public static void createData(){
        Account account = new Account();
		account.Name = 'SRSA';
		insert account;
        
        List<Product2> prods = new List<Product2>();
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Product1';
        prod1.RIM_Size__c = '16';
        prod1.PDT_Code__c = 'Test753159';
        prod1.StockKeepingUnit = 'Test753159';
        prod1.ProductCode = 'Test753159';
        prods.add(prod1);

        Product2 prod2 = new Product2();
        prod2.Name = 'Product2';
        prod2.RIM_Size__c = '14';
        prod2.PDT_Code__c = 'Test159753';
        prod2.StockKeepingUnit = 'Test159753';
        prod2.ProductCode = 'Test159753';
        prods.add(prod2);
        
        insert prods;

        List<PriceBookEntry> stdPbes = new List<PriceBookEntry>();
        stdPbes.add(new PriceBookEntry(Product2Id=prod1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=700));
        stdPbes.add(new PriceBookEntry(Product2Id=prod2.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=900));
        
        insert stdPbes;

        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = 'TestSAP142536';
        insert priceBook;
        
        List<PriceBookEntry> pbes = new List<PriceBookEntry>();
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Product2Id = prod1.Id;
        pbe1.IsActive = true;
        pbe1.UnitPrice = 750;
        pbe1.Pricebook2Id = priceBook.Id;
        pbes.add(pbe1);
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.Product2Id = prod2.Id;
        pbe2.IsActive = true;
        pbe2.UnitPrice = 750;
        pbe2.Pricebook2Id = priceBook.Id;
        pbes.add(pbe2);
        
        insert pbes;
        
        Order orderRec = new Order();
        orderRec.AccountId = account.Id;
        orderRec.Status = 'Draft';
        orderRec.Pricebook2Id = priceBook.Id;
        orderRec.EffectiveDate = System.today();
        insert orderRec;
        
        OrderItem orderProd = new OrderItem();
        orderProd.OrderId = orderRec.Id;
        orderProd.Product2Id = prod1.Id;
        orderProd.PricebookEntryId = pbe1.Id;
        orderProd.Quantity = 1;
        orderProd.UnitPrice = 750;
        insert orderProd;
    }
    
    @isTest
    public static void testUpdatePriceBookEntryLastInvoicePrice(){
        List<OrderItem> orderProds = [SELECT Id, PricebookEntryId, TotalPrice FROM OrderItem];
        INV_UpdatePriceBookEntryInvoicePrice.updatePriceBookEntryLastInvoicePrice(orderProds);
        Map<Id, Decimal> pbeIdLastInvPrice = new Map<Id, Decimal>();
        Set<Id> pbeIds = new Set<Id>();
        Boolean doPricesMatch = true;
        
        for(OrderItem orderProd : orderProds){
            pbeIds.add(orderProd.PricebookEntryId);
        }
        
        List<PriceBookEntry> PBEs = [SELECT Id, Last_Invoiced_Price__c FROM PriceBookEntry WHERE Id IN: pbeIds];
        
        for(PriceBookEntry PBE : PBEs){
            pbeIdLastInvPrice.put(PBE.Id, PBE.Last_Invoiced_Price__c);
        }
        
        for(OrderItem orderProd : orderProds){
            if(orderProd.TotalPrice != pbeIdLastInvPrice.get(orderProd.PricebookEntryId)){
                doPricesMatch = false;
            }
        }
        
        System.assert(doPricesMatch);
    }
}