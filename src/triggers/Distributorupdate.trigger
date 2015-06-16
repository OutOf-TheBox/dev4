trigger Distributorupdate on SBQQ__Quote__c (before insert, before update) {
SBQQ__Quote__c quo=trigger.new[0];
 system.debug('trigger.new.size()'+trigger.new.size());
 system.debug('Opp id--'+quo.SBQQ__Opportunity__r.id);
 system.debug('Opp id11--'+quo.SBQQ__Opportunity__c);
 System.debug('quo.SBQQ__Status__c------'+quo.SBQQ__Status__c); 
    opportunity opp=[select id, name, Reseller_Account__r.id, Reseller_Account__r.Distributor__c,Reseller_Account__r.Distributor_Email__c 
    , Reseller_Account__r.Distributor__r.name,
    Reseller_Account__r.Distributor__r.BillingStreet,
    Reseller_Account__r.Distributor__r.BillingCity,
     Reseller_Account__r.Distributor__r.BillingState,
     Reseller_Account__r.Distributor__r.BillingPostalCode,
     Reseller_Account__r.Distributor__r.BillingCountry,
    
   Reseller_Account__r.name,
    Reseller_Account__r.ShippingStreet,
    Reseller_Account__r.ShippingCity,
     Reseller_Account__r.ShippingState,
     Reseller_Account__r.ShippingPostalCode,
     Reseller_Account__r.ShippingCountry,
     
     Account.name,
    Account.ShippingStreet,
    Account.ShippingCity,
     Account.ShippingState,
     Account.ShippingPostalCode,
     Account.ShippingCountry,
                     
                   
   Account.BillingStreet,
 Account.BillingCity,
    Account.BillingState,
    Account.BillingPostalCode,
   Account.BillingCountry,
                     
                     
        Reseller_Account__r.BillingStreet,
        Reseller_Account__r.BillingCity,
        Reseller_Account__r.BillingState,
        Reseller_Account__r.BillingPostalCode,
        Reseller_Account__r.BillingCountry
     
     
    
    from opportunity where id=:quo.SBQQ__Opportunity__c limit 1];
    
    opportunitycontactrole[] opc=[Select Id, contactid from opportunitycontactrole where opportunityid=:quo.SBQQ__Opportunity__c and isprimary=True limit 1];
    
 if (opc.size() > 0)
 {
   quo.SBQQ__PrimaryContact__c=opc[0].contactid;
   }

quo.SBQQ__Partner__c=opp.Reseller_Account__r.id;
        quo.SBQQ__Distributor__c=opp.Reseller_Account__r.Distributor__c;
        quo.Distributor_Email__c=opp.Reseller_Account__r.Distributor_Email__c;


if (trigger.Isinsert)
{
    
        quo.SBQQ__Account__c=opp.Account.id;    
  
   
  
    
    if (quo.recordtypeid!='012S00000008wEUIAY')
    {
   if  (opp.Reseller_Account__r.Distributor__c!=null)
     {    
       //Populate bill to information on quote from distributor account
        quo.SBQQ__BillingName__c=opp.Reseller_Account__r.Distributor__r.name;
        quo.SBQQ__BillingStreet__c=opp.Reseller_Account__r.Distributor__r.BillingStreet;
        quo.SBQQ__BillingCity__c=opp.Reseller_Account__r.Distributor__r.BillingCity;
        quo.SBQQ__BillingState__c=opp.Reseller_Account__r.Distributor__r.BillingState;
        quo.SBQQ__BillingPostalCode__c=opp.Reseller_Account__r.Distributor__r.BillingPostalCode;
        quo.SBQQ__BillingCountry__c=opp.Reseller_Account__r.Distributor__r.BillingCountry;
        
        /*Additon By -
            Name- Jitender Singh Padda
            Project - Channel Quoting
            Company- Mansa Systems
        */
        /*
        //Start
        //Populate bill to information on quote from reseller account on to New Fields
        quo.Reseller_Bill_to_Name__c=opp.Reseller_Account__r.name;
        quo.Reseller_Bill_to_Street__c=opp.Reseller_Account__r.BillingStreet;
        quo.Reseller_Bill_to_City__c=opp.Reseller_Account__r.BillingCity;
        quo.Reseller_Bill_to_State__c=opp.Reseller_Account__r.BillingState;
        quo.Reseller_Bill_to_Postal_Code__c=opp.Reseller_Account__r.BillingPostalCode;
        quo.Reseller_Bill_to_Country__c=opp.Reseller_Account__r.BillingCountry; 
        //Finish
        */
        }
        if  (opp.Reseller_Account__r.Distributor__c==null)
        {
        
           //Populate bill to information on quote from reseller account
        quo.SBQQ__BillingName__c=opp.Reseller_Account__r.name;
        quo.SBQQ__BillingStreet__c=opp.Reseller_Account__r.BillingStreet;
        quo.SBQQ__BillingCity__c=opp.Reseller_Account__r.BillingCity;
        quo.SBQQ__BillingState__c=opp.Reseller_Account__r.BillingState;
        quo.SBQQ__BillingPostalCode__c=opp.Reseller_Account__r.BillingPostalCode;
        quo.SBQQ__BillingCountry__c=opp.Reseller_Account__r.BillingCountry;
        
        } }
        
        //Populate ship to information on quote from account ship to
        quo.SBQQ__ShippingName__c=opp.Account.name;
        quo.SBQQ__ShippingStreet__c=opp.Account.ShippingStreet;
        quo.SBQQ__ShippingCity__c=opp.Account.ShippingCity;
        quo.SBQQ__ShippingState__c=opp.Account.ShippingState;
        quo.SBQQ__ShippingPostalCode__c=opp.Account.ShippingPostalCode;
        quo.SBQQ__ShippingCountry__c=opp.Account.ShippingCountry;
        
    //Populate sold to to information on quote from account bill to
    quo.Sold_To_Name__c=opp.Account.name;
    quo.Sold_To_Street__c=opp.Account.BillingStreet;
    quo.Sold_To_City__c=opp.Account.BillingCity;
    quo.Sold_To_State__c=opp.Account.BillingState;
    quo.Sold_To_Postal_Code__c=opp.Account.BillingPostalCode;
    quo.Sold_To_Country__c=opp.Account.BillingCountry;
    
}
    /*Additon By -
            Name- Jitender Singh Padda
            Project - Channel Quoting
            Company- Mansa Systems
    */
    //Start
    //To Set Partner Information to Quote
    ID DistiProfileID=[Select ID from Profile where name='NS-SALES-PartnerPortal-Disti-Manage-Quotes'].Id;
    if(Userinfo.getProfileId()==DistiProfileID){
        for(SBQQ__Quote__c quote: Trigger.new){
            quote.Partner_Owner__c=Userinfo.getUserId();
            quote.Partner_Community_Quote__c=true;
        }
    }
    //To set Quote Source
    if(Trigger.isInsert){
        if(UserInfo.getUserType()=='PowerPartner'){
            for(SBQQ__Quote__c quote: Trigger.new){
                quote.Quote_Source__c='Indirect';
            }
        }
        else {
              for(SBQQ__Quote__c quote: Trigger.new){
                  quote.Quote_Source__c='Direct';
             }
        }
    }
    //To Set Quote Status according to Discounts on Update
    if(Trigger.isUpdate){
       //ID DistiProfileID=[Select ID from Profile where name='NS-SALES-PartnerPortal-Disti-Manage-Quotes'].Id;
        if(Userinfo.getProfileId()==DistiProfileID){
            for(SBQQ__Quote__c quote: Trigger.new){
                if(quote.SBQQ__Status__c=='Draft' || quote.SBQQ__Status__c=='Orderable' || quote.SBQQ__Status__c=='Accepted' || quote.SBQQ__Status__c=='Rejected' || quote.SBQQ__Status__c=='Recalled'){
                    if(quote.No_of_quote_lines__c >0){   
                        if(quote.Total_Discount_Percent_Hardware__c<=49.25 && quote.Total_Discount_Percent_Support__c<=23){
                            if(Trigger.oldMap.get(quote.ID).Total_Discount_Percent_Hardware__c!=quote.Total_Discount_Percent_Hardware__c || Trigger.oldMap.get(quote.ID).Total_Discount_Percent_Support__c!=quote.Total_Discount_Percent_Support__c){
                                    quote.SBQQ__Status__c='Accepted';
                                }   
                                
                            }
                        else if(quote.Total_Discount_Percent_Hardware__c>49.25 || quote.Total_Discount_Percent_Support__c>23){
                                if(Trigger.oldMap.get(quote.ID).Total_Discount_Percent_Hardware__c!=quote.Total_Discount_Percent_Hardware__c || Trigger.oldMap.get(quote.ID).Total_Discount_Percent_Support__c!=quote.Total_Discount_Percent_Support__c){
                                    quote.SBQQ__Status__c='Orderable';
                                    quote.Quote_Reviewed__c=false;
                                    System.debug('Trigger.oldMap.get(quote.ID).SBQQ__Status__c====='+Trigger.oldMap.get(quote.ID).SBQQ__Status__c);
                                    System.debug('quote@@@@@@'+quote);
                                    /* //To Send Email to Sales Rep for Approval
                                    if(quote.Quote_Line_Incomplete_Rollup__c >0 && quote.SBQQ__LineItemCount__c >0 && Trigger.oldMap.get(quote.ID).SBQQ__Status__c!='Orderable' && quote.SBQQ__Status__c=='Orderable'){
                                        ID tempID=[Select ID from EmailTemplate where developerName='New_Quote_Submission_on_Portal_Alert'].ID;
                                        Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
                                        email.setTemplateId(tempID);
                                        email.setTargetObjectId(quote.SBQQ__SalesRep__c);
                                        email.setWhatId(quote.ID);
                                        email.setReplyTo('channelquoteemailservice@x-2f8gxz3mas2x39cwd0pp6yhwvw7hkovryn422n9hbcnkmkg6v3.n-dxjyeas.cs30.apex.sandbox.salesforce.com');
                                        email.setSaveAsActivity(false); 
                                        Messaging.sendEmail(new List<Messaging.Singleemailmessage>{email});
                                    }*/
                               }
                                
                            
                        }
                        System.debug('quote------'+quote);
                    }
                }   
            }
        }
        //Quote Reviewed to be TRUE when Quote_Lines>0 && Quote_Status='DRAFT' && LastModifiedBy UserType()!='PowerPartner' for Sales Rep so Status='Accepted'
            Map<ID,SBQQ__Quote__c> LastModByUserIDQuoteMap=new Map<ID,SBQQ__Quote__c>();
            for(SBQQ__Quote__c quote: Trigger.new){
                if(quote.No_of_quote_lines__c >0 && quote.SBQQ__Status__c=='Draft'){
                   LastModByUserIDQuoteMap.put(quote.LastModifiedByID,quote);     
                }
                System.debug('quote.SBQQ__Status__c----'+quote.SBQQ__Status__c);
            }
            for(User u:[Select ID,Name,UserType from User where ID IN:LastModByUserIDQuoteMap.keyset()]){
                if(u.UserType!='PowerPartner'){
                    System.debug('u.name----'+u.name);
                    SBQQ__Quote__c q=LastModByUserIDQuoteMap.get(u.ID);
                    q.Quote_Reviewed__c=true;
                }
            }
        //To set Quote Status to Accepted when Quote Reviewed='TRUE' by Sales Rep
        if(UserInfo.getUserType()!='PowerPartner'){
            for(SBQQ__Quote__c quote: Trigger.new){
                if(quote.No_of_quote_lines__c >0 && (quote.SBQQ__Status__c=='Draft' || quote.SBQQ__Status__c=='Orderable' || quote.SBQQ__Status__c=='Accepted' || quote.SBQQ__Status__c=='Rejected' || quote.SBQQ__Status__c=='Recalled')){
                   if(quote.Quote_Reviewed__c==true ){
                       quote.SBQQ__Status__c='Accepted';
                   }     
                }
            }   
        }
        System.debug('UserInfo.getUserType()------'+UserInfo.getUserType());
        if(!System.Test.isRunningTest()){
        	//To make sure Quote Source and Partner Pricing are never blank
	        Map<ID,SBQQ__Quote__c> CreatedByUserIDQuoteMap=new Map<ID,SBQQ__Quote__c>();
	        for(SBQQ__Quote__c quote: Trigger.new){
	            if(quote.Quote_Source__c=='' || quote.Quote_Source__c==null){
	                CreatedByUserIDQuoteMap.put(quote.CreatedById ,quote);     
	            }
	            //Partner Pricing
	            if(quote.Field_Set_Scenario__c=='' || quote.Field_Set_Scenario__c==null){
	                quote.Field_Set_Scenario__c='Distributor Pricing';
	            }   
	        }
	        for(User u:[Select ID,Name,UserType from User where ID IN:CreatedByUserIDQuoteMap.keyset()]){
	        	SBQQ__Quote__c q=CreatedByUserIDQuoteMap.get(u.ID);
	        	if(u.UserType=='PowerPartner'){    
	                q.Quote_Source__c='Indirect';
	        	}  
	            else q.Quote_Source__c='Direct';
	        }
	        //Additonal Logic for OLD Quotes
	        for(SBQQ__Quote__c quote: Trigger.new){
	        	if(Userinfo.getProfileId()==DistiProfileID){
	        		if(quote.SBQQ__Status__c=='Draft' && quote.No_of_quote_lines__c >0 && quote.Total_Discount_Percent_Hardware__c<=49.25 && quote.Total_Discount_Percent_Support__c<=23){
		        		quote.SBQQ__Status__c='Accepted';
		        	}
		        	else if(quote.SBQQ__Status__c=='Draft' && quote.No_of_quote_lines__c >0 ){
		        			if(quote.Total_Discount_Percent_Hardware__c>49.25 || quote.Total_Discount_Percent_Support__c>23){
		        				quote.SBQQ__Status__c='Orderable';
		        			}
		        		 }
	        	}  	
	        }	
        }
        
    }  
    //Finish        
}