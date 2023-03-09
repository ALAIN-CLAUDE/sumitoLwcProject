global class B2B_Batch_ContactPointAddressesUpsert implements Database.Batchable<sObject> {
    public static final String BILLING_ADDRESS = 'Billing Address';
    public static final String BILLING = 'Billing';
    public static final String SHIPPING = 'Shipping';
    private List<String> accSAPCustCodes;
    
    public B2B_Batch_ContactPointAddressesUpsert() {}
    
    public B2B_Batch_ContactPointAddressesUpsert(List<String> accSAPCustCodes) {
        this.accSAPCustCodes = accSAPCustCodes;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(accSAPCustCodes != null && accSAPCustCodes.size() > 0){
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM Pricebook2
                WHERE Account_SAP_Customer_Code__c IN: accSAPCustCodes
            ]);
        } else {
            return Database.getQueryLocator([
                SELECT Id, Account_SAP_Customer_Code__c
                FROM Pricebook2
                WHERE Account_SAP_Customer_Code__c LIKE '6%'
            ]);
        }
    }

    global void execute(Database.BatchableContext bc, List<Pricebook2> scope) {
        List<ContactPointAddress> contactPointAddressesToUpsert = new List<ContactPointAddress>();
        Map<Id, Account> accountMap = new Map<Id, Account>();
        Set<String> pricebookSAPCode = new Set<String>();
        Set<Id> accountIds = new Set<Id>();

        if (!scope.isEmpty()) {
            for (Pricebook2 pb : scope) {
                pricebookSAPCode.add(pb.Account_SAP_Customer_Code__c);
            }

            List<Account> matchingAccountList = [SELECT Id, Name, SAP_Customer_Code__c, BillingAddress, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode FROM Account WHERE SAP_Customer_Code__c IN:pricebookSAPCode];

            for (Account acc : matchingAccountList) {
                accountMap.put(acc.Id, acc);
                accountIds.add(acc.Id);
            }

            List<AssociatedLocation> associatedLocationsList = [SELECT Id, ParentRecordId, Associated_Location_Key__c, SAP_Customer_Code__c, location.Street_Address__c, Location.City__c, Location.Province__c, Location.Country__c, Location.Postal_Code__c FROM AssociatedLocation WHERE ParentRecordId IN: accountIds];

            Account acc;
            ContactPointAddress cpShippingAddress;

            for (AssociatedLocation al : associatedLocationsList) {

                if(accountMap.get(al.ParentRecordId) != null){
                    acc = accountMap.get(al.ParentRecordId);

                    cpShippingAddress = new ContactPointAddress();
                    cpShippingAddress.ParentId = acc.Id;
                    cpShippingAddress.Name = acc.Name;
                    cpShippingAddress.Street = al.SAP_Customer_Code__c + ' - ' + al.Location.Street_Address__c;
                    cpShippingAddress.City = al.Location.City__c;
                    cpShippingAddress.State = al.Location.Province__c;
                    cpShippingAddress.Country = al.Location.Country__c;
                    cpShippingAddress.PostalCode = al.Location.Postal_Code__c;
                    cpShippingAddress.AddressType = SHIPPING;
                    cpShippingAddress.Key__c = al.Associated_Location_Key__c;
                    cpShippingAddress.Associated_Location__c = al.Id;
                    contactPointAddressesToUpsert.add(cpShippingAddress);
                }
            }

            if (contactPointAddressesToUpsert.size() > 0) {
                Database.upsert(contactPointAddressesToUpsert, ContactPointAddress.Key__c, false);
            }
        }
    }

    global void finish(Database.BatchableContext bc) {

    }
}