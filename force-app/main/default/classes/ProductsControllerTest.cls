@isTest
public with sharing class ProductsControllerTest {
    @TestSetup
    static void makeData(){
        Product2 product = new Product2(Name='Test Product', IsActive=true, Is_Advertise__c = true, Family = 'TestFamily') ;
        insert product;
        Product2 product2 = new Product2(Name='Test Product2', IsActive=true, Is_Advertise__c = false, Family = 'TestFamily') ;
        insert product2;
    }
    @isTest
    static void getProductsTest() {
        List<Product2> results = ProductsController.getProducts();
        System.assertEquals(results.size(), 1);
        System.assertEquals(results[0].Name, 'Test Product');

        List<Product2> resultsNoAdv = ProductsController.getProductsNoAdv();
        System.assertEquals(resultsNoAdv.size(), 1);
        System.assertEquals(resultsNoAdv[0].Name, 'Test Product2');
    }
}