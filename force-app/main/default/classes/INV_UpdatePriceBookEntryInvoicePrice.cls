/**
 * @description       : class to update Price Book Entry Last_Invoiced_Price__c field
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-01-06   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class INV_UpdatePriceBookEntryInvoicePrice {
	
    @InvocableMethod
    public static void updatePriceBookEntryLastInvoicePrice(List<OrderItem> orderProds){
        
        Set<Id> pbeIds = new Set<Id>(); //Price Book Entry Ids
        
        for(OrderItem orderProd : orderProds){
            pbeIds.add(orderProd.PriceBookEntryId);
        }
        
        List<PriceBookEntry> pbes = [SELECT Id, Last_Invoiced_Price__c FROM PriceBookEntry WHERE Id IN: pbeIds];

        for(PriceBookEntry pbe : pbes){
            for(OrderItem orderProd : orderProds){
                if(pbe.Id.equals(orderProd.PriceBookEntryId)){
                    pbe.Last_Invoiced_Price__c = orderProd.TotalPrice;
                }
            }
        }

        update pbes;
    }
}