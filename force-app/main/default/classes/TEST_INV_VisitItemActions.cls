@isTest
public class TEST_INV_VisitItemActions {
    @isTest static void Test_updateVAFields(){
        Visit_Action__c va									= new Visit_Action__c();
        va.Account_Name__c						= '1234';
        va.Visit_Site_Group_Name__c									= 'Initial';
        
        insert va;
        List<Id> visitActionID = new List<Id>();
        visitActionID.add(va.Id);
        
        try{
            INV_VisitItemActions.updateVAFields(visitActionID);
        }catch(Exception e){}
    }
   
}