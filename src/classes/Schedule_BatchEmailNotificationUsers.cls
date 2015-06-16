global class Schedule_BatchEmailNotificationUsers implements Schedulable{
	global void execute(SchedulableContext sc)
    {
    	
    	CronTrigger ct =new CronTrigger();
    	ct= [SELECT TimesTriggered, NextFireTime,PreviousFireTime
    					 FROM CronTrigger WHERE Id = :sc.getTriggerId()];
    					 datetime dt=ct.PreviousFireTime;    	
    					 
    					 				 
         
        String query='Select id,OwnerId,SO_Owner__c,name,Sales_Order__r.name,Target_Install_Date__c,Expedite_Status__c,Approval_To_Overnight__c, Ship_to_Customer__c, Ship_To_Address__c, Sales_Order__c, Reason_For_Expedite__c,Overnight__c, Opp_Team_9__c, Opp_Team_8__c, Opp_Team_7__c, Opp_Team_6__c, Opp_Team_5__c, Opp_Team_4__c, Opp_Team_3__c, Opp_Team_2__c, Opp_Team_1__c,Opp_Team_10__c, Current_Ship_Date__c ,Last_Sched_Ship_Date_Update__c from Expedite_Request__c where Last_Sched_Ship_Date_Update__c=null and Expedite_Status__c=\'Open\'';
        BatchEmailNotificationUsers bse=new BatchEmailNotificationUsers();
        bse.query=query;
        bse.dtbatch=dt;
        Database.executebatch(bse,1);
    }

}