@isTest
global class MockHttpResponseFlowGear implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"error": "", "SAPResponse": "SRSA_Replacement Ord 2024903013 has been saved"}');
        res.setStatusCode(200);
        return res;
    }
}