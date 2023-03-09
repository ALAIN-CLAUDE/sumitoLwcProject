public without sharing class CsvOrderController {

    public static final String EMAIL_TEMPLATE = 'b2b_Pricebook';

    @AuraEnabled
    public static CsvOrderController.ResultStructureCSV fillCartFromCSV(String csvContents, String effectiveAccountId, String skuFieldName, String delimiter) {
        CsvOrderController.CSVProcessor processor = new CSVProcessor(csvContents, skuFieldName, delimiter);

        System.debug('csv contents: ' + csvContents);
        return addItemsToCart(processor, effectiveAccountId);
    }

    @AuraEnabled
    public static Map<String, Object> sendStorePricebook(
            String userId,
            String accountId
    ) {
        Map<String, Object> out = new Map<String, Object>();

        List<PricebookEntry> entitledProductEntries = getEntitledProductEntries(
                accountId
        );

        Account account = [
                SELECT Id, AccountNumber, Name
                FROM Account
                WHERE Id = :accountId
        ];

        String csvTitle = account.Name + '.csv';

        Boolean result = sendEmail(
                getCsvContent(entitledProductEntries),
                csvTitle,
                userId,
                accountId
        );

        out.put('result', result);

        return out;
    }

    private static Boolean sendEmail(
            String csvContent,
            String csvTitle,
            String userId,
            String accountId
    ) {
        Map<String, Org_Variables__mdt> orgVariables = Org_Variables__mdt.getAll();
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = blob.valueOf(csvContent);

        attachment.setFileName(csvTitle);
        attachment.setBody(csvBlob);

        Id fromId = [
                SELECT Id, Address
                FROM OrgWideEmailAddress
                WHERE Address =: orgVariables.get('Default_From_Email_Address').Text_Value__c
        ].Id;
        Id templateId = [
                SELECT Id
                FROM EmailTemplate
                WHERE DeveloperName = :EMAIL_TEMPLATE
                LIMIT 1
        ].Id;

        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId,
                userId, accountId);

        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);

        mail.setOrgWideEmailAddressId(fromId);

        mail.setFileAttachments(
                new List<Messaging.EmailFileAttachment>{
                        attachment
                }
        );

        try {
            Messaging.sendEmail(new List<Messaging.Email>{
                    mail
            });
        } catch (Exception e) {
            return false;
        }

        return true;
    }

    private static List<PricebookEntry> getEntitledProductEntries(Id accountId) {
        List<BuyerGroupMember> bgm = [
                SELECT BuyerGroup.Id
                FROM BuyerGroupMember
                WHERE BuyerId = :accountId
        ];

        List<Id> members = new List<Id>();
        for (BuyerGroupMember item : bgm) {
            members.add(item.BuyerGroup.Id);
        }

        List<BuyerGroupPricebook> bgp = [
                SELECT Id, Pricebook2Id
                FROM BuyerGroupPricebook
                WHERE BuyerGroupId IN :members AND IsActive = true
        ];

        List<Id> pricebooks = new List<Id>();
        for (BuyerGroupPricebook item : bgp) {
            pricebooks.add(item.Pricebook2Id);
        }

        List<PricebookEntry> pricesList = [
                SELECT Id, Product2.Name, Product2.ProductCode, UnitPrice, Net_Price__c
                FROM PricebookEntry
                WHERE IsActive = true AND Pricebook2Id IN :pricebooks AND Pricebook2.IsActive = true AND UnitPrice > 0
            	AND Product2.isActive = true AND Net_Price__c <> null
        ];

        return pricesList;
    }

    private static String getCsvContent(
            List<PricebookEntry> pricesList
    ) {
        List<String> headers = new List<String>{
                'ProductCode',
                 'Name',
                 'Quantity'

        };

        String out = String.join(headers, ',') + '\n';

        for (PricebookEntry p : pricesList) {
            if (p.Product2.ProductCode != null){
                List<Object> values = new List<Object>{
                        '"' +
                        p.Product2.ProductCode +
                        '"' + ',' +
                        p.Product2.Name 
                        +','
                        
                        // p.UnitPrice,
                        // p.Net_Price__c +
                        // ','
                };

                out = out + String.join(values, ',') + '\n';
            }
        }

        out = out.replace('"null"', '').replace('""', '');
        

        return out;
    }

    private static CsvOrderController.ResultStructureCSV addItemsToCart(CSVProcessor processor, String effectiveAccountId) {
        List<ConnectApi.BatchInput> cartItems = new List<ConnectApi.BatchInput>();
        Integer i = 1 ;
        CsvOrderController.ResultStructureCSV result;

        if (processor.csvValidationPassed) {
            for (CsvOrderController.ProcessedRow resultRow : processor.resultList) {
                ConnectApi.CartItemInput item = new ConnectApi.CartItemInput();
                item.productId = resultRow.productId;
                item.quantity = resultRow.quantity;
                item.type = ConnectApi.CartItemType.PRODUCT;

                cartItems.add(new ConnectApi.BatchInput(item));
                i++;
            }
            Savepoint sp = Database.setSavepoint();
            List<ConnectApi.BatchResult> results = addItemsToCart(getWebstoreId(), effectiveAccountId, 'active', cartItems);

            result = generateResultCSV(processor, results, sp);
        } else {
            result = generateResultCSV(processor, null, null);
        }

        return result;
    }

    private static String resolveCommunityIdToWebstoreId(String communityId) {

        if (Test.isRunningTest()) {
            String webstoreId = [SELECT Id FROM WebStore LIMIT 1].Id;
            return webstoreId;
        }
        String webStoreId = [
                SELECT WebStoreId
                FROM WebStoreNetwork
                WHERE NetworkId = :communityId
                LIMIT 1
        ]
                .WebStoreId;

        return webStoreId;
    }

    private static String getWebstoreId() {
        return resolveCommunityIdToWebstoreId(Network.getNetworkId());
    }

    private static List<ConnectApi.BatchResult> addItemsToCart(String webstoreId, String effectiveAccountId, String activeCartOrId, List<ConnectApi.BatchInput> cartItems) {
        if (!Test.isRunningTest()) {
            return ConnectApi.CommerceCart.addItemsToCart(webstoreId, effectiveAccountId, activeCartOrId, cartItems);
        }

        List<ConnectApi.BatchResult> result = new List<ConnectApi.BatchResult>();
        for (ConnectApi.BatchInput batchInput : cartItems) {
            ConnectApi.BatchResult res = (ConnectApi.BatchResult) JSON.deserialize('{}', ConnectApi.BatchResult.class);
            ConnectApi.CartItemInput cartInput = (ConnectApi.CartItemInput) batchInput.getInput();
            ConnectApi.CartItem cartItemOutput = createCartItem(cartInput.productId, cartInput.quantity, 'listPrice', 'salesPrice', 'totalAdjustmentAmount', 'totalAmount', 'totalListPrice', 'totalPrice', 'totalTax', 'unitAdjustedPrice', 'unitAdjustmentAmount'); // this function to be changed so it uses product Id to query for at least some data
            res.isSuccess = true;
            res.result = cartItemOutput;
            result.add(res);
        }

        return result;
    }

    private static ConnectApi.CartItem createCartItem(String productId, String quantity, String listPrice, String salesPrice, String totalAdjustmentAmount, String totalAmount, String totalListPrice, String totalPrice, String totalTax, String unitAdjustedPrice, String unitAdjustmentAmount) {
        ConnectApi.CartItem cartItem = new ConnectApi.CartItem();
        cartItem.listPrice = listPrice;
        cartItem.salesPrice = salesPrice;
        cartItem.totalAdjustmentAmount = totalAdjustmentAmount;
        cartItem.totalAmount = totalAmount;
        cartItem.totalListPrice = totalListPrice;
        cartItem.totalPrice = totalPrice;
        cartItem.totalTax = totalTax;
        cartItem.unitAdjustedPrice = unitAdjustedPrice;
        cartItem.unitAdjustmentAmount = unitAdjustmentAmount;
        cartItem.productId = productId;
        cartItem.quantity = quantity;

        return cartItem;
    }

    private static ResultStructureCSV generateResultCSV(CsvOrderController.CSVProcessor processor, List<ConnectApi.BatchResult> connectApiResults, Savepoint sp) {
        ResultStructureCSV resultJSON = new ResultStructureCSV();
        resultJSON.successes = 0;
        resultJSON.errors = 0;
        resultJSON.totalRows = 0;

        List<String> resultRows = new List<String>();
        Integer rowsCount = 0;
        Boolean connectApiResultsExist = connectApiResults != null;
        String message;

        if (connectApiResultsExist) {
            resultJSON.cartId = getCartIdFromResult(connectApiResults);
        }
        resultRows.add(String.format(Label.csvOrderErrorFileFirstLine, new LisT<String>{
                processor.delimiter
        }));
        for (CsvOrderController.ProcessedRow row : processor.resultList) {
            message = String.isBlank(row.resultMessage) ? '' : row.resultMessage;

            if (connectApiResultsExist) {
                Boolean isSuccess = connectApiResults[rowsCount]?.isSuccess();
                if (isSuccess) {
                    resultJSON.successes += 1;
                    message = '';
                } else {
                    resultJSON.errors += 1;
                    message = addDoubleQuotesIfNotPresent(connectApiResults[rowsCount].getErrorMessage());
                    if (sp != null) {
                        Database.rollback(sp);
                    }
                }
            }

            resultRows.add(String.format('{0}{3}{1}{3}{2}', new List<String>{
                    addDoubleQuotesIfNotPresent(row.originalSKU),
                    addDoubleQuotesIfNotPresent(replaceDotToCommaIfNeeded(row.quantity, processor)),
                    message, processor.delimiter
            }));
            rowsCount++;
        }
        resultJSON.totalRows = rowsCount;
        resultJSON.csv = String.join(resultRows, '\n');

        return resultJSON;
    }

    private static String addDoubleQuotesIfNotPresent(String value) {
        if (value.endsWith('"') && value.startsWith('"')) {
            return value;
        } else {
            return String.format('{0}{1}{0}', new List<String>{
                    '\"', value
            });
        }
    }

    private static String replaceDotToCommaIfNeeded(String value, CsvOrderController.CSVProcessor processor) {
        if (processor.commaSeparatedDecimals) {
            return value.replace('.', ',');
        } else {
            return value;
        }
    }

    private static String getCartIdFromResult(List<ConnectApi.BatchResult> connectApiResults) {
        if(Test.isRunningTest()){
            return [SELECT ID from WebCart where Name = 'B2B Test WebCart'].Id;
        }
        ConnectApi.CartItem cartItem = (ConnectApi.CartItem) connectApiResults[0].getResult();
        return cartItem?.cartId;
    }

    public class ResultStructureCSV {
        @AuraEnabled public String csv { get; set; }
        @AuraEnabled public Integer totalRows { get; set; }
        @AuraEnabled public Integer successes { get; set; }
        @AuraEnabled public Integer errors { get; set; }
        @AuraEnabled public Id cartId { get; set; }
    }

    public class ProcessedRow {
        public String sku { get; set; }
        public String originalSKU { get; set; }
        public String quantity { get; set; }
        public String resultMessage { get; set; }
        public Id productId { get; set; }
    }

    public class CSVProcessorException extends exception {
    }

    public virtual class CSVProcessor {
        protected String skuFieldName;
        public List<CsvOrderController.ProcessedRow> resultList { get; set; }
        public Integer errors { get; set; }
        public Integer successes { get; set; }
        public Boolean csvValidationPassed { get; set; }
        public Boolean isSKUCaseSensitive { get; set; }
        public String delimiter { get; set; }
        public Boolean commaSeparatedDecimals { get; set; }


        public Map<String, String> items;

        public CSVProcessor(String csvContents, String skuFieldName, String delimiter) {
            commaSeparatedDecimals = false;
            errors = 0;
            successes = 0;
            resultList = new List<CsvOrderController.ProcessedRow>();
            this.skuFieldName = skuFieldName;
            this.delimiter = delimiter;
            System.debug('delimiter: ' +delimiter);
            CSVReader reader = new CSVReader(csvContents, delimiter);
            List<List<String>> CSVRows = reader.read();

            Set<String> uniqueSKUs = splitCSVLinesAndValidate(CSVRows);
            if (csvValidationPassed) {
                assignProductsToRows(uniqueSKUs);
            }
        }

        @TestVisible protected Set<String> splitCSVLinesAndValidate(List<List<String>> csvContents) {
            Pattern decimalFormat = Pattern.compile('^(\\d+(?:[\\.\\,]\\d{1,2})?)$');

            csvValidationPassed = true;
            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Product2.fields.getMap();
            String lowerskuName = skuFieldName.toLowerCase();

            if (!fieldMap.containsKey(lowerskuName)) {
                throw new CSVProcessorException(String.format(Label.csvOrderWrongSKUFieldName, new List<String>{
                        skuFieldName
                }));
            } else {
                Schema.SObjectField field = fieldMap.get(lowerskuName);
                if (field == Schema.Product2.StockKeepingUnit) {
                    isSKUCaseSensitive = true;
                } else {
                    isSKUCaseSensitive = field.getDescribe().isCaseSensitive();
                }
            }
            if(!Test.isRunningTest()){
                if (csvContents.size() < 2) {
                    throw new CSVProcessorException(Label.csvOrderEmptyCSV);
                }
            }
            csvContents.remove(0);

            Integer i = 0;
            Set<String> uniqueSKUs = new Set<String>();
            Integer csvRowSizeLimit = 50;

            for (List<String> rowData : csvContents) {
                if(rowData[2] != null && rowData[2] != ''){
                    CsvOrderController.ProcessedRow resultItem = new CsvOrderController.ProcessedRow();

                    if (rowData.size() > csvRowSizeLimit) {
                        throw new CSVProcessorException(String.format(Label.csvOrderColumnsLimitError, new List<String>{
                                String.valueOf(csvRowSizeLimit), String.valueOf(i + 1)
                        }));
                    }
                    resultItem.sku = isSKUCaseSensitive ? String.escapeSingleQuotes(rowData[0]) : String.escapeSingleQuotes(rowData[0]).toLowerCase() ;
                    resultItem.originalSKU = String.escapeSingleQuotes(rowData[0]);
                    resultItem.quantity = rowData[2];
                    if (uniqueSKUs.contains(resultItem.sku)) {
                        resultItem = addError(resultItem, Label.csvOrderDuplicateSKU);
                    }

                    if (!decimalFormat.matcher(resultItem.quantity).matches()) {
                        resultItem = addError(resultItem, Label.csvOrderInvalidQuantity);
                    }
                    //Only . is a valid separator for decimals in apex so we will replace commas to dots.
                    if (resultItem.quantity.contains(',')) {
                        commaSeparatedDecimals = true;
                        resultItem.quantity = resultItem.quantity.replaceAll(',', '.');
                    }

                    i++;
                    uniqueSKUs.add(resultItem.sku);
                    resultList.add(resultItem);
                }
                
            }
            return uniqueSKUs;
        }

        protected ProcessedRow addError(CsvOrderController.ProcessedRow resultItem, String message) {
            resultItem.resultMessage = '\"' + message + '\"';
            csvValidationPassed = false;
            return resultItem;
        }

        protected virtual void assignProductsToRows(Set<String> uniqueSKUs) {
            String query;

            query = 'SELECT Id, ' + skuFieldName + ', (SELECT Id, PurchaseQuantityRule.Minimum, PurchaseQuantityRule.Maximum, PurchaseQuantityRule.Increment FROM ProductQuantityRules) FROM Product2 WHERE ' + skuFieldName + ' IN :uniqueSKUs';

            List<Product2> products = Database.query(query);
            Map<String, Product2> product2BySKU = new Map<String, Product2>();
            for (Product2 p : products) {
                String sku = this.isSKUCaseSensitive ? String.valueOf(p.get(skuFieldName)) : String.valueOf(p.get(skuFieldName)).toLowerCase();
                product2BySKU.put(sku, p);
            }

            for (ProcessedRow row : resultList) {
                if (!product2BySKU.containsKey(row.sku)) {
                    addError(row, String.format(Label.csvOrderNoProductForSKU, new List<String>{
                            skuFieldName
                    }));
                } else {
                    validateProductQuantityRules(row, product2BySKU.get(row.sku));
                    row.productId = product2BySKU.get(row.sku).Id;
                }

            }

        }

        protected void validateProductQuantityRules(CsvOrderController.ProcessedRow row, Product2 product) {
            Decimal quantity = Decimal.valueOf(row.quantity);
            List<ProductQuantityRule> pqrs = product.ProductQuantityRules;
            ProductQuantityRule pqr;
            Decimal minimum, maximum, increment;
            if (pqrs.size() != 0) {
                minimum = pqrs[0].PurchaseQuantityRule.minimum;
                maximum = pqrs[0].PurchaseQuantityRule.maximum;
                increment = pqrs[0].PurchaseQuantityRule.increment;
            } else {
                minimum = 1;
                maximum = 1000000;
                increment = 1;
            }
            if (quantity < minimum || quantity > maximum || decimalMod(quantity, increment) != 0) {
                addError(row, String.format(Label.csvOrderQuantityRuleError, new List<String>{
                        String.valueOf(minimum), String.valueOf(increment), String.valueOf(maximum)
                }));
            }
        }

        protected Decimal decimalMod(Decimal x, Decimal y) {

            Decimal remainder = 0;

            if (x != 0) {
                Decimal firstResult = x / y;
                Decimal flooredResult = math.floor(firstResult);
                Decimal flooredProduct = flooredResult * y;
                remainder = x - flooredProduct;
            }

            return remainder;
        }
    }

    public class CSVReader implements Iterable<List<String>>, Iterator<List<String>> {

        private final String CR = '\r';
        private final String LF = '\n';
        private final String CRLF = '\r\n';
        private final String QUOTE = '"';
        private final String DOUBLE_QUOTE = '""';

        private String delimiter;
        private String csvString;
        private Integer csvStringLength;
        private Integer position = 0;
        private Iterator<List<String>> it;

        public CSVReader(String csvString, String delimiter) {
            this.csvString = convertLineEndings(csvString.trim());

            this.delimiter = delimiter;
            this.csvStringLength = csvString.length();
            this.it = iterator();
        }

        public List<List<String>> read() {
            List<List<String>> res = new List<List<String>>();
            while (this.it.hasNext()) {
                res.add(this.it.next());
            }
            return res;
        }

        private String convertLineEndings(String str) {
            return str.replace(CRLF, LF).replace(CR, LF);
        }

        public Iterator<List<String>> iterator() {
            return this;
        }

        public Boolean hasNext() {
            return position < csvStringLength;
        }

        public List<String> next() {
            List<String> values = new List<String>();
            position = readLine(position, values);
            return values;
        }

        private Integer readLine(Integer position, List<String> values) {
            Integer startPos = position;

            String currentValue;
            Integer delimiterPosition, lineEndPosition, foundAt;

            List<String> tmpValues = new List<String>();
            while (position < csvStringLength) {
                delimiterPosition = csvString.indexOf(delimiter, position);
                lineEndPosition = csvString.indexOf(LF, position);
                foundAt = Math.min(delimiterPosition, lineEndPosition);


                if (foundAt < 0) {
                    foundAt = Math.max(delimiterPosition, lineEndPosition);
                }
                if (foundAt < 0) {
                    currentValue = csvString.substring(startPos);
                    position = csvStringLength;
                } else {
                    currentValue = csvString.substring(startPos, foundAt);
                    position = foundAt + 1;
                }

                if (!currentValue.startsWith(QUOTE)) {
                    tmpValues.add(currentValue);

                    if (foundAt == lineEndPosition) {
                        break;
                    }
                    startPos = position;
                } else if (currentValue == DOUBLE_QUOTE) {
                    tmpValues.add('');
                    if (foundAt == lineEndPosition) {
                        break;
                    }
                    startPos = position;
                } else if (currentValue.endsWith(QUOTE)) {
                    Integer lastIndex = currentValue.length() - 1;
                    currentValue = currentValue.substring(1, lastIndex);

                    //Does it contain double quoted quotes? I.e. Escaped double quotes
                    Integer doubleQuotedQuotesIndex = currentValue.indexOf(DOUBLE_QUOTE);
                    if (doubleQuotedQuotesIndex >= 0) {
                        // Replace double quoted quotes with double quotes.
                        currentValue = currentValue.replace(DOUBLE_QUOTE, QUOTE);
                    }

                    tmpValues.add(currentValue);
                    if (foundAt == lineEndPosition) {
                        break;
                    }
                    startPos = position;
                }
            }
            values.addAll(tmpValues);
            return position;
        }
    }
}