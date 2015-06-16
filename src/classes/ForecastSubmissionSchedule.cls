/**
 * This scheduled is supposed to execute at a given date every week to snapshot forecast for users with specified forecast level.
 */
global class ForecastSubmissionSchedule implements Schedulable
{
    global String level;
    
    global ForecastSubmissionSchedule()
    {
      this(null);
    }
    
    global ForecastSubmissionSchedule(String l)
    {
        this.level = l;
    }
    
    global void execute(SchedulableContext SC)
    {
        ForecastingDataModel.FiscalQuarterInfo currentQuarter;
        ForecastingDataModel.WeekInfo nextWeek;
        
        Date nextWeekStartDay = Date.today().addDays(7).toStartOfWeek();
        currentQuarter = new ForecastingDataModel.FiscalQuarterInfo();
        nextWeek = currentQuarter.getWeek(nextWeekStartDay);
        if(nextWeek == null)
        {
            currentQuarter = currentQuarter.next;
            nextWeek = currentQuarter.getWeek(nextWeekStartDay);
        }
        
        ForecastSubmissionBatch batch = new ForecastSubmissionBatch(level, currentQuarter.FormattedString, nextWeek.FormattedString);
        Database.executeBatch(batch);
    }
}