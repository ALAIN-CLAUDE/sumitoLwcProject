/**
 * @author          Bernie Oosthuizen
 * @createdDate     14 October 2022
 * @updatedDate     16 November 2022
 * @description     This is created for this JIRA story: SD-465
 *                  This is the Apex controller for the "productBulletins" LWC.
 */

public with sharing class ProductBulletinsController {

    @AuraEnabled
    public static List<ContentVersion> getContents(String contentWorkspaceName) {
        Set<Id> contentIds = new Set<Id>();
        List<ContentWorkspace> parentFolder;
        String parentFolderId;

        try {
            parentFolder = [SELECT Id FROM ContentWorkspace WHERE Name=: contentWorkspaceName];
            parentFolderId = String.valueOf(parentFolder[0].Id);
            for (ContentDocument cont :[SELECT Id ,Title FROM ContentDocument WHERE ParentId= :parentFolderId]) {
                contentIds.add(cont.Id);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return [SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId IN :contentIds];
    }

    @AuraEnabled
    public static String getOrgUrl() {
        String prefix = URL.getSalesforceBaseURL().toExternalForm().replace('https://', '').split('\\.')[0];

        Map<String, Org_Variables__mdt> orgVars = Org_Variables__mdt.getAll();
        return 'https://' + prefix.toLowerCase() + orgVars.get('File_URL').Text_Value__c;
    }
}