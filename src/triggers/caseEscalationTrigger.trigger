trigger caseEscalationTrigger on caseEscalation__c (before insert, before update,
                                                    after  insert, after  update, after delete)
  {// NOTE: This trigger is NOT yet enhanced to work with bulk records (it is not bulkified).

   // "Before" logic checks to see if there is already an existing entry
   // with the same name and if so, throws an error.
   if (Trigger.isBefore)
     {for (caseEscalation__c recordToProcess : Trigger.new)
        {List <caseEscalation__c> caseEscalations = [SELECT Id
                                                     FROM   caseEscalation__c
                                                     WHERE  caseEscalationCase__c           = :recordToProcess.caseEscalationCase__c AND
                                                            caseEscalationTypeDefinition__c = :recordToProcess.caseEscalationTypeDefinition__c];

         if (caseEscalations.size() > 0)
           {recordToProcess.addError('ERROR: There is already a Case Escalation with this Case Number and Escalation Type (Group/User).');
            return;
           }
        }
     }

   // "After" logic populates the Case Escalation Type multi-select picklist
   // on the Case with the child escalation types on the Case.
   else
     {for (caseEscalation__c recordToProcess : Trigger.isDelete ? Trigger.old : Trigger.new)
        {// Retrieve the list of all Case Escalation Type Definition Groups for this same case.
         // GROUP BY is used to eliminate results from the same Group (such as multiple "PEAK Escalation" entries).

         List <AggregateResult> aggResults = [SELECT   caseEscalationTypeDefinition__r.caseEscalationTypeDefinitionGroup__c
                                              FROM     caseEscalation__c
                                              WHERE    caseEscalationCase__c = :recordToProcess.caseEscalationCase__c
                                              GROUP BY caseEscalationTypeDefinition__r.caseEscalationTypeDefinitionGroup__c
                                              ORDER BY caseEscalationTypeDefinition__r.caseEscalationTypeDefinitionGroup__c];

         Case aCase = [SELECT Id,
                              caseEscalationType__c
                       FROM   Case
                       WHERE  Id = :recordToProcess.caseEscalationCase__c];

         aCase.caseEscalationType__c = null;

         // Add each value to the Case Escalation Type multi-select picklist and update the case.
         for (AggregateResult aggResult : aggResults)
           {String groupName = (String) aggResult.get('caseEscalationTypeDefinitionGroup__c');

            // system.debug('DEBUG: aggResult group = ' + groupName);
            if (aCase.caseEscalationType__c == null)
              {aCase.caseEscalationType__c = groupName;
              }
            else
              {aCase.caseEscalationType__c += ';' + groupName;
              }
           }

         // If the Case Escalation Type is still null (nothing was added to it),
         // set the value to "Not Escalated"
         if (aCase.caseEscalationType__c == null)
           {aCase.caseEscalationType__c = 'Not Escalated';
           }

         update aCase;
        }
     }
  }