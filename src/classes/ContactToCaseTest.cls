@isTest
Public class ContactToCaseTest
{// NOTE: Divided this test class up into separate test methods because
 //       everything in one method was overriding SOQL governor limits.

    static testMethod void test_01()
    {
         ID ProfileID = [ Select id from Profile where name = 'Support: System Administrator'].id;
         User usr = new User(email='test-user@example1.com',profileid = ProfileID, 
                      UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                      LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                      FirstName = 'Test',LastName = 'UserTest' );
         insert usr;
         System.runAs(usr) {
             RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Support Provider' Limit 1];
             RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Channel' Limit 1];
             Account serviceAccount = new Account(Name = 'Service',Type = 'Support Provider',RecordTypeId = rt.id);
             insert serviceAccount;
             Contact serviceContact = new Contact(LastName = 'Test',Support_Provider__c = true,AccountId = serviceAccount.Id);
             insert serviceContact;
             Account account = new Account(Name = 'Test',Type = 'Customer',RecordTypeId = rt2.id,Support_Provider__c = serviceAccount.id);
             insert account;
             Contact contact = new Contact(LastName = 'Test2',AccountId = account.Id);
             insert contact;

             Case caseRec = new Case(Status = 'new',AccountId = account.Id);
             insert caseRec;
             ContactToCase.updateCase(caseRec.Id);
         }
    } 

    static testMethod void test_02()
    {
         ID ProfileID = [ Select id from Profile where name = 'Support: System Administrator'].id;
         User usr = new User(email='test-user@example1.com',profileid = ProfileID, 
                      UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                      LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                      FirstName = 'Test',LastName = 'UserTest' );
         insert usr;
         System.runAs(usr) {
             RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Support Provider' Limit 1];
             RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Channel' Limit 1];
             Account serviceAccount = new Account(Name = 'Service',Type = 'Support Provider',RecordTypeId = rt.id);
             insert serviceAccount;
             Contact serviceContact = new Contact(LastName = 'Test',Support_Provider__c = true,AccountId = serviceAccount.Id);
             insert serviceContact;
             Account account = new Account(Name = 'Test',Type = 'Customer',RecordTypeId = rt2.id,Support_Provider__c = serviceAccount.id);
             insert account;
             Contact contact = new Contact(LastName = 'Test2',AccountId = account.Id);
             insert contact;

             Case caseRecd = new Case(Status = 'new');
             insert caseRecd;
             ContactToCase.updateCase(caseRecd.Id);
             Delete caseRecd;
             ContactToCase.updateCase(caseRecd.Id);
         }
    } 

    static testMethod void test_03()
    {
         ID ProfileID = [ Select id from Profile where name = 'Support: System Administrator'].id;
         User usr = new User(email='test-user@example1.com',profileid = ProfileID, 
                      UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                      LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                      FirstName = 'Test',LastName = 'UserTest' );
         insert usr;
         System.runAs(usr) {
             RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Support Provider' Limit 1];
             RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Channel' Limit 1];
             Account serviceAccount = new Account(Name = 'Service',Type = 'Support Provider',RecordTypeId = rt.id);
             insert serviceAccount;
             Contact serviceContact = new Contact(LastName = 'Test',Support_Provider__c = true,AccountId = serviceAccount.Id);
             insert serviceContact;
             Account account = new Account(Name = 'Test',Type = 'Customer',RecordTypeId = rt2.id,Support_Provider__c = serviceAccount.id);
             insert account;
             Contact contact = new Contact(LastName = 'Test2',AccountId = account.Id);
             insert contact;

             Account acc = new Account(Name = 'Test', Type = 'Customer',RecordTypeId = rt2.id,Support_Provider__c = serviceAccount.id );
             insert acc;
             Case caseRcd = new Case(Status = 'new',AccountId = acc.Id);
             insert caseRcd;
             ContactToCase.updateCase(caseRcd.Id);
         }
    } 
}