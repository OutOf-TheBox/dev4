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
private class Test_SendExpediteEmail {

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
         
		Expedite_Request_Email__c expemail= new Expedite_Request_Email__c();
		expemail.Expedite_Request__c=exp.Id;
		expemail.Email_Body__c='test body';
		expemail.Email_Subject__c='test subject';
		expemail.Email_cc__c='test@gmail.com';
		expemail.Email_To__c='test1@gmail.com';
		expemail.Attachment_Indicator__c=false;
		
		expemail.Inbound_Indicator__c=false;
		insert expemail;
		Blob b = Blob.valueOf('Test Data'); 
		Attachment a = new Attachment();
		a.Name='test';
		a.ParentId=expemail.Id;
		a.Body=b;
		insert a;
		
		expemail.Attachment_Indicator__c=true;
		update expemail;

    }
}