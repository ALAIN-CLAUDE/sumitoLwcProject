@isTest
private class IBAdvFilter_TEST{
    
    @isTest
    private static void parse_TEST(){
        Test.startTest();
        IBAdvFilter.parse('[{"Name": "FirstName LastName"}, {"Name": "FirstName LastName"}, {"Name": "FirstName LastName"}]');
        Test.stopTest();
    }
}