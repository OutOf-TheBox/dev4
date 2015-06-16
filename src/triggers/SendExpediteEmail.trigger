trigger SendExpediteEmail on Expedite_Request_Email__c (before insert, before update) {
    if(trigger.isinsert)
    {
        list<string> emailto=new list<string>();
        list<string> emailcc=new list<string>();
        EmailServicesAddress emailaddress=[Select LocalPart, FunctionId, EmailDomainName, CreatedDate From EmailServicesAddress where LocalPart='expediterequests' and IsActive=true limit 1 ];
        string esubject=''; 
        string ebody='';
        string htmlbody;
        //map<string,string> expmap=new map<string,string>();
        set<string> expid=new set<string>();
        list<Expedite_Request_Email__c> expemaillist=new list<Expedite_Request_Email__c>();
        for(Expedite_Request_Email__c exp:trigger.new)
        {
            expemaillist.add(exp);        
            expid.add(exp.Expedite_Request__c);
        }
        
        map<string,string> expnamemap=new map<string,string>();
        for(Expedite_Request__c ex:[select name from Expedite_Request__c where id in:expid])
        {
            expnamemap.put(ex.id,ex.name);
        }
        
        // expemaillist=[select id,name,expedite_request__r.ID,expedite_request__r.name,Email_cc__c,inbound_indicator__c,Email_Subject__c,Email_To__c,Email_Body__c from Expedite_Request_Email__c where id in:trigger.newmap.keyset()];
        
        for(Expedite_Request_Email__c ex:expemaillist)
        {
            if(ex.inbound_indicator__c==false && ex.Attachment_Indicator__c==false)
            {               
            string s;
            htmlbody='';
            htmlbody+='<html><table><tr><td>***********************************************************************************************<BR/>EXPEDITE REQUEST REFERENCE NUMBER REQUIRED - DO NOT MODIFY<BR/>'+expnamemap.get(ex.Expedite_Request__c)+'<br/>***********************************************************************************************</td></tr></table>';
            emailto=ex.Email_To__c.split(';');
            system.debug('emailto--------'+ex.Email_To__c.split(';'));
            if(ex.Email_cc__c!=null && ex.Email_cc__c!='')
            emailcc=ex.Email_cc__c.split(';');           
            esubject=ex.Email_Subject__c+'[ref:'+expnamemap.get(ex.Expedite_Request__c)+']';           
            ebody=ex.Email_Body__c+htmlbody;
            list<string> tr=new list<string>();
            tr.add('kavi.kumar@mansasys.com');
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailto);
            mail.setReplyTo('expediterequests@'+emailaddress.EmailDomainName);              
            mail.setCcAddresses(emailcc);
            mail.setHtmlBody(ebody); 
            mail.setSubject(esubject);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           
                }
                
        
    }

}
if(trigger.isUpdate)
    {
        list<string> emailto=new list<string>();
        list<string> emailcc=new list<string>();
        EmailServicesAddress emailaddress=[Select LocalPart, FunctionId, EmailDomainName, CreatedDate From EmailServicesAddress where LocalPart='expediterequests' and IsActive=true limit 1 ];
        string esubject=''; 
        string ebody='';
        string htmlbody;
        //map<string,string> expmap=new map<string,string>();
        set<string> expid=new set<string>();
        list<Expedite_Request_Email__c> expemaillist=new list<Expedite_Request_Email__c>();
        set<string> expemailId=new set<string>();
        for(Expedite_Request_Email__c exp:trigger.new)
        {
            expemaillist.add(exp);        
            expid.add(exp.Expedite_Request__c);
            expemailId.add(exp.Id);
            
        }
map<string,list<Messaging.Emailfileattachment>> attachmentmap= new map<string,list<Messaging.Emailfileattachment>>();
    for(string s:expemailId)
    {
        list<Messaging.Emailfileattachment> fileAttachments=new list<Messaging.Emailfileattachment>();
        for(Attachment a:[select Name, Body, BodyLength from Attachment where ParentId =:s])
        {
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
            
        }
        
        attachmentmap.put(s,fileAttachments);
    }
    system.debug('attachmentmap--------'+attachmentmap);
        
        map<string,string> expnamemap=new map<string,string>();
        for(Expedite_Request__c ex:[select name from Expedite_Request__c where id in:expid])
        {
            expnamemap.put(ex.id,ex.name);
        }
        
        // expemaillist=[select id,name,expedite_request__r.ID,expedite_request__r.name,Email_cc__c,inbound_indicator__c,Email_Subject__c,Email_To__c,Email_Body__c from Expedite_Request_Email__c where id in:trigger.newmap.keyset()];
        
        for(Expedite_Request_Email__c ex:expemaillist)
        {
            if(ex.Attachment_Indicator__c==true)
            { 
            ex.Attachment_Indicator__c=false;           
            string s;
            htmlbody='';
            htmlbody+='<html><table><tr><td>***********************************************************************************************<BR/>EXPEDITE REQUEST REFERENCE NUMBER REQUIRED - DO NOT MODIFY<BR/>'+expnamemap.get(ex.Expedite_Request__c)+'<br/>***********************************************************************************************</td></tr></table>';
            emailto=ex.Email_To__c.split(';');
            system.debug('emailto--------'+ex.Email_To__c.split(';'));
            if(ex.Email_cc__c!=null && ex.Email_cc__c!='')
            emailcc=ex.Email_cc__c.split(';');           
            esubject=ex.Email_Subject__c+'[ref:'+expnamemap.get(ex.Expedite_Request__c)+']';           
            ebody=ex.Email_Body__c+htmlbody;
            list<string> tr=new list<string>();
            tr.add('kavi.kumar@mansasys.com');
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailto);
            mail.setReplyTo('expediterequests@'+emailaddress.EmailDomainName);              
            mail.setCcAddresses(emailcc);
            mail.setHtmlBody(ebody); 
            mail.setSubject(esubject);
            mail.setFileAttachments(attachmentmap.get(ex.id));
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           
                }
                
        
    }

}

}