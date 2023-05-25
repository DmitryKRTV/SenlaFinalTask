public with sharing class AutomotiveCenterController {
    @AuraEnabled(cacheable=true)
    public static List<Automotive_Center__c> getAllCentersForMap(){
        return [
            SELECT Id, Name, Location__Latitude__s, Location__Longitude__s
            FROM Automotive_Center__c
       ];
    }
    @AuraEnabled(cacheable=true)
    public static List<Automotive_Center__c> getAllCenters(String centerType){
        return [
            SELECT Id, Name, Location__Latitude__s, Location__Longitude__s, Address__c, Image__c, Phone__c, Working_days__c, Working_hours__c, RecordType.name
            FROM Automotive_Center__c
            WHERE RecordType.name = :centerType
       ];
    }

    @AuraEnabled(cacheable=true)
    public static List<CenterLineItem__c> getProductsOfCenterAdv(String centerId){
        return [
            SELECT ProductId__r.Id, ProductId__r.Name, ProductId__r.Description, ProductId__r.Family, ProductId__r.Image__c
            FROM CenterLineItem__c
            WHERE AutomotiveCenterId__r.Id = :centerId AND ProductId__r.Is_Advertise__c = true
       ];
    }

    @AuraEnabled(cacheable=true)
    public static List<PriceBookEntry> getProductsOfCenter(String centerid, String family, String currencyCode){
        List<CenterLineItem__c> centerProducts = [
            SELECT ProductId__r.Id
            FROM CenterLineItem__c
            WHERE AutomotiveCenterId__r.Id = :centerId AND ProductId__r.Is_Advertise__c = false AND ProductId__r.Family = :family
        ];

        List<Product2> products2 = new List<Product2>();
        for (CenterLineItem__c pEntry: centerProducts) {
           Product2 aProduct = new Product2();
           aProduct.Id = pEntry.ProductId__r.Id;
           products2.add(aProduct);
        }

        List<PriceBookEntry> beforeSendProducts = [
            SELECT Product2Id, Product2.Name, Product2.Drive_Unit__c, Product2.Transmission__c, UnitPrice, 
            Product2.Car_Body_Type__c, Product2.Engine__c, Product2.Fuel_Type__c, Product2.Color__c, Product2.Image__c
            FROM PriceBookEntry
            WHERE Product2Id IN :products2
        ];

        Exchange_Rate__c currentCurrencyRate = [
            SELECT Alphabetic_Currency_Code__c, Currency_Conversion_Factor__c 
            FROM Exchange_Rate__c 
            WHERE Alphabetic_Currency_Code__c = :currencyCode
            LIMIT 1
        ];

        List <PriceBookEntry> resultProducts = new List<PriceBookEntry>();

        for (PriceBookEntry beforeSendProduct : beforeSendProducts) {
            beforeSendProduct.UnitPrice = (beforeSendProduct.UnitPrice / currentCurrencyRate.Currency_Conversion_Factor__c).setScale(0);
            resultProducts.add(beforeSendProduct);
        }

        return resultProducts;
    }

    @AuraEnabled
    public static String getPDF(String centerid, String family, String currencyCode){
        List<CenterLineItem__c> centerProducts = [
            SELECT ProductId__r.Id
            FROM CenterLineItem__c
            WHERE AutomotiveCenterId__r.Id = :centerId AND ProductId__r.Is_Advertise__c = false AND ProductId__r.Family = :family
        ];

        List<Product2> products2 = new List<Product2>();
        for (CenterLineItem__c pEntry: centerProducts) {
           Product2 aProduct = new Product2();
           aProduct.Id = pEntry.ProductId__r.Id;
           products2.add(aProduct);
        }

        List<PriceBookEntry> beforeSendProducts = [
            SELECT Product2Id, Product2.Name, Product2.Drive_Unit__c, Product2.Transmission__c, UnitPrice, Product2.Family, Product2.Complectation__c,
            Product2.Car_Body_Type__c, Product2.Engine__c, Product2.Fuel_Type__c, Product2.Color__c, Product2.Image__c
            FROM PriceBookEntry
            WHERE Product2Id IN :products2
        ];

        Exchange_Rate__c currentCurrencyRate = [
            SELECT Alphabetic_Currency_Code__c, Currency_Conversion_Factor__c 
            FROM Exchange_Rate__c 
            WHERE Alphabetic_Currency_Code__c = :currencyCode
            LIMIT 1
        ];

        List <PriceBookEntry> resultProducts = new List<PriceBookEntry>();

        for (PriceBookEntry beforeSendProduct : beforeSendProducts) {
            beforeSendProduct.UnitPrice = (beforeSendProduct.UnitPrice * currentCurrencyRate.Currency_Conversion_Factor__c).setScale(0);
            resultProducts.add(beforeSendProduct);
        }
        
        String pdfText;
        pdfText = '<HTML><BODY>';
        pdfText = '';
        if(resultProducts.size() > 0) {
            pdfText += '<H2>' + resultProducts[0].Product2.Family + '</H2><br>';
        }
        
        //pdfText
        for(Integer i=0; i < resultProducts.size(); i++)   {
            pdfText = pdfText +('<p>' + '<&emsp>' 
                                + resultProducts.get(i).Product2.Name + '<br><&emsp>' 
                                + 'Complectation: ' + resultProducts.get(i).Product2.Complectation__c + '<br><&emsp>' 
                                + 'Drive Unit: ' + resultProducts.get(i).Product2.Drive_Unit__c + '<br><&emsp>' 
                                + 'Transmission: ' +resultProducts.get(i).Product2.Transmission__c + '<br><&emsp>' 
                                + 'Car Body Type: ' +resultProducts.get(i).Product2.Car_Body_Type__c + '<br><&emsp>' 
                                + 'Engine: ' +resultProducts.get(i).Product2.Engine__c + '<br><&emsp>' 
                                + 'Fuel Type: ' +resultProducts.get(i).Product2.Fuel_Type__c + '<br><&emsp>' 
                                + 'Color: ' +resultProducts.get(i).Product2.Color__c + '<br><&emsp>' 
                                + 'Price: ' + resultProducts.get(i).UnitPrice + ' ' + currentCurrencyRate.Alphabetic_Currency_Code__c + '<br></p><br>');
        }
        pdfText = pdfText + '</BODY></HTML>';

        Blob pdfContent = Blob.toPdf(pdfText);
        System.debug(pdfContent);
        return EncodingUtil.base64Encode(pdfContent);
    }
}