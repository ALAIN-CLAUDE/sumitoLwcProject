public class AssociatedLocationTriggerHelper {

	public static void handleAfterInsert(List<AssociatedLocation> associatedLocations){
        List<ContactPointAddress> contPointAddresses = new List<ContactPointAddress>();
        ContactPointAddress contPointAddress;
        Integer sapCustCodeNum; 

        for(AssociatedLocation associatedLocation : associatedLocations){
            sapCustCodeNum = Integer.valueOf(associatedLocation.SAP_Customer_Code__c) * 1;
            contPointAddress = new ContactPointAddress();
            contPointAddress.Associated_Location__c = associatedLocation.Id;
            contPointAddress.Name = associatedLocation.Location_Name_Formula__c;
            contPointAddress.ParentId = associatedLocation.ParentRecordId;
            contPointAddress.AddressType = 'Shipping';
            contPointAddress.Street = sapCustCodeNum + ' - ' + associatedLocation.NT_Street_Address__c;
            contPointAddress.City = associatedLocation.NT_City__c;
            contPointAddress.State = associatedLocation.NT_Province__c;
            contPointAddress.Country = associatedLocation.NT_Country__c;
            contPointAddress.PostalCode = associatedLocation.NT_Postal_Code__c;
            contPointAddress.Key__c = associatedLocation.Associated_Location_Key__c;
            contPointAddresses.add(contPointAddress);
        }

        if(contPointAddresses != null && contPointAddresses.size() > 0){
            insert contPointAddresses;
        }
    }
}