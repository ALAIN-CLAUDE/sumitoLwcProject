/**
* Apex Enterprise Design Patterns
* Selector Layer for Account object
*
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2021-07-18
*/

public class AccountsSelector extends fflib_SObjectSelector {
	//MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Account.Id,
                Account.Account_Clerk__c,
                Account.Bank_Account_Number__c,
                Account.BillingCity,
                Account.BillingPostalCode,
                Account.BillingState,
                Account.BillingStreet,
                Account.Block_Central_Billing__c,
                Account.Block_Central_Delivery__c,
                Account.Block_Central_Order__c,
                Account.Company_Registration__c,
                Account.Compressor__c,
                Account.Counter_and_Reception_Area__c,
                Account.Country__c,
                Account.CreatedDate,
                Account.Credit_Exposure__c,
                Account.Credit_Last_Updated_Date__c,
                Account.Credit_Limit__c,
                Account.Credit_Limit_Available__c,
                Account.Credit_Limit_Requested__c,
                Account.Credit_Limit_used__c,
                Account.Current__c,
                Account.CurrencyIsoCode,
                Account.Currency_to_adopt__c,
                Account.Customer_accgroup__c,
                Account.Customer_Group__c,
                Account.Customer_Group_Pricing__c,
                Account.Customer_Group_Pricing_Code__c,
                Account.Delivering_Plant__c,
                Account.Delivery_Priority__c,
                Account.Delivery_terms__c,
                Account.Distribution_Channel__c,
                Account.Division__c,
                Account.Domestic_Require_Documents_Count__c,
                Account.Dunlop_Commitment__c,
                Account.Electric_Balancing_Machine__c,
                Account.Email_Address__c,
                Account.Enterprise_Development__c,
                Account.FittingArea__c,
                Account.Fitting_Machine__c,
                Account.Forwarding_Agent_Name__c,
                Account.Group_4__c,
                Account.Group_5__c,
                Account.Group_Name__c,
                Account.House_Bank__c,
                Account.IB_Require_Documents_Count__c,
                Account.Inco2__c,
                Account.Inspection_Company__c,
                Account.LastModifiedDate,
                Account.Last_Payment__c,
                Account.Last_Payment_Date__c,
                Account.Lower_Level_Lifts__c,
                Account.Marketing_Rands_Balance__c,
                Account.Marketing_Rands_Expiring__c,
                Account.Name,
                Account.Overdue__c,
                Account.ParentId,
                Account.Payment_Terms__c,
                Account.Phone,
                Account.Port_of_destination__c,
                Account.Price_Group__c,
                Account.Region__c,
                Account.Restrooms__c,
                Account.Sales_District__c,
                Account.Sales_Group__c,
                Account.Sales_Office__c,
                Account.SAP_Customer_Code__c,
                Account.Shipping_Company__c,
                Account.ShippingCity,
                Account.ShippingPostalCode,
                Account.ShippingState,
                Account.ShippingStreet,
                Account.Stage__c,
                Account.Tel__c,
                Account.Total__c,
                Account.Total_Credit_Limit__c,
                Account.Trading_As_Name__c,
                Account.Trading_Name_of_Buyer_If_Different__c,
                Account.Turnover_Potential__c,
                Account.Unapplied__c,
                Account.VAT_Number__c,
                Account.X0_30_Days__c,
                Account.X30_60_Days__c,
                Account.X60_90_Days__c,
                Account.X90_180_Days__c,
                Account.X180_360_Days__c,
                Account.X360_Days__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    public List<Account> selectById(Set<Id> idSet) {
        return (List<Account>) Database.query(
            newQueryFactory()
            .selectField('CreatedBy.Name')
            .selectField('LastModifiedBy.Name')
            .selectField('Owner.Name')
            .selectField('Parent.Name')
            .selectField('RecordType.Name')
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }
}