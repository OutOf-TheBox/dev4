public with sharing class ApprovalQuoteLineControllerdistributor {
    public Id quoteId {get; set;}
    
    private SBQQ__QuoteLine__c[] lines;
    
    public SBQQ__QuoteLine__c[] getLines() {
        if (lines == null) {
            lines = [SELECT Name, Part_Number__c, SBQQ__ProductName__c, Serial_Number_Calculated__c, SBQQ__ListPrice__c, SBQQ__Quantity__c, SBQQ__NetPrice__c, SBQQ__NetTotal__c, BOM_Package_Regular_Total__c, BOM_Package_Net_Unit_Price__c, BOM_Package_Net_Total__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c = :quoteId ORDER BY SBQQ__Number__c];
        }
        return lines;
    }
    
    testMethod static void test() {
        Opportunity opp = new Opportunity(Name='Test',StageName='Prospecting',CloseDate=System.today());
        insert opp;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity__c=opp.Id);
        insert quote;
        
        Product2 p = new Product2(Name='Test');
        insert p;
        
        SBQQ__QuoteLine__c l1 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Quantity__c=1,SBQQ__ListPrice__c=1000,SBQQ__NetPrice__c=900,SBQQ__Product__c=p.Id);
        SBQQ__QuoteLine__c l2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Quantity__c=10,SBQQ__ListPrice__c=100,SBQQ__NetPrice__c=80,SBQQ__Product__c=p.Id);
        insert new SBQQ__QuoteLine__c[]{l1,l2};
        
        ApprovalQuoteLineControllerdistributor target = new ApprovalQuoteLineControllerdistributor();
        target.quoteId = quote.Id;
        SBQQ__QuoteLine__c[] lines = target.getLines();
        System.assertEquals(2, lines.size());
    }
}