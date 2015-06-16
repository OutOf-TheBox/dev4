/*Written By -
            Name- Jitender Singh Padda
            Project - Channel Quoting
            Company- Mansa Systems
*/
public with sharing class approval_controller {
    ID QuoteID;
    SBQQ__Quote__c q;
    public Boolean Competitive_Pressures{get;set;}
    public Boolean New_Customer_Acquisition{get;set;}
    public Boolean Timeline_for_Closing{get;set;}
    public Boolean Customer_Satisfaction{get;set;}
    public Boolean Customer_Budget{get;set;}
    public Boolean Multi_Quote_Deal{get;set;}
    public Boolean Missing_Wrong_Part_on_Quote{get;set;}
    public Boolean Design_Sizing_Error{get;set;}
    public Boolean Match_Previous_Discounts{get;set;}
    public Boolean X100_Deal_Discount{get;set;}
    public String Comment{get;set;}
    
    public Boolean renderSaveSubmitButton{get;set;}
    public Boolean renderNewPanel{get;set;}
    public Boolean renderEditPanel{get;set;}
    public Boolean renderViewPanel{get;set;}
    public Boolean saveClicked;
    
    public approval_controller(ApexPages.StandardController controller) {
        QuoteID=controller.getId();
        q=[Select Id,SBQQ__Status__c from SBQQ__Quote__c where id=:QuoteID];
        
        //Partner Approval record already exists but create new as Status='Rejected' or Status='Recalled'
        if(q.SBQQ__Status__c=='Rejected' || q.SBQQ__Status__c=='Recalled'){
                List<Partner_Quote_Approval_Justification__c> pqajList=[Select ID from Partner_Quote_Approval_Justification__c where Quote__c=:QuoteId];
                if(pqajList.size()>0){
                     renderNewPanel=true;
                }
        }
        //Quote Status = ‘Approved’  and there is already a record then show Existing Record
        if(q.SBQQ__Status__c=='Approved'){
                List<Partner_Quote_Approval_Justification__c> pqajList=[Select ID,Competitive_Pressures__c,New_Customer_Acquisition__c,Timeline_for_Closing__c,Customer_Satisfaction__c,Customer_Budget__c,Multi_Quote_Deal__c,Missing_Wrong_Part_on_Quote__c,Design_Sizing_Error__c,Match_Previous_Discounts__c,X100_Deal_Discount__c,Comment__c from Partner_Quote_Approval_Justification__c where Quote__c=:QuoteId Order By CreatedDate DESC];
                if(pqajList.size()>0){
                        Competitive_Pressures=pqajList[0].Competitive_Pressures__c;
                                New_Customer_Acquisition=pqajList[0].New_Customer_Acquisition__c;
                                Timeline_for_Closing=pqajList[0].Timeline_for_Closing__c;
                                Customer_Satisfaction=pqajList[0].Customer_Satisfaction__c;
                                Customer_Budget=pqajList[0].Customer_Budget__c;
                                Multi_Quote_Deal=pqajList[0].Multi_Quote_Deal__c;
                                Missing_Wrong_Part_on_Quote=pqajList[0].Missing_Wrong_Part_on_Quote__c;
                                Design_Sizing_Error=pqajList[0].Design_Sizing_Error__c;
                                Match_Previous_Discounts=pqajList[0].Match_Previous_Discounts__c;
                                X100_Deal_Discount=pqajList[0].X100_Deal_Discount__c;
                                Comment=pqajList[0].Comment__c;
                    renderViewPanel=true;
                }//No record Exists then create New
                else renderNewPanel=true;
        }
        //Quote Status = ‘In Review’ or Status='Approval Pending' then, it should display the existing data to view
        if(q.SBQQ__Status__c=='In Review' || q.SBQQ__Status__c=='Approval Pending' || q.SBQQ__Status__c=='Approved'){
                List<Partner_Quote_Approval_Justification__c> pqajList=[Select ID,Competitive_Pressures__c,New_Customer_Acquisition__c,Timeline_for_Closing__c,Customer_Satisfaction__c,Customer_Budget__c,Multi_Quote_Deal__c,Missing_Wrong_Part_on_Quote__c,Design_Sizing_Error__c,Match_Previous_Discounts__c,X100_Deal_Discount__c,Comment__c from Partner_Quote_Approval_Justification__c where Quote__c=:QuoteId Order By CreatedDate DESC];
                if(pqajList.size()>0){
                        Competitive_Pressures=pqajList[0].Competitive_Pressures__c;
                                New_Customer_Acquisition=pqajList[0].New_Customer_Acquisition__c;
                                Timeline_for_Closing=pqajList[0].Timeline_for_Closing__c;
                                Customer_Satisfaction=pqajList[0].Customer_Satisfaction__c;
                                Customer_Budget=pqajList[0].Customer_Budget__c;
                                Multi_Quote_Deal=pqajList[0].Multi_Quote_Deal__c;
                                Missing_Wrong_Part_on_Quote=pqajList[0].Missing_Wrong_Part_on_Quote__c;
                                Design_Sizing_Error=pqajList[0].Design_Sizing_Error__c;
                                Match_Previous_Discounts=pqajList[0].Match_Previous_Discounts__c;
                                X100_Deal_Discount=pqajList[0].X100_Deal_Discount__c;
                                Comment=pqajList[0].Comment__c;
                        renderViewPanel=true;
                }       
        }
        //Quote Status !=  (‘Approved’, ‘Rejected’, ‘Recalled’)  then it should query the latest record and allow to update
        if(q.SBQQ__Status__c!='Approved' && q.SBQQ__Status__c!='Rejected' && q.SBQQ__Status__c!='Recalled' && q.SBQQ__Status__c!='In Review' && q.SBQQ__Status__c!='Approval Pending'){
                List<Partner_Quote_Approval_Justification__c> pqajList=[Select ID,Competitive_Pressures__c,New_Customer_Acquisition__c,Timeline_for_Closing__c,Customer_Satisfaction__c,Customer_Budget__c,Multi_Quote_Deal__c,Missing_Wrong_Part_on_Quote__c,Design_Sizing_Error__c,Match_Previous_Discounts__c,X100_Deal_Discount__c,Comment__c from Partner_Quote_Approval_Justification__c where Quote__c=:QuoteId Order By CreatedDate DESC];
                if(pqajList.size()>0){
                        Competitive_Pressures=pqajList[0].Competitive_Pressures__c;
                                New_Customer_Acquisition=pqajList[0].New_Customer_Acquisition__c;
                                Timeline_for_Closing=pqajList[0].Timeline_for_Closing__c;
                                Customer_Satisfaction=pqajList[0].Customer_Satisfaction__c;
                                Customer_Budget=pqajList[0].Customer_Budget__c;
                                Multi_Quote_Deal=pqajList[0].Multi_Quote_Deal__c;
                                Missing_Wrong_Part_on_Quote=pqajList[0].Missing_Wrong_Part_on_Quote__c;
                                Design_Sizing_Error=pqajList[0].Design_Sizing_Error__c;
                                Match_Previous_Discounts=pqajList[0].Match_Previous_Discounts__c;
                                X100_Deal_Discount=pqajList[0].X100_Deal_Discount__c;
                                Comment=pqajList[0].Comment__c;
                    renderEditPanel=true;
                }
                else renderNewPanel=true;    
        }
        //Save Submit Button Render Conditions
        if(q.SBQQ__Status__c!='Approved' && q.SBQQ__Status__c!='In Review' && q.SBQQ__Status__c!='Approval Pending'){
            renderSaveSubmitButton=true;
        }
        /*if(q.SBQQ__Status__c=='Approved'){
                List<Partner_Quote_Approval_Justification__c> pqajList=[Select ID from Partner_Quote_Approval_Justification__c where Quote__c=:QuoteId];
            if(pqajList.size()==0){
                renderSaveSubmitButton=true;
            }
        }*/
    }
    public Pagereference SaveRecord(){
        saveClicked=true;
        List<Partner_Quote_Approval_Justification__c> pqajList=[Select ID,Competitive_Pressures__c,New_Customer_Acquisition__c,Timeline_for_Closing__c,Customer_Satisfaction__c,Customer_Budget__c,Multi_Quote_Deal__c,Missing_Wrong_Part_on_Quote__c,Design_Sizing_Error__c,Match_Previous_Discounts__c,X100_Deal_Discount__c,Comment__c from Partner_Quote_Approval_Justification__c where Quote__c=:QuoteId Order By CreatedDate DESC];
        if(pqajList.size()>0 && (q.SBQQ__Status__c!='Rejected' && q.SBQQ__Status__c!='Recalled')){
                pqajList[0].Competitive_Pressures__c=Competitive_Pressures;
                pqajList[0].New_Customer_Acquisition__c=New_Customer_Acquisition;
                pqajList[0].Timeline_for_Closing__c=Timeline_for_Closing;
                pqajList[0].Customer_Satisfaction__c=Customer_Satisfaction;
                pqajList[0].Customer_Budget__c=Customer_Budget;
                pqajList[0].Multi_Quote_Deal__c=Multi_Quote_Deal;
                pqajList[0].Missing_Wrong_Part_on_Quote__c=Missing_Wrong_Part_on_Quote;
                pqajList[0].Design_Sizing_Error__c=Design_Sizing_Error;
                pqajList[0].Match_Previous_Discounts__c=Match_Previous_Discounts;
                pqajList[0].X100_Deal_Discount__c=X100_Deal_Discount;
                pqajList[0].Comment__c=Comment;
                update pqajList[0];
        }
        else{    
                Partner_Quote_Approval_Justification__c pqaj=new Partner_Quote_Approval_Justification__c();
                pqaj.Quote__c=QuoteID;
                pqaj.Competitive_Pressures__c=Competitive_Pressures;
                pqaj.New_Customer_Acquisition__c=New_Customer_Acquisition;
                pqaj.Timeline_for_Closing__c=Timeline_for_Closing;
                pqaj.Customer_Satisfaction__c=Customer_Satisfaction;
                pqaj.Customer_Budget__c=Customer_Budget;
                pqaj.Multi_Quote_Deal__c=Multi_Quote_Deal;
                pqaj.Missing_Wrong_Part_on_Quote__c=Missing_Wrong_Part_on_Quote;
                pqaj.Design_Sizing_Error__c=Design_Sizing_Error;
                pqaj.Match_Previous_Discounts__c=Match_Previous_Discounts;
                pqaj.X100_Deal_Discount__c=X100_Deal_Discount;
                pqaj.Comment__c=Comment;
                insert pqaj;
        } 
        return null;
    }
    public void Submit(){
        if(saveClicked!=true){
                SaveRecord();
        }
        SBQQ__Quote__c thisQuote=[Select ID,SBQQ__Status__c,SBQQ__Opportunity__r.ownerID,SBQQ__Opportunity__r.Sales_Area__c,Total_Discount_Percent_Support__c,Total_Discount_Percent_Hardware__c,Total_List_Price_Hardware__c from SBQQ__Quote__c where id=:QuoteID];
        //Update Quote Status according to conditions
        String salesRegion=thisQuote.SBQQ__Opportunity__r.Sales_Area__c;
        EmailTemplate etApprovedRep=[Select ID from EmailTemplate where name='Quote Approved from Initiate Approval'];
        EmailTemplate etApprovedDisti=[Select ID from EmailTemplate where name='Quote Approved'];
        ID EvalRecordType=[Select ID from RecordType where sObjectType='SBQQ__Quote__c' and developerName='Eval_Quote'].ID;
        ID EvalApprovedRecordType=[Select ID from RecordType where sObjectType='SBQQ__Quote__c' and developerName='Eval_Quote_Approved'].ID;
        ID StandardSalesRecordType=[Select ID from RecordType where sObjectType='SBQQ__Quote__c' and developerName='Standard_Sales_Quote'].ID;
        ID StandardSalesApprovedRecordType=[Select ID from RecordType where sObjectType='SBQQ__Quote__c' and developerName='Standard_Sales_Quote_Approved'].ID;
        ID SupportRenewalRecordType=[Select ID from RecordType where sObjectType='SBQQ__Quote__c' and developerName='Support_Renewal'].ID;
        ID SupportRenewalApprovedRecordType=[Select ID from RecordType where sObjectType='SBQQ__Quote__c' and developerName='Support_Renewal_Approved'].ID;
        if(thisQuote.Total_List_Price_Hardware__c<90000 && !salesRegion.startsWith('EMEA') && thisQuote.Total_Discount_Percent_Support__c<=23 && thisQuote.Total_Discount_Percent_Hardware__c<=55){
            thisQuote.SBQQ__Status__c='Approved';
            if(thisQuote.RecordTypeId==EvalRecordType){
                thisQuote.RecordTypeId=EvalApprovedRecordType;              
            }
            else if(thisQuote.RecordTypeId==StandardSalesRecordType){
                    thisQuote.RecordTypeId=StandardSalesApprovedRecordType;
            }
            else if(thisQuote.RecordTypeId==SupportRenewalRecordType){
                    thisQuote.RecordTypeId=SupportRenewalApprovedRecordType;
            }
            Update thisQuote;
            //Email to Opportunity Owner/Sales Rep
            Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
            email.setTemplateId(etApprovedRep.Id);
            email.setTargetObjectId(thisQuote.SBQQ__Opportunity__r.ownerID);
            email.setWhatId(QuoteID);
            email.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
            //Email to Distributor
            /*Messaging.Singleemailmessage DistiEmail=new Messaging.Singleemailmessage();
            DistiEmail.setTemplateId(etApprovedDisti.Id);
            DistiEmail.setTargetObjectId(UserInfo.getUserId());
            DistiEmail.setWhatId(QuoteID);
            DistiEmail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.Singleemailmessage[]{DistiEmail});*/    
        }
        else if(thisQuote.Total_List_Price_Hardware__c>90000 && !salesRegion.startsWith('EMEA') && thisQuote.Total_Discount_Percent_Support__c<=23 && thisQuote.Total_Discount_Percent_Hardware__c<=52){
                 thisQuote.SBQQ__Status__c='Approved';
                 if(thisQuote.RecordTypeId==EvalRecordType){
                    thisQuote.RecordTypeId=EvalApprovedRecordType;              
                 }
                 else if(thisQuote.RecordTypeId==StandardSalesRecordType){
                        thisQuote.RecordTypeId=StandardSalesApprovedRecordType;
                 }
                 else if(thisQuote.RecordTypeId==SupportRenewalRecordType){
                        thisQuote.RecordTypeId=SupportRenewalApprovedRecordType;
                 }
                 Update thisQuote;
                 //Email to Opportunity Owner/Sales Rep
                 Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
                 email.setTemplateId(etApprovedRep.Id);
                 email.setTargetObjectId(thisQuote.SBQQ__Opportunity__r.ownerID);
                 email.setWhatId(QuoteID);
                 email.setSaveAsActivity(false);
                 Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
                 //Email to Distributor
                 /*Messaging.Singleemailmessage DistiEmail=new Messaging.Singleemailmessage();
                 DistiEmail.setTemplateId(etApprovedDisti.Id);
                 DistiEmail.setTargetObjectId(UserInfo.getUserId());
                 DistiEmail.setWhatId(QuoteID);
                 DistiEmail.setSaveAsActivity(false);
                 Messaging.sendEmail(new Messaging.Singleemailmessage[]{DistiEmail});*/   
             } else if(thisQuote.Total_List_Price_Hardware__c<90000 && salesRegion.startsWith('EMEA') && thisQuote.Total_Discount_Percent_Support__c<=23 && thisQuote.Total_Discount_Percent_Hardware__c<=55){
                        thisQuote.SBQQ__Status__c='Approved';
                        if(thisQuote.RecordTypeId==EvalRecordType){
                            thisQuote.RecordTypeId=EvalApprovedRecordType;              
                        }
                        else if(thisQuote.RecordTypeId==StandardSalesRecordType){
                                thisQuote.RecordTypeId=StandardSalesApprovedRecordType;
                        }
                        else if(thisQuote.RecordTypeId==SupportRenewalRecordType){
                                thisQuote.RecordTypeId=SupportRenewalApprovedRecordType;
                        }
                        Update thisQuote;
                        //Email to Opportunity Owner/Sales Rep
                            Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
                            email.setTemplateId(etApprovedRep.Id);
                            email.setTargetObjectId(thisQuote.SBQQ__Opportunity__r.ownerID);
                            email.setWhatId(QuoteID);
                            email.setSaveAsActivity(false);
                            Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
                            //Email to Distributor
                            /*Messaging.Singleemailmessage DistiEmail=new Messaging.Singleemailmessage();
                            DistiEmail.setTemplateId(etApprovedDisti.Id);
                            DistiEmail.setTargetObjectId(UserInfo.getUserId());
                            DistiEmail.setWhatId(QuoteID);
                            DistiEmail.setSaveAsActivity(false);
                            Messaging.sendEmail(new Messaging.Singleemailmessage[]{DistiEmail});*/    
                    } else{
                            thisQuote.SBQQ__Status__c='Approval Pending';
                            Update thisQuote;
                            //Email to Opportunity Owner/Sales Rep
                            Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
                            EmailTemplate etPendingRep=[Select ID from EmailTemplate where name='Quote Pending Approval for Sales Reps'];
                            email.setTemplateId(etPendingRep.Id);
                            System.debug('thisQuote.SBQQ__Opportunity__r.ownerID----'+thisQuote.SBQQ__Opportunity__r.ownerID);
                            System.debug('QuoteID----'+QuoteID);
                            email.setTargetObjectId(thisQuote.SBQQ__Opportunity__r.ownerID);
                            email.setWhatId(QuoteID);
                            email.setSaveAsActivity(false);
                            System.debug('email----'+email);
                            Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
                            //Email to Distributor
                            /*Messaging.Singleemailmessage DistiEmail=new Messaging.Singleemailmessage();
                            EmailTemplate etPendingDisti=[Select ID from EmailTemplate where name='Quote Pending Approval'];
                            DistiEmail.setTemplateId(etPendingDisti.Id);
                            DistiEmail.setTargetObjectId(UserInfo.getUserId());
                            DistiEmail.setWhatId(QuoteID);
                            DistiEmail.setSaveAsActivity(false);
                            Messaging.sendEmail(new Messaging.Singleemailmessage[]{DistiEmail});*/
        }              
    }
}