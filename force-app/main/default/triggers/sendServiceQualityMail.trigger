trigger sendServiceQualityMail on Opportunity (after update) {
    {
        Map<Id, Opportunity> oldOpps = Trigger.oldMap;
        Map<Id, Opportunity> newOpps = Trigger.newMap;
        
        for (Id oppId : newOpps.keySet()) {
            Opportunity oldOpp = oldOpps.get(oppId);
            Opportunity newOpp = newOpps.get(oppId);
            
            if (oldOpp.StageName != 'Closed Won' && newOpp.StageName == 'Closed Won') {
                List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
                List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Id = :newOpp.ContactId];

                for (Contact contact : contacts) {
                    EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName ='Send_feedback'];
                    List<string> toAddress = new List<string>();
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(et.Id);
                    mail.setToAddresses(new String[] {contact.Email});
                    mail.setWhatId(newOpp.Id);
                    mail.setTargetObjectId(contact.Id);
                    messages.add(mail);
                }

                if (!messages.isEmpty()) {
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    
                    // Check if any email failed to send
                    for (Messaging.SendEmailResult result : results) {
                        if (!result.isSuccess()) {
                            System.debug('Failed to send email: ' + result.getErrors()[0].getMessage());
                        }
                    }
                }
            }
        }
    }
}