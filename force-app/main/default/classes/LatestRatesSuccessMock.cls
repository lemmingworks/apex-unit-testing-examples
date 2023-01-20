public class LatestRatesSuccessMock implements HttpCalloutMock {
    
    @testVisible
    private static Decimal rate;
    
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        response.setBody(
        '{' +
            '"fromCurrency": "GBP",' +
            '"toCurrency": "USD",' +
            '"date": "2022-01-02",' +
            '"rate": ' + rate +
        '}');

        return response;
    }
}
