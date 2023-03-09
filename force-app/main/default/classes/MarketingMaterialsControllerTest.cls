@isTest
public with sharing class MarketingMaterialsControllerTest {
    @TestSetup
    static void makeData(){
        ContentWorkSpace cws = new ContentWorkSpace(Name = 'Test Workspace');
        insert cws;
    }

    @isTest
    static void getWorkSpaceIdTest() {
        Test.startTest();
            MarketingMaterialsController.getWorkSpaceId('Test Workspace');
            try {
                MarketingMaterialsController.getWorkSpaceId('Test123');
            } catch(Exception e) {}
        Test.stopTest();
    }

    @isTest
    static void getFoldersAndFilesTest() {
        ContentWorkSpace cws = [SELECT Id FROM ContentWorkSpace][0];
        MarketingMaterialsController.getFoldersAndFiles(cws.id);
        try {
            MarketingMaterialsController.getFoldersAndFiles('x');
        } catch(Exception e) {}
    } 
}