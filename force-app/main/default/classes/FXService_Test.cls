@isTest
public class FXService_Test {
    
    @isTest
    private static void GetRate_SuccessResponse_ShouldReturnRateAsDecimal_Single() {

        // Setup
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetRateAPI200Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        // Test
        Test.setMock(HttpCalloutMock.class, mock);
        FXService service = new FXService();
        Decimal exchangeRate = service.getRate('USD', 'GBP');

        // Assert
        Assert.areEqual(1.21047, exchangeRate);
    }

    @isTest
    private static void GetRate_SuccessResponse_ShouldReturnRateAsDecimal_Multi() {

        // Setup
        MultiStaticResourceCalloutMock mock = new MultiStaticResourceCalloutMock();
        mock.setStaticResource(
            'https://fxservice.com/rate?fromcurrency=USD&tocurrency=GBP',
            'GetRateAPI200Response'
        );
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        // Test
        Test.setMock(HttpCalloutMock.class, mock);
        FXService service = new FXService();
        Decimal exchangeRate = service.getRate('USD', 'GBP');

        // Assert
        Assert.areEqual(1.21047, exchangeRate);
    }

    @isTest
    private static void GetRate_SuccessResponse_NamedCredential_Single() {

        // Setup
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetRateAPI200Response');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        // Test
        Test.setMock(HttpCalloutMock.class, mock);
        FXService service = new FXService();
        Decimal exchangeRate = service.getRateNamedCredentials('USD', 'GBP');

        // Assert
        Assert.areEqual(1.21047, exchangeRate);
    }

    @isTest
    private static void GetRate_SuccessResponse_NamedCredential_Multi() {

        // Setup
        MultiStaticResourceCalloutMock mock = new MultiStaticResourceCalloutMock();
        mock.setStaticResource(
            'callout:FxAPI/rate?fromcurrency=USD&tocurrency=GBP',
            'GetRateAPI200Response'
        );
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        // Test
        Test.setMock(HttpCalloutMock.class, mock);
        FXService service = new FXService();
        Decimal exchangeRate = service.getRateNamedCredentials('USD', 'GBP');

        // Assert
        Assert.areEqual(1.21047, exchangeRate);
    }

    @isTest
    private static void GetRate_400Response_ShouldThrow400Exception_Single() {

        // Setup
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetRateAPI400Response');
        mock.setStatusCode(400);
        mock.setHeader('Content-Type', 'application/json');

        // Test
        Test.setMock(HttpCalloutMock.class, mock);
        FxService service = new FXService();
        try {
            service.getRate('USD', 'GBP');
            Assert.fail('Should have thrown an exception');
        } catch(Exception ex) {
            Assert.isInstanceOfType(ex, FXService.BadRequest400Exception.class);
            Assert.areEqual(
                'The tocurrency parameter should be a 3 digit ISO country code.',
                ex.getMessage()
            );
        }
    }

    @isTest
    private static void GetRate_SuccessResponse_HttpCalloutMock() {

        // Setup
        LatestRatesSuccessMock.rate = 1.234;
        LatestRatesSuccessMock mock = new LatestRatesSuccessMock();

        // Test
        Test.setMock(HttpCalloutMock.class, mock);
        FXService service = new FXService();
        Decimal exchangeRate = service.getRate('USD', 'GBP');

        // Assert
        Assert.areEqual(1.234, exchangeRate);
    }
}
