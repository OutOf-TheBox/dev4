trigger caseEscalationTypeDefinitionTrigger on caseEscalationTypeDefinition__c (before insert, before update)
  {for (caseEscalationTypeDefinition__c recordToProcess : Trigger.new)
     {// NOTE: This trigger is NOT yet enhanced to work with bulk records (it is not bulkified).

      // Set the record Name field, which contains the Group field value,
      // and optionally the User field value if the Group is one that
      // requires Users (such as the Group "PEAK Escalation").

      if (recordToProcess.caseEscalationTypeDefinitionGroup__c == 'PEAK Escalation')
        {List <User> userRecords = [SELECT Id,
                                           FirstName,
                                           LastName
                                    FROM   User
                                    WHERE  Id = :recordToProcess.caseEscalationTypeDefinitionUser__c];

         if (userRecords.size() <> 1)
           {recordToProcess.addError('ERROR: Could not find the matching User record.');
            return;
           }

         recordToProcess.Name = 'PEAK Escalation: ' + userRecords[0].FirstName + ' ' + userRecords[0].LastName;
        }
      else
        {recordToProcess.Name = recordToProcess.caseEscalationTypeDefinitionGroup__c;
        }

      // See if there is already a record with the same Name.  If so, throw an error.

      List <caseEscalationTypeDefinition__c> duplicateRecords = [SELECT Id
                                                                 FROM   caseEscalationTypeDefinition__c
                                                                 WHERE  Name = :recordToProcess.Name];

      if (duplicateRecords.size() > 0)
        {recordToProcess.addError('ERROR: There is already a record with this Group and/or User combination.');
         return;
        }
     }
  }