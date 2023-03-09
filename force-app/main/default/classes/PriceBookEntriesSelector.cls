/**
* Apex Enterprise Design Patterns
* Selector Layer for PriceBookEntry object
*
* @author  Ephetehe Mokgopanyane(ephetehe.mokgopanyane@tetrad.co.za)
* @since   2021-07-18
*/

public class PriceBookEntriesSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return PriceBookEntry.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            PriceBookEntry.Id,
                PriceBookEntry.CurrencyIsoCode,
                PriceBookEntry.isActive,
                PriceBookEntry.Last_Invoiced_Price__c,
                PriceBookEntry.Name,
                PriceBookEntry.Net_Price__c,
                PriceBookEntry.Product2Id,
                PriceBookEntry.UnitPrice
                };
                    }
    //MANDATORY ABSTRACT METHODS - END
    
    public List<PriceBookEntry> selectActiveByPriceBookName(Set<String> accSapCode){
        return (List<PriceBookEntry>) Database.query(
            newQueryFactory()
            .selectField('PriceBook2.Name') // added by Nagendra 
            .selectField('Product2.Brand_Description__c')
            .selectField('Product2.Description')
            .selectField('Product2.Family')
            .selectField('Product2.Product_Image_Link__c')
            .selectField('Product2.Product_Image_Name__c')
            .selectField('Product2.Name')
            .setCondition('PriceBook2.Name IN: accSapCode AND isActive = true')
            .toSOQL()
        );
    }
    
    public List<PriceBookEntry> selectActiveByPriceBookNameAndLikeProductName(String accSapCode, String frntTyreSize, String rearTyreSize){
        String frntTyreSrchStr = '%' + frntTyreSize + '%';
        String rearTyreSrchStr = '%' + rearTyreSize + '%';
        
        return (List<PriceBookEntry>) Database.query(
            newQueryFactory()
            .selectField('Product2.Brand_Description__c')
            .selectField('Product2.Description')
            .selectField('Product2.Family')
            .selectField('Product2.Product_Image_Link__c')
            .selectField('Product2.Product_Image_Name__c')
            .selectField('Product2.Name')
            .setCondition('PriceBook2.Name =: accSapCode AND isActive = true AND (Name LIKE:frntTyreSrchStr OR Name LIKE:rearTyreSrchStr)')
            .toSOQL()
        );
    }
    
    public List<PriceBookEntry> selectActiveByTyreDetails(String accSapCode, String ratio, String pattern, String rimSize, String width){
        String searchString = 'PriceBook2.Name =: accSapCode AND isActive = true';
        
        if(ratio != null && ratio != ''){
            searchString += ' AND Product2.Aspect_Ratio_Description__c =:ratio';
        }
        
        if(pattern != null && pattern != ''){
            searchString += ' AND Product2.Pattern_Desc__c =:pattern';
        }
        
        if(rimSize != null && rimSize != ''){
            searchString += ' AND Product2.RIM_Size__c =:rimSize';
        }
        
        if(width != null && width != ''){
            searchString += ' AND Product2.Section_Width__c =:width';
        }
        
        return (List<PriceBookEntry>) Database.query(
            newQueryFactory()
            .selectField('Product2.Brand_Description__c')
            .selectField('Product2.Description')
            .selectField('Product2.Family')
            .selectField('Product2.Product_Image_Link__c')
            .selectField('Product2.Product_Image_Name__c')
            .selectField('Product2.Name')
            .setCondition(searchString)
            .toSOQL()
        );
    }
    
    public List<PriceBookEntry> selectActiveByName(String accSapCode, String txtSearch){
        String txtSearchSrchStr = '%' + txtSearch + '%';
        
        return (List<PriceBookEntry>) Database.query(
            newQueryFactory()
            .selectField('Product2.Brand_Description__c')
            .selectField('Product2.Description')
            .selectField('Product2.Family')
            .selectField('Product2.Product_Image_Link__c')
            .selectField('Product2.Product_Image_Name__c')
            .selectField('Product2.Name')
            .setCondition('PriceBook2.Name =: accSapCode AND isActive = true AND Name LIKE:txtSearchSrchStr')
            .toSOQL()
        );
    }
    
    public List<PriceBookEntry> selectByValidDateNotActive() {
        Date dateToday = System.today();
        
        return (List<PriceBookEntry>) Database.query(
            newQueryFactory()
            .setCondition('Valid_From__c <=: dateToday AND Valid_To__c >=: dateToday AND isActive = false')
            .toSOQL()
        );
        
    }
    
    public List<PriceBookEntry> selectActiveByFilters(String accSapCode, List<IBAdvFilter> iFilters){
        String searchString = 'PriceBook2.Name =: accSapCode AND isActive = true';
        List<String> iFilter0,iFilter1,iFilter2;
        iFilter0 = iFilters[0].value;
        iFilter1 = iFilters[1].value;
        iFilter2 = iFilters[2].value;
        
        if(iFilters[0].value != null && iFilters[0].value.size() > 0){
            searchString += ' AND Product2.Brand_Description__c IN :iFilter0';
        }
        
        if(iFilters[1].value != null && iFilters[1].value.size() > 0){
            searchString += ' AND Product2.Family IN :iFilter1';
        }
        
        if(iFilters[2].value != null && iFilters[2].value.size() > 0){
            searchString += ' AND Product2.Supplier_Country__c IN :iFilter2';
        }
        
        return (List<PriceBookEntry>) Database.query(
            newQueryFactory()
            .selectField('Product2.Brand_Description__c')
            .selectField('Product2.Description')
            .selectField('Product2.Family')
            .selectField('Product2.Product_Image_Link__c')
            .selectField('Product2.Product_Image_Name__c')
            .selectField('Product2.Name')
            .setCondition(searchString)
            .toSOQL()
        );
    }
}