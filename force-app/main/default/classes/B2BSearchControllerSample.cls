/**
* @description Demonstrates how to make REST calls to ConnectApi.CommerceSearch class
* to perform Search and Category browsing for B2B Commerce on Lightning.
*
* @see B2BUtils
*/
public with sharing class B2BSearchControllerSample {
    // Cached API version of this apex class.
    private static Decimal apiVersionApexClass = [
        SELECT ApiVersion
        FROM ApexClass
        WHERE Name = 'B2BSearchControllerSample'
        WITH SECURITY_ENFORCED
        LIMIT 1
    ].ApiVersion;
    
    /**
    * @description Demonstrates how to call ConnectApi.CommerceSearch.productSearch
    * @param communityId The Id of the community from which the call originated
    * @param searchQuery The search query parameters which includes searchTerm, categoryId, refinements, page and includePrices
    * @param @param effectiveAccountId ID of the account for which the request is made. If null, defaults to the account ID for the context user.
    */
    @AuraEnabled(cacheable=true)
    public static Object productSearch(
        String communityId,
        String searchQuery,
        String effectiveAccountId
    ) {
        
        System.debug(communityId + searchQuery + effectiveAccountId);
        // Lookup the webstore ID associated with the community
        String webstoreId = B2BUtils.resolveCommunityIdToWebstoreId(
            communityId
        );
        
        HttpRequest httpRequest = new HttpRequest();
        Object response;
        
        // As per the Salesforce documentation
        // "By security policy, sessions created by Lightning components aren’t
        //  enabled for API access. This prevents even your Apex code from
        //  making API calls to Salesforce. Using a named credential for
        //  specific API calls allows you to carefully and selectively bypass
        // this security restriction."
        // - https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/apex_api_calls.htm
        //
        // So the following section that takes the OAuth is commented out and
        // used the named credential callout 'CallMeBack' below.
        // The steps to create named credentials are documented the repo here
        // docs/NamedCredentials.md
        
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/json');
        httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());

        String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        String apiUrl = '/services/data/v' + apiVersionApexClass + '/commerce/webstores/' + webstoreId + '/search/product-search';
        httpRequest.setEndpoint(baseUrl + apiUrl);
        httpRequest.setBody(searchQuery);

        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            Integer statusCode = httpResponse.getStatusCode();
            
            if (statusCode >= 200 && statusCode <= 204) {
                System.debug(' httpResponse ' + httpResponse.getBody());
                response = JSON.deserializeUntyped(httpResponse.getBody());
                System.debug(' httpResponse json' + response);
            } else {
                System.debug(' httpResponse ' + httpResponse.getBody());
                throw new CalloutException(httpResponse.getBody());
            }
        } catch (System.Exception e) {
            System.debug('ERROR: ' + e);
            throw e;
        }

        Map<String, Object> m =  (Map<String, Object>) response;
        Map<String, Object> productsPage = (Map<String, Object>)m.get('productsPage');
        List<Object> products = (List<Object>)productsPage.get('products');
		products = getStockAvailability(products, effectiveAccountId, false);

        if(UserInfo.getUserId().equals('0057E00000DllnnQAB')){
            List<Object> facets = (List<Object>) JSON.deserialize(JSON.serialize(m.get('facets')), List<FacetsWrapper>.class);
            facets = updateFacets(facets, effectiveAccountId);
            m.put('facets', facets);
        }
        
        return response;
    }
    
    public static List<Object> updateFacets(List<Object> facets, Id accountId){
        Account acc = [SELECT Id, Delivering_Plant__c FROM Account WHERE Id=:accountId];
        List<Integer> facetIndexes = new List<Integer>();
        Boolean isFacetIndexChanged = false;

        List<FacetsWrapper> facetList = (List<FacetsWrapper>) JSON.deserialize(JSON.serialize(facets, true), List<FacetsWrapper>.class);
        
        Map<String, Object> facetValuesMap;
System.debug('Kgops1: ' + acc.Delivering_Plant__c);
        for(Integer i = 0; i < facetList.size(); i++){
System.debug('Kgops' + i + ': ' + facetList[i].nameOrId + ' - ' + acc.Delivering_Plant__c);
            if(facetList[i].nameOrId.equals('Stock_Available_Bloemfontein__c') && !acc.Delivering_Plant__c.equals('BL01')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Cape_Town__c') && !acc.Delivering_Plant__c.equals('CT01')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Durban_Plant__c') && !acc.Delivering_Plant__c.equals('4001')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Domestic_Products__c') && !acc.Delivering_Plant__c.equals('4003')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Durban_Head_Office__c') && !acc.Delivering_Plant__c.equals('4000')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Durban__c') && !acc.Delivering_Plant__c.equals('DU01')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_East_London__c') && !acc.Delivering_Plant__c.equals('EL01')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Jet_Park__c') && !acc.Delivering_Plant__c.equals('JP01')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Ladysmith_Plant__c') && !acc.Delivering_Plant__c.equals('4002')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Port_Elizabeth__c') && !acc.Delivering_Plant__c.equals('PE01')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Warehouse_V_Export__c') && !acc.Delivering_Plant__c.equals('EX01')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Warehouse_V_Mrchantg__c') && !acc.Delivering_Plant__c.equals('MR01')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            } else if(facetList[i].nameOrId.equals('Stock_Available_Warehouse__c') && !acc.Delivering_Plant__c.equals('EX02')){
                facetIndexes.add(i);
                isFacetIndexChanged = true;
            }
        }

        for(Integer facetIndex : facetIndexes){
            if(isFacetIndexChanged){
                facetList.remove(facetIndex);
            }
        }

        String facetsJSONString = JSON.serialize(facetList).replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
        facetsJSONString = facetsJSONString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
        facetsJSONString = facetsJSONString.replace('{,', '{'); //prevent opening brace from having a comma after it
        facetsJSONString = facetsJSONString.replace(',}', '}'); //prevent closing brace from having a comma before it
        facetsJSONString = facetsJSONString.replace('[,', '['); //prevent opening bracket from having a comma after it
        facetsJSONString = facetsJSONString.replace(',]', ']'); //prevent closing bracket from having a comma before it
        
        return (List<Object>) JSON.deserializeUntyped(facetsJSONString);
    }
    
    public static List<Object> getStockAvailability (List<Object> products, String effectiveAccountId, Boolean PDP){
        List<String> productIDs = new List<String>();

        if (PDP == true){
            PDPWrapper wrapper = (PDPWrapper) products[0];
            productIDs.add(wrapper.ID);
        } else {
            for(Object p: products){
                Map<String,Object> data = (Map<String,Object>) p;
                productIDs.add((String) data.get('id'));
            }
        } 

        if(effectiveAccountId != null){
            Map<String, String> productNetPrices = new Map<String, String>();   
            Account deliveryPlantAcc = [SELECT Delivering_Plant__c, SAP_Customer_Code__c from Account where Id =:effectiveAccountId limit 1];    
            List<PriceBookEntry> priceBookEntries = [SELECT Id, Net_Price__c, Product2Id FROM PriceBookEntry WHERE PriceBook2.Account_SAP_Customer_Code__c =: deliveryPlantAcc.SAP_Customer_Code__c AND Product2Id IN: productIDs];

            if(priceBookEntries != null && priceBookEntries.size() > 0){
                for(PriceBookEntry priceBookEntry : priceBookEntries){
                    productNetPrices.put(priceBookEntry.Product2Id, String.valueOf(priceBookEntry.Net_Price__c));
                }
            } else{
                priceBookEntries = [SELECT Id, Net_Price__c, Product2Id FROM PriceBookEntry WHERE Product2Id IN: productIDs];

                if(priceBookEntries != null && priceBookEntries.size() > 0){
                    for(PriceBookEntry priceBookEntry : priceBookEntries){
                        productNetPrices.put(priceBookEntry.Product2Id, String.valueOf(priceBookEntry.Net_Price__c));
                    }
                }
            }

            if (deliveryPlantAcc.Delivering_Plant__c != null) {
                Map<String, Stock_Message__mdt> stockMessageMDT = Stock_Message__mdt.getAll();

                // Local
                List<Stock__c> localStocks = [SELECT Id, Inbound_Date__c, Quantity__c, Product__c, Product__r.ProductCode from Stock__c where Plant__c =:deliveryPlantAcc.Delivering_Plant__c AND Product__c IN :productIDs ];
                List<ETA_Messages__mdt> etaMessages = [SELECT Id, DeveloperName, Message__c FROM ETA_Messages__mdt];
                Map<String, Decimal> localStocksMap = new Map<String, Decimal>();
                Map<String, String> localStockEtaMap = new Map<String, String>();
                Map<String, String> localStockMapDesc = new Map<String, String>();

                for (Stock__c stock : localStocks){
                    localStocksMap.put(stock.Product__c, stock.Quantity__c);
                    localStockMapDesc.put(stock.Product__c, calcStockMessage(stockMessageMDT, stock.Quantity__c));
                    if(stock.Inbound_Date__c != null && stock.Inbound_Date__c > System.today()){
                        localStockEtaMap.put(stock.Product__c, calcDeliveryMessage(stock.Inbound_Date__c, stock.Quantity__c, etaMessages));
                    } else if(stock.Inbound_Date__c == null || stock.Inbound_Date__c <= System.today()){
                        localStockEtaMap.put(stock.Product__c, calcDeliveryMessage(null, stock.Quantity__c, etaMessages));
                    }
                }

                // National
                Map<String, Product_Delivery_Plant__mdt> productDeliveryPlantMDT = Product_Delivery_Plant__mdt.getAll();
                Product_Delivery_Plant__mdt productDeliveryPlant = productDeliveryPlantMDT.get(deliveryPlantAcc.Delivering_Plant__c);
                Map<string, Decimal> nationalStockMap = new Map<String, Decimal>();
                Map<String, String> nationalStockMapDesc = new Map<String, String>();

                if(productDeliveryPlant.Related_Plants__c != null){
                    List<String> relatedPlants = productDeliveryPlant.Related_Plants__c.split(';');
                    //relatedPlants.add(deliveryPlantAcc.Delivering_Plant__c);
                    List<Stock__c> nationalStocks = [SELECT Id, Quantity__c, Product__c from Stock__c where Plant__c IN :relatedPlants AND Product__c IN :productIDs ];
                    Decimal quantitySUM;

                    for (Stock__c stock: nationalStocks){
                        if(nationalStockMap.get(stock.Product__c) != null){
                            quantitySUM = nationalStockMap.get(stock.Product__c) + stock.Quantity__c;
                            nationalStockMap.put(stock.Product__c, quantitySUM);
                        } else {
                            nationalStockMap.put(stock.Product__c, stock.Quantity__c);
                        }
                    }

                    for (String product : nationalStockMap.keySet()) {
                        nationalStockMapDesc.put(product, calcStockMessage(stockMessageMDT, nationalStockMap.get(product)));
                    }
                } else {
                    System.debug('no related plants filled for this account. National stock will be not filled.');
                }

                if(PDP == true){
                    PDPWrapper wrapper = (PDPWrapper) products[0];
                    wrapper.fields.put('Local_Stock', localStockMapDesc.get(wrapper.ID));
                    wrapper.fields.put('National_Stock', nationalStockMapDesc.get(wrapper.ID));
                    wrapper.fields.put('Stock_Delivery_Date', localStockEtaMap.get(wrapper.ID));
                    wrapper.fields.put('Net_Price', productNetPrices.get(wrapper.ID));
                    
                    if(localStockEtaMap.get(wrapper.ID) == null){
                        localStockEtaMap.put(wrapper.ID, calcDeliveryMessage(null, Integer.valueOf(localStockMapDesc.get(wrapper.ID)), etaMessages));
                        Map<String, String> valueObj = new Map<String, String>();
                        valueObj.put('value', localStockEtaMap.get(wrapper.ID));
                        wrapper.fields.put('Stock_Delivery_Date', localStockEtaMap.get(wrapper.ID));
                    }
                    
                    List<Object> result = new List<Object>();
                    result.add((Object) wrapper);
                    products = result;
                } else {
                    for(Object p: products){
                        Map<String,Object> data = (Map<String,Object>) p;
                        Map<String,Object> fields = (Map<String, Object>) data.get('fields');
                        
                        if (localStockMapDesc.get((String)data.get('id')) != null){
                            Map<String, String> valueObj = new Map<String, String>();
                            valueObj.put('value', localStockMapDesc.get((String)data.get('id')));
                            fields.put('Local_Stocks', valueObj);
                        }
                        
                        if(nationalStockMapDesc.get((String)data.get('id')) != null){
                            Map<String, String> valueObj = new Map<String, String>();
                            valueObj.put('value', nationalStockMapDesc.get((String)data.get('id')));
                            fields.put('National_Stocks', valueObj);
                        }

                        if(localStockEtaMap.get((String) data.get('id')) != null){
                            Map<String, String> valueObj = new Map<String, String>();
                            valueObj.put('value', localStockEtaMap.get((String)data.get('id')));
                            fields.put('Stock_Delivery_Dates', valueObj);
                        } else {
                            localStockEtaMap.put((String) data.get('id'), calcDeliveryMessage(null, Integer.valueOf(localStockMapDesc.get((String)data.get('id')) != null ? localStockMapDesc.get((String)data.get('id')) : '0'), etaMessages));
                            Map<String, String> valueObj = new Map<String, String>();
                            valueObj.put('value', localStockEtaMap.get((String)data.get('id')));
                            fields.put('Stock_Delivery_Dates', valueObj);
                        }

                        if(productNetPrices.get((String) data.get('id')) != null){
                            Map<String, String> valueObj = new Map<String, String>();
                            valueObj.put('value', productNetPrices.get((String)data.get('id')));
                            fields.put('Net_Price', valueObj);
                        }
                    }
                }
            } else {
                System.debug('no delivery plant set for Account, no stock will be filled.');
            }
        } else {
            System.debug('No account was found for this user, stock availability will be not visible');
        }

        return products;
    }

    @AuraEnabled
    public static List<Object> getStockAvailabilityPDP (PDPWrapper wrapper, String effectiveAccountId){
        List<Object> products = new List<Object>();
        products.add(wrapper);

        return getStockAvailability(products, effectiveAccountId, true);
    }

    public class PDPWrapper{
        @AuraEnabled
        public String ID {get; set;}
        @AuraEnabled
        public Map<String, String> fields {get;set;}
    }

    public static String calcStockMessage(Map<String, Stock_Message__mdt> stockMessageMDTs, Decimal stockQuantity){
        Stock_Message__mdt stockMessage;
        String message = '';

        if(stockQuantity < 68){
            message = stockMessageMDTs.get('First_Level').Message__c;
            
            if(message == null || message.equals('')){
                if(stockQuantity < 0){
                    message = String.valueOf(0);
                } else {
                    message = String.valueOf(stockQuantity);
                }
                
            }
        } else if(stockQuantity  > 68){
            message = stockMessageMDTs.get('Second_Level').Message__c;
        }

        return message;
    }
    
    public static String calcDeliveryMessage(Date deliveryDate, Decimal stockQuantity, List<ETA_Messages__mdt> etaMessages){
        String message = '';
        Map<String, String> etaMap = new Map<String, String>();

        for(ETA_Messages__mdt etaMessage : etaMessages){
            etaMap.put(etaMessage.DeveloperName, etaMessage.Message__c);
        }

        if(stockQuantity < 0){
            message = etaMap.get('X0_stock');
        } else if(stockQuantity == 0){
            if(deliveryDate == null){
                message = etaMap.get('X0_stock');
            } else {
                Integer daysUntilDelivery = System.today().daysBetween(deliveryDate);
                
                if(daysUntilDelivery > 7){
                    message = etaMap.get('X0_stock_with_ETA_above_7_days');
                } else {
                    message = etaMap.get('X0_Stock_with_ETA_within_7_days');
                }
            }
        } else if(stockQuantity > 0 && stockQuantity < 68){
            message = etaMap.get('X0_68pcs');
        } else {
            message = etaMap.get('X68pcs_and_above');
        }

        return message;
    }
}