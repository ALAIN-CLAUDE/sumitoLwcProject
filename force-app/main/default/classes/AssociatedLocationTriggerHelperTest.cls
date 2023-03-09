/**
 * @description       : Test class for AssociatedLocationTriggerHelper
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-08-16   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

@isTest
public class AssociatedLocationTriggerHelperTest {

	@testSetup
    public static void createData(){
    	Account account = new Account();
		account.Name = 'SRSA';
		insert account;

        Schema.Location loc = new Schema.Location();
        loc.Name = 'Test Location';
        loc.SAP_Customer_Code__c = 'TestLoc123';
        loc.Street_Address__c = '5 Libertas Road';
        loc.City__c = 'Sandton';
        loc.Province__c = 'Gauteng';
        loc.Country__c = 'South Africa';
        loc.Postal_Code__c = '2191';
        insert loc;

        AssociatedLocation assocLocation = new AssociatedLocation();
        assocLocation.ParentRecordId = account.Id;
        assocLocation.LocationId = loc.Id;
        insert assocLocation;
    }
    
	@isTest
    public static void testHandleAfterInsert(){
        Schema.Location loc = [SELECT Id, City__c, Country__c, Name, Postal_Code__c, Province__c, SAP_Customer_Code__c, Street_Address__c FROM Location LIMIT 1];
        ContactPointAddress CPA = [SELECT Id, AddressType, City, Country, Name, PostalCode, State, Street FROM ContactPointAddress];

        System.assert(loc.City__c.equals(CPA.City));
        System.assert(loc.Country__c.equals(CPA.Country));
        System.assert(loc.Name.equals(CPA.Name));
        System.assert(loc.Postal_Code__c.equals(CPA.PostalCode));
        System.assert(loc.Province__c.equals(CPA.State));
        System.assert(CPA.Street.contains(loc.SAP_Customer_Code__c));
        System.assert(CPA.Street.contains(loc.Street_Address__c));
        System.assert(CPA.AddressType.equals('Shipping'));
    }
}