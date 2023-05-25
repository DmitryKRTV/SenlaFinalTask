@isTest
public with sharing class CaseControllerTest {
    @TestSetup
    static void makeData(){
        Id pricebookId = Test.getStandardPricebookId();
        Product2 product = new Product2(Name='Test Product', IsActive=true, Is_Advertise__c = true, Family = 'TestFamily') ;
        insert product;
        PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id=pricebookId, Product2Id=product.Id, UnitPrice=100.0, IsActive=true);
        insert pricebookEntry;
    }

    @IsTest
    static void createTestDriveRequestTest() {
        Product2 product = [SELECT id FROM Product2 LIMIT 1];
        Id caseId = CaseController.createTestDriveRequest('TestFirst', 'TestLast', 'test@mail.com', '123456789', 'desc', product.id, 'compName');
        List<Case> cases = [SELECT id, SuppliedEmail FROM Case];
        List<Lead> leads = [SELECT id, FirstName FROM Lead];
    
        System.assertEquals(cases.size(), 1);
        System.assertEquals(cases[0].SuppliedEmail, 'test@mail.com');

        System.assertEquals(leads.size(), 1);
        System.assertEquals(leads[0].FirstName, 'TestFirst');
    }

    @IsTest
    static void createOrderRequestTest() {
        Product2 product = [SELECT id, Name FROM Product2 LIMIT 1];
        Id caseId = CaseController.createOrderRequest('TestFirst', 'TestLast', 'test@mail.com', '123456789', 'desc', product.id, 'compName');
        List<Case> cases = [SELECT id, SuppliedEmail, Subject FROM Case];
        List<Lead> leads = [SELECT id, FirstName FROM Lead];
    
        System.assertEquals(cases.size(), 1);
        System.assertEquals(cases[0].SuppliedEmail, 'test@mail.com');
        System.assertEquals(cases[0].Subject, 'New ' + product.Name + ' Order');

        System.assertEquals(leads.size(), 1);
        System.assertEquals(leads[0].FirstName, 'TestFirst');
    }
}