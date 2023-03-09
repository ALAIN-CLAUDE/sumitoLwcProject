/**
 * @description       : Controller class for IBContactUsDetails aura component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2021-07-15   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/

public class IBContactUsDetailsCtrl {
    @AuraEnabled
    public static List<String> getPicklistVals(){
        Schema.DescribeSObjectResult caseObj = case.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = caseObj.getRecordTypeInfos();
        List<String> recordTypes = new List<String>();
        
        for(Schema.RecordTypeInfo recordType : recordTypeInfo){
            if(!recordType.getName().equals('Master')){
                recordTypes.add(recordType.getName());
            }
        }
        
        return recordTypes;
    }
}