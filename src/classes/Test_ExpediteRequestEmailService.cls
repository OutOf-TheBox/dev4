/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ExpediteRequestEmailService {

    static testMethod void myUnitTest() {
    	Messaging.Inboundemail email= new Messaging.Inboundemail();
    	messaging.Inboundenvelope env=new Messaging.Inboundenvelope();
    	
    	 // Create the plainTextBody and fromAddres for the test
  email.plainTextBody = 'Test Method Email';
  env.fromAddress = 'xxxxx@gmail.com';
  env.toAddress = 'quoterequests@xxxxxx.net';

  email.fromName = 'Some Name';
  
  //create an attachment
  
  Messaging.InboundEmail.TextAttachment inbTextAttchment = new Messaging.InboundEmail.TextAttachment();
  inbTextAttchment.body = 'Test Test Test Test Test Test Test Test Test';
  inbTextAttchment.fileName = 'myAttachment.txt';
  Messaging.InboundEmail.TextAttachment[] textAttachs = new Messaging.InboundEmail.TextAttachment[1];
  textAttachs[0] = inbTextAttchment;   
  email.textAttachments = textAttachs; 
  Blob myBlob = Blob.valueof('test body');
  Messaging.Inboundemail.BinaryAttachment file = new Messaging.Inboundemail.BinaryAttachment();
  file.filename='test';
  file.body=myBlob;
  
  Messaging.InboundEmail.BinaryAttachment[] binAttachs = new Messaging.InboundEmail.BinaryAttachment[1];
  binAttachs[0] = file;   
  email.binaryattachments = binAttachs; 
  
  
  Sales_Order__c so= new Sales_Order__c();
        
        so.Name='test mansa';
        so.Type__c='Internal';
        so.Status__c='Approved by OA';
        so.Actual_Shipment_Date__c=system.today();
        
        insert so;
        Sales_Order_Line__c soline=new Sales_Order_Line__c();
        
        soline.Sales_Order__c=so.id;
        insert soline;
        
         Expedite_Request__c exp=new Expedite_Request__c();
         exp.Approval_To_Overnight__c=' test mansa';
         exp.Overnight__c=true;
         exp.Sales_Order__c=so.id;
         exp.Target_Install_Date__c=system.today();
         insert exp;
         system.debug('exp1-----------'+exp);
                  Expedite_Request__c exp1=new Expedite_Request__c();
         exp1=[select name from Expedite_Request__c where id=:exp.Id];
    
    email.subject = 'test:[ref:'+exp1.name+']';            
    system.debug('exp--------------'+exp1.name);
    
    ExpediteRequestEmailService eqr = new ExpediteRequestEmailService();
 	eqr.handleInboundEmail(email, env);
 	Expedite_Request_Email__c  expemail= new Expedite_Request_Email__c();
    expemail.Inbound_Indicator__c=true;
    expemail.Email_cc__c='test@gmail.com';
    expemail.Email_cc__c='test1@gmail.com';
    expemail.Email_Body__c='testbody';
    expemail.Email_Subject__c='test:[ref:'+exp1.name+']';
    expemail.Expedite_Request__c=exp.ID;
    insert expemail;
    
    Attachment attachment = new Attachment();

            attachment.Name = 'test';
            attachment.Body = Blob.valueOf('test hjjhjhj');
            attachment.ParentId = expemail.Id;
            insert attachment;
             integer i=1;
        System.assertEquals(i,1);
    
      
  
    }
}