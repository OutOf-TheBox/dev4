/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class ExpediteRequestEmailService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        
         
    String myPlainText= '';
    // Add the email plain text into the local variable 
    string plainsub=email.subject;
    list<string> divsub=new list<string>();
	divsub=plainsub.split('ref:');
    string ccadress=' ';
    list<string> cclist=new list<string>();
    email.ccAddresses=new list<string>();
    cclist=email.ccAddresses;
    if(cclist.size()>0)
    {
    for(string s:email.ccAddresses)
    {
    	ccadress+=s+';';
    }
    ccadress=ccadress.subString(0,ccadress.lastIndexOf(';'));
    system.debug('ccadress');
    }
    else
    ccadress=' ';
    
    
    
    string expname=' ';
    
    expname=divsub[1];
    system.debug('expname---------'+expname);
    expname=expname.subString(0,expname.lastIndexOf(']'));
    Expedite_Request__c expre=new Expedite_Request__c();
  //  Expedite_Request_Email__c exemail=[select id,name,Expedite_Request__c from Expedite_Request_Email__c where name=:expname];
    expre=[select id,name from Expedite_Request__c where name=:expname];
    myPlainText = email.plainTextBody;
    Expedite_Request_Email__c  expemail= new Expedite_Request_Email__c();
    expemail.Email_Body__c=email.plainTextBody;
    
    expemail.Email_cc__c=ccadress;
    expemail.Email_From__c=email.fromAddress;
    expemail.Expedite_Request__c=expre.id;
    expemail.Inbound_Indicator__c=true;
    expemail.Email_Subject__c=email.subject;
    insert expemail; 
    List<Attachment> attList = new List<Attachment>();
    // This will extract all blob attachments from email
     if (email.textAttachments != null) {
     	system.debug('text--------------');
            for(Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
            Attachment attachment = new Attachment();

            attachment.Name = tAttachment.fileName;
            attachment.Body = Blob.valueOf(tAttachment.body);
            attachment.ParentId = expemail.Id;
            attList .add(attachment);
            }
            }
    
    if(email.binaryAttachments!=null)
    {
    	
    
    for (Messaging.Inboundemail.BinaryAttachment file : email.binaryAttachments) 
    {
      Attachment attachment = new Attachment();
      attachment.Name = file .fileName;
      attachment.Body = file .body;
      // some hardcoded or id extracted from email reference
      attachment.ParentId = expemail.ID;
      attList .add(attachment);
   }
    }
    
   if(attList .size()>0)
   {
     insert attList;
   }

        return result;
    }
}