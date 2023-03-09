/**
 * @description       : Test class for IBCarSearchModalCtrl
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class IBCarSearchModalCtrlTest {
	
	@testSetup
    public static void createData(){
        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Make__c = 'SAAB';
        vehicle.Type__c = 'SAAB 9-5';
        vehicle.Model_Year__c = '2000';
        vehicle.Model__c = '9-5 Aero 2.3 TS Estate AT';
        vehicle.Tyre_Size_Rear__c = '225/45R17';
        vehicle.Tyre_Size_Front__c = '225/45R17';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'SAAB';
        vehicle.Type__c = 'SAAB 9-3';
        vehicle.Model_Year__c = '2002';
        vehicle.Model__c = '9-3 Sport Sedan Aero 2.0 TS';
        vehicle.Tyre_Size_Rear__c = '215/50R17';
        vehicle.Tyre_Size_Front__c = '215/50R17';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'TOYOTA';
        vehicle.Type__c = 'TOYOTA Corolla';
        vehicle.Model_Year__c = '1992';
        vehicle.Model__c = 'Corolla 1.6 Prestige MY14';
        vehicle.Tyre_Size_Rear__c = '175/70R13';
        vehicle.Tyre_Size_Front__c = '175/70R13';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'TOYOTA';
        vehicle.Type__c = 'TOYOTA Corolla';
        vehicle.Model_Year__c = '2017';
        vehicle.Model__c = 'Corolla 1.3 Impact';
        vehicle.Tyre_Size_Rear__c = '195/65R15';
        vehicle.Tyre_Size_Front__c = '195/65R15';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'SMART';
        vehicle.Type__c = 'SMART forfour';
        vehicle.Model_Year__c = '2004';
        vehicle.Model__c = 'forfour 1.5 Passion 5-dr';
        vehicle.Tyre_Size_Rear__c = '195/50R15';
        vehicle.Tyre_Size_Front__c = '195/50R15';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'SAAB';
        vehicle.Type__c = 'SAAB 9-5';
        vehicle.Model_Year__c = '2000';
        vehicle.Model__c = '9-5 Aero 2.3 TS AT (Saab)';
        vehicle.Tyre_Size_Rear__c = '225/45R17';
        vehicle.Tyre_Size_Front__c = '225/45R17';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'SAAB';
        vehicle.Type__c = 'SAAB 9-3';
        vehicle.Model_Year__c = '2003';
        vehicle.Model__c = '9-3 Sport Sedan 2.0 T Vector A';
        vehicle.Tyre_Size_Rear__c = '215/50R17';
        vehicle.Tyre_Size_Front__c = '215/50R17';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'TOYOTA';
        vehicle.Type__c = 'TOYOTA Corolla';
        vehicle.Model_Year__c = '1992';
        vehicle.Model__c = 'Corolla 1.6 LHD Exp';
        vehicle.Tyre_Size_Rear__c = '175/65R14';
        vehicle.Tyre_Size_Front__c = '175/65R14';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'TOYOTA';
        vehicle.Type__c = 'TOYOTA Corolla';
        vehicle.Model_Year__c = '2015';
        vehicle.Model__c = 'Corolla 1.3 GL';
        vehicle.Tyre_Size_Rear__c = '195/65R15';
        vehicle.Tyre_Size_Front__c = '195/65R15';
        vehicles.add(vehicle);
        
        vehicle = new Vehicle__c();
        vehicle.Make__c = 'SMART';
        vehicle.Type__c = 'SMART forfour';
        vehicle.Model_Year__c = '2016';
        vehicle.Model__c = 'forfour 1.3 Pure 5-dr';
        vehicle.Tyre_Size_Rear__c = '205/45R16';
        vehicle.Tyre_Size_Front__c = '185/50R16';
        vehicles.add(vehicle);
        
        insert vehicles;
        
        List<Product2> prods = new List<Product2>();
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Product1 225/45R17';
        prod1.RIM_Size__c = '11';
        prod1.PDT_Code__c = 'Test1';
        prod1.StockKeepingUnit = 'Test1';
        prod1.ProductCode = 'Test1';
        prod1.x_distr_chain_status_code__c = 'ON';
        prod1.MatGRP2_Description__c = 'Car Steel';
        prod1.IsActive = true;
        prods.add(prod1);

        Product2 prod2 = new Product2();
        prod2.Name = 'Product2 215/50R17';
        prod2.RIM_Size__c = '12';
        prod2.PDT_Code__c = 'Test2';
        prod2.StockKeepingUnit = 'Test2';
        prod2.ProductCode = 'Test2';
        prod2.x_distr_chain_status_code__c = 'ON';
        prod2.MatGRP2_Description__c = 'Car Steel';
        prod2.IsActive = true;
        prods.add(prod2);

        Product2 prod3 = new Product2();
        prod3.Name = 'Product3 175/70R13';
        prod3.RIM_Size__c = '13';
        prod3.PDT_Code__c = 'Test3';
        prod3.StockKeepingUnit = 'Test3';
        prod3.ProductCode = 'Test3';
        prod3.x_distr_chain_status_code__c = 'ON';
        prod3.MatGRP2_Description__c = 'Car Steel';
        prod3.IsActive = true;
        prods.add(prod3);

        Product2 prod4 = new Product2();
        prod4.Name = 'Product4 195/65R15';
        prod4.RIM_Size__c = '13';
        prod4.PDT_Code__c = 'Test4';
        prod4.StockKeepingUnit = 'Test4';
        prod4.ProductCode = 'Test4';
        prod4.x_distr_chain_status_code__c = 'ON';
        prod4.MatGRP2_Description__c = 'Car Steel';
        prod4.IsActive = true;
        prods.add(prod4);

        Product2 prod5 = new Product2();
        prod5.Name = 'Product5 195/50R15';
        prod5.RIM_Size__c = '13';
        prod5.PDT_Code__c = 'Test5';
        prod5.StockKeepingUnit = 'Test5';
        prod5.ProductCode = 'Test5';
        prod5.x_distr_chain_status_code__c = 'ON';
        prod5.MatGRP2_Description__c = 'Car Steel';
        prod5.IsActive = true;
        prods.add(prod5);

        Product2 prod6 = new Product2();
        prod6.Name = 'Product6 225/45R17';
        prod6.RIM_Size__c = '13';
        prod6.PDT_Code__c = 'Test6';
        prod6.StockKeepingUnit = 'Test6';
        prod6.ProductCode = 'Test6';
        prod6.x_distr_chain_status_code__c = 'ON';
        prod6.MatGRP2_Description__c = 'Car Steel';
        prod6.IsActive = true;
        prods.add(prod6);

        Product2 prod7 = new Product2();
        prod7.Name = 'Product7 215/50R17';
        prod7.RIM_Size__c = '13';
        prod7.PDT_Code__c = 'Test7';
        prod7.StockKeepingUnit = 'Test7';
        prod7.ProductCode = 'Test7';
        prod7.x_distr_chain_status_code__c = 'ON';
        prod7.MatGRP2_Description__c = 'Car Steel';
        prod7.IsActive = true;
        prods.add(prod7);

        Product2 prod8 = new Product2();
        prod8.Name = 'Product8 175/65R14';
        prod8.RIM_Size__c = '13';
        prod8.PDT_Code__c = 'Test8';
        prod8.StockKeepingUnit = 'Test8';
        prod8.ProductCode = 'Test8';
        prod8.x_distr_chain_status_code__c = 'ON';
        prod8.MatGRP2_Description__c = 'Car Steel';
        prod8.IsActive = true;
        prods.add(prod8);

        Product2 prod9 = new Product2();
        prod9.Name = 'Product9 195/65R15';
        prod9.RIM_Size__c = '13';
        prod9.PDT_Code__c = 'Test9';
        prod9.StockKeepingUnit = 'Test9';
        prod9.ProductCode = 'Test9';
        prod9.x_distr_chain_status_code__c = 'ON';
        prod9.MatGRP2_Description__c = 'Car Steel';
        prod9.IsActive = true;
        prods.add(prod9);

        Product2 prod10 = new Product2();
        prod10.Name = 'Product10 185/50R16';
        prod10.RIM_Size__c = '13';
        prod10.PDT_Code__c = 'Test10';
        prod10.StockKeepingUnit = 'Test10';
        prod10.ProductCode = 'Test10';
        prod10.x_distr_chain_status_code__c = 'ON';
        prod10.MatGRP2_Description__c = 'Car Steel';
        prod10.IsActive = true;
        prods.add(prod10);
        
        insert prods;

        List<PriceBookEntry> stdPbes = new List<PriceBookEntry>();
        stdPbes.add(new PriceBookEntry(Product2Id=prod1.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=100));
        stdPbes.add(new PriceBookEntry(Product2Id=prod2.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=200));
        stdPbes.add(new PriceBookEntry(Product2Id=prod3.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod4.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod5.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod6.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod7.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod8.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod9.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        stdPbes.add(new PriceBookEntry(Product2Id=prod10.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=300));
        
        insert stdPbes;

        PriceBook2 priceBook = new PriceBook2();
        priceBook.Name = 'PriceBook';
        priceBook.IsActive = true;
        priceBook.Account_SAP_Customer_Code__c = '6TestSAP142536';
        insert priceBook;
        
        List<PriceBookEntry> pbes = new List<PriceBookEntry>();
        
        PriceBookEntry pbe1 = new PriceBookEntry();
        pbe1.Product2Id = prod1.Id;
        pbe1.IsActive = true;
        pbe1.UnitPrice = 150;
        pbe1.Net_Price__c = 150;
        pbe1.Pricebook2Id = priceBook.Id;
        pbes.add(pbe1);
        
        PriceBookEntry pbe2 = new PriceBookEntry();
        pbe2.Product2Id = prod2.Id;
        pbe2.IsActive = false;
        pbe2.UnitPrice = 250;
        pbe2.Net_Price__c = 250;
        pbe2.Pricebook2Id = priceBook.Id;
        pbes.add(pbe2);
        
        PriceBookEntry pbe3 = new PriceBookEntry();
        pbe3.Product2Id = prod3.Id;
        pbe3.IsActive = true;
        pbe3.UnitPrice = 350;
        pbe3.Net_Price__c = 350;
        pbe3.Pricebook2Id = priceBook.Id;
        pbes.add(pbe3);
        
        PriceBookEntry pbe4 = new PriceBookEntry();
        pbe4.Product2Id = prod4.Id;
        pbe4.IsActive = true;
        pbe4.UnitPrice = 450;
        pbe4.Net_Price__c = 450;
        pbe4.Pricebook2Id = priceBook.Id;
        pbes.add(pbe4);
        
        PriceBookEntry pbe5 = new PriceBookEntry();
        pbe5.Product2Id = prod5.Id;
        pbe5.IsActive = true;
        pbe5.UnitPrice = 550;
        pbe5.Net_Price__c = 550;
        pbe5.Pricebook2Id = priceBook.Id;
        pbes.add(pbe5);
        
        PriceBookEntry pbe6 = new PriceBookEntry();
        pbe6.Product2Id = prod6.Id;
        pbe6.IsActive = true;
        pbe6.UnitPrice = 650;
        pbe6.Net_Price__c = 650;
        pbe6.Pricebook2Id = priceBook.Id;
        pbes.add(pbe6);
        
        PriceBookEntry pbe7 = new PriceBookEntry();
        pbe7.Product2Id = prod7.Id;
        pbe7.IsActive = true;
        pbe7.UnitPrice = 750;
        pbe7.Net_Price__c = 750;
        pbe7.Pricebook2Id = priceBook.Id;
        pbes.add(pbe7);
        
        PriceBookEntry pbe8 = new PriceBookEntry();
        pbe8.Product2Id = prod8.Id;
        pbe8.IsActive = true;
        pbe8.UnitPrice = 850;
        pbe8.Net_Price__c = 850;
        pbe8.Pricebook2Id = priceBook.Id;
        pbes.add(pbe8);
        
        PriceBookEntry pbe9 = new PriceBookEntry();
        pbe9.Product2Id = prod9.Id;
        pbe9.IsActive = true;
        pbe9.UnitPrice = 950;
        pbe9.Net_Price__c = 950;
        pbe9.Pricebook2Id = priceBook.Id;
        pbes.add(pbe9);
        
        PriceBookEntry pbe10 = new PriceBookEntry();
        pbe10.Product2Id = prod10.Id;
        pbe10.IsActive = true;
        pbe10.UnitPrice = 1050;
        pbe10.Net_Price__c = 1050;
        pbe10.Pricebook2Id = priceBook.Id;
        pbes.add(pbe10);
        
        insert pbes;
    }
    
    @isTest
    public static void testGetManufacturers(){
        Test.startTest();
        List<String> returnResult = IBCarSearchModalCtrl.getManufacturers();
        Test.stopTest();
        
        System.assertNotEquals(returnResult, null);
        System.assertNotEquals(returnResult.size(), 0);
    }

    @isTest
    public static void testGetTypes(){
       	Vehicle__c vehicle = [SELECT Id, Make__c, Type__c, Model_Year__c, Model__c, Tyre_Size_Rear__c, Tyre_Size_Front__c FROM Vehicle__c WHERE Make__c <> null AND Type__c <> null AND Model_Year__c <> null AND Model__c <> null AND Tyre_Size_Rear__c <> null AND Tyre_Size_Front__c <> null LIMIT 1];
		Test.startTest();
        List<String> returnResult = IBCarSearchModalCtrl.getTypes(vehicle.Make__c);
        Test.stopTest();
        
        System.assertNotEquals(returnResult, null);
        System.assertNotEquals(returnResult.size(), 0);        
    }

    @isTest
    public static void testGetModelYears(){
        //public static List<String> getModelYears(String manufacturer, String type){
        Vehicle__c vehicle = [SELECT Id, Make__c, Type__c, Model_Year__c, Model__c, Tyre_Size_Rear__c, Tyre_Size_Front__c FROM Vehicle__c WHERE Make__c <> null AND Type__c <> null AND Model_Year__c <> null AND Model__c <> null AND Tyre_Size_Rear__c <> null AND Tyre_Size_Front__c <> null LIMIT 1];
		Test.startTest();
        List<String> returnResult = IBCarSearchModalCtrl.getModelYears(vehicle.Make__c, vehicle.Type__c);
        Test.stopTest();
        
        System.assertNotEquals(returnResult, null);
        System.assertNotEquals(returnResult.size(), 0);
    }

    @isTest
    public static void testGetModels(){
        //public static List<String> getModels(String manufacturer, String type, String modelYear){
        Vehicle__c vehicle = [SELECT Id, Make__c, Type__c, Model_Year__c, Model__c, Tyre_Size_Rear__c, Tyre_Size_Front__c FROM Vehicle__c WHERE Make__c <> null AND Type__c <> null AND Model_Year__c <> null AND Model__c <> null AND Tyre_Size_Rear__c <> null AND Tyre_Size_Front__c <> null LIMIT 1];
		Test.startTest();
        List<String> returnResult = IBCarSearchModalCtrl.getModels(vehicle.Make__c, vehicle.Type__c, vehicle.Model_Year__c);
        Test.stopTest();
        
        System.assertNotEquals(returnResult, null);
        System.assertNotEquals(returnResult.size(), 0);
    }

    @isTest
    public static void testGetVehicles(){
        //public static List<Vehicle__c> getVehicles(String manufacturer, String type, String modelYear, String model){
        Vehicle__c vehicle = [SELECT Id, Make__c, Type__c, Model_Year__c, Model__c, Tyre_Size_Rear__c, Tyre_Size_Front__c FROM Vehicle__c WHERE Make__c <> null AND Type__c <> null AND Model_Year__c <> null AND Model__c <> null AND Tyre_Size_Rear__c <> null AND Tyre_Size_Front__c <> null LIMIT 1];
		Test.startTest();
        List<Vehicle__c> returnResult = IBCarSearchModalCtrl.getVehicles(vehicle.Make__c, vehicle.Type__c, vehicle.Model_Year__c, vehicle.Model__c);
        Test.stopTest();
        
        System.assertNotEquals(returnResult, null);
        System.assertNotEquals(returnResult.size(), 0);
    }

    @isTest
    public static void testGetProducts(){
        Profile customerProfile = [SELECT Id FROM Profile WHERE Name='B2B Customer Community Plus'];
       	UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile sysAdminProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner = new User();
        portalAccountOwner.UserRoleId = portalRole.Id;
        portalAccountOwner.ProfileId = sysAdminProfile.Id;
        portalAccountOwner.Username = 'srsab2btestuserPorOwner@srsa.co.za';
        portalAccountOwner.Alias = 'PrtlOwn';
        portalAccountOwner.Email='srsab2btestuserPorOwner@srsa.co.za';
        portalAccountOwner.EmailEncodingKey='UTF-8';
        portalAccountOwner.Firstname='TestPortal';
        portalAccountOwner.Lastname='Owner';
        portalAccountOwner.LanguageLocaleKey='en_US';
        portalAccountOwner.LocaleSidKey='en_US';
        portalAccountOwner.TimeZoneSidKey='America/Chicago';
 		insert portalAccountOwner;
        
        System.runAs(portalAccountOwner) {
            Account account = new Account();
            account.Name = 'SRSA';
            account.Stage__c = 'Active';
            account.SAP_Customer_Code__c = '6TestSAP142536';
            insert account;
            
            Contact contact = new Contact();
            contact.FirstName = 'FirstName';
            contact.LastName = 'LastName';
            contact.Email = 'firstname.lastname@srsa.co.za';
            contact.AccountId = account.Id;
            insert contact;
            
            User user = new User();
            user.Alias = 'test123';
            user.Email = 'firstname.lastname@srsa.co.za';
            user.EmailEncodingKey = 'UTF-8';
            user.FirstName = 'FirstName';
            user.LastName = 'LastName';
            user.ContactId = contact.Id;
            user.LanguageLocaleKey = 'en_US';
            user.LocalesIdKey = 'en_US';
            user.ProfileId = customerProfile.Id;
            user.TimezoneSidKey = 'America/Los_Angeles';
            user.Country = 'South Africa';
            user.Username = 'firstname.lastname@srsa.co.za';
            user.IsActive = true;
        	insert user;
            
            Vehicle__c vehicle = [SELECT Id, Make__c, Type__c, Model_Year__c, Model__c, Tyre_Size_Rear__c, Tyre_Size_Front__c FROM Vehicle__c WHERE Make__c <> null AND Type__c <> null AND Model_Year__c <> null AND Model__c <> null AND Tyre_Size_Rear__c <> null AND Tyre_Size_Front__c <> null LIMIT 1];
            List<PriceBookEntry> returnResult;
            
            system.runAs(user) {
                String tyreSizeFront = '%' + vehicle.Tyre_Size_Front__c + '%';
                String tyreSizeRear = '%' + vehicle.Tyre_Size_Rear__c + '%';
                Test.startTest();
                returnResult = IBCarSearchModalCtrl.getProducts(tyreSizeFront, tyreSizeRear);
                Test.stopTest();
            }
            
            System.assertNotEquals(returnResult, null);
            System.assertNotEquals(returnResult.size(), 0);
        }
    }
    
    @isTest
    public static void testGetProductsInternalUsers(){
        Profile customerProfile = [SELECT Id FROM Profile WHERE Name='B2B Customer Community Plus'];
       	UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile sysAdminProfile = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner = new User();
        portalAccountOwner.UserRoleId = portalRole.Id;
        portalAccountOwner.ProfileId = sysAdminProfile.Id;
        portalAccountOwner.Username = 'srsab2btestuserPorOwner@srsa.co.za';
        portalAccountOwner.Alias = 'PrtlOwn';
        portalAccountOwner.Email = 'srsab2btestuserPorOwner@srsa.co.za';
        portalAccountOwner.EmailEncodingKey = 'UTF-8';
        portalAccountOwner.Firstname = 'TestPortal';
        portalAccountOwner.Lastname = 'Owner';
        portalAccountOwner.LanguageLocaleKey = 'en_US';
        portalAccountOwner.LocaleSidKey = 'en_US';
        portalAccountOwner.TimeZoneSidKey = 'America/Chicago';
        portalAccountOwner.Internal_User_Account_SAP_Customer_Code__c = '6TestSAP142536';
 		insert portalAccountOwner;
        
        System.runAs(portalAccountOwner) {
            Vehicle__c vehicle = [SELECT Id, Make__c, Type__c, Model_Year__c, Model__c, Tyre_Size_Rear__c, Tyre_Size_Front__c FROM Vehicle__c WHERE Make__c <> null AND Type__c <> null AND Model_Year__c <> null AND Model__c <> null AND Tyre_Size_Rear__c <> null AND Tyre_Size_Front__c <> null LIMIT 1];
            
            String tyreSizeFront = '%' + vehicle.Tyre_Size_Front__c + '%';
            String tyreSizeRear = '%' + vehicle.Tyre_Size_Rear__c + '%';
            Test.startTest();
            List<PriceBookEntry> returnResult = IBCarSearchModalCtrl.getProducts(tyreSizeFront, tyreSizeRear);
            Test.stopTest();
            
            System.assertNotEquals(returnResult, null);
            System.assertNotEquals(returnResult.size(), 0);
        }
    }
}