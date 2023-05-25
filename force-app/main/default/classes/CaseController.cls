public with sharing class CaseController {
    @AuraEnabled
    public static Id createTestDriveRequest( String firstName, String lastName, String email, String phone, String description, String productId, String companyName) {
        List<Product2> product = [SELECT id FROM Product2 WHERE id = :productId];
        Case newCase = new Case();
        newCase.Subject = 'New Test-Drive order';
        newCase.SuppliedEmail = email;
        newCase.Description = description;
        if(product.size() > 0) {
            newCase.Desired_Product__c = product[0].id;
        }

        insert newCase;
    
        Lead newLead = new Lead();
        newLead.FirstName = firstName;
        newLead.LastName = lastName;
        newLead.Email = email;
        newLead.Phone = phone;
        newLead.Description = description;
        newLead.Company = companyName;

        insert newLead;

        return newCase.id;
    }

    @AuraEnabled
    public static Id createOrderRequest( String firstName, String lastName, String email, String phone, String description, String productId, String companyName) {
        List<Product2> product = [SELECT id, Name FROM Product2 WHERE id = :productId];
        Case newCase = new Case();
        newCase.Subject = 'New ' + product[0].Name + ' Order';
        newCase.SuppliedEmail = email;
        newCase.Description = description;
        if(product.size() > 0) {
            newCase.Desired_Product__c = product[0].id;
        }

        insert newCase;
    
        Lead newLead = new Lead();
        newLead.FirstName = firstName;
        newLead.LastName = lastName;
        newLead.Email = email;
        newLead.Phone = phone;
        newLead.Description = description;
        newLead.Company = companyName;

        insert newLead;

        return newCase.id;
    }
}