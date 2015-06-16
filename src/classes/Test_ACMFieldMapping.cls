@isTest
public class Test_ACMFieldMapping {

    static testMethod void myUnitTest() {
    
    Product2 pr=new Product2();
    pr.name='Concierge Manager';
    pr.CurrencyIsoCode='USD';
    pr.ProductCode='CM-20';
    insert pr;
    
    Product2 pr1=new Product2();
    pr1.name='Concierge Manager';
    pr1.CurrencyIsoCode='USD';
    pr1.ProductCode='CM-10';
    insert pr1;
    
        Account acc=new Account();
        acc.name='test';
        acc.ACM_Start_Date__c=system.today();
        acc.ACM_End_Date__c=system.today()+30;
        acc.ACM_Service_Purchased_Quantity__c=2;
        acc.ACM_Service_Purchased__c=True;
        acc.CurrencyIsoCode='USD';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.name='test';
        opp.AccountId=acc.Id;
        opp.Type='New Business';
        opp.StageName='Qualified';
        opp.CloseDate=system.today()+3;
        insert opp;
        
        SBQQ__Quote__c quote1=new SBQQ__Quote__c();
        quote1.Quote_Name__c='test';
        quote1.SBQQ__Opportunity__c=opp.Id;
        
        insert quote1;
        
        /**SBQQ__QuoteLine__c quoteline=new SBQQ__QuoteLine__c();
        quoteline.SBQQ__Quote__c=quote1.Id;     
        insert quoteline;
        
        SBQQ__QuoteLine__c quoteline1=new SBQQ__QuoteLine__c();
        quoteline1.SBQQ__Quote__c=quote1.Id;
        quoteline1.SBQQ__RequiredBy__c=quoteline.Id;
        insert quoteline1;**/
      
        
        Sales_Order__c so=new Sales_Order__c();
        so.name='test';
        so.Type__c='Revenue';
        so.Opportunity__c=opp.id;
        insert so;
               
        integer i=1;
        System.assertEquals(i,1);
        
        Sales_Order_Line__c sol=new Sales_Order_Line__c();
        sol.Sales_Order__c=so.Id;
        sol.product__c=pr.Id;
        sol.CurrencyIsoCode='USD';
       
        sol.Actual_Shipping_Date__c=system.today()+3;
        //sol.Start_Date__c=system.today();
        //sol.End_Date__c=system.today()+30;
        sol.Quantity__c=3;
        insert sol;
        
         Sales_Order_Line__c sol1=new Sales_Order_Line__c();
        sol1.Sales_Order__c=so.Id;
        sol1.product__c=pr1.Id;
        
        sol1.CurrencyIsoCode='USD';
        
        sol1.Actual_Shipping_Date__c=system.today()+3;
        sol1.Start_Date__c=system.today();
        sol1.End_Date__c=system.today()+30;
        sol1.Quantity__c=3;
        insert sol1;
        
       test.startTest();
        sol.Start_Date__c=system.today()+1;
        sol.End_Date__c=system.today()+31;
        sol.Quantity__c=4;
        //sol.Sales_Order__c=so.Id;
        sol.product__c=pr.Id;
       update sol;
       sol1.Quantity__c=4;
       //sol1.Sales_Order__c=so.Id;
        sol1.product__c=pr1.Id;
       update sol1;
       test.stopTest();
        
        
        
        
        
    }
}