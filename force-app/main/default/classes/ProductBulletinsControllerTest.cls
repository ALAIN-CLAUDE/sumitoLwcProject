@isTest 
private class ProductBulletinsControllerTest {  
    @testSetup
    private static void createTestData() {
        ContentWorkspace testWorkspace = new ContentWorkspace(Name='Product Bulletins Test', DeveloperName='Product_Bulletins_Test');
        insert testWorkspace;
    }
    
    @isTest
    private static void testGetFilesList(){
        ContentWorkspace testWorkspace = [Select Id from ContentWorkspace where Name = 'Product Bulletins Test'];
        
        ContentFolder workspaceFolder = [Select Id from ContentFolder where Name =: testWorkspace.Id];
        
        ContentFolder testFolderRecord = new ContentFolder(Name='TEST FOLDER', ParentContentFolderId=workspaceFolder.Id);
        insert testFolderRecord;
        
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content';        
        cv.VersionData = Blob.valueOf('Unit Test Attachment Body');
        cv.PathOnClient = 'testcontent.jpg';
        insert cv;
        
        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id];
        
        List<ContentFolderMember> folderMembers = new List<ContentFolderMember>();
        System.debug(cv.Id + ' - ' + cv.ContentDocumentId);
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = testWorkspace.Id;
        insert cdl;
        
        for(ContentFolderMember cfm : [SELECT Id, ChildRecordId, ParentContentFolderId FROM ContentFolderMember WHERE ParentContentFolderId =: workspaceFolder.Id]) {
            cfm.ParentContentFolderId = testFolderRecord.Id;
            folderMembers.add(cfm);
        }
        
        update folderMembers;
        
    	List<ContentVersion> c = ProductBulletinsController.getContents('Product Bulletins Test');
        
        try{
            c = ProductBulletinsController.getContents('Product Bulletin Test');
        } catch(Exception exc){}
    }

    @isTest
    public static void testGetOrgUrl(){
        String url = ProductBulletinsController.getOrgUrl();
        Boolean result = url.contains('https://sumitomorubbersouthafrica');
        Assert.areEqual(result, true);
    }
}