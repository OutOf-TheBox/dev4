trigger taskcount on Task (after insert, after update, before delete) {
if (Trigger.isAfter)
{
if (Trigger.isInsert || Trigger.isupdate)
{
task ta=trigger.new[0];
task tsk=[SELECT id, subject, who.type FROM Task where id=:ta.id];
if(tsk.Who.Type == 'Lead')
{
    lead ld=[select Id, ISconverted, Lead_Call_Count__c from lead where Id=:ta.whoId];     
    if(ld!=null)
    {
       if(tsk.subject.contains('Call'))
        {task sk=new task(); 
        list<task> ts=new list<task>();
        try
        {
      sk=[SELECT Isclosed, status, subject, createddate, whoId FROM Task where whoId=:ld.id 
    and subject='NOTE: lead status changed to OPEN' order by createddate desc limit 1];               
            ts=[SELECT IsClosed, status, whoId FROM Task where whoId=:ld.id and status='completed' and subject like 'call%' and createddate>:sk.createddate];
               }catch(exception e){}
                if(ts.size()!=null)
                    {
                    Integer cl=ts.size();
                    ld.Lead_Call_Count__c=cl;
                    update ld;
                      }
           }             
        if(tsk.subject=='NOTE: lead status changed to OPEN')
         //if(tsk.subject.contains('NOTE'))
            {
                ld.Lead_Call_Count__c=0;
                update ld;         
            }
        }}}}
        if (Trigger.isBefore || Trigger.isDelete) {
        task ta=trigger.old[0];
task tsk=[SELECT id, subject, who.type FROM Task where id=:ta.id];
if(tsk.Who.Type == 'Lead'){
lead ld=[select Id, ISconverted, Lead_Call_Count__c from lead where Id=:ta.whoId];     
    if(ld!=null)
   {
   integer x=(integer)ld.Lead_Call_Count__c;
  ld.Lead_Call_Count__c=x-1;
  update ld;
  }
}}
}