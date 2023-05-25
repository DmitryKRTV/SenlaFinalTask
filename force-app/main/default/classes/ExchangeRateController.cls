public with sharing class ExchangeRateController {
    @AuraEnabled(cacheable=true)
    public static List<Exchange_Rate__c> getRates() {
        return [SELECT Alphabetic_Currency_Code__c, IsDefault__c FROM Exchange_Rate__c];
    }
    @future(callout=true)
    public static void changeRates() {
        List <Exchange_Rate__c> oldRates = [SELECT id, Currency_Conversion_Factor__c, Alphabetic_Currency_Code__c FROM Exchange_Rate__c];
        Map<String, Exchange_Rate__c> oldRatesMap = new Map<String, Exchange_Rate__c>();
        for (Exchange_Rate__c rate : oldRates) {
            oldRatesMap.put(rate.Alphabetic_Currency_Code__c, rate);
        }
        List <Exchange_Rate__c> newRates = new List<Exchange_Rate__c>();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.nbrb.by/exrates/rates?periodicity=0');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            List<Object> responseList = (List<Object>) JSON.deserializeUntyped(response.getBody());

            for (Object obj: responseList) {
                Map<String, Object> data = (Map<String, Object>) obj;
                String abbreviation = (String) data.get('Cur_Abbreviation');
                if( oldRatesMap.get(abbreviation) != null && oldRatesMap.get(abbreviation).Alphabetic_Currency_Code__c == abbreviation) {
                    Decimal curOfficialRate = (Decimal) data.get('Cur_OfficialRate');
                    Exchange_Rate__c newRate = new Exchange_Rate__c();
                    newRate = oldRatesMap.get(abbreviation);
                    newRate.Currency_Conversion_Factor__c = curOfficialRate;
                    newRates.add(newRate);
                }
            }
        }
        
        if(newRates.size() > 0) {
            update newRates;
        }
        
    }
}