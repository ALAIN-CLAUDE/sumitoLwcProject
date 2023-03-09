@isTest
public with sharing class BatchUpdateProductImagesTest {
    @TestSetup
    static void makeData() {
        Product2 product = new Product2(
                                Name = 'Test Product', 
                                Description = 'test description',
                                NT_Pattern_Desc__c = 'xyz',
                                Pattern_Desc__c = 'def',
                                Product_Image_Global_Key_Identifier__c = ''
                            );
        insert product;
    }

    @isTest
    static void mainTest() {
        Database.executeBatch(new BatchUpdateProductImages());
    }
}