@isTest(SeeAllData = true)
public class CntrbnMdl_DataCreatorTestClass{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    public static testMethod void DataCreatortest(){
        ID ProfileID = [ Select id from Profile where name = 'System Administrator'].id;
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
        ID SProfileID = [ Select id from Profile where name = 'Support: System Administrator'].id;
        User usr = new User(email='contest-user@example1.com',profileid = SProfileID, 
                      UserName='test-user25@email.com',alias='tuser25',CommunityNickName='tuser25',TimeZoneSidKey='America/New_York', 
                      LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                      FirstName = 'Test25',LastName = 'UserTest25' );
        insert usr;
        System.runAs(usr) {
            RecordType suprectype = [select id,Name from RecordType where SobjectType='Account' and Name='Support Provider' Limit 1];
            RecordType chrectype = [select id,Name from RecordType where SobjectType='Account' and Name='Channel' Limit 1];
            Account serviceAccount = new Account(Name = 'conmodeltest',Type = 'Support Provider',RecordTypeId = suprectype.id);
            insert serviceAccount;
            Account account = new Account(Name = 'conmodeltest2',Type = 'Customer',RecordTypeId = chrectype.id,Support_Provider__c = serviceAccount.id);
            insert account;
            Case caseRec = new Case(Status = 'new',AccountId = account.Id);
            insert caseRec;
        }    
        CntrbnMdl_ShoreTelCallLog__c shoretel = new CntrbnMdl_ShoreTelCallLog__c(User__c = u.id,Month__c = system.today(),Avg_Calls__c = 10, Avg_Call_Hold__c=10, Avg_Talk_Time__c=10);
        insert shoretel;
        CntrbnMdl_Project__c prj = new CntrbnMdl_Project__c(User__c = u.id,Month__c = system.today(),Project_Hours__c=10);
        insert prj;
        CntrbnMdl_PTO__c pto = new CntrbnMdl_PTO__c(User__c = u.id,Month__c = system.today(),Number_of_days_off__c=10);
        insert pto;
        CntrbnMdl_Training__c trn = new CntrbnMdl_Training__c(User__c = u.id,Month__c = system.today(),Development_Hours__c=10,Lead_Hours__c=10);
        insert trn;
        CntrbnMdl_CaseBacklog__c cb = new CntrbnMdl_CaseBacklog__c(User__c = u.id,Month__c = system.today(),Cumulative_Backlog__c=100,Batch_Count__c=10);
        insert cb;
        CntrbnMdl_Jive__c jv = new CntrbnMdl_Jive__c(User__c = u.id,Month__c = system.today(),ActiveCount__c=5,ContributingCount__c=6,ParticipatingCount__c=7);
        insert jv;
        CntrbnMdl_ContributionData__c con = new CntrbnMdl_ContributionData__c(TSE__c = tse.id,Call_Hold__c=10,Calls__c=10,Talk_Time__c=10,Case_Modifier__c=10,Case_Backlog__c=10,Cases__c=10,Difficulty__c=10,
                                                 Escalated__c=10,KBs_Reviewed__c=10,KBs_Written__c=10,Peer_Cases__c=10,Projects__c=10,Training_Dev__c=10,Training_Lead__c=10,Start_Date__c=Date.parse('5/1/2014'),end_Date__c=Date.parse('5/31/2014') );
        insert con;
        system.debug('+++con+++'+con);
        CntrbnMdl_ContributionData__c con2 = new CntrbnMdl_ContributionData__c(TSE__c = tse2.id,Call_Hold__c=10,Calls__c=10,Talk_Time__c=10,Case_Modifier__c=10,Case_Backlog__c=10,Cases__c=10,Difficulty__c=10,
                                                 Escalated__c=10,KBs_Reviewed__c=10,KBs_Written__c=10,Peer_Cases__c=10,Projects__c=10,Training_Dev__c=10,Training_Lead__c=10,Start_Date__c=Date.parse('5/1/2014'),end_Date__c=Date.parse('5/31/2014') );
        insert con2;
        CntrbnMdl_ContributionData__c con3 = new CntrbnMdl_ContributionData__c(TSE__c = tse2.id,Call_Hold__c=10,Calls__c=10,Talk_Time__c=10,Case_Modifier__c=10,Case_Backlog__c=10,Cases__c=10,Difficulty__c=10,
                                                 Escalated__c=10,KBs_Reviewed__c=10,KBs_Written__c=10,Peer_Cases__c=10,Projects__c=10,Training_Dev__c=10,Training_Lead__c=10,Start_Date__c=system.today().toStartOfMonth(),end_Date__c=system.today()-1 );
        insert con3;
        Test.startTest();
          CntrbnMdl_CntrbnDataCreator  CDC = new CntrbnMdl_CntrbnDataCreator ();
          //Database.executeBatch(CDC);
         // String jobId = System.schedule('CntrbnMdl_CntrbnDataCreatorSchedular',CRON_EXP,new CntrbnMdl_CntrbnDataCreatorSchedular());
        Test.stopTest();
       
    }
}