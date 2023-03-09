@isTest
public class Test_SFSupport {
    @isTest
    public static void testSOQL(){
        try {
            List<String> prodId = new List<String>();
            AggregateResult[] productList = [SELECT count(id), product2Id 
                                            FROM PricebookEntry
                                            GROUP BY product2Id
                                            HAVING count(id) > 1
                                        ];
            
            for(AggregateResult ar : productList) {
            String theId = String.valueOf(ar.get('product2Id'));
                CommerceEntitlementProduct[] tmp  = [select productId from CommerceEntitlementProduct where productId = :theId];
                if (tmp.size() == 0) {
                    prodId.add(theId);
                    System.debug(theId);
                    break;
                }
            }
            
        } catch(Exception e) {
            
        }
    }
}