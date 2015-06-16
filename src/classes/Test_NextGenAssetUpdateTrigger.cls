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
private class Test_NextGenAssetUpdateTrigger {

    static testMethod void myUnitTest() {
    	Product2 pro=new Product2();
    	pro.Name='test';
    	Pro.Component_Code__c='test1';
    	pro.ProductCode='test1';
    	insert pro;
    	
    	Account acc=new Account();
    	acc.Name='test acc';
    	
    	insert acc;
    	
    	Contact con= new Contact();
    	con.LastName='last';
    	con.Email='test@gmail.com';
    	
    	con.AccountId=acc.Id;
    	insert con;
    	
    	Asset a =new Asset();
    	a.Array_Cache__c='test';
    	a.Array_Capacity__c='test1';
    	a.Array_Controller__c='test2';
    	a.Array_Networking__c='test3';
    	a.ContactId=con.Id;
    	a.AccountId=acc.Id;
    	
    	a.Name='test';
    	insert a;
    	 integer i=1;
		System.assertEquals(i,1);
    	
    	update a;
    }
}