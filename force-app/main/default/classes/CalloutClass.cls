public class CalloutClass {

    public static HttpResponse MakeAnHTTPCallout(Id accountId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.externalcaseservice.com/account?id=' + accountId);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }

    public static HttpResponse MakeAnHttpCallout() {

        Date today = Date.today();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.externalcaseservice.com/account?date=' + today);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}
