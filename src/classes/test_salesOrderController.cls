@isTest
private class test_salesOrderController {

    static testMethod void myUnitTest() 
    {
    	
        Account a = new Account(Name='Test');
        insert a;
        
        Opportunity opp = new Opportunity(Name='Test',StageName='Prospecting',CloseDate=System.today().addMonths(1));
        insert opp;
        
        Product2 p = new Product2(Name='Test',IsActive=true,Productcode='Test');
        insert p;
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c(SBQQ__Opportunity__c=opp.Id,SBQQ__Primary__c=true);
        insert quote;
        
        SBQQ__QuoteLine__c line = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        line.SBQQ__ListPrice__c = 1000;
        line.BOM_Line_Number__c='1';
        line.SBQQ__Quantity__c = 1;
        //insert line;
        
        SBQQ__QuoteLine__c cline = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline.SBQQ__RequiredBy__c=line.Id;
        cline.SBQQ__Bundled__c=true;
        cline.SBQQ__BundledQuantity__c=4;
        cline.SBQQ__ListPrice__c = 100;
        cline.BOM_Line_Number__c='1';
        cline.SBQQ__OptionType__c = 'Component';
        cline.SBQQ__Quantity__c = 6;
        //cline.Discount_Category__c='Hardware';
        //insert cline;
        
        list<SBQQ__QuoteLine__c> listQl = new list<SBQQ__QuoteLine__c>();
        
        SBQQ__QuoteLine__c cline4 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline4.SBQQ__RequiredBy__c=line.Id;
        cline4.SBQQ__Bundled__c=true;
        cline4.SBQQ__BundledQuantity__c=5;
        cline4.SBQQ__ListPrice__c = 1000;
        cline4.BOM_Line_Number__c='1';
        cline4.SBQQ__OptionType__c = 'Component';
        cline4.SBQQ__Quantity__c = 7;
        //insert cline4;
        //listQl.add(cline4);
        
        SBQQ__QuoteLine__c cline5 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline5.SBQQ__RequiredBy__c=line.Id;
        cline5.SBQQ__Bundled__c=true;
        cline5.SBQQ__BundledQuantity__c=7;
        cline5.SBQQ__ListPrice__c = 1000;
        cline5.BOM_Line_Number__c='1';
        cline5.SBQQ__OptionType__c = 'Component';
        cline5.SBQQ__Quantity__c = 9;
        //insert cline4;
        //listQl.add(cline5);
        
        SBQQ__QuoteLine__c cline6 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline6.SBQQ__RequiredBy__c=line.Id;
        cline6.SBQQ__Bundled__c=true;
        cline6.SBQQ__BundledQuantity__c=9;
        cline6.SBQQ__ListPrice__c = 1000;
        cline6.BOM_Line_Number__c='1';
        cline6.SBQQ__OptionType__c = 'Component';
        cline6.SBQQ__Quantity__c = 10;
        //insert cline4;
        //listQl.add(cline6);
        
        SBQQ__QuoteLine__c cline9 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline9.SBQQ__RequiredBy__c=line.Id;
        cline9.SBQQ__Bundled__c=true;
        cline9.SBQQ__BundledQuantity__c=7;
        cline9.SBQQ__ListPrice__c = 1000;
        cline9.BOM_Line_Number__c='1';
        cline9.SBQQ__OptionType__c = 'Component';
        cline9.SBQQ__Quantity__c = 9;
        //insert cline4;
        //listQl.add(cline9);
        
        SBQQ__QuoteLine__c cline10 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline10.SBQQ__RequiredBy__c=line.Id;
        cline10.SBQQ__Bundled__c=true;
        cline10.SBQQ__BundledQuantity__c=9;
        cline10.SBQQ__ListPrice__c = 1000;
        cline10.BOM_Line_Number__c='1';
        cline10.SBQQ__OptionType__c = 'Component';
        cline10.SBQQ__Quantity__c = 10;
        //insert cline4;
        //listQl.add(cline10);
        
        SBQQ__QuoteLine__c cline11 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline11.SBQQ__RequiredBy__c=line.Id;
        cline11.SBQQ__Bundled__c=true;
        cline11.SBQQ__BundledQuantity__c=9;
        cline11.SBQQ__ListPrice__c = 1000;
        cline11.BOM_Line_Number__c='1';
        cline11.SBQQ__OptionType__c = 'Component';
        cline11.SBQQ__Quantity__c = 10;
        //insert cline4;
        //listQl.add(cline11);
        
        SBQQ__QuoteLine__c cline2 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline2.SBQQ__RequiredBy__c=line.Id;
        cline2.SBQQ__Bundled__c=true;
        cline2.SBQQ__BundledQuantity__c=5;
        cline2.SBQQ__ListPrice__c = 1000;
        cline2.BOM_Line_Number__c='1.1';
        cline2.SBQQ__OptionType__c = 'Component';
        cline2.SBQQ__Quantity__c = 7;
        //insert cline2;
        //listQl.add(cline2);
        
        SBQQ__QuoteLine__c cline3 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline3.SBQQ__RequiredBy__c=line.Id;
        cline3.SBQQ__Bundled__c=true;
        cline3.SBQQ__BundledQuantity__c=5;
        cline3.SBQQ__ListPrice__c = 1000;
        cline3.BOM_Line_Number__c='1.1';
        cline3.SBQQ__OptionType__c = 'Component';
        cline3.SBQQ__Quantity__c = 7;
        //listQl.add(cline3);
        
        SBQQ__QuoteLine__c cline7 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline7.SBQQ__RequiredBy__c=line.Id;
        cline7.SBQQ__Bundled__c=true;
        cline7.SBQQ__BundledQuantity__c=5;
        cline7.SBQQ__ListPrice__c = 1000;
        cline7.BOM_Line_Number__c='1.1';
        cline7.SBQQ__OptionType__c = 'Component';
        cline7.SBQQ__Quantity__c = 7;
        //listQl.add(cline7);
        
        SBQQ__QuoteLine__c cline8 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline8.SBQQ__RequiredBy__c=line.Id;
        cline8.SBQQ__Bundled__c=true;
        cline8.SBQQ__BundledQuantity__c=5;
        cline8.SBQQ__ListPrice__c = 1000;
        cline8.BOM_Line_Number__c='1.1';
        cline8.SBQQ__OptionType__c = 'Component';
        cline8.SBQQ__Quantity__c = 7;
        //listQl.add(cline8);
        
        SBQQ__QuoteLine__c cline12 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline12.SBQQ__RequiredBy__c=line.Id;
        cline12.SBQQ__Bundled__c=true;
        cline12.SBQQ__BundledQuantity__c=5;
        cline12.SBQQ__ListPrice__c = 1000;
        cline12.BOM_Line_Number__c='1.1';
        cline12.SBQQ__OptionType__c = 'Component';
        cline12.SBQQ__Quantity__c = 7;
        //listQl.add(cline12);
        
        SBQQ__QuoteLine__c cline13 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline13.SBQQ__RequiredBy__c=line.Id;
        cline13.SBQQ__Bundled__c=true;
        cline13.SBQQ__BundledQuantity__c=5;
        cline13.SBQQ__ListPrice__c = 1000;
        cline13.BOM_Line_Number__c='1.1';
        cline13.SBQQ__OptionType__c = 'Component';
        cline13.SBQQ__Quantity__c = 7;
        //listQl.add(cline13);
        
        SBQQ__QuoteLine__c cline14 = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quote.Id,SBQQ__Product__c=p.Id);
        cline14.SBQQ__RequiredBy__c=line.Id;
        cline14.SBQQ__Bundled__c=true;
        cline14.SBQQ__BundledQuantity__c=5;
        cline14.SBQQ__ListPrice__c = 1000;
        cline14.BOM_Line_Number__c='1.1';
        cline14.SBQQ__OptionType__c = 'Component';
        cline14.SBQQ__Quantity__c = 7;
        //listQl.add(cline14);
        
        
        //insert listQl;
        test.startTest();
        Sales_Order__c so = new Sales_Order__c();
        SalesOrderController target = new SalesOrderController(new ApexPages.StandardController(so));
        ApexPages.currentPage().getParameters().put('oppid', String.valueOf(opp.Id));
        target.onOverrideNew();
        System.assertEquals(1, ApexPages.getMessages().size());
        
        quote.SBQQ__Status__c = 'Approved';
        update quote;
        PageReference pref = target.onOverrideNew();
        //System.assert(pref != null, 'Errors: ' + ApexPages.getMessages());
        //System.assert(pref.getUrl().startsWith('/' + Sales_Order__c.sObjectType.getDescribe().getKeyPrefix() + '/e'));
        
        so.Opportunity__c = opp.Id;
        insert so;
        
        ApexPages.currentPage().getParameters().put('newid', String.valueOf(so.Id));
        target = new SalesOrderController(new ApexPages.StandardController(so));
        //System.assert(target.lineItemRows != null); 
        //System.assertEquals(1, target.lineItemRows.size());
        //target.lineItemRows[0].selected = true;
        pref = target.onAddLines();
        //System.assert(pref != null, 'Errors: ' + ApexPages.getMessages());
        //System.assertEquals('/' + so.Id, pref.getUrl());
        System.assertEquals(0, [SELECT count() FROM Sales_Order_Line__c WHERE Sales_Order__c = :so.Id]);
        test.stopTest();
    }
}