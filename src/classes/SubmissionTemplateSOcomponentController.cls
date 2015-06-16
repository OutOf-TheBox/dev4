public with sharing class SubmissionTemplateSOcomponentController {
    public ID SOid{get;set;}
    
    public list<Sales_Order_Line__c> getSOlines(){
    list<Sales_Order_Line__c> SOlinesList;
    /*Sales_Order__c SO;
    try{
    SO=[Select s.Type__c, s.Owner.Name, s.Name From Sales_Order__c s where s.Opportunity__c=:oppID and s.Type__c='Prebuild' limit 1];
    SOid=SO.Id;
    }catch(Exception e){}*/
    try{
    SOlinesList=[Select s.Sale_Price__c, s.Quantity__c, s.Product__r.Name, s.Package_Product_Code__c, s.Name, s.BOM_Line_Number__c From Sales_Order_Line__c s where s.Sales_Order__c=:SOid AND (NOT s.BOM_Line_Number__c LIKE '%.%')];
    }catch(Exception e){}
    System.debug('SOlinesList========'+SOlinesList);
    return SOlinesList;
}
}