@isTest
private class CaseRecommendationTests
{

   static testMethod void testRecommendations()
   {
       Account          account;
       Contact          contact;
       Asset            asset;
       Case             aCase;
       Outstanding_Recommendation__c rec;
      
          // Create test account
          account = new Account(Name = 'TEST-ACCOUNT');
          insert account;
                    
          // Create test contact
          contact = new Contact(LastName = 'TEST-CONTACT-LAST-NAME',
                                AccountId = account.id);
          insert contact;
          

          //create asset          
          asset = new Asset(Name = 'TEST-ASSET',
                            AccountId = account.id,
                            ContactId = contact.id,
                            SLA__c = 'Premium',
                            Install_Street1__c        = 'TEST-ASSET-INSTALL-STREET1',
                            Install_Street2__c        = 'TEST-ASSET-INSTALL-STREET2',
                            Install_City__c           = 'TEST-ASSET-INSTALL-CITY',
                            Install_State_Province__c = 'TEST-ASSET-INSTALL-STATE');
          insert asset;
         
          
          // Create test case - Set 1
          aCase = new Case(AccountId = account.id,
                           AssetId   = asset.id,
                           ContactId = contact.id,
                           Subject = 'TEST-CASE-SUBJECT');
          insert aCase;
          

          //create test Recommendations
          
          rec = new Outstanding_Recommendation__c(Status__c = 'Requested',
                           Recommended_Action__c   = 'Test1',
                           Case__c = aCase.id,
                           Asset__c = asset.id,
                           Account__c = account.id,
                           Contact__c = contact.id);
          
           insert rec;

         
         
          Test.startTest();  
          
          
             ApexPages.StandardController sc = new ApexPages.standardController(acase);
             CaseRecommendation cs=new CaseRecommendation(sc);
             
             cs.cse = aCase;
             cs.cseAccountID = account.id;
             cs.executeCount();
             cs.getFooter();
             cs.getdisableValue();
             cs.getRecz();
              
             cs.cse = aCase; 
             cs.cseAccountID = null; 
             cs.total_size   =10;
             cs.list_size = 5;
             cs.executeCount();
             cs.getFooter();
             cs.getdisableValue();
             cs.getRecz();
             
             cs.cse = aCase; 
             cs.cseAccountID = account.id; 
             cs.total_size   =10;
             cs.list_size = 10;
             cs.executeCount();
             cs.getFooter();
             cs.getdisableValue();
             cs.getRecz();
             
             cs.cse = aCase;
             cs.cseAccountID = account.id;
             cs.total_size   = 5;
             cs.list_size = 10;
             cs.executeCount();
             cs.getFooter();
             cs.getdisableValue();
             cs.getRecz();
             
     
             
          Test.stopTest();
         
      
           
    }
    
       static testMethod void testRecommendationList()
   {
       Account          account;
       Contact          contact;
       Asset            asset;
       Case             aCase;
       Outstanding_Recommendation__c rec;
      
          // Create test account
          account = new Account(Name = 'TEST-ACCOUNT');
          insert account;
                    
          // Create test contact
          contact = new Contact(LastName = 'TEST-CONTACT-LAST-NAME',
                                AccountId = account.id);
          insert contact;
          

          //create asset          
          asset = new Asset(Name = 'TEST-ASSET',
                            AccountId = account.id,
                            ContactId = contact.id,
                            SLA__c = 'Premium',
                            Install_Street1__c        = 'TEST-ASSET-INSTALL-STREET1',
                            Install_Street2__c        = 'TEST-ASSET-INSTALL-STREET2',
                            Install_City__c           = 'TEST-ASSET-INSTALL-CITY',
                            Install_State_Province__c = 'TEST-ASSET-INSTALL-STATE');
          insert asset;
         
          
          // Create test case - Set 1
          aCase = new Case(AccountId = account.id,
                           AssetId   = asset.id,
                           ContactId = contact.id,
                           Subject = 'TEST-CASE-SUBJECT');
          insert aCase;
          

          //create test Recommendations
          
          rec = new Outstanding_Recommendation__c(Status__c = 'Requested',
                           Recommended_Action__c   = 'Test1',
                           Case__c = aCase.id,
                           Asset__c = asset.id,
                           Account__c = account.id,
                           Contact__c = contact.id);
          
           insert rec;

         
         
          Test.startTest();  
          
          
             ApexPages.StandardController sc = new ApexPages.standardController(acase);
             CaseRecommendationList cs=new CaseRecommendationList(sc);
             
              
             cs.cse = aCase;
             cs.cseAccountID = account.id;
             cs.executeCount();
             cs.getFooter();
             cs.getdisableValue();
             cs.getRecz();
              
             cs.cse = aCase; 
             cs.cseAccountID = null; 
             cs.total_size   =10;
             cs.list_size = 5;
             cs.executeCount();
             cs.getFooter();
             cs.getdisableValue();
             cs.getRecz();
             
             cs.cse = aCase; 
             cs.cseAccountID = account.id; 
             cs.total_size   =10;
             cs.list_size = 10;
             cs.executeCount();
             cs.getFooter();
             cs.getdisableValue();
             cs.getRecz();
             
             cs.cse = aCase;
             cs.cseAccountID = account.id;
             cs.total_size   = 5;
             cs.list_size = 10;
             cs.executeCount();
             cs.getFooter();
             cs.getdisableValue();
             cs.getRecz();
             
     
             
          Test.stopTest();
         
      
           
    }
      
     
}