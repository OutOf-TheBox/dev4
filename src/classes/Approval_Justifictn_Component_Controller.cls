public with sharing class Approval_Justifictn_Component_Controller {
    public ID QuoteID{get;set;}
    public Boolean Competitive_Pressures;
    public Boolean New_Customer_Acquisition;
    public Boolean Timeline_for_Closing;
    public Boolean Customer_Satisfaction;
    public Boolean Customer_Budget;
    public Boolean Multi_Quote_Deal;
    public Boolean Missing_Wrong_Part_on_Quote;
    public Boolean Design_Sizing_Error;
    public Boolean Match_Previous_Discounts;
    public Boolean X100_Deal_Discount;
    public String Comment;
    public Boolean getCompetitive_Pressures(){
        try{
        Partner_Quote_Approval_Justification__c pqaj=[Select ID,Competitive_Pressures__c,X100_Deal_Discount__c,Comment__c,Customer_Budget__c,Customer_Satisfaction__c,Design_Sizing_Error__c,Match_Previous_Discounts__c,Missing_Wrong_Part_on_Quote__c,Multi_Quote_Deal__c,New_Customer_Acquisition__c,Timeline_for_Closing__c from Partner_Quote_Approval_Justification__c where Quote__c=:QuoteID Order By CreatedDate DESC Limit 1];
         Competitive_Pressures=pqaj.Competitive_Pressures__c;
         New_Customer_Acquisition=pqaj.New_Customer_Acquisition__c;
         Timeline_for_Closing=pqaj.Timeline_for_Closing__c;
         Customer_Satisfaction=pqaj.Customer_Satisfaction__c;
         Customer_Budget=pqaj.Customer_Budget__c;
         Multi_Quote_Deal=pqaj.Multi_Quote_Deal__c;
         Missing_Wrong_Part_on_Quote=pqaj.Missing_Wrong_Part_on_Quote__c;
         Design_Sizing_Error=pqaj.Design_Sizing_Error__c;
         Match_Previous_Discounts=pqaj.Match_Previous_Discounts__c;
         X100_Deal_Discount=pqaj.X100_Deal_Discount__c;
         Comment=pqaj.Comment__c;
        }catch(Exception e){}
        return Competitive_Pressures;
    }
    public Boolean getNew_Customer_Acquisition(){
        return New_Customer_Acquisition;
    }
    public Boolean getTimeline_for_Closing(){
        return Timeline_for_Closing;
    }
    public Boolean getCustomer_Satisfaction(){
        return Customer_Satisfaction;
    }
    public Boolean getCustomer_Budget(){
        return Customer_Budget;
    }
    public Boolean getMulti_Quote_Deal(){
        return Multi_Quote_Deal;
    }
    public Boolean getMissing_Wrong_Part_on_Quote(){
        return Missing_Wrong_Part_on_Quote;
    }
    public Boolean getDesign_Sizing_Error(){
        return Design_Sizing_Error;
    }
    public Boolean getMatch_Previous_Discounts(){
        return Match_Previous_Discounts;
    }
    public Boolean getX100_Deal_Discount(){
        return X100_Deal_Discount;
    }
    public String getComment(){
        return Comment;
    }
}