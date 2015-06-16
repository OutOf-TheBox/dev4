@isTest(seeAlldata = true)
public class CntrbnMdl_ReportTestclass{
    public static testMethod void main(){
       //CntrbnMdl_DataCreatorHelper SC = new CntrbnMdl_DataCreatorHelper();
       //SC.SupportCalculation();
       Test.startTest();
          CntrbnMdl_CntrbnDataCreator  CDC = new CntrbnMdl_CntrbnDataCreator ();
          //Database.executeBatch(CDC);
       Test.stopTest();
    }
    public static testMethod void Report(){
        ID ProfileID = [ Select id from Profile where name = 'System Administrator'].id;
        system.debug('+++ProfileID +++'+ProfileID);
        User u = new User(email='test-user@example1.com',profileid = ProfileID, 
                             UserName='test-user@email.com',alias='tuser1',CommunityNickName='tuser',TimeZoneSidKey='America/New_York', 
                             LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                             FirstName = 'Test',LastName = 'UserTest' );
        insert u;
        system.debug('+++u+++'+u);
        User u2 = new User(email='test-user@example1.com',profileid = ProfileID, 
                             UserName='test-user2@email.com',alias='tuser12',CommunityNickName='tuser2',TimeZoneSidKey='America/New_York', 
                             LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', 
                             FirstName = 'Test2',LastName = 'UserTest2' );
        insert u2;
        system.debug('+++u2+++'+u2);
        CntrbnMdl_TSE__c tse = new CntrbnMdl_TSE__c(Employee_Name__c = u.id,team__c='HQ',organization__c='TSE',start_date__c = system.today());
        insert tse;
        CntrbnMdl_TSE__c tse2 = new CntrbnMdl_TSE__c(Employee_Name__c = u2.id,team__c='HQ',organization__c='TSE',start_date__c = system.today());
        insert tse2;
        system.debug('+++tse2+++'+tse2);
        CntrbnMdl_ContributionData__c con = new CntrbnMdl_ContributionData__c(TSE__c = tse.id,Call_Hold__c=10,Calls__c=10,Talk_Time__c=10,Case_Modifier__c=10,Case_Backlog__c=10,Cases__c=10,Difficulty__c=10,
                                                 Escalated__c=10,KBs_Reviewed__c=10,KBs_Written__c=10,Peer_Cases__c=10,Projects__c=10,Training_Dev__c=10,Training_Lead__c=10,Start_Date__c=Date.parse('5/1/2014'),end_Date__c=Date.parse('5/31/2014') );
        insert con;
        system.debug('+++con+++'+con);
        CntrbnMdl_ContributionData__c con2 = new CntrbnMdl_ContributionData__c(TSE__c = tse2.id,Call_Hold__c=10,Calls__c=10,Talk_Time__c=10,Case_Modifier__c=10,Case_Backlog__c=10,Cases__c=10,Difficulty__c=10,
                                                 Escalated__c=10,KBs_Reviewed__c=10,KBs_Written__c=10,Peer_Cases__c=10,Projects__c=10,Training_Dev__c=10,Training_Lead__c=10,Start_Date__c=Date.parse('5/1/2014'),end_Date__c=Date.parse('5/31/2014') );
        insert con2;
        system.debug('+++con2+++'+con2);
        CntrbnMdl_Sweetspot__c swt = new CntrbnMdl_Sweetspot__c(Minus_Margin__c = 100,Plus_Margin__c = 200);
        insert swt;
        Test.startTest();
          System.runas(u){
             CntrbnMdl_Report CR=new CntrbnMdl_Report();
             CR.fromdate = '05/01/2014';
             CR.todate = '05/31/2014';
             CR.SelectedTSE = u.id;
             CR.SelectedTeam = 'HQ';
             CR.SelectedOrg  = 'TSE';
             CR.updateTSEDetails();
             try{
             CR.Calculation();
             }catch(exception e){
                system.debug('++++error+++'+e.getmessage());
             }
             CR.getOrgChartData();
             CR.getChartData();
            // CntrbnMdl_Report.getOrgChartWidth();
             //CntrbnMdl_Report.getTeamChartWidth();
             CR.getItems();
             CR.getTeams();
             CR.getOrgs();
             CR.getTSEDetails();
             CR.getCallData();
             CR.getCaseCldMfdData();
             CR.getCaseCldMfdList();
             CR.getCaseData();
             CR.getCasePointsData();
             CR.getProjectData();
             CR.getProjectPointsData();
             CR.getEmptyData();
             CR.getTotalPointsData();
             CR.SelectedTSE = '--None--';
             CR.updateTSEDetails();
             CR.Calculation();
             CR.SelectedTSE = u.id;
             CR.SelectedTeam = '--None--';
             CR.Calculation();
             CR.SelectedTeam = 'HQ';
             CR.SelectedOrg  = '--None--';
             CR.Calculation();
             CR.SelectedOrg  = 'TSE';
             CR.fromdate = '05/02/2014';
             CR.dateValidation();
             CR.Calculation();
             CR.fromdate = '';
             CR.dateValidation();
             CR.Calculation();
             CR.fromdate = '05/01/2014';
             CR.todate = '05/25/2014';
             CR.dateValidation();
             CR.FilterValidation();
             CR.todate = '';
             CR.FilterValidation();
             CR.FilterValidation();
             CR.todate = '06/30/2014';
             CR.fromdate = '03/01/2014';
             CR.FilterValidation();
             CR.fromdate = '06/01/2030';
             CR.FilterValidation();
             CR.dateValidation();
             CR.fromdate = '06/01/2014';
             CR.todate = '04/31/2014';
             CR.FilterValidation();
          }
        Test.stopTest();
       
    }
}