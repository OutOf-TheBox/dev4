/**
 * Batch job to create next week's CustomForecast.
 */
global class ForecastSubmissionBatch implements Database.Batchable<sObject>
{
    global final String level;
    global final String qtr;
    global final String week;
    
    global ForecastSubmissionBatch(String l, String q, String w)
    {
        level = l;
        qtr = q;
        week = w;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'select Id from User where ForecastEnabled__c=true and IsActive=true';
        if(level != null)
        {
            query += ' and ForecastLevel__c=\'Level '+level+'\'';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope)
    {
        List<CustomForecast__c> existingForecasts = [select Id, FYFQ__c, FollowingWeekCommit__c, Month1Commit__c, Month2Commit__c, Month3Commit__c, QuarterCommit__c, QuarterGut__c, QuarterUpside__c, UpcomingWeekCommit__c, User__c, YYWW__c from CustomForecast__c where User__c in :scope and Locked__c=false];
        List<CustomForecast__c> newForecasts = new List<CustomForecast__c>();
        for(CustomForecast__c existing : existingForecasts)
        {
            if(existing.YYWW__c == week && existing.FYFQ__c == qtr)
            {
                return;
            }
            existing.SubmittedOn__c = DateTime.now();
            existing.Locked__c = true;
            CustomForecast__c newFc = existing.clone(false, false, false, false);
            newFc.Locked__c = false;
            newFc.FYFQ__c = qtr;
            newFc.YYWW__c = week;
            newFc.SubmittedOn__c = null;
            newFc.LastEdited__c = DateTime.now();
            newForecasts.add(newFc);
        }
        try 
        {
            update existingForecasts;
            insert newForecasts;
        }
        catch(DMLException ex) 
        {
            System.debug(ex);
        }
    }
    
    global void finish(Database.BatchableContext BC) 
    {
    }
}