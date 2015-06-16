public with sharing class ForecastingStatsService
{

    public ForecastingStatsService(ForecastingController controller) { }

    @RemoteAction @ReadOnly
    public static ForecastSummary GetForecastSummary(String userId, String fiscalQuarter, Boolean includeWeekly)
    {
        User user;
        List<User> users = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :userId LIMIT 1];
        if(users.size() > 0)
        {
            ForecastSummary forecastSummary = new ForecastSummary();
            forecastSummary.UserId = users[0].Id;
            forecastSummary.UserName = users[0].Name;
            
            ForecastingDataModel.FiscalQuarterInfo quarter = new ForecastingDataModel.FiscalQuarterInfo(fiscalQuarter);
            
            List<Id> allUserIds = new List<Id>();
            allUserIds.add(userId);
            allUserIds.addAll(ForecastingService.getAllSubordinateUserIds(userId));
            
            if(includeWeekly)
            {
                loadWeeklyForecasts(forecastSummary, userId, allUserIds, quarter);
            }
            loadSummaryNumbers(forecastSummary, userId, allUserIds, quarter);
            return forecastSummary;
        }
        else
        {
            return null;
        }
    }

    private static void loadWeeklyForecasts(ForecastSummary forecastSummary, String userId, List<Id> teamUserId, ForecastingDataModel.FiscalQuarterInfo qtr)
    {
        if(forecastSummary != null) 
        {
            forecastSummary.WeeklyForecasts = new List<ForecastEntry>();
            for(CustomForecast__c forecast : [SELECT YYWW__c, User__c, User__r.Name, UpcomingWeekCommit__c, FollowingWeekCommit__c, Month1Commit__c, Month2Commit__c, Month3Commit__c, QuarterCommit__c, QuarterGut__c, QuarterUpside__c, Locked__c FROM CustomForecast__c WHERE User__c = :userId and FYFQ__c=:qtr.FormattedString ORDER BY CreatedDate LIMIT 13])
            {
                forecastSummary.WeeklyForecasts.add(new ForecastEntry(forecast));
            }
            completeWeeklyList(forecastSummary.WeeklyForecasts, qtr);
            
            for(Opportunity opp : [select Amount, IsWon, CloseDate from Opportunity where CloseDate <= :qtr.EndDate AND CloseDate >= :qtr.StartDate AND OwnerId IN :teamUserId])
            {
                for(Integer i = 0; i < qtr.Weeks.size(); i++)
                {
                    ForecastingDataModel.WeekInfo w = qtr.Weeks[i];
                    ForecastEntry forecast = forecastSummary.WeeklyForecasts[i];
                    if(opp.CloseDate.daysBetween(w.StartDate) <= 0 && opp.CloseDate.daysBetween(w.EndDate) >= 0)
                    {
                        if(opp.IsWon)
                        {
                            forecast.WeeklyActual = (forecast.WeeklyActual == null) ? 0 : forecast.WeeklyActual;
                            forecast.WeeklyActual += (opp.Amount == null) ? 0 : opp.Amount;
                        }
                        break;
                    }
                }
            }
            Decimal cumulativeBooking = 0;
            for(ForecastEntry forecast : forecastSummary.WeeklyForecasts)
            {
                forecast.QtrBooking = (forecast.WeeklyActual == null ? 0 : forecast.WeeklyActual) + cumulativeBooking;
                cumulativeBooking = forecast.QtrBooking;
                forecast.QtrBooking = (forecast.QtrBooking == 0) ? null : forecast.QtrBooking;
                
            }
        }
    }
    
    private static void loadSummaryNumbers(ForecastSummary forecastSummary, String userId, List<Id> teamUserId, ForecastingDataModel.FiscalQuarterInfo qtr) 
    {
        if(forecastSummary != null) 
        {
            List<AggregateResult> openAggregation = [SELECT SUM(Amount) a, SUM(ExpectedRevenue) e FROM Opportunity WHERE CloseDate <= :qtr.EndDate AND CloseDate >= :qtr.StartDate AND OwnerId IN :teamUserId AND IsClosed=false];
            forecastSummary.TotalPipe = openAggregation[0].get('a') == null ? 0 : (Decimal)openAggregation[0].get('a');
            forecastSummary.WeightedPipe = openAggregation[0].get('e') == null ? 0 : (Decimal)openAggregation[0].get('e');
            
            List<AggregateResult> wonAggregation = [SELECT SUM(Amount) a FROM Opportunity WHERE CloseDate <= :qtr.EndDate AND CloseDate >= :qtr.StartDate AND OwnerId IN :teamUserId AND IsWon = true];
            forecastSummary.QTDBooking = wonAggregation[0].get('a') == null ? 0 : (Decimal)wonAggregation[0].get('a'); 
            
            List<AggregateResult> sfcAggregation = [SELECT SUM(Amount) a, Sales_Forecast_Category__c c FROM Opportunity WHERE CloseDate <= :qtr.EndDate AND CloseDate >= :qtr.StartDate AND OwnerId IN :teamUserId AND Sales_Forecast_Category__c != 'Closed' group by Sales_Forecast_Category__c];
            for(AggregateResult aggregate : sfcAggregation)
            {
                String category = (String)aggregate.get('c');
                Decimal amount = (Decimal)aggregate.get('a');
                if(category == 'Won')
                {
                    forecastSummary.SfcWon = amount;
                }
                else if(category == 'Expected')
                {
                    forecastSummary.SfcExpected = amount;
                }
                else if(category == 'Upside')
                {
                    forecastSummary.SfcUpside = amount;
                }
                else if(category == 'Pipeline')
                {
                    forecastSummary.SfcPipeline = amount;
                }
            }
            
            List<AggregateResult> monthAggregate = [select SUM(Amount) a, CALENDAR_MONTH(CloseDate) d from Opportunity where IsWon=true and CloseDate <= :qtr.EndDate AND CloseDate >= :qtr.StartDate AND OwnerId IN :teamUserId group by CALENDAR_MONTH(CloseDate)];
            for(AggregateResult aggregate : monthAggregate)
            {
                Integer month = (Integer)aggregate.get('d');
                Decimal amount = (Decimal)aggregate.get('a');
                if(month == qtr.StartDate.month())
                {
                    forecastSummary.Month1Actual = amount;
                }
                else if(month == qtr.StartDate.addMonths(1).month())
                {
                    forecastSummary.Month2Actual = amount;
                }
                else if(month == qtr.StartDate.addMonths(2).month())
                {
                    forecastSummary.Month3Actual = amount;
                }
            }
            
            List<CustomForecast__c> latestForecasts = [SELECT YYWW__c, User__c, User__r.Name, UpcomingWeekCommit__c, FollowingWeekCommit__c, Month1Commit__c, Month2Commit__c, Month3Commit__c, QuarterCommit__c, QuarterGut__c, QuarterUpside__c FROM CustomForecast__c WHERE User__c = :userId and FYFQ__c=:qtr.FormattedString ORDER BY CreatedDate desc LIMIT 2];
            if(latestForecasts.size() >= 1)
            {
                forecastSummary.QtrCommit = latestForecasts[0].QuarterCommit__c;
                forecastSummary.QtrGut = latestForecasts[0].QuarterGut__c;
                forecastSummary.QtrUpside = latestForecasts[0].QuarterUpside__c;
                forecastSummary.Month1Commit = latestForecasts[0].Month1Commit__c;
                forecastSummary.Month2Commit = latestForecasts[0].Month2Commit__c;
                forecastSummary.Month3Commit = latestForecasts[0].Month3Commit__c;
                forecastSummary.UpcomingWeekCommit = latestForecasts[0].UpcomingWeekCommit__c;
                forecastSummary.FollowingWeekCommit = latestForecasts[0].FollowingWeekCommit__c;
                Date tempD = Date.today().toStartOfMonth();
                if(tempD.isSameDay(qtr.StartDate))
                {
                    forecastSummary.CurrentMonthCommit = forecastSummary.Month1Commit;
                    forecastSummary.CurrentMonthActual = forecastSummary.Month1Actual;
                }
                else if(tempD.isSameDay(qtr.StartDate.addMonths(1)))
                {
                    forecastSummary.CurrentMonthCommit = forecastSummary.Month2Commit;
                    forecastSummary.CurrentMonthActual = forecastSummary.Month2Actual;
                }
                else if(tempD.isSameDay(qtr.StartDate.addMonths(2)))
                {
                    forecastSummary.CurrentMonthCommit = forecastSummary.Month3Commit;
                    forecastSummary.CurrentMonthActual = forecastSummary.Month3Actual;
                }
                else if(qtr.StartDate.daysBetween(tempD) > 0)
                {
                    //viewing history
                    forecastSummary.CurrentMonthCommit = forecastSummary.Month3Commit;
                    forecastSummary.CurrentMonthActual = forecastSummary.Month3Actual;
                }
                else
                {
                    //viewing future qtr, always blank.
                }
            }
            if(latestForecasts.size() == 2)
            {
                forecastSummary.LastWeekCommit = latestForecasts[1].UpcomingWeekCommit__c;
            }
            ForecastingDataModel.WeekInfo lastWeek = null;
            if(qtr.EndDate.daysBetween(Date.today()) > 0)
            {
                //viewing history
                lastWeek = qtr.Weeks[12];
            }
            else if(qtr.StartDate.daysBetween(Date.today()) >= 0)
            {
                //viewing current
                for(ForecastingDataModel.WeekInfo w : qtr.Weeks)
                {
                    if(w.EndDate.daysBetween(Date.today()) <= 0)
                    {
                        break;
                    }
                    lastWeek = w;
                }
            }
            if(lastWeek != null)
            {
                List<AggregateResult> lastWeekAggregate = [select sum(Amount) a from Opportunity where IsWon=true and CloseDate>=:lastWeek.StartDate and CloseDate<=:lastWeek.EndDate and OwnerId IN :teamUserId];
                forecastSummary.LastWeekActual = (Decimal)lastWeekAggregate[0].get('a');
            }
            if(qtr.StartDate.addMonths(3).daysBetween(Date.today()) > 0)
            {
                forecastSummary.Month1 = forecastSummary.Month1Actual;
                forecastSummary.Month2 = forecastSummary.Month2Actual;
                forecastSummary.Month3 = forecastSummary.Month3Actual;
            }
            else if(qtr.StartDate.addMonths(2).daysBetween(Date.today()) > 0)
            {
                forecastSummary.Month1 = forecastSummary.Month1Actual;
                forecastSummary.Month2 = forecastSummary.Month2Actual;
                forecastSummary.Month3 = forecastSummary.Month3Commit;
            }
            else if(qtr.StartDate.addMonths(1).daysBetween(Date.today()) > 0)
            {
                forecastSummary.Month1 = forecastSummary.Month1Actual;
                forecastSummary.Month2 = forecastSummary.Month2Commit;
                forecastSummary.Month3 = forecastSummary.Month3Commit;
            }
            else if(qtr.StartDate.daysBetween(Date.today()) > 0)
            {
                forecastSummary.Month1 = forecastSummary.Month1Commit;
                forecastSummary.Month2 = forecastSummary.Month2Commit;
                forecastSummary.Month3 = forecastSummary.Month3Commit;
            }
        }
    }
    
    private static void completeWeeklyList(List<ForecastEntry> weeklyList, ForecastingDataModel.FiscalQuarterInfo qtr)
    {
        for(ForecastingDataModel.WeekInfo week : qtr.Weeks)
        {
            Boolean found = false;
            for(ForecastEntry entry : weeklyList)
            {
                if(entry.YYWW == week.FormattedString)
                {
                    found = true;
                }
            }
            if(!found)
            {
                ForecastEntry newentry = new ForecastEntry();
                newentry.YYWW = week.FormattedString;
                weeklyList.add(newentry);
            }
        }
        weeklyList.sort();
    }

    @RemoteAction @ReadOnly
    public static ForecastingOppListResponse GetOpportunityListing(ForecastingOppListRequest request)
    {   
        List<Id> allUserIds = new List<Id>();
        allUserIds.add(request.userId);
        allUserIds.addAll(ForecastingService.getAllSubordinateUserIds(request.userId));

        ForecastingDataModel.FiscalQuarterInfo qtr = new ForecastingDataModel.FiscalQuarterInfo(request.FiscalQtr);
        Date startDate = qtr.StartDate;
        Date endDate = qtr.EndDate;
        
        Integer pageSize = 25;

        String closeDate = '';
        if(request.CloseDate == 'This Quarter')
        {
            closeDate = 'AND CloseDate <= :endDate AND CloseDate >= :startDate ';
        }
        else if(request.CloseDate == 'Next Quarter')
        {
            ForecastingDataModel.FiscalQuarterInfo nextQtr = qtr.Next;
            startDate = nextQtr.StartDate;
            endDate = nextQtr.EndDate;
            closeDate = 'AND CloseDate <= :endDate AND CloseDate >= :startDate ';
        }
        else if(request.CloseDate == 'This Fiscal Year')
        {
            startDate = qtr.FiscalYear.StartDate;
            endDate = qtr.FiscalYear.EndDate;
            closeDate = 'AND CloseDate <= :endDate AND CloseDate >= :startDate ';
        }
        else if(request.CloseDate == 'Next Fiscal Year')
        {
            startDate = qtr.FiscalYear.Next.StartDate;
            endDate = qtr.FiscalYear.Next.EndDate;
            closeDate = 'AND CloseDate <= :endDate AND CloseDate >= :startDate ';
        }
        
        String status = '';
        if(request.status == 'All Open')
        {
            status = 'AND IsClosed=false ';
        }
        else if(request.status == 'All Won')
        {
            status = 'AND IsWon=true ';
        }
        else if(request.status == 'All Open & Won')
        {
            status = 'AND (IsClosed=false OR IsWon=true) ';
        }
        else if(request.status == 'Closed Lost')
        {
            status = 'AND StageName=\'8- Closed Lost\' ';
        }
        else if(request.status == 'Closed No Decision')
        {
            status = 'AND StageName=\'8- Closed No Decision\' ';
        }
        
        String stage = '';
        if(request.Stage == 'Initial Stage Opps')
        {
            stage = 'AND (StageName like \'2%\' OR StageName like \'3%\') ';
        }
        else if(request.Stage == 'Adv Stage Opps') 
        {
            stage = 'AND (StageName like \'4%\' OR StageName like \'5%\' OR StageName like \'6%\' OR StageName like \'7%\') ';
        }
        
        String salesRegion = '';
        if(request.SalesRegion != 'All')
        {
            salesRegion = 'AND Sales_Region__c=\'' + request.SalesRegion + '\' ';
        }
        
        String forecastCategory = '';
        if(request.ForecastCategory != 'All')
        {
            forecastCategory = 'AND Sales_Forecast_Category__c=\''+request.ForecastCategory+'\' ';
        }
        
        String probability = '';
        if(String.isNotBlank(request.Probability))
        {
            probability = 'AND Probability ' + request.Probability + ' ';
        }

        String sortBy = 'ORDER BY ' + (String.isBlank(request.SortField) ? 'CloseDate' : request.SortField) + ' ';
        String order = (request.IsAscendingOrder == true) ? 'ASC' : 'DESC NULLS LAST';

        String query = 'SELECT Name, StageName, Type, OwnerId, Owner.Name, Probability, ForecastCategory, ForecastCategoryName, ExpectedRevenue, CloseDate, Amount, NextStep, IsClosed, Next_Step_Field_Last_Updated_On__c FROM Opportunity ';
        query += 'WHERE OwnerId IN :allUserIds ';
        query += closeDate;
        query += stage;
        query += status;
        query += salesRegion;
        query += forecastCategory;
        query += probability;
        query += sortBy;
        query += order;

        System.debug(query);
        ApexPages.StandardSetcontroller oppController = new ApexPages.StandardSetcontroller(Database.getQueryLocator(query));
        oppController.setPageSize(pageSize);
        
        if(request.PageIndex != null && request.PageIndex > 0)
        {
            oppController.setPageNumber(request.PageIndex);
        }
        ForecastingOppListResponse response = new ForecastingOppListResponse();
        response.HasNext = oppController.getHasNext();
        response.HasPrevious = oppController.getHasPrevious();
        response.PageIndex = oppController.getPageNumber();
        response.RecordCount = oppController.getResultSize();
        response.PageCount = response.RecordCount / pageSize + 1;
        //response.PageCount = Math.ceil(response.RecordCount * 1.0 / pageSize).intValue();

        for(sObject opp : oppController.getRecords())
        {
            response.Opportunities.add(new OpportunityEntry((Opportunity)opp));
        }
        return response;
    }

    @RemoteAction
    public static void SaveForecast(Id userId, ForecastEntry entryValue)
    {
        CustomForecast__c target = null;
        List<CustomForecast__c> forecasts = [SELECT User__c, FYFQ__c, YYWW__c, LastEdited__c, SubmittedOn__c, Locked__c, UpcomingWeekCommit__c, FollowingWeekCommit__c, Month1Commit__c, Month2Commit__c, Month3Commit__c, QuarterCommit__c, QuarterGut__c, QuarterUpside__c FROM CustomForecast__c WHERE User__c =:userId AND Locked__c=false ORDER BY CreatedDate DESC LIMIT 1];
        if(forecasts.size() == 1)
        {
            target = forecasts[0];
        }
        else
        {
            throw new ForecastingException('Error occured while saving the forecast. Please contact your system admin.');
        }
        target.UpcomingWeekCommit__c = entryValue.UpcomingWeekCommit;
        target.FollowingWeekCommit__c = entryValue.FollowingWeekCommit;
        target.Month1Commit__c = entryValue.Month1Commit;
        target.Month2Commit__c = entryValue.Month2Commit;
        target.Month3Commit__c = entryValue.Month3Commit;
        target.QuarterCommit__c = entryValue.QtrCommit;
        target.QuarterGut__c = entryValue.QtrGut;
        target.QuarterUpside__c = entryValue.QtrUpside;
        target.LastEdited__c = DateTime.now();
        
        try
        {
            upsert target;
        }
        catch (Exception e) 
        {
            throw new ForecastingException('Failed to save forecast. Error message is: ' + e.getMessage());
        }
    }

    public class ForecastSummary
    {
        public String UserId { get; set; }
        public String UserName { get; set; }
        public List<ForecastEntry> WeeklyForecasts { get; set; }

        public Decimal QtrCommit { get; set; }
        public Decimal QtrGut { get; set; }
        public Decimal QtrUpside { get; set; }
        public Decimal TotalPipe { get; set; }
        public Decimal WeightedPipe { get; set; }
        public Decimal QTDBooking { get; set; }
        public Decimal Month1 { get; set; }
        public Decimal Month2 { get; set; }
        public Decimal Month3 { get; set; }
        public Decimal Month1Actual { get; set; }
        public Decimal Month2Actual { get; set; }
        public Decimal Month3Actual { get; set; }
        public Decimal Month1Commit { get; set; }
        public Decimal Month2Commit { get; set; }
        public Decimal Month3Commit { get; set; }
        public Decimal CurrentMonthCommit { get; set; }
        public Decimal CurrentMonthActual { get; set; }
        public Decimal UpcomingWeekCommit { get; set; }
        public Decimal FollowingWeekCommit { get; set; }
        public Decimal LastWeekCommit { get; set; }
        public Decimal LastWeekActual { get; set; }
        public Decimal SfcWon { get; set; }
        public Decimal SfcExpected { get; set; }
        public Decimal SfcUpside { get; set; }
        public Decimal SfcPipeline { get; set; }
        
        public ForecastSummary()
        {
            WeeklyForecasts = new List<ForecastEntry>();
        }
    }

    public class ForecastEntry implements Comparable
    {
        public String UserId { get; set; }
        public String UserName { get; set; }
        public String YYWW { get; set; }
        public Decimal UpcomingWeekCommit { get; set; }
        public Decimal FollowingWeekCommit { get; set; }
        public Decimal Month1Commit { get; set; }
        public Decimal Month2Commit { get; set; }
        public Decimal Month3Commit { get; set; }
        public Decimal QtrBooking { get; set; }
        public Decimal QtrCommit { get; set; }
        public Decimal QtrGut { get; set; }
        public Decimal QtrUpside { get; set; }
        public Decimal Pipeline { get; set; }    
        public Decimal WeeklyActual { get; set; }
        public Boolean Editable { get; set; }
        
        public ForecastEntry()
        {

        }

        public ForecastEntry(CustomForecast__c forecast)
        {
            UserId = forecast.User__c;
            UserName = forecast.User__r.Name;
            YYWW = forecast.YYWW__c;
            UpcomingWeekCommit = forecast.UpcomingWeekCommit__c;
            FollowingWeekCommit = forecast.FollowingWeekCommit__c;
            Month1Commit = forecast.Month1Commit__c;
            Month2Commit = forecast.Month2Commit__c;
            Month3Commit = forecast.Month3Commit__c;
            QtrCommit = forecast.QuarterCommit__c;
            QtrGut = forecast.QuarterGut__c;
            QtrUpside= forecast.QuarterUpside__c;
            Editable = !forecast.Locked__c;
        }
        
        public Integer compareTo(Object compareTo) 
        {
            if(compareTo == null || !(compareTo instanceOf ForecastEntry))
            {
                return 1;
            }
            if(YYWW > ((ForecastEntry)compareTo).YYWW)
            {
                return 1;
            }
            else if(YYWW == ((ForecastEntry)compareTo).YYWW)
            {
                return 0;
            }
            else
            {
                return -1;
            }
        }
    }
    
    public class ForecastingOppListRequest
    {
        public String UserId { get; set; }
        public String FiscalQtr { get; set; }
        public String Probability { get; set; }
        public String CloseDate { get; set; }
        public String Status { get; set; }
        public String Stage { get; set; }
        public String SalesRegion { get; set; }
        public String ForecastCategory { get; set; }
        public String SortField { get; set; }
        public Boolean IsAscendingOrder { get; set; }
        public Integer PageIndex { get; set; }
    }
    
    public class ForecastingOppListResponse
    {
        public ForecastingOppListResponse()
        {
            Opportunities = new List<OpportunityEntry>();
        }
        
        public List<OpportunityEntry> Opportunities { get; set; }
        public Boolean HasNext { get; set; }
        public Boolean HasPrevious { get; set; }
        public Integer PageIndex { get; set; }
        public Integer PageCount { get; set; }
        public Integer RecordCount { get; set; }
    }
    
    public class OpportunityEntry
    {
        public OpportunityEntry(Opportunity opp)
        {
            this.OppId = opp.Id;
            this.OppName = opp.Name;
            this.Amount = opp.Amount;
            this.Stage = opp.StageName;
            this.Probability = opp.Probability;
            this.CloseDate = (opp.CloseDate == null) ? '' : formatDate(opp.CloseDate);
            this.ForecastCategory = opp.ForecastCategoryName;
            this.Type = opp.Type;
            this.NextStep = opp.NextStep;
            this.OwnerId = opp.OwnerId;
            this.OwnerName = opp.Owner.Name;
            if(!opp.IsClosed && opp.Next_Step_Field_Last_Updated_On__c != null && opp.Next_Step_Field_Last_Updated_On__c.daysBetween(Date.today()) > 15)
            {
                this.HighlightLevel = 1;
            }
            if(!opp.IsClosed && opp.Next_Step_Field_Last_Updated_On__c != null && opp.Next_Step_Field_Last_Updated_On__c.daysBetween(Date.today()) > 30)
            {
                this.HighlightLevel = 2;
            }
            if(!opp.IsClosed && opp.CloseDate != null && opp.CloseDate.daysBetween(Date.today()) > 0)
            {
                this.HighlightLevel = 3;
            }
        }
        
        public String OppId { get; set; }
        public String OppName { get; set; }
        public Decimal Amount { get; set; }
        public String Stage { get; set; }
        public Decimal Probability { get; set; }
        public String CloseDate { get; set; }
        public String ForecastCategory { get; set; }
        public String Type { get; set; }
        public String NextStep { get; set; }
        public String OwnerId { get; set; }
        public String OwnerName { get; set; }
        public Integer HighlightLevel { get; set; }
        
        private String formatDate(Date d)
        {
            String month = (d.month() < 10) ? '0' + d.month() : '' + d.month();
            String day = (d.day() < 10) ? '0' + d.day() : '' + d.day();
            return month + '/' + day + '/' + d.year();
        }
    }
}