public class FXService {

    public class GetRateResponse {
        public Integer statusCode {get;set;}
        public String fromCurrency {get;set;}
        public String toCurrency {get;set;}
        public Decimal rate {get;set;}
        public String errorMessage {get;set;}
    }
    
    public Decimal getRate(String fromCur, String toCur) {

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://fxservice.com/rate?fromcurrency=' + fromCur + '&tocurrency=' + toCur);
        
        HttpResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        GetRateResponse responseBody = (GetRateResponse)JSON.deserialize(res.getBody(), GetRateResponse.class);

        if(statusCode != 200) {
            if(statusCode == 400) {
                throw new BadRequest400Exception(responseBody.errorMessage);
            } else if(statusCode == 500) {
                throw new InternalServer500Exception(responseBody.errorMessage);
            } else {
                throw new FXServiceException(responseBody.errorMessage);
            }
        }

        return responseBody.rate;
    }

    public Decimal getRateNamedCredentials(String fromCurrency, String toCurrency) {

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:FxAPI/rate?fromcurrency=' + fromCurrency + '&tocurrency=' + toCurrency);
        
        HttpResponse res = http.send(req);
        Integer statusCode = res.getStatusCode();
        GetRateResponse responseBody =
                (GetRateResponse)JSON.deserialize(res.getBody(), GetRateResponse.class);

        return responseBody.rate;
    }

    public class FXServiceException extends Exception {}
    public class BadRequest400Exception extends Exception {}
    public class InternalServer500Exception extends Exception {}
}
