@isTest(SeeAllData = true)
public class CntrbnMdl_CaseBacklogTestClass{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    public static testMethod void Casebacklog(){
       ID ProfileID = [ Select id from Profile where name = 'System Administrator'].id;
       system.debug('+++ProfileID +++'+ProfileID);
       User u = new User(email='test-user@example1.com',profileid = ProfileID, 
                             UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                             LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                             FirstName = 'Test',LastName = 'UserTest' );
       insert u;
       User u2 = new User(email='test-user@example1.com',profileid = ProfileID, 
                             UserName='test-user2@email.com',alias='tuser12',CommunityNickName='tuser2',TimeZoneSidKey='America/New_York', 
                             LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                             FirstName = 'Test2',LastName = 'UserTest2' );
       insert u2;
       CntrbnMdl_TSE__c tse = new CntrbnMdl_TSE__c(Employee_Name__c = u.id,team__c='HQ',organization__c='TSE');
       insert tse;
       CntrbnMdl_TSE__c tse2 = new CntrbnMdl_TSE__c(Employee_Name__c = u2.id,team__c='HQ',organization__c='TSE');
       insert tse2;
       Account acc = new Account (Name = 'TestAccount1');
       insert acc;
       Case caseRecclsd = new Case(Status = 'closed',AccountId = acc.Id,ownerId = u.id);
       insert caseRecclsd;
       Case caseRecopen = new Case(Status = 'open',AccountId = acc.Id,ownerId = u.id);
       insert caseRecopen;
       Case caseRecclsd2 = new Case(Status = 'closed',AccountId = acc.Id,ownerId = u2.id);
       insert caseRecclsd2;
       Case caseRecopen2 = new Case(Status = 'open',AccountId = acc.Id,ownerId = u2.id);
       insert caseRecopen2;
       CntrbnMdl_CaseBacklog__c csb = new CntrbnMdl_CaseBacklog__c(User__c = u.id,Month__c = system.today(),Cumulative_Backlog__c=100,Batch_Count__c=10);
       insert csb;
       Test.startTest();
          CntrbnMdl_CaseBacklogUpdator cb = new CntrbnMdl_CaseBacklogUpdator();
          //Database.executeBatch(cb);
          String jobId = System.schedule('CntrbnMdl_CaseBacklogUpdatorSchedular',CRON_EXP,new CntrbnMdl_CaseBacklogUpdatorSchedular());
       Test.stopTest();
    }
}