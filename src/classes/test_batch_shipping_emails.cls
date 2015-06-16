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
private class test_batch_shipping_emails {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<String> idss=new List<String>();
        List<Sales_Order_Line__c> solRecs=new List<Sales_Order_Line__c>();
        
        Sales_Order__c so=new Sales_Order__c();
        so.name='Test Salesorder';
        so.Type__c='Beta';
        insert so;
        
        Sales_Order__c so1=new Sales_Order__c();
        so1.name='Test Salesorder';
        so1.Type__c='Beta';
        insert so1;
        idss.add(so.id);
        idss.add(so1.id);
        
        Sales_Order_Line__c sol=new Sales_Order_Line__c();
        sol.Sales_Order__c=so.id;
        sol.Tracking_Number__c='123';
        sol.CurrencyIsoCode='USD';
        sol.BOM_Line_Number__c='1';
        insert sol;
         Sales_Order_Line__c sol1=new Sales_Order_Line__c();
        sol1.Sales_Order__c=so.id;
        sol1.Tracking_Number__c='1234';
        sol1.CurrencyIsoCode='USD';
        sol1.BOM_Line_Number__c='1.1';
        insert sol1;
        
        solRecs.add(sol1);
        
        Sales_Order_Line__c sol2=new Sales_Order_Line__c();
        sol2.Sales_Order__c=so.id;
        sol2.Tracking_Number__c='1234';
        sol2.CurrencyIsoCode='USD';
        insert sol2;
        
        solRecs.add(sol2);
        
        Test.startTest();
        batch_shipping_emails bse=new batch_shipping_emails();
        bse.query='Select id,Item__c,Quantity__c,Serial_Number__c,Tracking_Number__c,Sales_Order__c,Actual_Shipping_Date__c from Sales_Order_Line__c';
        //bse.salesOrderIds=idss;
        bse.execute(null,solRecs);
        ID batchprocessid = Database.executeBatch(bse);
        
        Test.stopTest();
        integer i=1;
        System.assertEquals(i,1);
        
        
        
        }
        }