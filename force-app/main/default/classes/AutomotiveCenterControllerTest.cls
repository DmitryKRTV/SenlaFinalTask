@isTest
private with sharing class AutomotiveCenterControllerTest {
    @TestSetup
    static void setup(){
        Id dealerRecordTypeId = Schema.SObjectType.Automotive_Center__c.getRecordTypeInfosByName()
        .get('Dealer').getRecordTypeId();

        Id serviceRecordTypeId = Schema.SObjectType.Automotive_Center__c.getRecordTypeInfosByName()
        .get('Service').getRecordTypeId();

        List<Automotive_Center__c> centers = new List <Automotive_Center__c>();
        centers.add(new Automotive_Center__c(Name ='Test', Location__Latitude__s = 1, Location__Longitude__s = 2, RecordTypeId = dealerRecordTypeId));
        centers.add(new Automotive_Center__c(Name ='Test' + 1, Location__Latitude__s = 3, Location__Longitude__s = 4, RecordTypeId = serviceRecordTypeId));

        insert centers;

        Automotive_Center__c center = 
            [SELECT Id, RecordType.name
            FROM Automotive_Center__c
            WHERE RecordType.name = 'Dealer'
            LIMIT 1];
       
        Id pricebookId = Test.getStandardPricebookId();
        Product2 product = new Product2(Name='Test Product', IsActive=true, Is_Advertise__c = true, Family = 'TestFamily') ;
        insert product;
        PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=product.Id, UnitPrice=100.0, IsActive=true);
        insert pricebookEntry;

        CenterLineItem__c CenterLineItem = new CenterLineItem__c(AutomotiveCenterId__c=center.Id, ProductId__c=product.Id);
        insert CenterLineItem;

        Product2 product2 = new Product2(Name='Test Product2', IsActive=true, Is_Advertise__c = false, Family = 'TestFamily') ;
        insert product2;
        PricebookEntry pricebookEntry2 = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=product2.Id, UnitPrice=100.0, IsActive=true);
        insert pricebookEntry2;

        CenterLineItem__c CenterLineItem2 = new CenterLineItem__c(AutomotiveCenterId__c=center.Id, ProductId__c=product2.Id);
        insert CenterLineItem2;

        Exchange_Rate__c rate = new Exchange_Rate__c(Name='test', Alphabetic_Currency_Code__c='BYN', Currency_Conversion_Factor__c=2);
        insert rate;
        
    }
    @IsTest
    static void getAllCentersTest() {
        List<Automotive_Center__c> centersTestMethod = AutomotiveCenterController.getAllCentersForMap();
        List<Automotive_Center__c> centersOfRecordTypeTestMethod = AutomotiveCenterController.getAllCenters('Dealer');

        System.assertEquals(2, centersTestMethod.size());
        System.assertEquals(centersOfRecordTypeTestMethod.size(), 1);
    }

    @IsTest
    static void getProductsOfCenterAdvTest() {
        Automotive_Center__c center = 
        [SELECT Id, RecordType.name
        FROM Automotive_Center__c
        WHERE RecordType.name = 'Dealer'
        LIMIT 1];
        List<CenterLineItem__c> items = AutomotiveCenterController.getProductsOfCenterAdv(center.id);

        System.assertEquals(1, items.size());
        System.assertEquals('Test Product', items[0].ProductId__r.Name);
    }

    @IsTest
    static void getProductsOfCenterTest() {
        Automotive_Center__c center = 
        [SELECT Id, RecordType.name
        FROM Automotive_Center__c
        WHERE RecordType.name = 'Dealer'
        LIMIT 1];
        List<PriceBookEntry> results = AutomotiveCenterController.getProductsOfCenter(center.id, 'TestFamily', 'BYN');
        System.assertEquals(results.size(), 1);
        System.assertEquals(results[0].UnitPrice, 50);
    }

    @IsTest
    static void getPdfTest() {
        Automotive_Center__c center = 
        [SELECT Id, RecordType.name
        FROM Automotive_Center__c
        WHERE RecordType.name = 'Dealer'
        LIMIT 1];
        String result = AutomotiveCenterController.getPDF(center.id, 'TestFamily', 'BYN');
        System.assertNotEquals(result, null);
    }
}