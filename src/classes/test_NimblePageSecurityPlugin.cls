@isTest
private class test_NimblePageSecurityPlugin {

    static testMethod void myUnitTest() {
    	
    	Opportunity opp = new Opportunity(Name='Test',StageName='Prospecting',CloseDate=System.today().addMonths(1));
        opp.Type='New Business';
        insert opp;
        
        Product2 p = new Product2(Name='Test',IsActive=true,Productcode='Test');
        p.ProductCode='pro';
        p.BOM_Level__c=1;
        p.Separate_Order_Line_Per_Unit__c=false;
        insert p;
        
    	SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity__c=opp.Id,SBQQ__Primary__c=false,SBQQ__Status__c='Rejected');
		insert quote;
        
        SBQQ__QuoteLine__c line = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        line.SBQQ__ListPrice__c = 1000;
        line.SBQQ__NetPrice__c=1000;
        line.SBQQ__RequiredBy__c=null;
        line.BOM_Line_Number__c='1';
        line.SBQQ__Quantity__c = 11;
        line.SBQQ__PackageProductCode__c='pro';
        line.SBQQ__ProductOption__c=null;
        line.SBQQ__Renewal__c=true;
        line.SBQQ__OptionType__c='Component';
        line.SBQQ__ComponentDiscountedByPackage__c=true;
        line.Distributor_Discount__c=10;
        insert line;
        
        NimblePageSecurityPlugin secPlugin = new NimblePageSecurityPlugin();
        boolean retval = secPlugin.isFieldEditable('EditLines',SBQQ__QuoteLine__c.SBQQ__Quantity__c);
        boolean retval2 = secPlugin.isFieldEditable('EditLines',SBQQ__QuoteLine__c.SBQQ__Quantity__c,line);
        boolean retval3 = secPlugin.isFieldVisible('EditLines',SBQQ__QuoteLine__c.SBQQ__Quantity__c);
        boolean retval4 = secPlugin.isFieldVisible('EditLines',SBQQ__QuoteLine__c.Distributor_Discount__c,line);
    }
}