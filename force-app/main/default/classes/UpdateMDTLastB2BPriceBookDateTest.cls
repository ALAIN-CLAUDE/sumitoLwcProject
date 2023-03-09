/**
 * @description       : Test class for UpdateMDTLastB2BPriceBookDate
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2022-11-14   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
@isTest
public class UpdateMDTLastB2BPriceBookDateTest {
	@isTest
    public static void testUpdateCustomMetadata(){
        Test.startTest();
        UpdateMDTLastB2BPriceBookDate.updateCustomMetadata('Last_B2B_Price_Book_Update_Insert');
        Test.stopTest();
    }
}