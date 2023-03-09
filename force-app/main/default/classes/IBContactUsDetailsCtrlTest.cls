/**
 * @description       : Test class for IBContactUsDetailsCtrl
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class IBContactUsDetailsCtrlTest {

    @isTest
    public static void testGetPicklistVals(){
        Test.startTest();
        List<String> pickVals = IBContactUsDetailsCtrl.getPicklistVals();
        Test.stopTest();
        
        System.Assert(pickVals.size() > 0);
    }
}