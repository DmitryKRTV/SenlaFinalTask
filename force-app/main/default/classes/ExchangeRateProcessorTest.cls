@IsTest
public with sharing class ExchangeRateProcessorTest {
    @IsTest
    static void testScheduledJob() {
        Test.startTest();
        String jobId = System.schedule('Test Schedule', '0 0 0 * * ? *', new ExchangeRateProcessor());
        Test.stopTest();
    }
}