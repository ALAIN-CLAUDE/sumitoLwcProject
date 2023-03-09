@isTest
public with sharing class B2BUtilsTest {
    @isTest
    private static void getUserAccountIDTest(){

        String result = B2BUtils.getUserAccountID();
        System.assertEquals(null, result);
    }

    @IsTest
    private static void resolveSortParamTest(){
        B2BUtils.resolveSortParam('xxx');
    }

    @isTest(SeeAllData = True)
    private static void resolveCommunityIdToWebstoreIdTest(){
        try{
            B2BUtils.resolveCommunityIdToWebstoreId('xxx');
        } catch(Exception e){
        }
    }

}