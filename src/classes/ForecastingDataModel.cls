public class ForecastingDataModel
{
    public class UserInfo
    {
        public UserInfo(User usr)
        {
            this.UserId = usr.Id;
            this.Username = usr.Name;
            this.RoleId = usr.UserRoleId;
            this.RoleName = usr.UserRole.Name;
            this.ForecastEnabled = usr.ForecastEnabled__c;
            this.ViewForecastAsId = usr.ViewForecastAs__c;
            this.ForecastLevel = usr.ForecastLevel__c;
        }
        
        public String UserId { get; set; }
        public String Username { get; set; }
        public String RoleId { get; set; }
        public String RoleName { get; set; }
        public Boolean ForecastEnabled { get; set; }
        public Id ViewForecastAsId { get; set; }
        public String ForecastLevel { get; set; }
        
        public UserInfo ViewForecastAs 
        {
            get
            {
                return (ViewForecastAsId != null) ? ForecastingService.getUser(viewForecastAsId) : null;
            }
        }
    }

    public class WeekInfo
    {
        public WeekInfo()
        {
            this(Date.today().toStartOfWeek());
        }
        
        public WeekInfo(Date day)
        {
            StartDate = day.toStartOfWeek();
            EndDate = StartDate.addDays(6);
            Year = StartDate.year();
            Week = StartDate.dayOfYear() / 7 + 1;
        }
        
        public WeekInfo(Date sow, Date eow)
        {
            StartDate = sow;
            EndDate = eow;
            Year = sow.year();
            Week = StartDate.dayOfYear() / 7 + 1;
        }
        
        public Integer Year { get; private set; }
        public Integer Week { get; private set; }
        public Date StartDate { get; private set; }
        public Date EndDate { get; private set; }
        public Integer Days { get { return StartDate.daysBetween(EndDate) + 1; } }

        public String FormattedString
        {
            get
            {
                return Year + ((Week < 10) ? '0' : '') + Week;
            }
        }
        
        public String FormattedShortString
        {
            get
            {
                Map<Integer, String> monthNames = new Map<Integer, String> {1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct', 11 => 'Nov', 12 => 'Dec' };
                String result = '';
                result += monthNames.get(StartDate.month()) + ' ' + StartDate.day() + ' - ';
                result += (StartDate.year() == EndDate.year() && StartDate.month() == EndDate.month()) ? String.valueOf(EndDate.day()) : (monthNames.get(EndDate.month()) + ' ' + EndDate.day());
                return result;
            }
        }
        
        private WeekInfo mergeWeek(WeekInfo w)
        {
            WeekInfo result = new WeekInfo(this.StartDate, this.EndDate);
            if(result.StartDate.daysBetween(w.StartDate) < 0)
            {
                result.StartDate = w.StartDate;
            }
            if(result.EndDate.daysBetween(w.EndDate) > 0)
            {
                result.EndDate = w.EndDate;
            }
            return result;
        }
    }
    
    public class FiscalYearInfo
    {
        public FiscalYearInfo(Integer year)
        {
            this.Year = year;
        }
        public Integer Year { get; set; }
        public Date StartDate { get; set; }
        public Date EndDate { get; set; }
        public FiscalYearInfo Next
        {
            get
            {
                FiscalYearInfo nextYear = new FiscalYearInfo(Year+1);
                nextYear.StartDate = this.StartDate.addYears(1);
                nextYear.EndDate = this.EndDate.addYears(1);
                return nextYear;
            }
        }
        public FiscalYearInfo Previous
        {
            get
            {
                FiscalYearInfo prevYear = new FiscalYearInfo(Year-1);
                prevYear.StartDate = this.StartDate.addYears(-1);
                prevYear.EndDate = this.EndDate.addYears(-1);
                return prevYear;
            }
        }
    }
    
    public class FiscalQuarterInfo
    {
        public FiscalQuarterInfo()
        {
            this(Date.today());
        }
        
        public FiscalQuarterInfo(Date day) 
        {
            List<FiscalyearSettings> fiscalYears = [select Id, Name, IsStandardYear, StartDate, EndDate from FiscalYearSettings where StartDate<=:day and EndDate>=:day limit 1];
            if(fiscalyears.size() > 0)
            {
                if(fiscalyears[0].IsStandardYear)
                {
                    Year = Integer.valueOf(fiscalyears[0].Name);
                    Quarter = fiscalyears[0].StartDate.monthsBetween(day) / 3 + 1;
                    FormattedString = Year + 'Q' + Quarter;
                    StartDate = fiscalYears[0].StartDate.addMonths((Quarter - 1) * 3);
                    EndDate = StartDate.addMonths(3).addDays(-1);
                    FiscalYear = new FiscalYearInfo(Year);
                }
                else
                {
                    List<Period> periods = [SELECT Type, StartDate, EndDate, QuarterLabel, PeriodLabel, Number, FiscalYearSettings.Name FROM Period WHERE Type = 'Quarter' AND StartDate <= :day AND EndDate >= :day LIMIT 1];
                    if(periods.size() > 0)
                    {
                        Year = Integer.valueOf(periods[0].FiscalYearSettings.Name);
                        Quarter = periods[0].Number;
                        FormattedString = periods[0].FiscalYearSettings.Name + 'Q' + periods[0].Number;
                        StartDate = periods[0].StartDate;
                        EndDate = periods[0].EndDate; 
                        FiscalYear = new FiscalYearInfo(Year);
                    }
                }
                Fiscalyear.StartDate = fiscalYears[0].StartDate;
                Fiscalyear.EndDate = fiscalYears[0].EndDate;
            }
            if(Year == null)
            {
                Year = day.year();
                Quarter = (day.month() - 1) / 3 + 1;
                FormattedString = Year + 'Q' + Quarter;
                StartDate = Date.newInstance(Year, (Quarter - 1) * 3 + 1, 1);
                EndDate = StartDate.addMonths(3).addDays(-1);
                FiscalYear = new FiscalYearInfo(Year);
                Fiscalyear.StartDate = Date.newInstance(Year, 1, 1);
                Fiscalyear.EndDate = Fiscalyear.StartDate.addYears(1).addDays(-1);
            }
            buildWeeks();
        }
        
        public FiscalQuarterInfo(String text)
        {
            if(String.isBlank(text) || text.length() != 6 || !Pattern.matches('\\d\\d\\d\\d[Qq]\\d', text))
            {
                throw new ForecastingException('Incorrrect format of fiscal quarter [' + text + ']');
            }
            FormattedString = text;
            String[] textParts = text.split('[Qq]');
            Year = Integer.valueOf(textParts[0]);
            Quarter = Integer.valueOf(textParts[1]);
            FiscalYear = new FiscalYearInfo(Year);
            
            List<FiscalyearSettings> fiscalYears = [select Id, IsStandardYear, StartDate, EndDate from FiscalYearSettings where Name=:textParts[0] limit 1];
            if(fiscalYears.size() > 0)
            {
                Fiscalyear.StartDate = fiscalYears[0].StartDate;
                Fiscalyear.EndDate = fiscalYears[0].EndDate;
                if(fiscalYears[0].IsStandardYear)
                {
                    StartDate = fiscalYears[0].StartDate.addMonths((Quarter - 1) * 3);
                    EndDate = StartDate.addMonths(3).addDays(-1);
                }
                else
                {
                    List<Period> periods = [SELECT Type, Number, StartDate, EndDate FROM Period WHERE Type = 'Quarter' AND Number = :quarter AND FiscalYearSettings.Name = :textParts[0] LIMIT 1];
                    if(periods.size() > 0)
                    {
                        StartDate = periods[0].StartDate;
                        EndDate = periods[0].EndDate;
                    }
                }
            }
            if(StartDate == null)
            {
                StartDate = Date.newInstance(Year, (Quarter - 1) * 3 + 1, 1);
                EndDate = StartDate.addMonths(3).addDays(-1);
                Fiscalyear.StartDate = Date.newInstance(Year, 1, 1);
                Fiscalyear.EndDate = Fiscalyear.StartDate.addYears(1).addDays(-1);
            }
            buildWeeks();
        }
        
        public String FormattedString { get; set; }
        public Integer Year { get; private set; }
        public Integer Quarter { get; private set; }
        public Date StartDate { get; private set; }
        public Date EndDate { get; private set; }
        public FiscalYearInfo FiscalYear { get; private set; }
        public List<WeekInfo> Weeks { get; set; }
        
        public String JsonWeeks 
        {
            get
            {
                return JSON.serialize(Weeks);
            }
        }
        
        public FiscalQuarterInfo Previous
        {
            get
            {
                String text = (Quarter == 1) ? (Year - 1) + 'Q4' : Year + 'Q' + (Quarter - 1);
                return new FiscalQuarterInfo(text);
            }
        }
        
        public FiscalQuarterInfo Next
        {
            get
            {
                String text = (Quarter == 4) ? (Year + 1) + 'Q1' : Year + 'Q' + (Quarter + 1);
                return new FiscalQuarterInfo(text);
            }
        }
        
        public Boolean isLastWeek(WeekInfo week)
        {
            return week.EndDate.daysBetween(EndDate) <= 0;
        }
        
        public WeekInfo getWeek(Date d)
        {
            for(WeekInfo w : Weeks)
            {
                if(d.daysBetween(w.EndDate) >= 0 && w.StartDate.daysBetween(d) >= 0)
                {
                    return w;
                }
            }
            return null;
        }
        
        private void buildWeeks()
        {
            Weeks = new List<WeekInfo>();
            
            for(Date d = this.StartDate; d.toStartOfWeek().daysBetween(this.EndDate) >= 0; d = d.addDays(7))
            {
                WeekInfo w = new WeekInfo(d);
                if(w.StartDate.daysBetween(this.StartDate) > 0)
                {
                    w.StartDate = this.StartDate;
                }
                if(w.EndDate.daysBetween(this.EndDate) < 0)
                {
                    w.EndDate = this.EndDate;
                }
                Weeks.add(w);
            }
            if(Weeks.size() == 14)
            {
                if(Weeks[13].Days == 1 || Weeks[13].Days == 2)
                {
                    Weeks[12] = Weeks[12].mergeWeek(Weeks[13]);
                    Weeks.remove(13);
                }
                else
                {
                    Weeks[0] = Weeks[0].mergeWeek(Weeks[1]);
                    Weeks.remove(1);
                }
            }
        }
    }
}