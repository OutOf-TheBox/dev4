trigger CntrbnMdlTSETimeTrigger on CntrbnMdl_TSE__c (before update) 
{
    for(Integer i=0; i<trigger.new.size(); i++){
        CntrbnMdl_TSE__c nTse = Trigger.new.get(i);
        CntrbnMdl_TSE__c oTse = Trigger.old.get(i);
        if( nTse.Enter_Starttime__c != oTse.Enter_Starttime__c && nTse.Enter_Starttime__c!=null)
        { 
            Datetime sTime = nTse.Enter_Starttime__c;            
            nTse.DateTime_Eastern__c = sTime.format('hh:mm a','America/New_York');
            nTse.DateTime_Pacific__c = sTime.format('hh:mm a','America/Los_Angeles');
            nTse.DateTime_singapore__c = sTime.format('hh:mm a','Asia/Singapore');
            nTse.Datetime_GMT__c = sTime.format('hh:mm a','GMT');

        }
    }
}