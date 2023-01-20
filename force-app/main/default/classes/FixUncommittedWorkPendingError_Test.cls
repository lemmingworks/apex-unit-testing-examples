@isTest
public class FixUncommittedWorkPendingError_Test {
    

    /**
     * Callouts aren't allowed after DML in the same transaction,
     * so this code will throw an uncommitted work pending exception.
     * (This is caught and verified here in order to have a passing test.)
     */
    @isTest
    private static void DMLBeforeCallout_ThrowsUncommittedWorkPendingException() {

        // Setup
        Account acc = new Account(Name='Account created in unit test');
        insert acc;

        // Test
        try {
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            HttpResponse res = CalloutClass.MakeAnHTTPCallout(acc.Id);
            Assert.fail('This should have thrown uncommitted work pending exception');
        } catch (Exception ex) {
            Assert.areEqual('You have uncommitted work pending. Please commit or rollback before calling out', ex.getMessage());
        }
    }

    /**
     * Wrapping the mock setup and HTTP callout in the 
     * Test.startTest(), Test.stopTest() block allows test data to
     * be inserted.
     */
    @isTest
    private static void DMLBeforeCallout_Fix_WrapMockSetupAndCalloutInTestStartStop() {

        // Setup
        Account acc = new Account(Name='Account created in unit test');
        insert acc;

        // Test
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            HttpResponse res = CalloutClass.MakeAnHTTPCallout(acc.Id);
        Test.stopTest();

        // Assert
        Assert.areEqual(200, res.getStatusCode());
        Assert.areEqual('Example Callout Test Response', res.getBody());
    }

    /**
     * Asynchronous Apex, such as the future method shown here,
     * is not allowed before a callout in the same transaction
     * and will throw an uncommitted pending work exception.
     */
    @isTest
    private static void FutureMethodBeforeCallout_ThrowsUncommittedWorkPendingException() {

        // Setup
        FutureMethodClass.FutureMethodThatCreatesAnAccount();

        // Test
        try {
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            HttpResponse res = CalloutClass.MakeAnHTTPCallout();
            Assert.fail('This should have thrown uncommitted work pending exception');
        } catch (Exception ex) {
            Assert.areEqual('You have uncommitted work pending. Please commit or rollback before calling out', ex.getMessage());
        }
    }

    /**
     * In order to prevent the uncommitted pending work exception,
     * AND to ensure the future method runs synchronously for the
     * purposes of the unit test, the future method is wrapped in a
     * Test.startTest() - Test.stopTest() block. The HTTP callout
     * is placed outside of the Test.startTest() - Test.stopTest()
     * block.
     */
    @isTest
    private static void FutureMethodBeforeCallout_Fix_WrapTheAsynchronousApexInTestStartStop() {

        // Test
        Test.startTest();
            // The future method has to be inside a 
            // Test.startTest() and Test.stopTest() block
            // in order for it to complete execution.
            FutureMethodClass.FutureMethodThatCreatesAnAccount();
        Test.stopTest();

        Account acc = [Select Name From Account];
        Assert.areEqual('Account created in future method', acc.Name);

        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        HttpResponse res = CalloutClass.MakeAnHTTPCallout();

        // Assert
        Assert.areEqual(200, res.getStatusCode());
        Assert.areEqual('Example Callout Test Response', res.getBody());
    }

    /**
     * Asynchronous Apex, such as the batch job shown here,
     * is not allowed before a callout in the same transaction
     * and will throw an uncommitted pending work exception.
     */
    @isTest
    private static void BatchJobBeforeCallout_ThrowsUncommittedWorkPendingException() {

        Account acc = new Account(Name='Test Account');
        insert acc;

        Database.executeBatch(new UpdateAccountsBatch(), 200);

        // Test
        try {
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            HttpResponse res = CalloutClass.MakeAnHTTPCallout();
            Assert.fail('This should have thrown uncommitted work pending exception');
        } catch (Exception ex) {
            Assert.areEqual('You have uncommitted work pending. Please commit or rollback before calling out', ex.getMessage());
        }
    }

    /**
     * In order to prevent the uncommitted pending work exception,
     * AND to ensure the batch job runs synchronously for the
     * purposes of the unit test, the batch job is wrapped in a
     * Test.startTest() - Test.stopTest() block. The HTTP callout
     * is placed outside of the Test.startTest() - Test.stopTest()
     * block.
     */
    @isTest
    private static void BatchJobBeforeCallout_Fix_WrapTheAsynchronousApexInTestStartStop() {

        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Test.startTest();
            // The batch job has to be inside a 
            // Test.startTest() and Test.stopTest() block
            // in order for it to complete execution.
            Database.executeBatch(new UpdateAccountsBatch());            
        Test.stopTest();

        acc = [Select Name From Account];
        Assert.areEqual('Account updated in batch job', acc.Name);

        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        HttpResponse res = CalloutClass.MakeAnHTTPCallout();

        // Assert
        Assert.areEqual(200, res.getStatusCode());
        Assert.areEqual('Example Callout Test Response', res.getBody());
    }

    /**
     * Asynchronous Apex, such as the scheduled Apex shown here,
     * is not allowed before a callout in the same transaction
     * and will throw an uncommitted pending work exception.
     */
    @isTest
    private static void ScheduleApexBeforeCallout_ThrowsUncommittedWorkPendingException() {

        String schedule = '0 6 * * * ?';
        String jobID = System.schedule('Create Account Scheduled', schedule, new ScheduledApexClass());

        try {
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            HttpResponse res = CalloutClass.MakeAnHTTPCallout();
            Assert.fail('This should have thrown uncommitted work pending exception');
        } catch (Exception ex) {
            Assert.areEqual('You have uncommitted work pending. Please commit or rollback before calling out', ex.getMessage());
        }
    }

    /**
     * In order to prevent the uncommitted pending work exception,
     * AND to ensure the scheduled job runs synchronously for the
     * purposes of the unit test, the scheduled job is wrapped in a
     * Test.startTest() - Test.stopTest() block. The HTTP callout
     * is placed outside of the Test.startTest() - Test.stopTest()
     * block.
     */
    @isTest
    private static void ScheduleApexBeforeCallout_Fix_WrapMockSetupAndCalloutInTestStartStop() {

        Test.startTest();
            // Scheduling the job *has* to be in the Test.startTest() and Test.stopTest()
            // in order for it to complete execution.
            String schedule = '0 6 * * * ?';
            String jobID = System.schedule('Create Account Scheduled', schedule, new ScheduledApexClass());
        Test.stopTest();

        Account acc = [Select Name From Account];
        Assert.areEqual('Account created in scheduled job', acc.Name);

        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
        HttpResponse res = CalloutClass.MakeAnHTTPCallout();

        // Assert
        Assert.areEqual(200, res.getStatusCode());
        Assert.areEqual('Example Callout Test Response', res.getBody());
    }

    @isTest
    private static void EmailBeforeCallout_ThrowsUncommittedWorkPendingException() {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Test Email');
        mail.setPlainTextBody('This is a test');
        mail.setToAddresses(new List<String>{ 'terry@test.com' });
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });

        // Test
        try {
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            HttpResponse res = CalloutClass.MakeAnHTTPCallout();
            Assert.fail('This should have thrown uncommitted work pending exception');
        } catch (Exception ex) {
            Assert.areEqual('You have uncommitted work pending. Please commit or rollback before calling out', ex.getMessage());
        }
    }

    @isTest
    private static void EmailBeforeCallout_Fix_WrapMockSetupAndCalloutInTestStartStop() {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Test Email');
        mail.setPlainTextBody('This is a test');
        mail.setToAddresses(new List<String>{ 'terry@test.com' });
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });

        // Test
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
            HttpResponse res = CalloutClass.MakeAnHTTPCallout();
        Test.stopTest();

        // Assert
        Assert.areEqual(200, res.getStatusCode());
        Assert.areEqual('Example Callout Test Response', res.getBody());
    }
}