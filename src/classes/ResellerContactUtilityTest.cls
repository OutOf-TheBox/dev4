@isTest(seeAlldata = false)
private class ResellerContactUtilityTest
{
   static testMethod void testControllers()
   {
       ID ProfileID = [ Select id from Profile where name = 'Support: System Administrator'].id;
       User usr = new User(email='test-user@example1.com',profileid = ProfileID, 
                      UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                      LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                      FirstName = 'Test',LastName = 'UserTest' );
       insert usr;
       System.runAs(usr) {
           UserRole roleId = [select id from UserRole where name = 'Executive Staff'];
           Profile p2 = [select Id from Profile where Name = 'System Administrator' limit 1];
           User accUsr = new User(email='testsp-user@fakeemail.com',profileid = p2.Id, userrole= roleId, 
                        UserName='testsp-user@fakeemail.com', alias='tuser1', CommunityNickName='stuser1', 
                        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                        LanguageLocaleKey='en_US',
                        FirstName = 'Tests', LastName = 'User');
           insert accUsr;
           ID accRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Support Provider'].Id;
           RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Channel' Limit 1];
           Account supAcct = new Account(Name = 'TestSuppProvider', Type = 'Support Provider', Email__c = 'supemail@test.com', RecordTypeId = accRecordType);
           insert supAcct; //create support provider account
           Account resAcct = new Account(Name = 'TestResAcct', Type = 'Reseller',RecordTypeId = rt2.id,Support_Provider__c = supAcct.id);
           insert resAcct; //create reseller account
           Account custAcct = new Account(OwnerId=accUsr.Id,Name = 'TestCustAcct', Type = 'Customer', RecordTypeId = rt2.id,Support_Provider__c = supAcct.id);
           insert custAcct; //create customer account
           Contact resCont = new Contact(FirstName = 'Test_FN', LastName = 'Test_LN' , AccountId = resAcct.Id, Email = 'resemail@test.com');
           insert resCont; // create reseller contact
           Contact custCont = new Contact(FirstName = 'Test_c_FN', LastName = 'Test_c_LN', AccountId = custAcct.Id, Email = 'custemail@test.com');
           insert custCont; // create customer contact
           Profile p = [select Id from Profile where Name = 'Nimble Customer Portal Profile' limit 1];
           User custUsr = new User(email='test-user@fakeemail.com', profileid = p2.Id, 
                        UserName='tests-user@fakeemail.com', alias='tuser1', CommunityNickName='stuser16', 
                        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                        LanguageLocaleKey='en_US',
                        FirstName = 'Test', LastName = 'User');
           insert custUsr;  // create a portal user
           AccountTeamMember atm = new AccountTeamMember(AccountId = custAcct.Id, UserId = custUsr.Id,TeamMemberRole = 'Account Executive (AE)');
           insert atm;
           Asset asst = new Asset(name= 'testasset', ContactId =custCont.Id, AccountId = custAcct.Id);
           insert asst;
           Reseller_Contact__c rc = new Reseller_Contact__c(resellerCustomerAccount__c = custAcct.Id, Reseller_Account__c = resAcct.Id, ResellerContact__c = resCont.Id, Status__c = 'Pending');
           Test.startTest();
           insert rc;//create reseller contact 
           //Inbox__c inb = [select Id from Inbox__c where Customer_Account__c =: custAcct.Id];
           rc.Status__c = 'Approved';
           update rc;
          Test.stopTest();
      }
    }


    static testMethod void testControllers2()
    {
        ID ProfileID = [ Select id from Profile where name = 'Support: System Administrator'].id;
        User usr = new User(email='test-user@example1.com',profileid = ProfileID, 
                             UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                             LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                             FirstName = 'Test',LastName = 'UserTest' );
           insert usr;
           System.runAs(usr) {
               UserRole roleId = [select id from UserRole where name = 'Executive Staff'];
               Profile p2 = [select Id from Profile where Name = 'System Administrator' limit 1];
               User accUsr = new User(email='testsp-user@fakeemail.com',profileid = p2.Id, userrole= roleId, 
                        UserName='testsp-user@fakeemail.com', alias='tuser1', CommunityNickName='stuser14', 
                        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                        LanguageLocaleKey='en_US',
                        FirstName = 'Tests', LastName = 'User');
               insert accUsr;
               ID accRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Support Provider'].Id;
               RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Channel' Limit 1];
               Account supAcct = new Account(Name = 'TestSuppProvider',showSupportTabCustomers__c = true, Type = 'Support Provider', Email__c = 'supemail@test.com', RecordTypeId = accRecordType);
               insert supAcct; //create support provider account
               Account resAcct = new Account(Name = 'TestResAcct', Type = 'Reseller',RecordTypeId = rt2.id,Support_Provider__c = supAcct.id);
               insert resAcct; //create reseller account
               Account custAcct = new Account(OwnerId=accUsr.Id,Name = 'TestCustAcct', Type = 'Customer', RecordTypeId = rt2.id,Support_Provider__c = supAcct.id);
               insert custAcct; //create customer account
               Contact resCont = new Contact(FirstName = 'Test_FN', LastName = 'Test_LN' , AccountId = resAcct.Id, Email = 'resemail@test.com');
               insert resCont; // create reseller contact
               Contact custCont = new Contact(FirstName = 'Test_c_FN', LastName = 'Test_c_LN', AccountId = custAcct.Id, Email = 'custemail@test.com');
               insert custCont; // create customer contact
               Profile p = [select Id from Profile where Name = 'Nimble Customer Portal Profile' limit 1];
               User custUsr = new User(email='test-user@fakeemail.com', profileid = p2.Id, 
                        UserName='tests-user@fakeemail.com', alias='tuser1', CommunityNickName='stuser17', 
                        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                        LanguageLocaleKey='en_US',
                        FirstName = 'Test', LastName = 'User');
               insert custUsr;  // create a portal user
               AccountTeamMember atm = new AccountTeamMember(AccountId = custAcct.Id, UserId = custUsr.Id,TeamMemberRole = 'Account Executive (AE)');
               insert atm;
               Asset asst = new Asset(name= 'testasset', ContactId =custCont.Id, AccountId = custAcct.Id);
               insert asst;
               Reseller_Contact__c rc = new Reseller_Contact__c(resellerCustomerAccount__c = custAcct.Id, Reseller_Account__c = resAcct.Id, ResellerContact__c = resCont.Id, Status__c = 'Pending');
              Test.startTest();
                  insert rc;//create reseller contact 
                 //Inbox__c inb = [select Id from Inbox__c where Customer_Account__c =: custAcct.Id];
                 rc.Status__c = 'Approved';
                 update rc;
              Test.stopTest();
         }
    }

    static testMethod void testControllers3()
    {
       UserRole roleId = [select id from UserRole where name = 'Executive Staff'];
       Profile p3 = [select Id from Profile where Name = 'System Administrator' limit 1];
       User accUsr = new User(email='testsp-user@fakeemail.com',profileid = p3.Id, userrole= roleId, 
                        UserName='testsp-user@fakeemail.com', alias='tuser1', CommunityNickName='stuser14', 
                        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                        LanguageLocaleKey='en_US',
                        FirstName = 'Tests', LastName = 'User');
       insert accUsr;
       Account resAcct2 = new Account(Name = 'TestResAcct', Type = 'Reseller');
       insert resAcct2; //create reseller account
       Account custAcct2 = new Account(OwnerId=accUsr.Id,Name = 'TestCustAcct', Type = 'Customer');
       insert custAcct2; //create customer account
       Contact resCont2 = new Contact(FirstName = 'Test_FN', LastName = 'Test_LN' , AccountId = resAcct2.Id, Email = 'resemail@test.com');
       insert resCont2; // create reseller contact
       Contact custCont2 = new Contact(FirstName = 'Test_c_FN', LastName = 'Test_c_LN', AccountId = custAcct2.Id, Email = 'custemail@test.com');
       insert custCont2; // create customer contact
       Profile p2 = [select Id from Profile where Name = 'Nimble Customer Portal Profile' limit 1];
       User custUsr2 = new User(email='test-user2@fakeemail.com', profileid = p3.Id, 
                        UserName='test-user2@fakeemail.com', alias='tuser1', CommunityNickName='tuser128', 
                        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                        LanguageLocaleKey='en_US',
                        FirstName = 'Test', LastName = 'User');
        insert custUsr2;  // create a portal user
        AccountTeamMember atm2 = new AccountTeamMember(AccountId = custAcct2.Id, UserId = custUsr2.Id,TeamMemberRole = 'Account Executive (AE)');
        insert atm2;
        Asset asst = new Asset(name= 'testasset', ContactId =custCont2.Id, AccountId = custAcct2.Id);
        insert asst;
        Reseller_Contact__c rc2 = new Reseller_Contact__c(resellerCustomerAccount__c = custAcct2.Id, Reseller_Account__c = resAcct2.Id, ResellerContact__c = resCont2.Id, Status__c = 'Pending');
        Test.startTest();
           insert rc2;//create reseller contact  
           //Inbox__c inb2 = [select Id from Inbox__c where Customer_Account__c =: custAcct2.Id];
           rc2.Status__c = 'Approved';
         Test.stopTest();
         update rc2;
      }

}