@isTest
private class caseTriggerNewCommentOnFieldUpdatesTest
  {// ==================================================================================== createNewCaseWithNullFields
   static testMethod void createNewCaseWithNullFields()
     {Case       aCase;
      List<Case> cases;

      // Create test case
      aCase = new Case(Subject = 'TEST-CASE-SUBJECT');

      insert aCase;

      cases = [SELECT Id,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      System.assertEquals(1,                   cases.size());
      System.assertEquals('TEST-CASE-SUBJECT', cases[0].Subject);
     }

   // ==================================================================================== createNewCaseWithNonNullFields
   static testMethod void createNewCaseWithNonNullFields()
     {Case       aCase;
      List<Case> cases;

      // Create test case
      aCase = new Case(Subject              = 'TEST-CASE-SUBJECT',
                       caseCurrentStatus__c = 'CS-1',
                       casePlanOfAction__c  = 'PoA-1');

      insert aCase;

      cases = [SELECT Id,
                      Subject,
                      caseCurrentStatus__c,
                      casePlanOfAction__c
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      System.assertEquals(1,                   cases.size());
      System.assertEquals('TEST-CASE-SUBJECT', cases[0].Subject);
      System.assertEquals('CS-1',              cases[0].caseCurrentStatus__c);
      System.assertEquals('PoA-1',             cases[0].casePlanOfAction__c);
     }

   // ==================================================================================== testNewCaseWithNullFields
   static testMethod void testNewCaseWithNullFields()
     {List<Case>        cases;
      List<CaseComment> caseComments;
      ID                testCaseId;

      createNewCaseWithNullFields();

      cases = [SELECT Id,
                      caseCurrentStatus__c,
                      casePlanOfAction__c,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      testCaseId = cases[0].Id;

      caseComments = [SELECT Id,
                             ParentId
                      FROM   CaseComment
                      WHERE  ParentId = :testCaseId];

      System.assertEquals(0, caseComments.size());
     }

   // ==================================================================================== testNewCaseWithNonNullFields
   static testMethod void testNewCaseWithNonNullFields()
     {List<Case>        cases;
      List<CaseComment> caseComments;
      ID                testCaseId;

      createNewCaseWithNonNullFields();

      cases = [SELECT Id,
                      caseCurrentStatus__c,
                      casePlanOfAction__c,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      testCaseId = cases[0].Id;

      caseComments = [SELECT Id,
                             ParentId,
                             CommentBody
                      FROM   CaseComment
                      WHERE  ParentId = :testCaseId];

      System.assertEquals(1, caseComments.size());
      System.assert(caseComments[0].CommentBody.contains('Current Status: CS-1'));
      system.assert(caseComments[0].CommentBody.contains('Plan Of Action: PoA-1'));
     }

   // ==================================================================================== testUpdates
   static testMethod void testUpdates()
     {List<Case>        cases;
      List<CaseComment> caseComments;
      ID                testCaseId;

      createNewCaseWithNonNullFields();

      cases = [SELECT Id,
                      caseCurrentStatus__c,
                      casePlanOfAction__c,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      testCaseId = cases[0].Id;

      cases[0].caseCurrentStatus__c = 'CS-2';
      cases[0].casePlanOfAction__c  = 'PoA-2';

      update cases[0];

      caseComments = [SELECT   Id,
                               ParentId,
                               CommentBody,
                               CreatedDate
                      FROM     CaseComment
                      WHERE    ParentId = :testCaseId
                      ORDER BY CreatedDate];

      System.assertEquals(2, caseComments.size());
      System.assert(caseComments[1].CommentBody.contains('Current Status: CS-2'));
      system.assert(caseComments[1].CommentBody.contains('Plan Of Action: PoA-2'));
     }
  }