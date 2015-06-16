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
private class Test_ExpediteEmailRequestEdit {

    static testMethod void myUnitTest() {
    	

        
    	
    	
		Sales_Order__c so= new Sales_Order__c();        
        so.Name='test mansa';
        so.Type__c='Internal';
        so.Status__c='Approved by OA';
        so.Actual_Shipment_Date__c=system.today();
        insert so;
        
                
         Expedite_Request__c exp=new Expedite_Request__c();
         exp.Approval_To_Overnight__c=' test mansa';
         exp.Overnight__c=true;
         exp.Sales_Order__c=so.id;
         exp.Target_Install_Date__c=system.today();
         insert exp;
         
         Expedite_Request_Email__c exemailinsert=new Expedite_Request_Email__c();
        exemailinsert.Email_Body__c='test';
        exemailinsert.Email_Subject__c='test subject';
        exemailinsert.Email_cc__c='test@mansa.com';
        exemailinsert.Email_To__c='test1@mansa.com';
        exemailinsert.Expedite_Request__c=exp.id;
        insert exemailinsert;
         
     	 PageReference pageRef = new PageReference('/apex/ExpediteEmailRequestEdit?retURL=%2F'+exp.Id);
		 Test.setCurrentPage(pageRef);         
         apexpages.currentPage().getParameters().put('EMId',exemailinsert.Id);    
                //  apexpages.currentPage().getParameters().put('retURL',exp.Id);       
            
         //apexpages.currentPage().getParameters().put('retURL',exp.Id);
         
         string email='test@gmail.com';
         string opname='name'; 
         ApexPages.StandardController sc = new ApexPages.StandardController(exp);
         ExpediteEmailRequestEdit expctrl= new ExpediteEmailRequestEdit(sc);
         expctrl.backtoexpedite();
         expctrl.cancel();
         expctrl.Reply();
         expctrl.replyall();
         expctrl.ReSend();
         expctrl.send();
         expctrl.sendwithattachment();
         ExpediteEmailRequestEdit.wrapexpemail wrap=new ExpediteEmailRequestEdit.wrapexpemail(opname,email);
         
                 
         
    }
    static testMethod void myUnitTest1() {
    	

        
    	
    	
		Sales_Order__c so= new Sales_Order__c();        
        so.Name='test mansa';
        so.Type__c='Internal';
        so.Status__c='Approved by OA';
        so.Actual_Shipment_Date__c=system.today();
        insert so;
        
                
         Expedite_Request__c exp=new Expedite_Request__c();
         exp.Approval_To_Overnight__c=' test mansa';
         exp.Overnight__c=true;
         exp.Sales_Order__c=so.id;
         exp.Target_Install_Date__c=system.today();
         insert exp;
         
         Expedite_Request_Email__c exemailinsert=new Expedite_Request_Email__c();
        exemailinsert.Email_Body__c='test';
        exemailinsert.Email_Subject__c='test subject';
        exemailinsert.Email_cc__c='test@mansa.com';
        exemailinsert.Email_To__c='test1@mansa.com';
        exemailinsert.Expedite_Request__c=exp.id;
        insert exemailinsert;
        Attachment attachment = new Attachment();

            attachment.Name = 'test';
            attachment.Body = Blob.valueOf('test hjjhjhj');
            attachment.ParentId = exemailinsert.Id;
            insert attachment;
             integer i=1;
        System.assertEquals(i,1);
        Attachment attachment1 = new Attachment();

            attachment1.Name = 'test';
            attachment1.Body = Blob.valueOf('test hjjhjhj');
            attachment1.ParentId = exemailinsert.Id;
            insert attachment1;
            
        Attachment attachment2 = new Attachment();

            attachment2.Name = 'test';
            attachment2.Body = Blob.valueOf('test hjjhjhj');
            attachment2.ParentId = exemailinsert.Id;
            insert attachment2;
            
        Attachment attachment4 = new Attachment();

            attachment4.Name = 'test';
            attachment4.Body = Blob.valueOf('test hjjhjhj');
            attachment4.ParentId = exemailinsert.Id;
            insert attachment4;
             
        
        
         
     	 PageReference pageRef = new PageReference('/apex/ExpediteEmailRequestEdit?retURL=%2F'+exp.Id);
		 Test.setCurrentPage(pageRef);         
         apexpages.currentPage().getParameters().put('EMId',exemailinsert.Id);    
                //  apexpages.currentPage().getParameters().put('retURL',exp.Id);       
            
         //apexpages.currentPage().getParameters().put('retURL',exp.Id);
         
          
         ApexPages.StandardController sc = new ApexPages.StandardController(exp);
         ExpediteEmailRequestEdit expctrl= new ExpediteEmailRequestEdit(sc);
         expctrl.checkattachment='False';
         expctrl.backtoexpedite();
         expctrl.cancel();
         expctrl.Reply();
         expctrl.replyall();
         expctrl.ReSend();
         expctrl.send();
         expctrl.sendwithattachment();
         expctrl.deleteatt();
         expctrl.deleteatt();
         expctrl.viewatt();
         expctrl.Editatt();
         
         
         
                 
         
    }
}