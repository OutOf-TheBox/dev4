@isTest
   Public class CaseCommentHandlerTest{
       static testMethod void test(){
           ID ProfileID = [ Select id from Profile where name = 'Support: System Administrator'].id;
          
          
           User usr = new User(email='test-user@example1.com',profileid = ProfileID, 
                             UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                             LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                             FirstName = 'Test',LastName = 'UserTest' );
           insert usr;
           System.runAs(usr) {
              RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Support Provider' Limit 1];
              Account serviceAccount = new Account(Name = 'Service',Type = 'Support Provider',RecordTypeId = rt.id);
              insert serviceAccount;
              Contact serviceContact = new Contact(LastName = 'Test',Support_Provider__c = true,AccountId = serviceAccount.Id);
              insert serviceContact;
              Account account = new Account(Name = 'Test',Type = 'Support Provider',RecordTypeId = rt.id,Support_Provider__c = serviceAccount.id);
              insert account;
              Contact contact = new Contact(LastName = 'Test2',AccountId = account.Id);
              insert contact; 
              Case caseRec = new Case(Status = 'new',AccountId = account.Id);
              insert caseRec;   
              CaseComment cscm = new CaseComment(ParentId =caseRec.Id, CommentBody = 'TestBody' );
              insert cscm;
          }
       }
   }