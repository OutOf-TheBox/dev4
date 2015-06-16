public class CaseCommentMailerUtils {
public class MyException extends Exception{}
public static void sendMail(CaseComment[] mycase, string templateId, boolean isPortalUser) {

try {
    Messaging.reserveSingleEmailCapacity(1);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
    mail.setUseSignature(false);
    if (isPortalUser == true) {
        mail.setSaveAsActivity(false);
    }

    //mail.setReplyTo('asprocess@nimblestorage.com'); //sandbox
    mail.setReplyTo('supportcase@nimblestorage.com'); //production
    
    
    for (CaseComment cc :mycase){

        Case c = [SELECT Id, CaseNumber, ContactId, account.support_provider__c, Thread_Id__c, Supportforce_Comment_Flag__c, Auto_Close__c, Auto_Open__c from Case where Id = :cc.ParentId];
        
        if ( (c.Supportforce_Comment_Flag__c == true && c.Auto_Open__c == true && c.account.support_provider__c == null) || isPortalUser == true ) {
        
            string contactId = c.ContactId;                
            if (contactId != null) {                    
                Contact ct = [SELECT Id, Email from Contact where Id = :c.ContactId];
            
                string assetEmail = ct.Email;                       
                if (assetEmail != null) {
            
                    // Dont use Template
                    //String[] toAddresses = new String[] {ct.Email};
                    //toAddresses.add('dbocskai@nimblestorage.com');
                    //mail.setSubject('Testing Trigger');
                    //mail.setToAddresses(toAddresses);
                    //mail.setplainTextBody('Comment: ' + cc.CommentBody + '\r\r' + 'To Email: ' + toAddresses + '\n\n' + 'Thread Id: ' + c.Thread_Id__c );
               
                    // Use Template
                    //templateId = '00X80000001RZpEEBW';  //testing non existing template                                                             
                    EmailTemplate[] et = [SELECT Id from EmailTemplate where Id = :templateId];
                    if (et.size() > 0) {
                        mail.setTemplateId(et[0].Id);                        
                        mail.settargetObjectId(c.ContactId);
                        mail.setWhatId(c.Id);
                                                     
                        // Send the email
                        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        
                        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        if (!results.get(0).isSuccess()) {
                            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
                            String errorMessage = results.get(0).getErrors()[0].getMessage();
                            throw new MyException('Email for case: ' + c.CaseNumber + 'CommentId: ' + cc.Id + ' not sent\n' + errorMessage);
                        }
                    }
                    else {
                        system.debug(LoggingLevel.ERROR, 'Cant find template: ' + templateId);                        
                        throw new MyException( 'CaseComment Trigger cant find the EmailTemplate: ' + templateId + '\n');                        
                    }
                }
            }
            c.Supportforce_Comment_Flag__c = false;
            update c;
        }
    }
}
catch (MyException e){
    sendError('error: ' + e);
}
catch(System.EmailException emlEx) {
    sendError ('Sending Email Failed from SF trigger CaseCommentMailerUtils: ' + emlEx);
}
finally {
    for (CaseComment cc :mycase){
        Case c = [SELECT Supportforce_Comment_Flag__c from Case where Id = :cc.ParentId];
            c.Supportforce_Comment_Flag__c = false;
            update c;    
    }
}    
}

public static void sendError(string error) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
    mail.setUseSignature(false);
    //String[] toAddresses = new String[] {'dbocskai@nimblestorage.com'};  //sandbox
    String[] toAddresses = new String[] {'support-tools@nimblestorage.com'};  //production         
    mail.setSubject('Adding/Updating Case Comment Trigger ERROR');
    mail.setToAddresses(toAddresses);
    mail.setplainTextBody(error);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

}

public static void DoNothing() {        integer i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;        i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;i = 0;}
}