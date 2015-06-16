@isTest(SeeAllData=true)
private class Test_ApprovalController {

    static testMethod void myUnitTest() {
        Account acc=new Account();
    	acc.Name='test mansa';
    	insert acc;
        Opportunity opp= new Opportunity();
    	opp.Name='test mansa';
    	opp.AccountId=acc.id;
    	opp.CloseDate=system.today()+3;
    	opp.StageName='Qualified';
    	opp.Sales_Area__c='EMEA';
    	insert opp;
        SBQQ__Quote__c quoteTest=new SBQQ__Quote__c();
        quoteTest.SBQQ__Opportunity__c=opp.ID;
        quoteTest.SBQQ__Type__c='Revenue';
        quoteTest.SBQQ__Status__c='Draft';
        quoteTest.Quote_Produced_or__c='Distributor';
        insert quoteTest;
        
        Product2 p = new Product2(Name='Test',IsActive=true,Productcode='Test');
        insert p;
        SBQQ__QuoteLine__c quoteLineTest=new SBQQ__QuoteLine__c();
        quoteLineTest.SBQQ__Product__c=p.Id;
        quoteLineTest.SBQQ__Quote__c=quoteTest.ID;
        quoteLineTest.SBQQ__Bundled__c=true;
        quoteLineTest.SBQQ__BundledQuantity__c=4;
        quoteLineTest.SBQQ__ListPrice__c = 100;
        quoteLineTest.BOM_Line_Number__c='1';
        quoteLineTest.SBQQ__OptionType__c = 'Component';
        quoteLineTest.SBQQ__Quantity__c = 6;
        insert quoteLineTest;
        
        Apexpages.Standardcontroller sc=new Apexpages.Standardcontroller(quoteTest);
        approval_controller app_con=new approval_controller(sc);
        app_con.Competitive_Pressures=false;
        app_con.New_Customer_Acquisition=false;
        app_con.Timeline_for_Closing=false;
        app_con.Customer_Satisfaction=false;
        app_con.Customer_Budget=false;
        app_con.Multi_Quote_Deal=false;
        app_con.Missing_Wrong_Part_on_Quote=false;
        app_con.Design_Sizing_Error=false;
        app_con.Match_Previous_Discounts=false;
        app_con.X100_Deal_Discount=false;
        app_con.renderEditPanel=false;
        app_con.renderViewPanel=false;
        app_con.SaveRecord();
        app_con.Submit();
        
        quoteTest.SBQQ__Status__c='Rejected';
        update quoteTest;
        quoteLineTest.SBQQ__ListPrice__c =89000;
        update quoteLineTest;
        Apexpages.Standardcontroller sc1=new Apexpages.Standardcontroller(quoteTest);
        approval_controller app_con1=new approval_controller(sc1);
        app_con1.Competitive_Pressures=false;
        app_con1.New_Customer_Acquisition=false;
        app_con1.Timeline_for_Closing=false;
        app_con1.Customer_Satisfaction=false;
        app_con1.Customer_Budget=false;
        app_con1.Multi_Quote_Deal=false;
        app_con1.Missing_Wrong_Part_on_Quote=false;
        app_con1.Design_Sizing_Error=false;
        app_con1.Match_Previous_Discounts=false;
        app_con1.X100_Deal_Discount=false;
        app_con1.renderEditPanel=false;
        app_con1.renderViewPanel=false;
        app_con1.SaveRecord();
        app_con1.Submit();
        
        quoteTest.SBQQ__Status__c='Approved';
        update quoteTest;
        quoteLineTest.SBQQ__ListPrice__c =91000;
        update quoteLineTest;
        Apexpages.Standardcontroller sc2=new Apexpages.Standardcontroller(quoteTest);
        approval_controller app_con2=new approval_controller(sc2);
        app_con2.Competitive_Pressures=false;
        app_con2.New_Customer_Acquisition=false;
        app_con2.Timeline_for_Closing=false;
        app_con2.Customer_Satisfaction=false;
        app_con2.Customer_Budget=false;
        app_con2.Multi_Quote_Deal=false;
        app_con2.Missing_Wrong_Part_on_Quote=false;
        app_con2.Design_Sizing_Error=false;
        app_con2.Match_Previous_Discounts=false;
        app_con2.X100_Deal_Discount=false;
        app_con2.renderEditPanel=false;
        app_con2.renderViewPanel=false;
        app_con2.SaveRecord();
        app_con2.Submit();
        
    }
}