@IsTest
public with sharing class sendServiceQualityMailTest {
    @TestSetup
    static void setup() {
        Contact contact = new Contact(FirstName = 'TestFirst', LastName = 'TestLast', Email = 'testemmail@mail.com');
        insert contact;
        
        Opportunity opportunity = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today(), ContactId = contact.Id);
        insert opportunity;
    }
    
    @IsTest
    static void testSendFeedbackEmail() {
        Opportunity opportunity = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        opportunity.StageName = 'Closed Won';
        update opportunity;
        
        List<EmailMessage> emails = [SELECT Id, ToAddress FROM EmailMessage WHERE RelatedToId = :opportunity.Id];
        System.assertEquals(1, emails.size());
        System.assertEquals('testemmail@mail.com', emails[0].ToAddress);
    }
    
}
