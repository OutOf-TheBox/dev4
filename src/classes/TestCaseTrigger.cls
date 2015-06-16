@isTest
class TestCaseTrigger
{

    static testMethod void testCaseCommentCatandSubCat()
    {
        //Create category notes
        List<Category_Notes__c> notesList = new List<Category_Notes__c>();
        Category_Notes__c n1 = new Category_Notes__c();
        n1.Category__c='Backup Integration';
        n1.Sub_Category__c='CommVault';
        n1.Notes__c='1.Question';
        notesList.add(n1);
        Category_Notes__c n2 = new Category_Notes__c();
        n2.Category__c='Cisco UCS Integration';
        n2.Sub_Category__c='Boot from SAN';
        n2.Notes__c='1.Question';
        notesList.add(n2);
        insert notesList;
        //Create a new case 
        Case c = new Case(casecatCategory__c='Backup Integration',caseSubCategory__c='CommVault');
        insert c;
        CaseComment cc = [select Id,CommentBody from CaseComment where ParentId=:c.Id];
        System.assertEquals(n1.Notes__c,cc.CommentBody);
        Case uCase = [select Id, LatestCommentId__c from Case where Id =: c.Id];
        System.assertEquals(cc.Id,uCase.LatestCommentId__c);
		Test.startTest();
        //Update a case
        c.casecatCategory__c = 'Cisco UCS Integration';
        c.caseSubCategory__c = 'Boot from SAN';
        update c;
        CaseComment cc1 = [select Id,CommentBody from CaseComment where ParentId=:c.Id];
        System.assertEquals(n2.Notes__c,cc1.CommentBody);
        Case uCase1 = [select Id, LatestCommentId__c from Case where Id =: c.Id];
        System.assertEquals(cc1.Id,uCase1.LatestCommentId__c);
		Test.stopTest();
    }
/*static testMethod void testOOOLoop()
{
Case c = new Case(Subject = 'Out Of Office');
try
{
insert c;
}
catch(Exception e)
{

}
}*/
}