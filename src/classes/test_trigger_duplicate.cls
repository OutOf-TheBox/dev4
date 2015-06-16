@isTest
private class test_trigger_duplicate { 


    static testMethod void myUnitTest() {
        // TO DO: implement unit test        
        
        //////////1st condition
        
         Account acc=new Account();
         acc.Name='Test account';
         acc.CurrencyIsoCode='USD';
         insert acc;
         
         
         Contact con=new Contact();
         con.lastName='Test Contact';
         con.CurrencyIsoCode='USD';
         con.accountid=acc.id;
         insert con;
         
         
         
         Asset nAssRec=new Asset();
         nAssRec.Accountid=acc.id;
         nAssRec.Contactid=con.id;
         nAssRec.Name='Test asset';
         nAssRec.SerialNumber='123';
         nAssRec.status='Shipped';
         insert nAssRec;
         
         Asset nAssRec1=new Asset();
         nAssRec1.Accountid=acc.id;
         nAssRec1.Contactid=con.id;
         nAssRec1.Name='Test asset';
         nAssRec1.SerialNumber='1234';
         nAssRec1.status='Shipped';
         insert nAssRec1;
         
         
         Duplicate_Asset__c du=new Duplicate_Asset__c();
         du.Account__c=acc.id;         
         du.Serial_Number__c='123';
         du.Asset_Name__c='test';
         du.sla__c='Premium';
         du.Support_Start_Date__c=date.today();
         du.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du; 
         
         du.Serial_Number__c='124';
         update du;
         
         Duplicate_Asset__c du1=new Duplicate_Asset__c();
         du1.Account__c=acc.id;         
         du1.Serial_Number__c='123456';
         du1.Asset_Name__c='test';
         du1.sla__c='Premium';
         du1.Support_Start_Date__c=date.today();
         du1.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du1; 
         
         
         
    }
    
    
    static testMethod void myUnitTest2() {
         
         Account acc2=new Account();
         acc2.Name='Test account';
         acc2.CurrencyIsoCode='USD';
         insert acc2;
         
         Contact con2=new Contact();
         con2.lastName='Test Contact';
         con2.CurrencyIsoCode='USD';
         con2.AccountId=acc2.id;
         con2.email='a@gmail.com';
         insert con2;
         
         
         Asset nAssRec=new Asset();
         nAssRec.Accountid=acc2.id;
        // nAssRec.Contactid=con2.id;
         nAssRec.Name='Test asset';
         nAssRec.SerialNumber='1239';
         nAssRec.status='Shipped';
         insert nAssRec;
         
         
         Sales_Order__c so=new Sales_Order__c();
         so.name='Test Sales Order';
         so.Type__c='Revenue';
         so.Ship_To_Contact_Email__c='a@gmail.com';
         insert so;
         
         
         
         Duplicate_Asset__c du2=new Duplicate_Asset__c();
         du2.Account__c=acc2.id;         
         du2.Serial_Number__c='123456';
         du2.Asset_Name__c='test';
         du2.Sales_Order__c=so.Id;
         du2.sla__c='Premium';
         du2.Support_Start_Date__c=date.today();
         du2.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du2; 
             }
        
    
    static testMethod void myUnitTest3() {
         
         Account acc3=new Account();
         acc3.Name='Test account';
         acc3.CurrencyIsoCode='USD';
         insert acc3;
         Account acc=new Account();
         acc.name='test';
         acc.CurrencyIsoCode='USD';
         insert acc;
         
         Contact con=new Contact();
         con.lastName='Test Contact';
         con.CurrencyIsoCode='USD';
         con.accountid=acc.id;
         
         insert con;         
         
                
         Asset nAssRec=new Asset();
         nAssRec.Accountid=acc3.id;
         //nAssRec.Contactid=con2.id;
         nAssRec.Name='Test asset';
         nAssRec.SerialNumber='123';
         nAssRec.status='Shipped';
         insert nAssRec;
         
                 
         
         Case c=new Case();
         c.Status='New';
         c.Origin='Web';
         c.Category__c='RAM';
         c.type='Problem';
         c.Reason='Other';       
         c.Nimble_Version__c='N/A';
         c.Estimated_Effort__c='1 Day';
         c.caseEscalationType__c='Not Escalated';
         c.accountid=acc3.id; 
         c.contactid=con.id;
         insert c;
         
         
         Duplicate_Asset__c du3=new Duplicate_Asset__c();
         du3.Account__c=acc3.id;         
         du3.Serial_Number__c='123456';
         du3.Asset_Name__c='test';
         du3.sla__c='Premium';
         du3.Support_Start_Date__c=date.today();
         du3.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du3; 
                      }
                      
                
                      static testMethod void myUnitTest4() {
         
         Account acc3=new Account();
         acc3.Name='Test account';
         acc3.CurrencyIsoCode='USD';
         insert acc3;
         
         Contact con=new Contact();
         con.lastName='Test Contact';
         con.CurrencyIsoCode='USD';
         con.accountid=acc3.id;
         
         insert con;
         
          Asset nAssRec=new Asset();
         nAssRec.Accountid=acc3.id;
         //nAssRec.Contactid=con2.id;
         nAssRec.Name='Test asset';
         nAssRec.SerialNumber='123';
         nAssRec.status='Shipped';
         insert nAssRec;
         
         Sales_Order__c so1=new Sales_Order__c();
         so1.name='Test Sales Order';
         so1.Type__c='Revenue';
         so1.Ship_To_Contact_Email__c='aeretre@gmail.com';
         insert so1;
         
         
         Duplicate_Asset__c du3=new Duplicate_Asset__c();
         du3.Account__c=acc3.id;         
         du3.Serial_Number__c='123456';
         du3.Asset_Name__c='test';
         du3.sla__c='Premium';
         du3.Support_Start_Date__c=date.today();
         du3.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du3; 
                      }
                      
                      
                      static testMethod void myUnitTest5() {
         
         Account acc3=new Account();
         acc3.Name='Test account';
         acc3.CurrencyIsoCode='USD';
         insert acc3;
         
         
          Asset nAssRec=new Asset();
         nAssRec.Accountid=acc3.id;
         //nAssRec.Contactid=con2.id;
         nAssRec.Name='Test asset';
         nAssRec.SerialNumber='123';
         nAssRec.status='Shipped';
         insert nAssRec;
         
         Sales_Order__c so1=new Sales_Order__c();
         so1.name='Test Sales Order';
         so1.Type__c='Revenue';
         so1.Ship_To_Contact_Email__c='aeretre@gmail.com';
         insert so1;
         
         
         
         Duplicate_Asset__c du3=new Duplicate_Asset__c();
         du3.Account__c=acc3.id;         
         du3.Serial_Number__c='123456';
         du3.Asset_Name__c='test';
         du3.sla__c='Premium';
         du3.Support_Start_Date__c=date.today();
         du3.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du3; 
                      }
                      
    
      /*
        static testMethod void myUnitTest6() {
        // TO DO: implement unit test        
        
        //////////1st condition
        
         Account acc=new Account();
         acc.Name='Test account';
         acc.CurrencyIsoCode='USD';
         insert acc;
         
         
         Contact con=new Contact();
         con.lastName='Test Contact';
         con.CurrencyIsoCode='USD';
         con.accountid=acc.id;
         insert con;
         
         
         
         Asset nAssRec=new Asset();
         nAssRec.Accountid=acc.id;
         nAssRec.Contactid=con.id;
         nAssRec.Name='Test asset';
         nAssRec.SerialNumber='123';
         nAssRec.status='Shipped';
         insert nAssRec;
         
         
         
         
         Duplicate_Asset__c du=new Duplicate_Asset__c();
         du.Account__c=acc.id;         
         du.Serial_Number__c='123';
         du.Asset_Name__c='test';
         du.sla__c='Premium';
         du.Support_Start_Date__c=date.today();
         du.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du; 
         
         du.Serial_Number__c='124';
         update du;
         
         Duplicate_Asset__c du1=new Duplicate_Asset__c();
         du1.Account__c=acc.id;         
         du1.Serial_Number__c='123456';
         du1.Asset_Name__c='test';
         du1.sla__c='Premium';
         du1.Support_Start_Date__c=date.today();
         du1.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du1; 
         
         
         
    }
    */
    
    
    static testMethod void myUnitTest7() {
         
         Account acc2=new Account();
         acc2.Name='Test account';
         acc2.CurrencyIsoCode='USD';
         insert acc2;
         
         Contact con2=new Contact();
         con2.lastName='Test Contact';
         con2.CurrencyIsoCode='USD';
         con2.accountid=acc2.id;
         con2.email='a@gmail.com';
         insert con2;
         
        
         
         
         Sales_Order__c so=new Sales_Order__c();
         so.name='Test Sales Order';
         so.Type__c='Revenue';
         so.Ship_To_Contact_Email__c='a@gmail.com';
         insert so;
         
         
         
         Duplicate_Asset__c du2=new Duplicate_Asset__c();
         du2.Account__c=acc2.id;         
         du2.Serial_Number__c='123456';
         du2.Asset_Name__c='test';
         du2.Sales_Order__c=so.Id;
         du2.sla__c='Premium';
         du2.Support_Start_Date__c=date.today();
         du2.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du2; 
             }
         
    
    static testMethod void myUnitTest8() {
         
         
         Account acc3=new Account();
         acc3.Name='Test account';
         acc3.CurrencyIsoCode='USD';
         insert acc3;
         Account acc=new Account();
         acc.name='test';
         acc.CurrencyIsoCode='USD';
         insert acc;
         
         Contact con=new Contact();
         con.lastName='Test Contact';
         con.CurrencyIsoCode='USD';
         con.accountid=acc.id;
         
         insert con;         
                   
         
         Case c=new Case();
         c.Status='New';
         c.Origin='Web';
         c.Category__c='RAM';
         c.type='Problem';
         c.Reason='Other';       
         c.Nimble_Version__c='N/A';
         c.Estimated_Effort__c='1 Day';
         c.caseEscalationType__c='Not Escalated';
         c.accountid=acc3.id; 
         c.contactid=con.id;
         insert c;
         
         
         Duplicate_Asset__c du3=new Duplicate_Asset__c();
         du3.Account__c=acc3.id;         
         du3.Serial_Number__c='123456';
         du3.Asset_Name__c='test';
         du3.sla__c='Premium';
         du3.Support_Start_Date__c=date.today();
         du3.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du3;
                      }
                      
                      static testMethod void myUnitTest9() {
         
         Account acc3=new Account();
         acc3.Name='Test account';
         acc3.CurrencyIsoCode='USD';
         insert acc3;
         
         Contact con=new Contact();
         con.lastName='Test Contact';
         con.CurrencyIsoCode='USD';
         con.accountid=acc3.id;
         
         insert con;
         
                 
         
         Sales_Order__c so1=new Sales_Order__c();
         so1.name='Test Sales Order';
         so1.Type__c='Revenue';
         so1.Ship_To_Contact_Email__c='aeretre@gmail.com';
         insert so1;
         
         
         Duplicate_Asset__c du3=new Duplicate_Asset__c();
         du3.Account__c=acc3.id;         
         du3.Serial_Number__c='123456';
         du3.Asset_Name__c='test';
         du3.sla__c='Premium';
         du3.Support_Start_Date__c=date.today();
         du3.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du3; 
                      }
                      
                      static testMethod void myUnitTest10() {
         
         Account acc3=new Account();
         acc3.Name='Test account';
         acc3.CurrencyIsoCode='USD';
         insert acc3;
         
         
         
         
         Sales_Order__c so1=new Sales_Order__c();
         so1.name='Test Sales Order';
         so1.Type__c='Revenue';
         so1.Ship_To_Contact_Email__c='aeretre@gmail.com';
         insert so1;
         
         
         
         Duplicate_Asset__c du3=new Duplicate_Asset__c();
         du3.Account__c=acc3.id;         
         du3.Serial_Number__c='123456';
         du3.Asset_Name__c='test';
         du3.sla__c='Premium';
         du3.Support_Start_Date__c=date.today();
         du3.Support_End_Date__c=date.today()+12;
         Utility.runDupRecTrigger=true;    
         insert du3; 
                      }
                      
                  
      
        
       }