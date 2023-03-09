public with sharing class getMarketingMaterial {  
    @AuraEnabled(cacheable=false)
  
    public static List<ContentFolder> getMarketingMaterial() {
        return [SELECT ID, Name FROM ContentFolder WHERE ParentContentFolderId = '07H3L0000008W5xUAE'];
    }
}