@isTest
private class caseEscalationTypeDefinitionTriggerTest
  {// ==================================================================================== testGood_UserNotRequired
   static testMethod void testGood_UserNotRequired()
     {caseEscalationTypeDefinition__c newCaseEscalationTypeDefinition = new caseEscalationTypeDefinition__c();
      List<caseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;

      newCaseEscalationTypeDefinition.caseEscalationTypeDefinitionGroup__c = 'Engineering Escalation';
      newCaseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__c  = null;

      insert(newCaseEscalationTypeDefinition);

      caseEscalationTypeDefinitions = [SELECT Id,
                                              Name,
                                              caseEscalationTypeDefinitionGroup__c,
                                              caseEscalationTypeDefinitionUser__c
                                       FROM   caseEscalationTypeDefinition__c];

      System.assertEquals(1,                        caseEscalationTypeDefinitions.size());
      System.assertEquals('Engineering Escalation', caseEscalationTypeDefinitions[0].Name);
      System.assertEquals('Engineering Escalation', caseEscalationTypeDefinitions[0].caseEscalationTypeDefinitionGroup__c);
      System.assertEquals(null,                     caseEscalationTypeDefinitions[0].caseEscalationTypeDefinitionUser__c);
     }

   // ==================================================================================== testGood_UserRequired
   static testMethod void testGood_UserRequired()
     {List<User> activeUsers;
      caseEscalationTypeDefinition__c newCaseEscalationTypeDefinition = new caseEscalationTypeDefinition__c();
      List<caseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;
      String activeUserFirstName;
      String activeUserLastName;

      activeUsers = [SELECT Id,
                            Name,
                            FirstName,
                            LastName
                     FROM   User
                     WHERE  FirstName != null AND
                            LastName  != null AND
                            isActive  = true
                     LIMIT  1];

      System.assertEquals(1, activeUsers.size());

      activeUserFirstName = activeUsers[0].FirstName;
      activeUserLastName  = activeUsers[0].LastName;

      newCaseEscalationTypeDefinition.caseEscalationTypeDefinitionGroup__c = 'PEAK Escalation';
      newCaseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__c  = activeUsers[0].Id;

      insert(newCaseEscalationTypeDefinition);

      caseEscalationTypeDefinitions = [SELECT Id,
                                              Name,
                                              caseEscalationTypeDefinitionGroup__c,
                                              caseEscalationTypeDefinitionUser__c
                                       FROM   caseEscalationTypeDefinition__c];

      System.assertEquals(1,                                                                    caseEscalationTypeDefinitions.size());
      System.assertEquals('PEAK Escalation: ' + activeUserFirstName + ' ' + activeUserLastName, caseEscalationTypeDefinitions[0].Name);
      System.assertEquals('PEAK Escalation',                                                    caseEscalationTypeDefinitions[0].caseEscalationTypeDefinitionGroup__c);
      System.assertEquals(activeUsers[0].Id,                                                    caseEscalationTypeDefinitions[0].caseEscalationTypeDefinitionUser__c);
     }

   // ==================================================================================== testBad_UserMissing
   static testMethod void testBad_UserMissing()
     {caseEscalationTypeDefinition__c newCaseEscalationTypeDefinition = new caseEscalationTypeDefinition__c();
      List<caseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;
      Exception dmlException;

      newCaseEscalationTypeDefinition.caseEscalationTypeDefinitionGroup__c = 'PEAK Escalation';
      newCaseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__c  = null;

      try
        {insert(newCaseEscalationTypeDefinition);
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('ERROR: Could not find the matching User record.'));
     }

   // ==================================================================================== testBadDuplicateRecord
   static testMethod void testBad_DuplicateRecord()
     {caseEscalationTypeDefinition__c newCaseEscalationTypeDefinition1 = new caseEscalationTypeDefinition__c();
      caseEscalationTypeDefinition__c newCaseEscalationTypeDefinition2 = new caseEscalationTypeDefinition__c();
      List<caseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;
      Exception dmlException;

      newCaseEscalationTypeDefinition1.caseEscalationTypeDefinitionGroup__c = 'Engineering Escalation';
      newCaseEscalationTypeDefinition1.caseEscalationTypeDefinitionUser__c  = null;

      insert(newCaseEscalationTypeDefinition1);

      newCaseEscalationTypeDefinition2.caseEscalationTypeDefinitionGroup__c = 'Engineering Escalation';
      newCaseEscalationTypeDefinition2.caseEscalationTypeDefinitionUser__c  = null;

      try
        {insert(newCaseEscalationTypeDefinition2);
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('ERROR: There is already a record with this Group and/or User combination.'));
     }
  }