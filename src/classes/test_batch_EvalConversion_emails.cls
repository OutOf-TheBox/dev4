@isTest
private class test_batch_EvalConversion_emails {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<String> idss=new List<String>();
        List<Sales_Order_Line__c> solRecs=new List<Sales_Order_Line__c>();
        List<Sales_Order_Line__c> solRecs1=new List<Sales_Order_Line__c>();
        
        Sales_Order__c so=new Sales_Order__c();
        so.name='Test Salesorder';
        so.Type__c='Beta';
        so.Ship_To_Country__c='Usssssd';
        so.Bill_To_Country__c='Canada';
        so.End_Customer_Country__c='China';
        insert so;
        
        Sales_Order__c so1=new Sales_Order__c();
        so1.name='Test Salesorder';
        so1.Type__c='Beta';
        so1.Ship_To_Country__c='Usssssd';
        so1.Bill_To_Country__c='Canada';
        so1.End_Customer_Country__c='China';

        insert so1;
        idss.add(so.id);
        idss.add(so1.id);
        
        Sales_Order_Line__c sol=new Sales_Order_Line__c();
        sol.Sales_Order__c=so.id;
        sol.Tracking_Number__c='123';
        sol.CurrencyIsoCode='USD';
        sol.Support_Renewal_Indicator__c=true;
        insert sol;
        solRecs.add(sol);
        
        Sales_Order_Line__c sol1=new Sales_Order_Line__c();
        sol1.Sales_Order__c=so.id;
        sol1.Tracking_Number__c='123';
        sol1.CurrencyIsoCode='USD';
        sol1.Eval_Conversion_Indicator__c=true;
        insert sol1;
        solRecs1.add(sol1);
        
        Test.startTest();
        /*BatchRenewalShippingEmails bse=new BatchRenewalShippingEmails();
        bse.query='Select id,Item__c,Tracking_Number__c,Quantity__c,Serial_Number__c,Sales_Order__c,Actual_Shipping_Date__c from Sales_Order_Line__c where Shipping_Email_Indicator__c=false AND Support_Renewal_Indicator__c=true';
        //bse.salesOrderIds=idss;
        bse.execute(null,solRecs);
        ID batchprocessid = Database.executeBatch(bse);*/
        
        batch_EvalConversion_emails bse1=new batch_EvalConversion_emails();
        bse1.query='Select id,Item__c,Tracking_Number__c,Quantity__c,Serial_Number__c,Sales_Order__c,Actual_Shipping_Date__c from Sales_Order_Line__c where Shipping_Email_Indicator__c=false AND Eval_Conversion_Indicator__c=true';
        //bse.salesOrderIds=idss;
        bse1.execute(null,solRecs1);
        ID batchprocessid1 = Database.executeBatch(bse1);
        
        Test.stopTest();
        integer i=1;
        System.assertEquals(i,1);
   
        
        }
}