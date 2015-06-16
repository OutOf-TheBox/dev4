@isTest
private class caseEscalationTriggerTest
  {// ==================================================================================== testGood
   static testMethod void testGood()
     {// ===== Create test Case
      Case testCase;
      List<Case> testCases;
      Id testCaseId;

      testCase = new Case(Subject = 'TEST-CASE-SUBJECT');

      insert(testCase);

      testCases = [SELECT Id,
                          Subject
                   FROM   Case
                   WHERE  Subject = 'TEST-CASE-SUBJECT'];

      testCaseId = testCases[0].id;

      // ===== Create test Case Escalation Type Definition
      caseEscalationTypeDefinition__c testCaseEscalationTypeDefinition;
      List<caseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;
      Id testCaseEscalationTypeDefinitionId;

      testCaseEscalationTypeDefinition = new caseEscalationTypeDefinition__c(caseEscalationTypeDefinitionGroup__c = 'Engineering Escalation',
                                                                             caseEscalationTypeDefinitionUser__c  = null);

      insert(testCaseEscalationTypeDefinition);

      caseEscalationTypeDefinitions = [SELECT Id,
                                              Name,
                                              caseEscalationTypeDefinitionGroup__c,
                                              caseEscalationTypeDefinitionUser__c
                                       FROM   caseEscalationTypeDefinition__c];

      testCaseEscalationTypeDefinitionId = caseEscalationTypeDefinitions[0].Id;

      // ===== Create test Case Escalation
      caseEscalation__c testCaseEscalation;
      List<caseEscalation__c> caseEscalations;

      testCaseEscalation = new caseEscalation__c(caseEscalationCase__c = testCaseId,
                                                 caseEscalationTypeDefinition__c = testCaseEscalationTypeDefinitionId);

      insert(testCaseEscalation);

      caseEscalations = [SELECT Id,
                                caseEscalationCase__c,
                                caseEscalationTypeDefinition__c
                         FROM   caseEscalation__c];

      System.assertEquals(1,                                  caseEscalations.size());
      System.assertEquals(testCaseId,                         caseEscalations[0].caseEscalationCase__c);
      System.assertEquals(testCaseEscalationTypeDefinitionId, caseEscalations[0].caseEscalationTypeDefinition__c);

      testCases = [SELECT Id,
                          caseEscalationType__c
                   FROM   Case
                   WHERE  Id = :testCaseId];

      System.assertEquals('Engineering Escalation', testCases[0].caseEscalationType__c);
     }

// ==================================================================================== testBad_Duplicate
   static testMethod void testBad_Duplicate()
     {// ===== Create test Case
      Case testCase;
      List<Case> testCases;
      Id testCaseId;

      testCase = new Case(Subject = 'TEST-CASE-SUBJECT');

      insert(testCase);

      testCases = [SELECT Id,
                          Subject
                   FROM   Case
                   WHERE  Subject = 'TEST-CASE-SUBJECT'];

      testCaseId = testCases[0].id;

      // ===== Create test Case Escalation Type Definition
      caseEscalationTypeDefinition__c testCaseEscalationTypeDefinition;
      List<caseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;
      Id testCaseEscalationTypeDefinitionId;

      testCaseEscalationTypeDefinition = new caseEscalationTypeDefinition__c(caseEscalationTypeDefinitionGroup__c = 'Engineering Escalation',
                                                                             caseEscalationTypeDefinitionUser__c  = null);

      insert(testCaseEscalationTypeDefinition);

      caseEscalationTypeDefinitions = [SELECT Id,
                                              Name,
                                              caseEscalationTypeDefinitionGroup__c,
                                              caseEscalationTypeDefinitionUser__c
                                       FROM   caseEscalationTypeDefinition__c];

      testCaseEscalationTypeDefinitionId = caseEscalationTypeDefinitions[0].Id;

      // ===== Create test Case Escalation
      caseEscalation__c testCaseEscalation;
      List<caseEscalation__c> caseEscalations;

      testCaseEscalation = new caseEscalation__c(caseEscalationCase__c           = testCaseId,
                                                 caseEscalationTypeDefinition__c = testCaseEscalationTypeDefinitionId);

      insert(testCaseEscalation);

      caseEscalations = [SELECT Id,
                                caseEscalationCase__c,
                                caseEscalationTypeDefinition__c
                         FROM   caseEscalation__c];

      System.assertEquals(1,                                  caseEscalations.size());
      System.assertEquals(testCaseId,                         caseEscalations[0].caseEscalationCase__c);
      System.assertEquals(testCaseEscalationTypeDefinitionId, caseEscalations[0].caseEscalationTypeDefinition__c);

      // ===== Create duplicate test Case Escalation
      caseEscalation__c testCaseEscalation2;
      List<caseEscalation__c> caseEscalations2;
      Exception dmlException;

      testCaseEscalation2 = new caseEscalation__c(caseEscalationCase__c           = testCaseId,
                                                  caseEscalationTypeDefinition__c = testCaseEscalationTypeDefinitionId);

      try
        {insert(testCaseEscalation2);
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('ERROR: There is already a Case Escalation with this Case Number and Escalation Type (Group/User).'));
     }
  }