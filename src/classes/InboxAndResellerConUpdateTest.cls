@isTest(seeAllData = true)
public class InboxAndResellerConUpdateTest{
   public static testMethod void main(){
       ID ProfileID = [ Select id from Profile where name = 'Support: System Administrator'].id;
         User usr = new User(email='test-user@example1.com',profileid = ProfileID, 
                      UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                      LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                      FirstName = 'Test',LastName = 'UserTest' );
         insert usr;
         System.runAs(usr) {
            ID accRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Support Provider'].Id;
            RecordType rt2 = [select id,Name from RecordType where SobjectType='Account' and Name='Channel' Limit 1];
            Account supAcct = new Account(Name = 'TestSuppProvider', Type = 'Support Provider', Email__c = 'supemail@test.com', RecordTypeId = accRecordType);
            insert supAcct; //create support provider account
            Account supAcct2 = new Account(Name = 'TestSuppProvider', Type = 'Support Provider', Email__c = 'supemail@test.com', RecordTypeId = accRecordType);
            insert supAcct2; //create support provider account
            Account resAcct = new Account(Name = 'TestResAcct', Type = 'Reseller',RecordTypeId = rt2.id,Support_Provider__c = supAcct.id);
            insert resAcct; //create reseller account
            Inbox__c inbx = new Inbox__c(Reseller_Account__c = resAcct.Id);
            insert inbx;
            Reseller_Contact__c rc = new Reseller_Contact__c(Reseller_Account__c = resAcct.Id);
            insert rc; //create reseller contact 
            resAcct.Support_Provider__c = supAcct2.id;
            update  resAcct;
        }    
   }
}