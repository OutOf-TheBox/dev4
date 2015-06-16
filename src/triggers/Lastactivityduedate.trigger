trigger Lastactivityduedate on Task (after insert) {
if (Trigger.isInsert && Trigger.isafter)

{
task ta=trigger.new[0];
task tsk=[SELECT id, subject, who.type FROM Task where id=:ta.id];
if(tsk.Who.Type == 'Lead')
{    lead ld=[select Id, ISconverted,Last_Activity_Due_Date__c, Lead_Call_Count__c from lead where Id=:ta.whoId];     
    if(ld!=null)
    {
        system.debug('test.....'+ta.ActivityDate);
ld.Last_Activity_Due_Date__c=date.valueOf(ta.ActivityDate);
    update ld;
    }
}}}