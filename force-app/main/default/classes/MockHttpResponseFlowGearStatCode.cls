@isTest
global class MockHttpResponseFlowGearStatCode implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"error": "{\"Root\":{\"RETURN\":{\"ID\":\"YV01\",\"NUMBER\":\"141\",\"MESSAGE\":\"Sales order is not saved as quantity is not confirmed\",\"TYPE\":\"E\"}}}"}');
        res.setStatusCode(200);
        return res;
    }
}