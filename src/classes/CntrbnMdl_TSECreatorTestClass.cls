@isTest (SeeAllData = true)
public class CntrbnMdl_TSECreatorTestClass{
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    public static testMethod void TSECreator(){
        ID ProfileID = [ Select id from Profile where name = 'System Administrator'].id;
        Account acc = new Account (
            Name = 'TestAccount1');
        //insert acc;
        
        List<Contact> ContactList = new List<Contact>();
        Contact con = new Contact( 
            AccountID = acc.id, 
            FirstName = 'Test', 
            LastName = 'UserTest', 
            email = 'test-user@example1.com' );
        //insert con;
 
        User u = new User(email='test-tseuser@example1.com',profileid = ProfileID,isActive = true, 
                             UserName='test-tseuser@email.com',alias='tseuser1',CommunityNickName='tseuser',TimeZoneSidKey='America/New_York', 
                             LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                             FirstName = 'rseTest',LastName = 'UserTest' );
        insert u;
        Case caseRecnew = new Case(Status = 'new',AccountId = acc.Id,ownerId = u.id);
        insert caseRecnew;
        CntrbnMdl_ShoreTelCallLog__c shoretel = new CntrbnMdl_ShoreTelCallLog__c(User__c = u.id,Month__c = system.today(),Avg_Calls__c = 10, Avg_Call_Hold__c=10, Avg_Talk_Time__c=10);
        insert shoretel;
        CntrbnMdl_Project__c prj = new CntrbnMdl_Project__c(User__c = u.id,Month__c = system.today(),Project_Hours__c=10);
        insert prj;
        CntrbnMdl_PTO__c pto = new CntrbnMdl_PTO__c(User__c = u.id,Month__c = system.today(),Number_of_days_off__c=10);
        insert pto;
        CntrbnMdl_Training__c trn = new CntrbnMdl_Training__c(User__c = u.id,Month__c = system.today(),Development_Hours__c=10,Lead_Hours__c=10);
        insert trn;
        CntrbnMdl_Jive__c jv = new CntrbnMdl_Jive__c(User__c = u.id,Month__c = system.today(),ActiveCount__c=5,ContributingCount__c=6,ParticipatingCount__c=7);
        insert jv;
       Test.startTest();
          CntrbnMdl_TSECreator c = new CntrbnMdl_TSECreator();
          //Database.executeBatch(c);
          String jobId = System.schedule('CntrbnMdl_TSECreatorSchedular',CRON_EXP,new CntrbnMdl_TSECreatorSchedular());
       Test.stopTest();
    }
    
}