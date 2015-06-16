@isTest
private class OpportunityTriggerHandlerTest {
	static testMethod void testNextStepArchive() {
        Account a=new Account(Name='test');
        insert a;
        Opportunity o=new Opportunity(Name='test opp',AccountId=a.Id,Type='New Business',CloseDate=Date.today(),StageName='1-Prequalified',Sales_Area__c='NA West North');
        insert o;
        o.NextStep='Step 1';
        update o;
        o.NextStep='Step 2';
        update o;        
    }
}