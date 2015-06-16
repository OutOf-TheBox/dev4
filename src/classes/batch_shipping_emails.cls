global with sharing class batch_shipping_emails implements Database.Stateful,Database.Batchable<sObject>
{
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
    	    
        if(trackSOLI.contains(scope[0].Tracking_Number__c))
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
            
            
            
            list<Sales_Order_Line__c>Salc=[Select id,item__c,BOM_Line_Number__c ,Start_Date__c,End_Date__c,Actual_Shipping_Date__c,Tracking_Number__c,Shipping_Agent_Link__c,Shipping_Agent__c,Quantity__c,Serial_Number__c from Sales_Order_Line__c where Tracking_Number__c=:scope[0].Tracking_Number__c and Shipping_Email_Indicator__c=false];
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
                
                
          
                   
            /*String startDate;
            if(String.valueof(salc[0].Start_Date__c)!=null)
                startDate=String.valueof(Salc[0].Start_Date__c);
            else
                startDate=String.valueof('');
                
            String endDate;
            if(String.valueof(salc[0].End_Date__c)!=null)
                endDate=String.valueof(Salc[0].End_Date__c);
            else
                endDate=String.valueof('');*/
                
                
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
            
            
            if(soRec.Ship_To_Country__c!=null && (soRec.Ship_To_Country__c=='Japan' || soRec.Ship_To_Country__c=='JP' || soRec.Ship_To_Country__c=='JPN') )
            {
                emailList.add('tsc-nimble-contract@it-serve.co.jp');
                //emailList.add('naman.bhardwaj@mansasys.com');
            }
            
            
            OrgWideEmailAddress replyEmail = [SELECT ID, DisplayName FROM OrgWideEmailAddress WHERE Address =:'logistics@nimblestorage.com'];
            
             
          //  List<String> ccAddress=new List<String>(); 
            ccAddress.add([select Email from User where Id = :soRec.OwnerId].Email);    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailList);
            mail.setCcAddresses(ccAddress);
            //mail.setToAddresses(new string[]{'naman.bhardwaj@mansasys.com'});
            mail.setOrgWideEmailAddressId(replyEmail.Id);
            
            String subject='Shipment Notification for '+SoNumber+'-'+oppAccName+' on: '+actualShippingDate;
            String firstBody='The following shipment was made today:<br/><br/>';  
            String beforeBody='<table width="80%"><tr><td width="25%">Customer :</td><td width="25%">'+oppAccName+'</td></tr><tr><td width="25%">PO Number :</td><td width="25%">'+poNumber+'</td></tr><tr><td width="25%">Sales Order:</td><td>'+SoNumber+'</td></tr><tr><td width="25%">SO Type :</td><td width="25%">'+soRec.Type__c+'</td></tr><tr><td width="25%">Opportunity :</td><td width="25%"><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/' +oppRecID+'>'+oppRName+'</a></td></tr><tr><td width="25%">Shipping Method: </td><td>'+shippingAgentServiceCode+'</td></tr><tr><td width="25%">Carrier:</td><td><a href='+shippingagentLink+'>'+shippingagent+'</a>'+'</td></tr><tr><td width="25%">HAWB#:</td><td> '+Salc[0].Tracking_Number__c+'<td></tr></table><br/>';
            String afterBeforeBody ='<table width="80%"><tr><td width="25%">Shipped To:</td><td>'+shiptoContactName+'</td></tr><tr><td width="25%"></td><td>'+shiptoAddress1+'</td></tr><tr><td width="25%"></td><td>'+shiptoAddress2+'</td></tr><tr><td width="25%"></td><td >'+shiptoCity+', '+shiptoState+' '+zippostalCode+'</td></tr><tr><td width="25%"></td><td>'+shiptoCountry+'</td></tr></table><br/>';
            String afterBeforeBody2 ='<table width="80%"><tr><td width="25%">ATTN:</td><td>'+shiptoContactName+'</td><tr><td width="25%"></td><td>'+shiptoContactPhone+'</td></tr><tr><td width="25%"></td><td>'+shiptoContactEmail+'</td></tr></table><br/>'; 
            
            
            String lastMsg= '<table width="80%"><tr><td>If visible loss or damage is apparent at the time of delivery, it should be noted and recorded in detail on the delivery receipt provided by the freight carrier making the delivery. As the recipient, it is your duty to carefully identify, inspect and document loss and/or damage on the delivery receipt at time of delivery.  Nimble Storage cannot be held liable for loss and damages reported after signing for the goods in good order.  Please report any sign of damage to Nimble Storage immediately. </td></tr></table><br/>';
            String lastMsg3= '<table width="80%"><tr><td>This email herby confirms that the above shipment has Nimble Storage’s Support and Maintenance Services as listed above.</td></tr><tr><td>Support for such product(s) will be provided in accordance with Nimble Storage’s standard support terms and conditions set forth at: http://www.nimblestorage.com/docs/Nimble-Storage-Terms-of-Sale-and-Support.pdf</td></tr><br/><tr><td>Should you have any additional questions, please feel free to contact us by phone at +1-408-432-9600x2 or by email at support@nimblestorage.com.</td></tr><br/><tr><td>For customer purchasing product shipping into Japan, Toshiba IT-Services Corporation (TSC) will be your primary Support and Service provider. TSC is an authorized Nimble service provider.</td></tr><br/><tr><td>Contact information: TSC Support Helpdesk: +81 120 926 388 or TSC Support E-mail: TSC-nimble-helpdesk@it-serve.co.jp.</td></tr><br/><tr><td>For additional support tools, please visit InfoSight at https://infosight.nimblestorage.com/.</td></tr><br/><tr><td>For an overview of InfoSight, please go to http://www.nimblestorage.com/infosight/overview.php.</td></tr></table><br/>';
            
            String afterBeforeBody3= '<table width="80%"><tr><td>If you have any questions about the shipment of your order, please contact us at logistics@nimblestorage.com.</td></tr></table><br/>';
            
              //  String body='<tr><th style="border:1px solid #000000;" width="10%" >Item</th><th style="border:1px solid #000000;" width="16%" >Quantity</th><th style="border:1px solid #000000;" width="16%" >Serial Number</th><th style="border:1px solid #000000;" width="16%" >Support Dates</th></tr>';            
                string body='';
                String trackNo1;
                integer p=1;
                for(Sales_Order_Line__c sOLines:Salc)
                {
                	system.debug('sOLines.BOM_Line_Number__c------BOM_Line_Number__c---------------'+sOLines.BOM_Line_Number__c);
                	system.debug('sOLines------------------'+sOLines.Id+sOLines.BOM_Line_Number__c);
                	string bom='';
                	if(sOLines.BOM_Line_Number__c!=null && sOLines.BOM_Line_Number__c!='')
                	{
                	bom=sOLines.BOM_Line_Number__c;
                	system.debug('bom-----'+bom);
                	if(!bom.contains('.'))
                	{
                		if(p==1)
                		{
			                body='<tr><th style="border:1px solid #000000;" width="10%" >Item</th><th style="border:1px solid #000000;" width="16%" >Quantity</th><th style="border:1px solid #000000;" width="16%" >Serial Number</th><th style="border:1px solid #000000;" width="16%" >Support Dates</th></tr>';            
                			p=2;
                		}
                		system.debug('bom-----'+bom);
                		
                    if(sOLines.Serial_Number__c!=null)
                        trackNo1=sOLines.Serial_Number__c;
                    else
                        trackNo1='';
                        
                        
                    String startDate;
                    if(String.valueof(sOLines.Start_Date__c)!=null)
                        startDate=String.valueof(sOLines.Start_Date__c);
                    else
                        startDate=String.valueof('');
                
                    String endDate;
                    if(String.valueof(sOLines.End_Date__c)!=null)
                        endDate=String.valueof(sOLines.End_Date__c);
                    else
                        endDate=String.valueof('');     
                        
                 
                  body+='<tr><td style="width:30%;border:1px solid #000000;">'+sOLines.item__c+'</td><td style="width:10%;border:1px solid #000000;">'+sOLines.Quantity__c+'</td><td style="width:20%;border:1px solid #000000;">'+trackNo1+'</td><td style="width:30%;border:1px solid #000000;">'+startDate+' - '+endDate+'</td></tr>';
                }
                	}
                	else
                	{
                		if(p==1)
                		{
			                body='<tr><th style="border:1px solid #000000;" width="10%" >Item</th><th style="border:1px solid #000000;" width="16%" >Quantity</th><th style="border:1px solid #000000;" width="16%" >Serial Number</th><th style="border:1px solid #000000;" width="16%" >Support Dates</th></tr>';            
                			p=2;
                		}
                		if(sOLines.Serial_Number__c!=null)
                        trackNo1=sOLines.Serial_Number__c;
                    else
                        trackNo1='';
                        
                        
                    String startDate;
                    if(String.valueof(sOLines.Start_Date__c)!=null)
                        startDate=String.valueof(sOLines.Start_Date__c);
                    else
                        startDate=String.valueof('');
                
                    String endDate;
                    if(String.valueof(sOLines.End_Date__c)!=null)
                        endDate=String.valueof(sOLines.End_Date__c);
                    else
                        endDate=String.valueof('');     
                        
                 
                  body+='<tr><td style="width:30%;border:1px solid #000000;">'+sOLines.item__c+'</td><td style="width:10%;border:1px solid #000000;">'+sOLines.Quantity__c+'</td><td style="width:20%;border:1px solid #000000;">'+trackNo1+'</td><td style="width:30%;border:1px solid #000000;">'+startDate+' - '+endDate+'</td></tr>';
                
                		
                	}
                }

            String finalBody=firstBody+beforeBody+afterBeforeBody+afterBeforeBody2+lastMsg+afterBeforeBody3+'<table style="border:1px solid #000000;border-collapse:collapse;" cellpadding="2" cellspacing="2" width="70%">'+body+'</table><br/>'+lastMsg3;
            System.debug('---------finalBody--------'+finalBody);
            mail.setHtmlBody(finalBody); 
            mail.setSubject(subject);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
           
          
           
            /******************************Internal Email Template************************************************/
            
           List<String> emailList1=new List<String>(); 
           emailList1.add([select Email from User where Id = :soRec.OwnerId].Email); 
           emailList1.add('logistics@nimblestorage.com');
           emailList1.add('sales.Orders@nimblestorage.com');
           
           if(opteam.size()>0)
        	{ 
            	for(OpportunityTeamMember opt:opteam)
            	{               
                	emailList1.add(opt.user.email);
            	}
        	}
           
            
            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            mail1.setToAddresses(emailList1);  
                //mail1.setToAddresses(new string[]{'naman.bhardwaj@mansasys.com'});                                 
            //mail1.setCcAddresses(ccAddress);

            mail1.setOrgWideEmailAddressId(replyEmail.Id);
            String subject1='Shipment Notification for '+SoNumber+'-'+oppAccName+' on: '+actualShippingDate;
            String firstBody1='The following shipment was made today:<br/><br/>';  
            String beforeBody1='<table width="80%"><tr><td width="25%">Customer :</td><td width="25%">'+oppAccName+'</td></tr><tr><td width="25%">PO Number :</td><td width="25%">'+poNumber+'</td></tr><tr><td width="25%">Sales Order:</td><td><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/' +recId+'>'+SoNumber+'</a></td></tr><tr><td width="25%">SO Type: </td><td>'+soRec.Type__c+'</td></tr><tr><td width="25%">Opportunity :</td><td width="40%"><a href='+URL.getSalesforceBaseUrl().toExternalForm()+'/' +oppRecID+'>'+oppRName+'</a></td></tr><tr><td width="25%">Shipping Method: </td><td> '+shippingAgentServiceCode+'</td></tr><tr><td width="25%">Carrier:</td><td><a href='+shippingagentLink+'>'+shippingagent+'</a>'+'</td></tr><tr><td width="25%">HAWB#:</td><td> '+Salc[0].Tracking_Number__c+'<td></tr></table><br/>';
            String afterBeforeBody1 ='<table width="80%"><tr><td width="25%">Shipped To:</td><td >'+shiptoContactName+'</td></tr><tr><td width="25%"></td><td >'+shiptoAddress1+'</td></tr><tr><td width="25%"></td><td>'+shiptoAddress2+'</td></tr><tr><td width="25%"></td><td >'+shiptoCity+', '+shiptoState+' '+zippostalCode+'</td></tr><tr><td width="25%"></td><td>'+shiptoCountry+'</td></tr></table><br/>';
            String afterBeforeBody21 ='<table width="80%"><tr><td width="25%">ATTN:</td><td>'+shiptoContactName+'</td><tr><td width="25%"></td><td>'+shiptoContactPhone+'</td></tr><tr><td width="25%"></td><td>'+shiptoContactEmail+'</td></tr></table><br/>'; 
                
                String lastMsg1= '<table width="80%"><tr><td>If visible loss or damage is apparent at the time of delivery, it should be noted and recorded in detail on the delivery receipt provided by the freight carrier making the delivery. As the recipient, it is your duty to carefully identify, inspect and document loss and/or damage on the delivery receipt at time of delivery.  Nimble Storage cannot be held liable for loss and damages reported after signing for the goods in good order.  Please report any sign of damage to Nimble Storage immediately. </td></tr></table><br/>';
                String lastMsg2= '<table width="80%"><tr><td>This email herby confirms that the above shipment has Nimble Storage’s Support and Maintenance Services as listed above.</td></tr><tr><td>Support for such product(s) will be provided in accordance with Nimble Storage’s standard support terms and conditions set forth at: http://www.nimblestorage.com/docs/Nimble-Storage-Terms-of-Sale-and-Support.pdf</td></tr><br/><tr><td>Should you have any additional questions, please feel free to contact us by phone at +1-408-432-9600x2 or by email at support@nimblestorage.com.</td></tr><br/><tr><td>For customer purchasing product shipping into Japan, Toshiba IT-Services Corporation (TSC) will be your primary Support and Service provider. TSC is an authorized Nimble service provider.</td></tr><br/><tr><td>Contact information: TSC Support Helpdesk: +81 120 926 388 or TSC Support E-mail: TSC-nimble-helpdesk@it-serve.co.jp.</td></tr><br/><tr><td>For additional support tools, please visit InfoSight at https://infosight.nimblestorage.com/.</td></tr><br/><tr><td>For an overview of InfoSight, please go to http://www.nimblestorage.com/infosight/overview.php.</td></tr></table><br/>';
               // String body1='<tr><th style="border:1px solid #000000;" width="10%" >Item</th><th style="border:1px solid #000000;" width="16%" >Quantity</th><th style="border:1px solid #000000;" width="16%" >Serial Number</th><th style="border:1px solid #000000;" width="16%" >Support Dates</th></tr>';            
                 
                 string body1='';
                 String trackNo;
                integer i=1;
                for(Sales_Order_Line__c sOLines:Salc)
                {
                	                	system.debug('inside loop-----------------------');
                	                	                	system.debug('sOLines.BOM_Line_Number__c---------------------'+sOLines.BOM_Line_Number__c);
                	
                	string bom='';
                	if(sOLines.BOM_Line_Number__c!=null && sOLines.BOM_Line_Number__c!='')
                	{                		
                	bom=sOLines.BOM_Line_Number__c;
                	if(!bom.contains('.'))
                	{
                		if(i==1)
                		{
			                body1='<tr><th style="border:1px solid #000000;" width="10%" >Item</th><th style="border:1px solid #000000;" width="16%" >Quantity</th><th style="border:1px solid #000000;" width="16%" >Serial Number</th><th style="border:1px solid #000000;" width="16%" >Support Dates</th></tr>';            
                			i=2;
                		}
                	system.debug('inside loop----------');
                    if(sOLines.Serial_Number__c!=null)
                        trackNo=sOLines.Serial_Number__c;
                    else
                        trackNo='';     
                        
                     String startDate;
                    if(String.valueof(sOLines.Start_Date__c)!=null)
                        startDate=String.valueof(sOLines.Start_Date__c);
                    else
                        startDate=String.valueof('');
                
                    String endDate;
                    if(String.valueof(sOLines.End_Date__c)!=null)
                        endDate=String.valueof(sOLines.End_Date__c);
                    else
                        endDate=String.valueof('');      
                        
                        
                  body1+='<tr><td style="width:30%;border:1px solid #000000;">'+sOLines.item__c+'</td><td style="width:10%;border:1px solid #000000;">'+sOLines.Quantity__c+'</td><td style="width:20%;border:1px solid #000000;">'+trackNo+'</td><td style="width:30%;border:1px solid #000000;">'+startDate+' - '+endDate+'</td></tr>';
                	}
                	}
                	else
                	{
                		if(i==1)
                		{
			                body1='<tr><th style="border:1px solid #000000;" width="10%" >Item</th><th style="border:1px solid #000000;" width="16%" >Quantity</th><th style="border:1px solid #000000;" width="16%" >Serial Number</th><th style="border:1px solid #000000;" width="16%" >Support Dates</th></tr>';            
                			i=2;
                		}
                		if(sOLines.Serial_Number__c!=null)
                        trackNo=sOLines.Serial_Number__c;
                    else
                        trackNo='';     
                        
                     String startDate;
                    if(String.valueof(sOLines.Start_Date__c)!=null)
                        startDate=String.valueof(sOLines.Start_Date__c);
                    else
                        startDate=String.valueof('');
                
                    String endDate;
                    if(String.valueof(sOLines.End_Date__c)!=null)
                        endDate=String.valueof(sOLines.End_Date__c);
                    else
                        endDate=String.valueof('');      
                        
                        
                  body1+='<tr><td style="width:30%;border:1px solid #000000;">'+sOLines.item__c+'</td><td style="width:10%;border:1px solid #000000;">'+sOLines.Quantity__c+'</td><td style="width:20%;border:1px solid #000000;">'+trackNo+'</td><td style="width:30%;border:1px solid #000000;">'+startDate+' - '+endDate+'</td></tr>';
                	
                		
                	}
                }
            String finalBody1=firstBody1+beforeBody1+afterBeforeBody1+afterBeforeBody21+lastMsg1+'<table style="border:1px solid #000000;border-collapse:collapse;" cellpadding="2" cellspacing="2" width="70%">'+body+'</table><br/>'+lastMsg2;
            mail1.setHtmlBody(finalBody1); 
            mail1.setSubject(subject1);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 }); 
            trackSOLI.add(scope[0].Tracking_Number__c);
        }
            
    }
    global void finish(Database.BatchableContext BC)
    {
        
    } 
}