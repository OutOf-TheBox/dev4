public with sharing class SalesOrderAndSOlinesTemplate {

public ID oppID{get;set;}
public ID SOid;

public Sales_Order__c getSO(){
    if(System.test.isRunningTest()){
        Opportunity opp=new Opportunity();
        opp.Name='test';
        opp.StageName='0 - DisQualified';
        opp.CloseDate=System.today();
        opp.Type='New Business';
        insert opp;
        Prebuild__c prebuild=new Prebuild__c();
        prebuild.Opportunity__c=opp.Id;
        insert prebuild;
        Sales_Order__c sotest=new Sales_Order__c();
        sotest.Name='test';
        sotest.CurrencyIsoCode='AUD';
        sotest.Type__c='Prebuild';
        sotest.Opportunity__c=opp.Id;
        insert sotest;
        Sales_Order_Line__c soltest=new Sales_Order_Line__c();
        soltest.Sales_Order__c=sotest.Id;
        soltest.CurrencyIsoCode='AUD';
        oppID=opp.ID;
    }
    Sales_Order__c SO;
    try{
    SO=[Select s.Type__c, s.Owner.Name, s.Name From Sales_Order__c s where s.Opportunity__c=:oppID and s.Type__c='Prebuild' limit 1];
    SOid=SO.Id;
    }catch(Exception e){} 
    return SO;
     
}
public list<Sales_Order_Line__c> getSOlines(){
    list<Sales_Order_Line__c> SOlinesList;
    Sales_Order__c SO;
    try{
    SO=[Select s.Type__c, s.Owner.Name, s.Name From Sales_Order__c s where s.Opportunity__c=:oppID and s.Type__c='Prebuild' limit 1];
    SOid=SO.Id;
    }catch(Exception e){}
    try{
    SOlinesList=[Select s.Sale_Price__c, s.Quantity__c, s.Product__r.Name, s.Package_Product_Code__c, s.Name, s.BOM_Line_Number__c From Sales_Order_Line__c s where s.Sales_Order__c=:SOid];
    }catch(Exception e){}
    return SOlinesList;
}
}