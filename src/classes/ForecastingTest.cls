@isTest
private class ForecastingTest 
{
    @isTest
    static void testForecastingDataModel()
    {
        User currentUser = [SELECT Id, Name, UserRoleId, UserRole.Name, ForecastEnabled__c, ViewForecastAs__c, ForecastLevel__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        ForecastingDataModel.UserInfo usr = new ForecastingDataModel.UserInfo(currentUser);
        ForecastingDataModel.UserInfo usr2 = usr.ViewForecastAs;
        
        ForecastingDataModel.FiscalQuarterInfo qtr = new ForecastingDataModel.FiscalQuarterInfo();
        qtr = new ForecastingDataModel.FiscalQuarterInfo(Date.Today());
        qtr = new ForecastingDataModel.FiscalQuarterInfo('2015Q1');
        System.assertEquals('2015Q1', qtr.FormattedString);
        System.assertEquals('2015Q2', qtr.Next.FormattedString);
        System.assertEquals('2014Q4', qtr.Previous.FormattedString);

        ForecastingDataModel.FiscalYearInfo y = new ForecastingDataModel.FiscalYearInfo(2016);
        y.StartDate = Date.newInstance(2016, 1, 1);
        y.EndDate = Date.newInstance(2016, 12, 31);
        System.assertEquals(2017, y.Next.year);
        System.assertEquals(2015, y.Previous.year);
        
        ForecastingDataModel.WeekInfo week = new ForecastingDataModel.WeekInfo();
        ForecastingDataModel.WeekInfo week2 = new ForecastingDataModel.WeekInfo(Date.today(), Date.today().addDays(1));
        Date d = Date.newInstance(2015, 1, 1);
        week = new ForecastingDataModel.WeekInfo(d);
        String w = week.FormattedString;
        w = week.FormattedShortString;
    }
    
    @isTest
    static void  testForecastingController()
    {
        User u = new User(Id=UserInfo.getUserId(), ForecastEnabled__c=true);
        update u;
        
        PageReference pageRef = new PageReference('/apex/forecasting');
        Test.setCurrentPage(pageRef);
        ForecastingController controller = new ForecastingController();
        controller.setupForecast();
        
        String userId = UserInfo.getUserId();
        pageRef = new PageReference('/apex/forecasting?quarter=2015Q1&path=/'+userId);
        Test.setCurrentPage(pageRef);
        controller = new ForecastingController();

        String path = controller.UserPath;
        System.assertEquals('2015Q1', controller.CurrentFiscalQuarter.FormattedString);
        System.assertNotEquals(null, controller.CurrentViewingUser);
        System.assertNotEquals(null, ForecastingController.GetDirectSubordinateUsers(UserInfo.getUserId()));
        System.assertNotEquals(null, ForecastingController.GetAllSubordinateUsers(UserInfo.getUserId()));
    }
    
    @isTest
    static void testForecastingService()
    {
        Id userId = UserInfo.getUserId();

        ForecastingService.GetDirectSubordinateUsers(userId);
        ForecastingService.GetAllSubordinateUsers(userId);
        ForecastingService.GetDirectSubordinateUserIds(userId);
        ForecastingService.GetAllSubordinateUserIds(userId);
        ForecastingService.GetUser(userId);
        ForecastingService.GetStartOfCurrentFiscalYear();
    }
    
    @isTest
    static void testForecastingStatsService()
    {
        Account acc = new Account(name='acme');
        insert acc;
        Opportunity opp = new Opportunity(Name='acme', AccountId=acc.Id, StageName='1-Prequalified', CloseDate=Date.today(), Sales_Forecast_Category__c='Upside');
        insert opp;
        
        ForecastingDataModel.WeekInfo weekInfo = new ForecastingDataModel.WeekInfo();
        ForecastingDataModel.FiscalQuarterInfo qtrInfo = new ForecastingDataModel.FiscalQuarterInfo();
        Id userId = UserInfo.getUserId();
        String qtr = qtrInfo.FormattedString;
        String week = weekInfo.FormattedString;
        
        CustomForecast__c forecast = new CustomForecast__c(YYWW__c=week, FYFQ__c=qtr, User__c=userId, QuarterCommit__c=1000);
        insert forecast;
        
        ForecastingStatsService.GetForecastSummary(userId, qtr, true);

        ForecastingStatsService.ForecastingOppListRequest req = new ForecastingStatsService.ForecastingOppListRequest();
        req.UserId = userId;
        req.FiscalQtr = qtr;
        req.Stage = 'All Open';
        req.Probability = '> 10';
        ForecastingStatsService.GetOpportunityListing(req);

        ForecastingStatsService.ForecastEntry entry = new ForecastingStatsService.ForecastEntry();
        entry.UserId = userId;
        entry.QtrCommit = 200;
        entry.QtrUpside = 250;
        entry.QtrGut = 300;
        ForecastingStatsService.SaveForecast(userId, entry);
    }
    
    @isTest
    static void testForecastingException()
    {
        ForecastingException ex = new ForecastingException();
    }
    
    @isTest
    static void testBatchJob()
    {
      List<user> users = [select Id from User where ForecastEnabled__c=true and IsActive=true];
      if(users.size() > 0)
      {
        CustomForecast__c f = new CustomForecast__c(User__c=users[0].Id, Locked__c=false, Month1Commit__c=100);
        insert f;
        Test.startTest();
        ForecastSubmissionBatch job = new ForecastSubmissionBatch(null, '2016Q1', '201611');
        Database.executeBatch(job);
        Test.stopTest();
        
        f = [select Id, Locked__c, SubmittedOn__c from CustomForecast__c where Id=:f.Id limit 1];
        System.assertEquals(true, f.Locked__c);
        List<CustomForecast__c> newFc = [select Id, Month1Commit__c, User__c, Locked__c from CustomForecast__c where Locked__c=false];
        System.assertEquals(1, newFc.size());
        System.assertEquals(100, newFc[0].Month1Commit__c);
        System.assertEquals(users[0].Id, newFc[0].User__c);
      }
    }
    
    @isTest
    static void testSchedule()
    {
      ForecastSubmissionSchedule schedule = new ForecastSubmissionSchedule(null);
      schedule.execute(null);
    }
}