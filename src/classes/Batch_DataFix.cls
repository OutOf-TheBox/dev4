global class Batch_DataFix implements Database.Batchable<SObject>
{
    String query;

    global Batch_DataFix()
    {
        query = 'Select Id, CaseNumber, Thread_Id__c, Contact.Email, Contact.Name, Account.Name, Case.Asset.SerialNumber, Case.Asset.Nimble_Version__c from Case where EmailNotficationToCustomers__c=true';
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
           return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List <sObject> scope)
    {
        List<Case> caseList = scope;       
        List<EmailMessage> eMssgList = new List<EmailMessage>();
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        for(Case c : caseList)
        {
            if(c.Contact.Email != null)
            {
                String body = 'Dear ' + c.Contact.Name + ',<br/><br/>' +Batch_DataFixUtility.body1 + '<br/><table border="1"><tr><td> Serial Number </td><td>Current Release</td><td>Array Name</td><td>Case Number</td></tr><tr><td>' + c.Asset.SerialNumber + '</td><td>' + c.Asset.Nimble_Version__c + '</td><td>' + c.Asset.SerialNumber + '</td><td>' + c.CaseNumber +'</td></tr></table><br/>' +Batch_DataFixUtility.body2 + '<br/>' + c.Thread_Id__c; // Construct the body with merge fields 
                String subject = '*GA RELEASE ANNOUNCEMENT* NimbleOS 2.0.7.0 GA (General Availability) ' + c.Account.Name; //+ c.Thread_Id__c; // Construct the subject with merge fields 
                //String body = 'Serial Number: ' + c.Asset.SerialNumber + '<br/>Current Release: ' + c.Asset.Nimble_Version__c + '<br/>' + c.Thread_Id__c; // Construct the body with merge fields 
                EmailMessage em = new EmailMessage();
                em.ParentId = c.Id;
                em.HtmlBody = body;
                em.subject = subject;
                em.FromAddress = 'supportcase@nimblestorage.com';//e2c address
                em.ToAddress = c.Contact.Email;
                em.MessageDate = Datetime.now();
                em.FromName = 'Support Case';
                eMssgList.add(em);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {c.Contact.Email});
                mail.setHtmlBody(body);
                mail.setSubject(subject);
                mail.setSaveAsActivity(false);
                mail.setOrgWideEmailAddressId('0D280000000019D'); // give org wide address of the e2c address different in prod and dev
                allMails.add(mail);
            }
        }
        //insert the email message records
        insert eMssgList;
        //send emails to contacts
        Messaging.sendEmail(allMails);
    }
    global void finish(Database.BatchableContext BC)
    {
    	System.debug('Finished...');
    }
}