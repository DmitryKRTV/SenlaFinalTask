public with sharing class ProductsController {
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProducts() {
        return [SELECT Id, Name FROM Product2 WHERE Is_Advertise__c = true];
    }

    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductsNoAdv() {
        return [SELECT Id, Name FROM Product2 WHERE Is_Advertise__c = false AND Is_Visible_For_Site__c = true];
    }
}