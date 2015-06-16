global with sharing class BatchRenewalShippingEmails implements Database.Stateful,Database.Batchable<sObject>{
    
    global string query;
    Set<String> trackSOLI=new Set<String>();
    List<String> emailList;
    List<Sales_Order_Line__c> sol;
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,  List<Sales_Order_Line__c > scope)  
    {  
    
        if(trackSOLI.contains(scope[0].Sales_Order__c))
        {   
        } 
        else
        {    
        emailList=new List<String>();
        List<String> ccAddress=new List<String>(); 
        Sales_Order__c soRec=[Select id,End_Customer_Contact_Email__c,opportunity__r.Account.name,PO__c,SO_Number__c,OwnerId,Shipping_Agent_Services_Code__c,Opportunity__c,Opportunity__r.name,Type__c,Bill_To_Contact_Email__c,Ship_to_Contact_Email__c,Ship_To_Company__c,Ship_To_Contact_Name__c,Ship_To_Contact_Phone__c,Ship_To_Address_1__c,Ship_To_Address_2__c,Ship_To_City__c,Ship_To_State__c,Ship_To_Zip_Postal_Code__c,Ship_To_Country__c from Sales_Order__c where id=:scope[0].Sales_Order__c ];
        list<OpportunityTeamMember> opteam=[select user.email from OpportunityTeamMember where OpportunityId=:soRec.Opportunity__c];
        if(opteam.size()>0)
        { 
            for(OpportunityTeamMember opt:opteam)
            {               
                ccAddress.add(opt.user.email);
            }
        }  
        system.debug('ccAddress----------------------'+ccAddress);
          system.debug('opteam----------------------'+opteam);
            
            if(soRec.Bill_To_Contact_Email__c!=null)
            {
                emailList.add(soRec.Bill_To_Contact_Email__c);
            }
            if(soRec.Ship_to_Contact_Email__c!=null)
            {
                emailList.add(soRec.Ship_to_Contact_Email__c);
            }
            if(sorec.End_Customer_Contact_Email__c!=null)
            {
                emailList.add(sorec.End_Customer_Contact_Email__c);
            }
            if(Test.isRunningTest())  
            {
                emailList.add('a@b.com');
            }
            list<Sales_Order_Line__c>Salc=[Select id,item__c,Actual_Shipping_Date__c,Tracking_Number__c,Shipping_Agent_Link__c,
                                                Shipping_Agent__c,Quantity__c,Serial_Number__c,Start_Date__c,End_Date__c 
                                                from Sales_Order_Line__c where Sales_Order__c=:scope[0].Sales_Order__c 
                                                and Shipping_Email_Indicator__c=false and Support_Renewal_Indicator__c=true]; 
                                                
                                                System.debug('==========Salc=========='+Salc);
                                                            
                                                
            sol=new List<Sales_Order_Line__c>();
            for(Sales_Order_Line__c s:salc)
            {
                    s.Shipping_Email_Indicator__c=true;
                    sol.add(s);
            }
            if(!sol.isEmpty())
            update sol;
            
            String recID;
            String SoNumber;
            if(soRec.SO_Number__c!=null)
            {
                SoNumber=soRec.SO_Number__c;
                recid=soRec.Id;
            }
                
            else
            {
                SoNumber='';
                recid='';
            }
                
            String shipToCompany;
            if(soRec.Ship_To_Company__c!=null)
                shipToCompany=soRec.Ship_To_Company__c;
            else
                shipToCompany='';
                
            String actualShippingDate;
            if(String.valueof(Salc[0].Actual_Shipping_Date__c)!=null)
                actualShippingDate=String.valueof(Salc[0].Actual_Shipping_Date__c);
            else
                actualShippingDate=String.valueof('');
                
            String shiptoAddress1;
            if(soRec.Ship_To_Address_1__c!=null)
                shiptoAddress1=soRec.Ship_To_Address_1__c;
            else
                shiptoAddress1='';
                
            String shiptoAddress2;
            if(soRec.Ship_To_Address_2__c!=null)
                shiptoAddress2=soRec.Ship_To_Address_2__c;
            else
                shiptoAddress2='';
                
            String shiptoCity;
            if(soRec.Ship_To_City__c!=null)
                shiptoCity=soRec.Ship_To_City__c;
            else
                shiptoCity=''; 
                
            String shiptoState;
            if(soRec.Ship_To_State__c!=null)
                shiptoState=soRec.Ship_To_State__c;
            else
                shiptoState='';  
                
            String zippostalCode;
            if(soRec.Ship_To_Zip_Postal_Code__c!=null)
                zippostalCode=soRec.Ship_To_Zip_Postal_Code__c;
            else
                zippostalCode='';  
                
            String shiptoCountry;
            if(soRec.Ship_To_Country__c!=null)
                shiptoCountry=soRec.Ship_To_Country__c;
            else
                shiptoCountry=''; 
                
            String shiptoContactName;
            if(soRec.Ship_To_Contact_Name__c!=null)
                shiptoContactName=soRec.Ship_To_Contact_Name__c;
            else
                shiptoContactName=''; 
                
            String shiptoContactPhone;
            if(soRec.Ship_To_Contact_Phone__c!=null)
                shiptoContactPhone=soRec.Ship_To_Contact_Phone__c;
            else
                shiptoContactPhone='';
                
            String shiptoContactEmail;
            if(soRec.Ship_To_Contact_Email__c!=null)
                shiptoContactEmail=soRec.Ship_To_Contact_Email__c;
            else
                shiptoContactEmail=''; 
                
                
            String shippingagentLink;
            if(salc[0].Shipping_Agent_Link__c!=null)
                shippingagentLink=salc[0].Shipping_Agent_Link__c;
            else
                shippingagentLink='';    
                
                
            String shippingagent;
            if(Salc[0].Shipping_Agent__c!=null)
                shippingagent=Salc[0].Shipping_Agent__c;
            else
                shippingagent=''; 
               
               
            /*String supportStartDate;   
            if(Salc[0].Start_Date__c!=null)
                supportStartDate=Salc[0].Start_Date__c.year()+'-'+Salc[0].Start_Date__c.month()+'-'+Salc[0].Start_Date__c.day();
                //String.valueof(Salc[0].Start_Date__c);
            else
                supportStartDate=''; 
                
            String supportEndDate;   
            if(Salc[0].End_Date__c!=null)
               supportEndDate=Salc[0].End_Date__c.year()+'-'+Salc[0].End_Date__c.month()+'-'+Salc[0].End_Date__c.day();
            else
                supportEndDate=''; */
                
                 
            String shippingAgentServiceCode;
            if(soRec.Shipping_Agent_Services_Code__c!=null)
                shippingAgentServiceCode=soRec.Shipping_Agent_Services_Code__c;
            else
                shippingAgentServiceCode=''; 
                
             
            String poNumber;
            if(soRec.PO__c!=null)
                poNumber=soRec.PO__c;
            else
                poNumber='';       
                
             /*Opportunity__c   
            String oppRName;
            if(soRec.Opportunity__r.name!=null)
                oppRName=soRec.Opportunity__r.name;
            else
                oppRName=''; */
                
                 
            String oppRecID;
            String oppRName;
            String oppAccName;
            if(soRec.Opportunity__c!=null)
            {
                oppRName=soRec.Opportunity__r.name;
                oppRecID=soRec.Opportunity__c;
                oppAccName = soRec.opportunity__r.Account.name;
            }
                
            else
            {
                oppRName='';
                oppRecID='';
            }
           
            
            OrgWideEmailAddress replyEmail = [SELECT ID, DisplayName FROM OrgWideEmailAddress WHERE Address =:'logistics@nimblestorage.com'];
            
             //emailList.add('naman.bhardwaj@mansasys.com');
          //  List<String> ccAddress=new List<String>(); 
            ccAddress.add([select Email from User where Id = :soRec.OwnerId].Email);    
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailList);
            mail.setCcAddresses(ccAddress);
            mail.setOrgWideEmailAddressId(replyEmail.Id);
            
            String subject='Support Renewal for '+oppAccName+'-'+SoNumber+' on '+actualShippingDate;
            String firstBody='The following support renewal was made today:<br/><br/>';  
            String beforeBody='<table width="80%"><tr><td width="25%">Customer :</td><td width="25%">'+oppAccName+'</td></tr><tr><td width="25%">Sales Order:</td><td>'+SoNumber+'</td><td width="25%"></td><td width="25%"></td><td width="25%"></td></table><br/>';
            String afterBeforeBody ='<table width="80%"><tr><td width="25%">Renewal For:</td><td>'+shiptoContactName+'</td></tr><tr><td width="25%"></td><td>'+shiptoAddress1+'</td></tr><tr><td width="25%"></td><td>'+shiptoAddress2+'</td></tr><tr><td width="25%"></td><td >'+shiptoCity+', '+shiptoState+' '+zippostalCode+'</td></tr><tr><td width="25%"></td><td>'+shiptoCountry+'</td></tr></table><br/>';
            String afterBeforeBody2 ='<table width="80%"><tr><td width="25%">ATTN:</td><td>'+shiptoContactName+'</td><tr><td width="25%"></td><td>'+shiptoContactPhone+'</td></tr><tr><td width="25%"></td><td>'+shiptoContactEmail+'</td></tr></table><br/>'; 
            
            //String afterBeforeBody3= '<table width="80%"><tr><td>If you have any questions about the shipment of your order, please contact us at logistics@nimblestorage.com.</td></tr></table><br/>';
            
                String body='<tr><th style="border:1px solid #000000;" width="10%" >Item</th><th style="border:1px solid #000000;" width="16%" >Quantity</th><th style="border:1px solid #000000;" width="16%" >Serial Number</th><th style="border:1px solid #000000;" width="16%" >Support Dates</th></tr>';            
                String trackNo1;
                for(Sales_Order_Line__c sOLines:Salc)
                {
                    if(sOLines.Serial_Number__c!=null)
                        trackNo1=sOLines.Serial_Number__c;
                    else
                        trackNo1='';
                        
                        String supportStartDate;
                    if(String.valueof(sOLines.Start_Date__c)!=null)
                        supportStartDate=String.valueof(sOLines.Start_Date__c);
                    else
                        supportStartDate=String.valueof('');
                
                    String supportEndDate;
                    if(String.valueof(sOLines.End_Date__c)!=null)
                        supportEndDate=String.valueof(sOLines.End_Date__c);
                    else
                        supportEndDate=String.valueof('');   
                 
                  body+='<tr><td style="width:30%;border:1px solid #000000;">'+sOLines.item__c+'</td><td style="width:10%;border:1px solid #000000;">'+sOLines.Quantity__c+'</td><td style="width:20%;border:1px solid #000000;">'+trackNo1+'</td><td style="width:30%;border:1px solid #000000;">'+supportStartDate+' - '+supportEndDate+'</td></tr>';
                }
            
            String lastMsg= '<table width="80%"><tr><td>This email herby confirms that the above shipment has Nimble Storage’s Support and Maintenance Services as listed above.</td></tr><tr><td>Support for such product(s) will be provided in accordance with Nimble Storage’s standard support terms and conditions set forth at: http://www.nimblestorage.com/docs/Nimble-Storage-Terms-of-Sale-and-Support.pdf</td></tr><br/><tr><td>Should you have any additional questions, please feel free to contact us by phone at +1-408-432-9600x2 or by email at support@nimblestorage.com.</td></tr><br/><tr><td>For customer purchasing product shipping into Japan, Toshiba IT-Services Corporation (TSC) will be your primary Support and Service provider. TSC is an authorized Nimble service provider.</td></tr><br/><tr><td>Contact information: TSC Support Helpdesk: +81 120 926 388 or TSC Support E-mail: TSC-nimble-helpdesk@it-serve.co.jp.</td></tr><br/><tr><td>For additional support tools, please visit InfoSight at https://infosight.nimblestorage.com/.</td></tr><br/><tr><td>For an overview of InfoSight, please go to http://www.nimblestorage.com/infosight/overview.php.</td></tr></table><br/>';

            String finalBody=firstBody+beforeBody+afterBeforeBody+afterBeforeBody2+'<table style="border:1px solid #000000;border-collapse:collapse;" cellpadding="2" cellspacing="2" width="70%">'+body+'</table><br/>'+lastMsg;
            System.debug('---------finalBody--------'+finalBody);
            mail.setHtmlBody(finalBody); 
            mail.setSubject(subject);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
           
          
           
            /******************************Internal Email Template************************************************/
            
           List<String> emailList1=new List<String>(); 
           emailList1.add([select Email from User where Id = :soRec.OwnerId].Email); 
           emailList1.add('logistics@nimblestorage.com');
           emailList1.add('sales.Orders@nimblestorage.com');
           //emailList1.add('naman.bhardwaj@mansasys.com');
           
           if(opteam.size()>0)
            { 
                for(OpportunityTeamMember opt:opteam)
                {               
                    emailList1.add(opt.user.email);
                }
            }  
            
            
            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            mail1.setToAddresses(emailList1);                                                               
            //mail1.setCcAddresses(ccAddress);
            
            mail1.setOrgWideEmailAddressId(replyEmail.Id);
            String subject1='Support Renewal Notification for '+oppAccName+'-'+SoNumber+' on '+actualShippingDate;
            String firstBody1='The following support renewal was made today:<br/><br/>';  
            String beforeBody1='<table width="80%"><tr><td width="25%">Customer :</td><td width="25%">'+oppAccName+'</td></tr><tr><td width="25%">Sales Order:</td><td><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/' +recId+'>'+SoNumber+'</a></td></tr><tr><td width="25%">SO Type: </td><td>'+soRec.Type__c+'</td></tr><tr><td width="25%">Opportunity :</td><td width="40%"><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/' +oppRecID+'>'+oppRName+'</a></td><td width="25%"></td><td width="25%"></td><td width="25%"></td><td width="25%"></td><td width="25%"></td><td width="25%"></td><td width="25%"></td><td width="25%"></td><td width="25%"></td></tr></table><br/>';
            String afterBeforeBody1 ='<table width="80%"><tr><td width="25%">Renewal For:</td><td >'+shiptoContactName+'</td></tr><tr><td width="25%"></td><td >'+shiptoAddress1+'</td></tr><tr><td width="25%"></td><td>'+shiptoAddress2+'</td></tr><tr><td width="25%"></td><td >'+shiptoCity+', '+shiptoState+' '+zippostalCode+'</td></tr><tr><td width="25%"></td><td>'+shiptoCountry+'</td></tr></table><br/>';
            String afterBeforeBody21 ='<table width="80%"><tr><td width="25%">ATTN:</td><td>'+shiptoContactName+'</td><tr><td width="25%"></td><td>'+shiptoContactPhone+'</td></tr><tr><td width="25%"></td><td>'+shiptoContactEmail+'</td></tr></table><br/>'; 
                String body1='<tr><th style="border:1px solid #000000;" width="10%" >Item</th><th style="border:1px solid #000000;" width="16%" >Quantity</th><th style="border:1px solid #000000;" width="16%" >Serial Number</th><th style="border:1px solid #000000;" width="16%" >Support Dates</th></tr>';            
                 String trackNo;
                for(Sales_Order_Line__c sOLines:Salc)
                {
                    if(sOLines.Serial_Number__c!=null)
                        trackNo=sOLines.Serial_Number__c;
                    else
                        trackNo='';    
                        
                        String supportStartDate;
                    if(String.valueof(sOLines.Start_Date__c)!=null)
                        supportStartDate=String.valueof(sOLines.Start_Date__c);
                    else
                        supportStartDate=String.valueof('');
                
                    String supportEndDate;
                    if(String.valueof(sOLines.End_Date__c)!=null)
                        supportEndDate=String.valueof(sOLines.End_Date__c);
                    else
                        supportEndDate=String.valueof('');    
                  body1+='<tr><td style="width:30%;border:1px solid #000000;">'+sOLines.item__c+'</td><td style="width:10%;border:1px solid #000000;">'+sOLines.Quantity__c+'</td><td style="width:20%;border:1px solid #000000;">'+trackNo+'</td><td style="width:30%;border:1px solid #000000;">'+supportStartDate+' - '+supportEndDate+'</td></tr>';
                }
            String lastMsg1= '<table width="80%"><tr><td>This email herby confirms that the above shipment has Nimble Storage’s Support and Maintenance Services as listed above.</td></tr><tr><td>Support for such product(s) will be provided in accordance with Nimble Storage’s standard support terms and conditions set forth at: http://www.nimblestorage.com/docs/Nimble-Storage-Terms-of-Sale-and-Support.pdf</td></tr><br/><tr><td>Should you have any additional questions, please feel free to contact us by phone at +1-408-432-9600x2 or by email at support@nimblestorage.com.</td></tr><br/><tr><td>For customer purchasing product shipping into Japan, Toshiba IT-Services Corporation (TSC) will be your primary Support and Service provider. TSC is an authorized Nimble service provider.</td></tr><br/><tr><td>Contact information: TSC Support Helpdesk: +81 120 926 388 or TSC Support E-mail: TSC-nimble-helpdesk@it-serve.co.jp.</td></tr><br/><tr><td>For additional support tools, please visit InfoSight at https://infosight.nimblestorage.com/.</td></tr><br/><tr><td>For an overview of InfoSight, please go to http://www.nimblestorage.com/infosight/overview.php.</td></tr></table><br/>';    
            
            String finalBody1=firstBody1+beforeBody1+afterBeforeBody1+afterBeforeBody21+'<table style="border:1px solid #000000;border-collapse:collapse;" cellpadding="2" cellspacing="2" width="70%">'+body+'</table><br/>'+lastMsg1;
            mail1.setHtmlBody(finalBody1); 
            mail1.setSubject(subject1);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 }); 
            trackSOLI.add(scope[0].Sales_Order__c);
        }
             
    }
    global void finish(Database.BatchableContext BC)
    {
        
    } 
    

}