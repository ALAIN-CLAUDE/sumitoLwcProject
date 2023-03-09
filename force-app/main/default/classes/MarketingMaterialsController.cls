/**
 * @author          Cihan Fethi Hizar
 * @createdDate     22 September 2022
 * @description     This is created for this JIRA story: SD-393
 *                  This is the Apex controller for the "marketingMaterials" LWC.
 */

public with sharing class MarketingMaterialsController {

    @AuraEnabled
    public static String getWorkSpaceId(String workspaceTitle){
        try {
            return [SELECT Id, RootContentFolderId FROM ContentWorkSpace WHERE Name = :workSpaceTitle][0].RootContentFolderId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
   
    @AuraEnabled
    public static List<List<ContentFolderItem>> getFoldersAndFiles(String workspaceId){
        try {
            Set<Id> idSet = new Set<Id>{workspaceId};
            List<ContentFolderItem> temp = new List<ContentFolderItem>();
            List<List<ContentFolderItem>> result = new List<List<ContentFolderItem>>();
            Boolean newLevel = true;
            while(newLevel) {
                temp = [SELECT Id, IsFolder, ParentContentFolderId, Title, FileExtension, FileType, ParentContentFolder.Name 
                        FROM ContentFolderItem WHERE ParentContentFolderId IN :idSet ORDER BY IsFolder, Title, CreatedDate DESC];
                if(temp.size() == 0) {
                    newLevel = false;
                    break;
                }
                else {
                    result.add(temp);
                    idSet = new Set<Id>();
                    for(ContentFolderItem cfi : temp)
                        idSet.add(cfi.Id);
                }
            }
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}