public class ResellerContactUtility
{
   /* public static void createInboxRecords(List<Reseller_Contact__c> rcList, Map<Id,List<Contact>> acctToCtMap)
    {
        try
        {
            List<Inbox__c> mssgList = new List<Inbox__c>();
            for(Reseller_Contact__c rc : rcList)
            {
                // create each inbox record for each reseller contact.
                Inbox__c inb = new Inbox__c();
                List<Contact> conts = acctToCtMap.get(rc.resellerCustomerAccount__c);
                List<Id> custContIds = new List<Id>();
                List<Id> resContIds = new List<Id>();
                inb.Customer_Account__c = rc.resellerCustomerAccount__c;
                inb.Reseller_Account__c = rc.Reseller_Account__c;
                inb.Reseller_Contact__c = rc.ResellerContact__c;                    
                inb.Status__c = 'Unread';
                String toaddrs = '';
                String[] toAddresses = new String[]{};
                for(Contact c : conts)
                {
                    toaddrs = toaddrs + c.Email + ',';
                    toAddresses.add(c.Email);
                }
                inb.To_Address__c = toaddrs;
                mssgList.add(inb);               
            }
            insert mssgList;
        }
        catch(Exception e)
        {
            System.debug('Exception Occured..' + e.getMessage());
        }            
    } */
    
    /*public static void sendMassEmail(List<Id> targetObjIds, String templateId)
    {      
        //String fromaddress ='Do-Not-Reply@nimblestorage.com';  
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        for(Id targetId : targetObjIds)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(targetId);
            mail.setTemplateId(templateId);
           // mail.setReplyTo(fromaddress);
            mail.setSaveAsActivity(false);
            allMails.add(mail);
        }
        Messaging.sendEmail(allMails);
    }*/
    public static String footer = '<p>For U.S. support:<br/>' +
                        'Toll-free: 1-877-3NIMBLE (877-364-6253), extension 2<br/>' +
                        'Local: 408-432-9600, extension 2<br/>' +
                        'Email: support@nimblestorage.com<br/>' +
                        'For other international support phone numbers:<a href=http://www.nimblestorage.com/support/overview/>http://www.nimblestorage.com/support/overview/</a></p>';
                        
    public static void sendEmailToCustomerOnRequest(List<Contact> contacts, Map<Id,Reseller_Contact__c> acctToResMap,Map<Id,Account> resToAccMap, String type)
    {        
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        //TODO: Revist the code on inbox creation
        Inbox__c inb = new Inbox__c();
        OrgWideEmailAddress owe = [select Id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'DoNotReply'];
        for(Contact con : contacts)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Reseller_Contact__c rc = acctToResMap.get(con.AccountId);
            String body;
            String subject;
            String header = 'Dear ' + con.FirstName + ' ' + con.LastName + ',<br/>';
            String message;
            String supportemail;
            String signature = '';
            Boolean isSupProvider = false;
            Boolean showSupportTab = false;
            
           if(rc.Reseller_Account__c != null && rc.resellerCustomerAccount__c != null ){
                Account cusSupAccount = resToAccMap.get(rc.resellerCustomerAccount__c);
                Account resSupAccount = resToAccMap.get(rc.Reseller_Account__c);
                    if(cusSupAccount.Support_Provider__c != null && resSupAccount.Support_Provider__c != null){ 
                         signature = resSupAccount.Support_Provider__r.Email_Signature__c;
                         isSupProvider = true;
                         supportemail = resSupAccount.Support_Provider__r.Email__c;
                         showSupportTab = resSupAccount.Support_Provider__r.showSupportTabCustomers__c;
                    }
            }
            if(signature == '' || signature == null){
                signature =  footer;
            }
            if(isSupProvider == true){
                if(showSupportTab == true){
                    if(type == 'new')
                    {
                         message = '<p>' + rc.Reseller_Contact_Name__c + 
                                   ' from reseller ' + rc.Reseller_Account_Name__c + ' is requesting access to ' + rc.Customer_Account_Name__c +
                                   ' operational data using InfoSight.<br/>'+
                                   'Please Approve or Reject this request by logging into InfoSight'+
                                   '<a href=https://infosight.nimblestorage.com/>(https://infosight.nimblestorage.com/)</a>'+
                                   ' and select Approve/Reject on the "Support" > "Reseller Account" tab.</p><br/>';
                         body = header + message + signature;
                         subject = 'Please approve/reject reseller request for Nimble InfoSight access.'; 
                    }
                    else if(type == 'update')
                    {   
                         message =  '<p> This is confirmation that you have ' +  rc.Status__c + ' InfoSight access for ' + 
                                    rc.Reseller_Contact_Name__c + ' from reseller ' + rc.Reseller_Account_Name__c + '.</p><br/>';
                         body = header + message + signature;
                         if(rc.Status__c == 'Approved'){
                             subject = 'You have ' + rc.Status__c +' '+ ' InfoSight request.';
                         }
                         else{
                             subject = 'Dear Customer you have '+' ' + rc.Status__c+'.';
                         }
                    }
                }
                else{
                    if(type == 'new')
                    {
                         message = '<p>' + rc.Reseller_Contact_Name__c + 
                                   ' from reseller ' + rc.Reseller_Account_Name__c + ' is requesting access to ' + rc.Customer_Account_Name__c +
                                   ' operational data using InfoSight.<br/>'+
                                   ' Please send approval/rejection confirmation to ('+ supportemail +').</p><br/>';
                         body = header + message + signature;
                         subject = 'Reseller has requested InfoSight Access - Please Approve / Reject.'; 
                    }
                    else if(type == 'update')
                    {
                         message =  '<p> This is confirmation that ' +rc.Approved_Or_Rejected_By_Name__c + ' has ' +  rc.Status__c + ' InfoSight access for ' + 
                                    rc.Reseller_Contact_Name__c + ' from reseller ' + rc.Reseller_Account_Name__c + '.</p><br/>';
                         body = header + message + signature;
                         if(rc.Status__c == 'Approved'){
                             subject = rc.Approved_Or_Rejected_By_Name__c+' '+'has' +' '+ rc.Status__c+' your InfoSight access.';
                         }
                         else{
                             subject = rc.Approved_Or_Rejected_By_Name__c+' '+'has' +' '+ rc.Status__c+' your InfoSight access.';
                         }
                    }
                }   
            }
            else{
                 if(type == 'new')
                 {
                     message = '<p>' + rc.Reseller_Contact_Name__c + 
                               ' from reseller ' + rc.Reseller_Account_Name__c + ' is requesting access to ' + rc.Customer_Account_Name__c +
                               ' operational data using InfoSight.<br/>'+
                               'Please Approve or Reject this request by logging into InfoSight'+
                               '<a href=https://infosight.nimblestorage.com/>(https://infosight.nimblestorage.com/)</a>'+
                               ' and select Approve/Reject on the "Support" > "Reseller Account" tab.</p><br/>';
                     body = header + message + footer;
                     subject = 'Please approve/reject reseller request for Nimble InfoSight access.'; 
                }
                else if(type == 'update')
                {
                     message =  '<p> This is confirmation that you have ' +  rc.Status__c + ' InfoSight access for ' + 
                                rc.Reseller_Contact_Name__c + ' from reseller ' + rc.Reseller_Account_Name__c + '.</p><br/>';
                     body = header + message + footer;
                     if(rc.Status__c == 'Approved'){
                          subject = 'You have ' + rc.Status__c + ' a request for Nimble InfoSight access.';
                     }
                     else{
                          subject = 'You have ' + rc.Status__c + ' a request for Nimble InfoSight access.';
                     }
                }  
            }
                    
            mail.setToAddresses(new String[] {con.Email});
            system.debug('+++mail+++'+mail);
            //mail.setInReplyTo('Do-Not-Reply@nimblestorage.com');
            //mail.setSenderDisplayName('Nimble Storage');
            mail.setOrgWideEmailAddressId(owe.id);
            mail.setHtmlBody(body);
            mail.setSubject(subject);
            mail.setSaveAsActivity(false);
            allMails.add(mail);
            inb.Reseller_Account__c = rc.Reseller_Account__c;
            inb.Reseller_Contact__c = rc.ResellerContact__c;
            inb.Customer_Account__c = rc.resellerCustomerAccount__c;                    
            inb.Status__c = 'Unread';            
            inb.From_Address__c = owe.Address;            
            inb.message__c = '<p><b>From: ' + inb.From_Address__c + '</b></p><br/><p><b>Subject: ' + subject + '</b></p><br/>' + message + signature;
            inb.Subject__c = subject;
        }
        system.debug('+++allMails+++'+allMails);
        Messaging.sendEmail(allMails);
        insert inb;
    }
    
    public static void sendEmailToResellerOnRequest(Map<Id,Reseller_Contact__c> acctToResMap,Map<Id,Account> resToAccMap, String type)
    {        
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        List<Reseller_Contact__c> rcList = acctToResMap.values();        
        OrgWideEmailAddress owe = [select Id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'DoNotReply'];
        for(Reseller_Contact__c rc : rcList)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            String body;
            String subject;
            String signature = '';
            if(rc.Reseller_Account__c != null && rc.resellerCustomerAccount__c != null ){
                Account cusSupAccount = resToAccMap.get(rc.resellerCustomerAccount__c);
                Account resSupAccount = resToAccMap.get(rc.Reseller_Account__c);
                    if(cusSupAccount.Support_Provider__c != null && resSupAccount.Support_Provider__c != null){ 
                         signature = resSupAccount.Support_Provider__r.Email_Signature__c;
                    }
            }
            /*if(rc.Reseller_Account__c != null){
                Account suppAccount = resToAccMap.get(rc.Reseller_Account__c);
                if(signature == null || signature == ''){
                    if(suppAccount.Support_Provider__c != null){ 
                         signature = suppAccount.Support_Provider__r.Email_Signature__c;
                    }
                }
            }*/
            if(signature == '' || signature == null){
                    signature =  footer;
            }
            if(type == 'new')
            {          
                body = ' Dear ' + rc.Reseller_Contact_Name__c + ',<br/>' +
                           '<p>Your request to access ' + rc.Customer_Account_Name__c + ' operational data using InfoSight is pending.' +
                              'You will be notified when the customer rejects/approves your request.</p><br/>' + signature;  
                subject = 'Your request for Nimble InfoSight access is pending.';
            }
            else if(type == 'update')
            {
                subject = 'Your request for Nimble InfoSight access has been ' + rc.Status__c + '.';
                body = 'Dear ' +  rc.Reseller_Contact_Name__c + ',<br/>' +
                        '<p>'+rc.Customer_Account_Name__c + ' has ' + rc.Status__c + ' your request to allow ' +
                        rc.Reseller_Contact_Name__c + ' of ' + rc.Reseller_Account_Name__c + 
                        ' access to ' + rc.Customer_Account_Name__c + ' operational data using InfoSight.</p><br/>' + signature;
            }
            mail.setOrgWideEmailAddressId(owe.id);
            mail.setToAddresses(new String[] {rc.Res_Email__c});
            mail.setHtmlBody(body);
            mail.setSubject(subject);
            mail.setSaveAsActivity(false);
            allMails.add(mail);
        }
        Messaging.sendEmail(allMails);
    }
    
    public static void sendEmailToAccountTeamMembersOnRequest(Set<Id> custAcctIds, Map<Id,Reseller_Contact__c> acctToResMap,Map<Id,Account> resToAccMap, String type)
    { 
        OrgWideEmailAddress owe = [select Id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'DoNotReply'];
        List<AccountTeamMember> atmList = getAccountTeamMemberUsers(custAcctIds);      
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();           
        for(AccountTeamMember atm : atmList)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            Reseller_Contact__c rc = acctToResMap.get(atm.AccountId);  
            String body;
            String subject;
            String signature = '';
            Boolean isSupProvider = false;
            Boolean showSupportTab = false;
            if(rc.Reseller_Account__c != null && rc.resellerCustomerAccount__c != null ){
                Account cusSupAccount = resToAccMap.get(rc.resellerCustomerAccount__c);
                Account resSupAccount = resToAccMap.get(rc.Reseller_Account__c);
                    if(cusSupAccount.Support_Provider__c != null && resSupAccount.Support_Provider__c != null){ 
                         signature = resSupAccount.Support_Provider__r.Email_Signature__c;
                         isSupProvider = true;
                         showSupportTab = resSupAccount.Support_Provider__r.showSupportTabCustomers__c;
                    }
            }
            /*if(rc.Reseller_Account__c != null){
                Account suppAccount = resToAccMap.get(rc.Reseller_Account__c);
                if(signature == null || signature == ''){
                    if(suppAccount.Support_Provider__c != null){ 
                         signature = suppAccount.Support_Provider__r.Email_Signature__c;
                         isSupProvider = true;
                         showSupportTab = suppAccount.Support_Provider__r.showSupportTabCustomers__c;
                    }
                }
            }*/
            if(signature == '' || signature == null){
                    signature =  footer;
            }
            User u = [select Id, Name, Email from User where Id = :atm.UserId];            
            if(isSupProvider == true){
                if(showSupportTab == true){
                     if(type == 'new')  
                     {      
                          body =    'This is for your information only. No action is required. '+ '<br/>' + 
                                    '<p>'+rc.Reseller_Contact_Name__c + ' from '+
                                    rc.Reseller_Account_Name__c + ' has requested access to ' + rc.Customer_Account_Name__c + 
                                    '. Email has been sent to ' + rc.Asset_Contact_Name__c + '.</p><br/>' + signature;
                          subject = 'FYI: Reseller has requested InfoSight Access.';
                     }
                     else if(type == 'update')
                     {
                          if(rc.Status__c == 'Approved'){
                               subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                          }
                          else{
                               subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                          }
                          body =    ' This is for your information only. No action is required. '+ '<br/>' +
                                    '<p>'+rc.Approved_Or_Rejected_By_Name__c + ' from ' + rc.Customer_Account_Name__c + ' has ' + rc.Status__c +
                                    ' access to  '+ rc.Reseller_Contact_Name__c + ' from ' + rc.Reseller_Account_Name__c + '.</p><br/>' + signature;
                     } 
                }
                else{
                     if(type == 'new')  
                     {      
                          body =    'Action Required. ' + '<br/>' +
                                    '<p>'+rc.Reseller_Contact_Name__c + ' from '+
                                    rc.Reseller_Account_Name__c + ' has requested access to ' + rc.Customer_Account_Name__c + 
                                    '. Email has been sent to ' + rc.Asset_Contact_Name__c+ '.</p><br/>'+
                                    'Please follow up with ('+ rc.Asset_Contact_Name__c +') to send the confirmation on the request.'+ '<br/>'+
                                    'To approve/reject upon customers response:'+ '<br/>'+
                                    '- login to Salesforce'+ '<br/>'+
                                    '- Navigate to "Reseller Contacts"'+ '<br/>'+
                                    '- Browse through the reseller contact records for the request'+ '<br/>'+
                                    '- Edit to approve/reject the request'+ '<br/>'
                                    + '.</p><br/>'+ signature;
                          subject = 'Action-Required: Reseller has requested InfoSight Access.';
                     }
                     else if(type == 'update')
                     {
                               if(rc.Status__c == 'Approved'){
                                   subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                               }
                               else{
                                   subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                               }
                               body =    ' This is for your information only. No action is required. '+
                                    '<p>'+rc.Approved_Or_Rejected_By_Name__c + ' from ' + ' Support ' + ' has ' + rc.Status__c +
                                    ' access to  '+ rc.Reseller_Contact_Name__c + ' from ' + rc.Reseller_Account_Name__c + '.</p><br/>' + signature;
                     }
                }
            }
            else{
                 if(type == 'new')  
                 {      
                      body = '<p>Dear ' + atm.User.Name + ',<br/>' +
                             'This is for your information only. No  Action is Required. ' + rc.Reseller_Contact_Name__c + ' from '+
                             rc.Reseller_Account_Name__c + ' has requested access to ' + rc.Customer_Account_Name__c + 
                             '. Email has been sent to ' + rc.Asset_Contact_Name__c + '.</p><br/>' + footer;
                      subject = 'FYI: Reseller has requested InfoSight Access.';
                 }
                 else if(type == 'update')
                 {
                      if(rc.Status__c == 'Approved'){
                           subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                      }
                      else{
                           subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                      }
                      body = '<p>Dear '+   atm.User.Name + ',<br/>' +
                             '<p> This is for your information only. No action is required. '+
                             rc.Approved_Or_Rejected_By_Name__c + ' from ' + rc.Customer_Account_Name__c + ' has ' + rc.Status__c +
                            ' access to  '+ rc.Reseller_Contact_Name__c + ' from ' + rc.Reseller_Account_Name__c + '.</p><br/>' + footer;
                 }   
            }
            mail.setOrgWideEmailAddressId(owe.id);
            mail.setToAddresses(new String[] {atm.User.User_Email_Dev_Purpose__c });
            mail.setSubject(subject);
            mail.setHtmlBody(body);           
            mail.setSaveAsActivity(false);
            allMails.add(mail);
        }
        Messaging.sendEmail(allMails);
    }
    public static void sendEmailToSupportProviderOnRequest(Map<Id,Reseller_Contact__c> acctToResMap,Map<Id,Account> resToAccMap, String type)
    {
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        List<Reseller_Contact__c> rcList = acctToResMap.values();
        OrgWideEmailAddress owe = [select Id, Address, DisplayName from OrgWideEmailAddress where DisplayName = 'DoNotReply'];
        
        for(Reseller_Contact__c rc : rcList)
        {
            String signature = '';
            Boolean isSupProvider = false;
            Boolean showSupportTab = false;
            List<String> toAddresses = new List<String>();
            if(rc.Reseller_Account__c != null && rc.resellerCustomerAccount__c != null ){
                Account cusSupAccount = resToAccMap.get(rc.resellerCustomerAccount__c);
                Account resSupAccount = resToAccMap.get(rc.Reseller_Account__c);
                    if(cusSupAccount.Support_Provider__c != null && resSupAccount.Support_Provider__c != null){ 
                         if(resSupAccount.Support_Provider__r.Email__c != null ){
                             toAddresses.add(resSupAccount.Support_Provider__r.Email__c);
                         }
                         signature = resSupAccount.Support_Provider__r.Email_Signature__c;
                         isSupProvider = true;
                         showSupportTab = resSupAccount.Support_Provider__r.showSupportTabCustomers__c;
                    }
            }
            /*if(rc.Reseller_Account__c != null){
                Account suppAccount = resToAccMap.get(rc.Reseller_Account__c);
                if(suppAccount.Support_Provider__c != null){
                     if(suppAccount.Support_Provider__r.Email__c != null ){
                          toAddresses.add(suppAccount.Support_Provider__r.Email__c);
                     }
                     signature = suppAccount.Support_Provider__r.Email_Signature__c;
                     isSupProvider = true;
                     showSupportTab = suppAccount.Support_Provider__r.showSupportTabCustomers__c;
                }
            }*/
            if(isSupProvider == true){
                 system.debug('+++isSupProvider+++'+isSupProvider);
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
                 String body;
                 String subject;
                 if(showSupportTab == true){
                      if(type == 'new')
                      {          
                            body = 'This is for your information only. No action is required. '+ '<br/>' + 
                                    '<p>'+rc.Reseller_Contact_Name__c + ' from '+
                                    rc.Reseller_Account_Name__c + ' has requested access to ' + rc.Customer_Account_Name__c + 
                                    '. Email has been sent to ' + rc.Asset_Contact_Name__c + '.</p><br/>' + signature;  
                            subject = 'FYI: Reseller has requested InfoSight Access.';
                      }
                      else if(type == 'update')
                      {
                            if(rc.Status__c == 'Approved'){
                               subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                          }
                          else{
                               subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                          }
                          body =     ' This is for your information only. No action is required. '+ '<br/>' +
                                    '<p>'+rc.Approved_Or_Rejected_By_Name__c + ' from ' + rc.Customer_Account_Name__c + ' has ' + rc.Status__c +
                                    ' access to  '+ rc.Reseller_Contact_Name__c + ' from ' + rc.Reseller_Account_Name__c + '.</p><br/>' + signature; 
                      }
                 }
                 else{
                      if(type == 'new')
                      {          
                            body = ' Dear Support Team,' + '<br/>' +
                                    
                                    '<p>'+rc.Reseller_Contact_Name__c + ' from '+
                                    rc.Reseller_Account_Name__c + ' has requested access to ' + rc.Customer_Account_Name__c + 
                                    '. Email has been sent to ' + rc.Asset_Contact_Name__c+ '.</p><br/>'+
                                    'Please follow up with ('+ rc.Asset_Contact_Name__c +') to send the confirmation on the request.'+ '<br/>'+
                                    'To approve/reject upon customers response:'+ '<br/>'+
                                    '- login to Salesforce'+ '<br/>'+
                                    '- Navigate to "Reseller Contacts"'+ '<br/>'+
                                    '- Browse through the reseller contact records for the request'+ '<br/>'+
                                    '- Edit to approve/reject the request'+ '<br/>'
                                    + '.</p><br/>'+ signature;  
                            subject = 'Action Required: Reseller has requested InfoSight Access.';
                      }
                      else if(type == 'update')
                      {
                            if(rc.Status__c == 'Approved'){
                                subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                            }
                            else{
                                subject = 'FYI:'+' '+rc.Approved_Or_Rejected_By_Name__c+' '+ 'has ' + rc.Status__c + ' InfoSight Access to Reseller.';
                            }
                                 body =    ' This is for your information only. No action is required. '+
                                           '<p>'+rc.Approved_Or_Rejected_By_Name__c + ' from ' + ' Support ' + ' has ' + rc.Status__c +
                                           ' access to  '+ rc.Reseller_Contact_Name__c + ' from ' + rc.Reseller_Account_Name__c + '.</p><br/>' + signature;
                      } 
                 }
                 mail.setOrgWideEmailAddressId(owe.id);
                 system.debug('+++toAddresses+++'+toAddresses);
                 //mail.setToAddresses(new String[] {resAccount.Support_Provider__r.Email__c});
                 mail.setToAddresses(toAddresses);
                 mail.setHtmlBody(body);
                 mail.setSubject(subject);
                 mail.setSaveAsActivity(false);
                 system.debug('+++SuppAccount+++'+rc.Reseller_Account__r.Support_Provider__c);
                 allMails.add(mail);
            }
        }
        system.debug('+++allMails+++'+allMails);
        Messaging.sendEmail(allMails);
    }
    public static List<AccountTeamMember> getAccountTeamMemberUsers(Set<Id> custAcctIds)
    {
        List<AccountTeamMember> atmList = [select Id, User.Name, User.Email, UserId, AccountId, User.User_Email_Dev_Purpose__c from AccountTeamMember where AccountId in :custAcctIds and (TeamMemberRole = 'Account Executive (AE)' or TeamMemberRole = 'Systems Engineer (SE)')];        
        return atmList;
    }

}