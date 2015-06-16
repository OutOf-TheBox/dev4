Trigger caseTriggerNewCommentOnFieldUpdates on Case (after insert, after update)

  {// This trigger is used to create a new Case Comment when the value
   // of certain Case fields change.  The fields tracked are:
   //   - Current Status
   //   - Plan Of Action

   List<CaseComment> newCaseComments = new List<CaseComment>();

   for (Case newCase : Trigger.new)
     {// Clear out variables for this iteration

      Boolean caseCurrentStatusUpdated = false;
      Boolean casePlanOfActionUpdated  = false;
      Boolean newCaseCommentNeeded     = false;
      String  newCaseCommentBody       = '';

      // Evaluate fields, and see if any were updated.
      // For inserts, this means checking to see if they have a value.
      // For updates, this means comparing the old value to the new one.
      // If any were updated, a new Case Comment will be needed.

      if (Trigger.isInsert)
        {if (!String.isBlank(newCase.caseCurrentStatus__c))
           {caseCurrentStatusUpdated = true;
            newCaseCommentNeeded     = true;
           }

         if (!String.isBlank(newCase.casePlanOfAction__c))
           {casePlanOfActionUpdated = true;
            newCaseCommentNeeded    = true;
           }

        }
      else if (Trigger.isUpdate)
        {// A useful website for finding out how to compare old vs new values in an update trigger
         // can be found at:
         //   http://cloudforce4u.blogspot.com/2013/07/compare-old-and-new-values-in-trigger.html

         Case oldCase = Trigger.oldMap.get(newCase.Id);

         if (oldCase.caseCurrentStatus__c != newCase.caseCurrentStatus__c)
           {caseCurrentStatusUpdated = true;
            newCaseCommentNeeded     = true;
           }

         if (oldCase.casePlanOfAction__c != newCase.casePlanOfAction__c)
           {casePlanOfActionUpdated = true;
            newCaseCommentNeeded    = true;
           }
        }

      // If a new Case Comment is needed, create it, and populate it
      // with the values of the fields.

      if (newCaseCommentNeeded)
        {newCaseCommentBody =  '*** CASE FIELDS UPDATED ***\n\n';
         newCaseCommentBody += 'New Values:\n\n';

         if (caseCurrentStatusUpdated)
           {newCaseCommentBody += 'Current Status: ' + newCase.caseCurrentStatus__c + '\n\n';
           }

         if (casePlanOfActionUpdated)
           {newCaseCommentBody += 'Plan Of Action: ' + newCase.casePlanOfAction__c + '\n';
           }

         newCaseComments.add(new CaseComment (ParentId    = newCase.Id,
                                              IsPublished = false,
                                              CommentBody = newCaseCommentBody));
        }
     }

   // Insert any new Case Comments that were created.

   insert newCaseComments;
  }