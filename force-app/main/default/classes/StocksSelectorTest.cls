/**
 * @description       : Test class for StocksSelector apex class
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class StocksSelectorTest {
	@testSetup
    public static void createData(){
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
        
        List<Stock__c> stocks = new List<Stock__c>();
        
        Stock__c stock1 = new Stock__c();
        stock1.Product__c = prod1.Id;
        stock1.Plant__c = '4000';
        stock1.Storage_Location__c = 'FG01';
        stock1.Quantity__c = 7;
        stock1.National_Stock__c = 4;
        stocks.add(stock1);
        
        Stock__c stock2 = new Stock__c();
        stock2.Product__c = prod2.Id;
        stock2.Plant__c = '4000';
        stock2.Storage_Location__c = 'FG01';
        stock2.Quantity__c = 7;
        stock2.National_Stock__c = 4;
        stocks.add(stock2);
        
        insert stocks;
        
    }
    
    @isTest
    public static void testSelectByProductId(){
        Stock__c stock = [SELECT Id, Product__c FROM Stock__c LIMIT 1];
        
        Test.startTest();
        List<Stock__c> stocks = new StocksSelector().selectByProductId(new Set<Id>{stock.Product__c});
        Test.stopTest();
        
        System.assert(stocks.size() > 0);
    }
    
    @isTest
    public static void testSelectByProductIdAndPlant(){
        Stock__c stock = [SELECT Id, Plant__c, Product__c FROM Stock__c LIMIT 1];
        
        Test.startTest();
        List<Stock__c> stocks = new StocksSelector().selectByProductIdAndPlant(new Set<Id>{stock.Product__c}, new Set<String>{stock.Plant__c});
        Test.stopTest();
        
        System.assert(stocks.size() > 0);
    }
}