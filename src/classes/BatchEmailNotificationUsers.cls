global with sharing class BatchEmailNotificationUsers implements Database.Stateful,Database.Batchable<sObject>{
    global string query;
    global datetime dtbatch; 
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);  
    }
    global void execute(Database.BatchableContext BC,  list<Expedite_request__c> scope)  
    {                   
        /*decimal decHours=0.00;
        system.debug('dtbatch------------'+dtbatch);
        
                system.debug('la time------------'+scope[0].Name);
        if(dtbatch == null)
        {
            decHours=(scope[0].Last_Act_Ship_Date_Update__c.getTime())/1000/60;
        }
        else
        {
        decHours = ((dtbatch.getTime())/1000/60) - ((scope[0].Last_Act_Ship_Date_Update__c.getTime())/1000/60);
        }
        system.debug('dechours---------'+decHours);
    if(decHours >1440)
    {    
    */  
        list<string> emailList=new list<string>();
        list<string> ccaddress=new list<string>();
        list<user> uslist=[select id,email,name from user where id=:scope[0].SO_Owner__c or id=:scope[0].Opp_Team_1__c or id=:scope[0].Opp_Team_2__c or id=:scope[0].Opp_Team_3__c 
                       or id=:scope[0].Opp_Team_4__c or id=:scope[0].Opp_Team_5__c or id=:scope[0].Opp_Team_6__c or id=:scope[0].Opp_Team_7__c or id=:scope[0].Opp_Team_8__c 
                       or id=:scope[0].Opp_Team_9__c  or id=:scope[0].Opp_Team_10__c or id=:scope[0].OwnerId ];
                       
                       system.debug('userlist-----------------'+uslist);
        
        for(user u: uslist)
        {
            emailList.add(u.email);
        }
        if(scope[0].Approval_To_Overnight__c==null)
        {
            scope[0].Approval_To_Overnight__c=' ';
        }
        if(scope[0].Reason_For_Expedite__c==null)
        {
            scope[0].Reason_For_Expedite__c=' ';
        }
        ccaddress.add('expedites.orders@nimblestorage.com');
         
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emaillist);
        
        mail.setCcAddresses(ccaddress);
        String subject='The Expedite Request for Sales Order '+scope[0].Sales_order__r.Name +'has not been updated.';
        string body='<html><body><p>The following Expedite Request for the noted Sales Order has not been updated with a new Shipping Date.'+' '+
                    'Please click the link below to review</p><p>&nbsp;</p>';
                    
        body+= '<p> Expedite Request Case #:'+'<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+scope[0].Id+'">'+  scope[0].name+'</p></a>';
        body+= '<p> Sales Order:'+'<a target="_blank" href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+scope[0].Sales_Order__c+'">'+  scope[0].Sales_Order__r.name+'</p></a>';        
        body+= '<p> Ship To Customer:'+  scope[0].Ship_to_Customer__c+'</p>';       
        body+= '<p> Ship To Address:'+  scope[0].Ship_To_Address__c+'</p>';     
        body+= '<p> Current Ship Date:'+  scope[0].Current_Ship_Date__c+'</p>';     
        body+= '<p> Target Install Date:'+  scope[0].Target_Install_Date__c+'</p>';
        body+= '<p> Last Actual Ship Date Update:'+  scope[0].Last_Sched_Ship_Date_Update__c+'</p>';        
        body+= '<p> Overnight:'+  scope[0].Approval_To_Overnight__c+'</p>';     
        body+= '<p> Approval to Overnight:'+  scope[0].Approval_To_Overnight__c+'</p>';     
        body+= '<p> Reason for Expedite:'+  scope[0].Reason_For_Expedite__c+'</p></html></body>';
        
        mail.setHtmlBody(body); 
        mail.setSubject(subject);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        
            
   // }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    } 
}