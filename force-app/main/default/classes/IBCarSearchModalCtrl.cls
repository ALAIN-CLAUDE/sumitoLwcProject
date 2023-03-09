/**
 * @description       : Controller class for IBCarSearchModal aura component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-12-22   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public with sharing class IBCarSearchModalCtrl {
    @AuraEnabled
    public static List<String> getManufacturers(){
        List<String> manufacturers = new List<String>();
        List<AggregateResult> vehicles = [SELECT Make__c FROM Vehicle__c GROUP BY Make__c ORDER BY Make__c];
        
        for(AggregateResult vehicle : vehicles){
            manufacturers.add(String.valueOf(vehicle.get('Make__c')));
        }
        
        return manufacturers;
    }

    @AuraEnabled
    public static List<String> getTypes(String manufacturer){
        List<String> vehicleTypes = new List<String>();
        List<AggregateResult> vehicles = [SELECT Type__c FROM Vehicle__c WHERE Make__c =: manufacturer GROUP BY Type__c ORDER BY Type__c];
        
        for(AggregateResult vehicle : vehicles){
            vehicleTypes.add(String.valueOf(vehicle.get('Type__c')));
        }
        
        return vehicleTypes;
    }

    @AuraEnabled
    public static List<String> getModelYears(String manufacturer, String type){
        List<String> modelsYears = new List<String>();
        List<AggregateResult> vehicles = [SELECT Model_Year__c FROM Vehicle__c WHERE Make__c =: manufacturer AND Type__c =: type GROUP BY Model_Year__c ORDER BY Model_Year__c];
        
        for(AggregateResult vehicle : vehicles){
            modelsYears.add(String.valueOf(vehicle.get('Model_Year__c')));
        }
        
        return modelsYears;
    }

    @AuraEnabled
    public static List<String> getModels(String manufacturer, String type, String modelYear){
        List<String> models = new List<String>();
        List<AggregateResult> vehicles = [SELECT Model__c FROM Vehicle__c WHERE Make__c =: manufacturer AND Type__c =: type AND Model_Year__c =: modelYear GROUP BY Model__c ORDER BY Model__c];
        
        for(AggregateResult vehicle : vehicles){
            models.add(String.valueOf(vehicle.get('Model__c')));
        }
        
        return models;
    }

    @AuraEnabled
    public static List<Vehicle__c> getVehicles(String manufacturer, String type, String modelYear, String model){
        List<Vehicle__c> vehicles = [
                SELECT Id, Tyre_Size_Front__c
                FROM Vehicle__c
                WHERE Make__c =: manufacturer AND Type__c =: type
                AND Model_Year__c =: modelYear AND Model__c =: model
        ];

        return vehicles;
    }

    @AuraEnabled
    public static List<PriceBookEntry> getProducts(String frntTyreSize, String rearTyreSize){
        Id crntUserId = UserInfo.getUserId();
        //User crntUser = new UsersSelector().selectById(new Set<Id>{crntUserId})[0];
        User crntUser = [SELECT Id, Internal_User_Account_SAP_Customer_Code__c, Contact.Account.SAP_Customer_Code__c FROM User WHERE Id =: crntUserId];
        
        if(crntUser.Contact.Account.SAP_Customer_Code__c == null){
            return [SELECT Id FROM PriceBookEntry WHERE PriceBook2.Account_SAP_Customer_Code__c =: crntUser.Internal_User_Account_SAP_Customer_Code__c AND isActive = true AND (Name LIKE:frntTyreSize OR Name LIKE:rearTyreSize)];
            //return new PriceBookEntriesSelector().selectActiveByPriceBookNameAndLikeProductName('600150', frntTyreSize, rearTyreSize);
        } else {
            System.debug(crntUser.Contact.Account.SAP_Customer_Code__c + ' : ' + frntTyreSize + ' : ' + rearTyreSize);
            return [SELECT Id FROM PriceBookEntry WHERE PriceBook2.Account_SAP_Customer_Code__c =: crntUser.Contact.Account.SAP_Customer_Code__c AND isActive = true AND (Name LIKE:frntTyreSize OR Name LIKE:rearTyreSize)];
            //return new PriceBookEntriesSelector().selectActiveByPriceBookNameAndLikeProductName(crntUser.Contact.Account.SAP_Customer_Code__c, frntTyreSize, rearTyreSize);
        }
    }
}