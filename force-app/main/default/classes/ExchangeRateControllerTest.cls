@isTest
public with sharing class ExchangeRateControllerTest {
    @TestSetup
    static void makeData(){
        Exchange_Rate__c rate = new Exchange_Rate__c(Name='test', Alphabetic_Currency_Code__c='BYN', Currency_Conversion_Factor__c=2);
        insert rate;
    }

    @isTest
    static void ExchangeRateControllerTest() {
        List<Exchange_Rate__c> result = ExchangeRateController.getRates();
        System.assertEquals(result.size(), 1);
        System.assertEquals(result[0].Alphabetic_Currency_Code__c, 'BYN');
    }

    @isTest
    static void ExchangeRateCalloutTest() {
        List <Exchange_Rate__c> oldRates = [SELECT id, Currency_Conversion_Factor__c, Alphabetic_Currency_Code__c FROM Exchange_Rate__c];
        System.assertEquals(oldRates.size(), 1);
        System.assertEquals(oldRates[0].Currency_Conversion_Factor__c, 2);
    
        Test.setMock(HttpCalloutMock.class, new MockHttpExchangeRate());

        Test.startTest();
        ExchangeRateController.changeRates();
        Test.stopTest();
        
        List <Exchange_Rate__c> newRates = [SELECT id, Currency_Conversion_Factor__c, Alphabetic_Currency_Code__c FROM Exchange_Rate__c];
        System.assertEquals(newRates.size(), 1);
        System.assertEquals(newRates[0].Currency_Conversion_Factor__c, 4);
    }
}