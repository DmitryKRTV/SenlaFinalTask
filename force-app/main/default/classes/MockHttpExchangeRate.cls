@IsTest
global class MockHttpExchangeRate implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('[{"Cur_ID": "510", "Cur_Abbreviation": "BYN", "Cur_OfficialRate": 4}]');
        return response;
    }
    
}