@isTest
global class MockHttpResponseUpdateQuote implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
        String responseBody = '{"access_token": "00D26000000HScW!AQoAQPWspSXaAKKySZaRnLNXsNRk1abQni5p58cVPCjYFhvlaKixawp2XON5Y5RN5_yDIOcrS7G4OySQRPP0FwZoNUjRoQaZ",';
        responseBody += '"instance_url": "https://profeeds--profeedsut.sandbox.my.salesforce.com",';
        responseBody += '"id": "https://test.salesforce.com/id/00D26000000HScWEAW/0058d000001xuEYAAY",';
        responseBody += '"token_type": "Bearer",';
        responseBody += '"issued_at": "1669297213527",';
        responseBody += '"signature": "G6hJgvwVMpNQIzS1bmJxGNUTPsWW+sKcO+JzZK8UX3U="}';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseBody);
        res.setStatusCode(200);
        return res;
    }
}