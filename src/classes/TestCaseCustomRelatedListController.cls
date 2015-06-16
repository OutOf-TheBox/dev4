@isTest
public class TestCaseCustomRelatedListController
{
    static testMethod void testCustomRelatedList()
    {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Asset asst = new Asset(Name = 'Test Asset',AccountId = acc.Id);
        insert asst;
        List<Case> caseList = new List<Case>();
        Case c1 = new Case(AssetId = asst.Id, AccountId = acc.Id, Case_Type__c = 'External');
        Case c2 = new Case(AssetId = asst.Id, AccountId = acc.Id, Case_Type__c = 'Internal');
        caseList.add(c1);
        caseList.add(c2);
        insert caseList;
        ApexPages.StandardController sc = new ApexPages.StandardController(asst);
        CaseCustomRelatedListController cnctrl = new CaseCustomRelatedListController(sc);
        PageReference pageRef = Page.CaseCustomRelatedListPage;
        Test.setCurrentPage(pageRef);
        List<Case> cList = cnctrl.getCases();
		System.assertEquals(1,cList.size());        
        
    }

}