@isTest(SeeAllData=true)
private class Test_Approval_Justifictn_Compnt_Controll {

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
      
      Approval_Justifictn_Component_Controller ajcc=new Approval_Justifictn_Component_Controller ();
      ajcc.QuoteID=quoteTest.ID;
      ajcc.Competitive_Pressures=true;
      ajcc.New_Customer_Acquisition=true;
      ajcc.Timeline_for_Closing=true;
      ajcc.Customer_Satisfaction=true;
      ajcc.Customer_Budget=true;
      ajcc.Multi_Quote_Deal=true;
      ajcc.Missing_Wrong_Part_on_Quote=true;
      ajcc.Design_Sizing_Error=true;
      ajcc.Match_Previous_Discounts=true;
      ajcc.X100_Deal_Discount=true;
      ajcc.getCompetitive_Pressures();
      ajcc.getNew_Customer_Acquisition();
      ajcc.getTimeline_for_Closing();
      ajcc.getCustomer_Satisfaction();
      ajcc.getCustomer_Budget();
      ajcc.getMulti_Quote_Deal();
      ajcc.getMissing_Wrong_Part_on_Quote();
      ajcc.getDesign_Sizing_Error();
      ajcc.getMatch_Previous_Discounts();
      ajcc.getX100_Deal_Discount();
     }
}