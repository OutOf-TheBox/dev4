public with sharing class quotelinecntlr {

public string QID{get;set;}
public List<SBQQ__QuoteLine__c> QuoteLin;

public List<SBQQ__QuoteLine__c> getQuoteLin() {
    if(QuoteLin==null)
       QuoteLin= [Select id,name,SBQQ__Product__r.name,Part_Number__c,SBQQ__Quantity__c
                        
                     from SBQQ__QuoteLine__c where SBQQ__Quote__c=:QID and Product_Type__c =: 'Hardware' and BOM_Level__c=:1 order by name];
                    
    return QuoteLin;
}

public quotelinecntlr ()
{}
}