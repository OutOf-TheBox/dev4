trigger CaseTrigger on Case (before insert, after insert, after update)
  {//System.debug('DEBUG: (CaseTrigger) ===== ENTERED');
   //System.debug('DEBUG: (CaseTrigger) ===== getQueries = ' + Limits.getQueries());
   if (Trigger.isBefore && Trigger.isInsert)
     {for (Case caseToProcess : Trigger.new)
        {if (caseToProcess.caseEscalationType__c == null)
           {caseToProcess.caseEscalationType__c = 'Not Escalated';
           }

         if (caseToProcess.subject != null &&
                                      (caseToProcess.subject.containsIgnoreCase('Out of office ' )    ||
                                       caseToProcess.subject.containsIgnoreCase('OOO')                ||
                                       caseToProcess.subject.containsIgnoreCase('out of the office' ) ||
                                       caseToProcess.subject.containsIgnoreCase('PTO')                ||
                                       caseToProcess.subject.containsIgnoreCase('Auto Reply' )        ||
                                       caseToProcess.subject.containsIgnoreCase('Auto Response')      ||
                                       caseToProcess.subject.containsIgnoreCase('[Auto-Reply]' )      ||
                                       caseToProcess.subject.containsIgnoreCase('[Out of office]')    ||
                                       caseToProcess.subject.containsIgnoreCase('Out-of-office' )     ||
                                       caseToProcess.subject.containsIgnoreCase('auto-response')      ||
                                       caseToProcess.subject.containsIgnoreCase('[Out-of-office]' )   ||
                                       caseToProcess.subject.containsIgnoreCase('autoresponse RE')    ||
                                       caseToProcess.subject.containsIgnoreCase('autoreply')          ||
                                       caseToProcess.subject.containsIgnoreCase('autoresponse')       ||
                                      (caseToProcess.subject.containsIgnoreCase('vacation') && !caseToProcess.account_name__c.containsIgnoreCase('vacation')) ||
                                       caseToProcess.subject.containsIgnoreCase('auto response')      ||
                                       caseToProcess.subject.containsIgnoreCase('Out of Office' )     ||
                                       caseToProcess.subject.containsIgnoreCase('Automatic reply')    ||
                                       caseToProcess.subject.containsIgnoreCase('Undeliverable')))
            {// Email subject is a out-of-office type, so don't create the case.
             caseToProcess.addError('Out-of-office type subjects are not allowed to create new cases.');
            }
            else
            {// No Errors, so allow case to be created.
            }
        }
    }
	
	//Added by Pradeep.
	
	if(Trigger.isAfter && Trigger.isInsert)
    {
        set<String> pachinkoCaseTypes = new set<String> ();
        List<Case> caseList = new List<Case>();
        for( Case c : trigger.new)
        {
            if(c.casePachinkoCaseType__c != '' && c.casePachinkoCaseType__c != null) // check for null
            {  
                pachinkoCaseTypes.add(c.casePachinkoCaseType__c);
                caseList.add(c);
            }
        }
        if(caseList.size() > 0)
            CaseUtility.createOutStandingRecomendationOnCaseInsert(caseList, pachinkoCaseTypes);
    }
    if(Trigger.isAfter && Trigger.isUpdate)
    {       
        List<Case> closedCases = new List<Case>();
        for(Integer i = 0; i<Trigger.new.size(); i++)
        {
            Case nCase = Trigger.new.get(i);
            Case oCase = Trigger.old.get(i);
            if((nCase.Status == 'Closed' || nCase.Status == 'Closed(Duplicate)') && 
               nCase.Status != oCase.Status &&
               (UserInfo.getUserId() == CaseUtility.NIMBLE_SUPPORT_USER_ID || Test.isRunningTest())
              )
            {
                
                closedCases.add(nCase);
            }
        }
        if(closedCases.size() > 0)
            CaseUtility.validateRecommendationOnCaseClose(closedCases);
    }

   // The below code will send survey emails when a Case is closed
   // (if other criteria is also met), and update Contacts as needed.
   if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
     {List<EmailTemplate> emailTemplates;
      Id emailTemplateId;
      Set<Id> relatedAccountIds = new Set<Id>();
      Set<Id> relatedContactIds = new Set<Id>();
      Account relatedAccount;
      Contact relatedContact;
      Set<Id> contactIdsToReceiveSurvey = new Set<Id>();
      List<Map<String, Id>> surveyIdsList = new List<Map<String, Id>>();
      Map<String, Id> surveyIdsMap;
      List<Contact> contactsToUpdate;
      Boolean statusChangedToClosed;

      // Get the ID of the email template for the survey
      emailTemplates = [SELECT Id FROM EmailTemplate WHERE Name = 'Survey: Support Closed Case 01'];
      if (emailTemplates.size() <> 1)
        {System.debug('DEBUG: (CaseTrigger) Failed to find one email template with name = "Survey: Support Closed Case 01"');
         System.debug('DEBUG: (CaseTrigger) emailTemplates size <> 1; size = ' + emailTemplates.size());
         return;
        }
      emailTemplateId = emailTemplates[0].Id;

      // Retrieve the related Account and Contact objects for the Cases to be processed
      for (Case caseToProcess : Trigger.new)
        {if (caseToProcess.accountId != null) {relatedAccountIds.add(caseToProcess.accountId);} else {continue;}
         if (caseToProcess.contactId != null) {relatedContactIds.add(caseToProcess.contactId);} else {continue;}
        }
      //System.debug('DEBUG: (caseTrigger) relatedAccountIds = ' + relatedAccountIds);
      //System.debug('DEBUG: (caseTrigger) relatedContactIds = ' + relatedContactIds);
      Map<Id, Account> relatedAccountsMap = new Map<Id, Account>([SELECT Id, Support_Provider__c FROM Account WHERE Id IN :relatedAccountIds]);
      Map<Id, Contact> relatedContactsMap = new Map<Id, Contact>([SELECT Id, contactLastSurveySentDate__c, Email FROM Contact WHERE Id IN :relatedContactIds]);
      //System.debug('DEBUG: (caseTrigger) relatedAccountsMap = ' + relatedAccountsMap);
      //System.debug('DEBUG: (caseTrigger) relatedContactsMap = ' + relatedContactsMap);

      // Iterate through each Case to see if a survey should be sent
      for (Case caseToProcess : Trigger.new)
        {// If Case is missing a related Account or Contact, skip it
         System.debug('DEBUG: (caseTrigger) ===== PROCESSING INDIVIDUAL CASE =====');
         System.debug('DEBUG: (caseTrigger) caseToProcess.accountId = ' + caseToProcess.accountId);
         System.debug('DEBUG: (caseTrigger) caseToProcess.contactId = ' + caseToProcess.contactId);

         if (caseToProcess.accountId == null || caseToProcess.contactId == null)
           {System.debug('DEBUG: (caseTrigger) accountId or contactId is null - skipping this case');
            continue;
           }

         relatedAccount = relatedAccountsMap.get(caseToProcess.accountId);
         relatedContact = relatedContactsMap.get(caseToProcess.contactId);

         System.debug('DEBUG: (caseTrigger) relatedAccount.id = ' + relatedAccount.id);
         System.debug('DEBUG: (caseTrigger) relatedContact.id = ' + relatedContact.id);

         // Evaluate if Case Status was changed to Closed, either by
         // it being set to Closed on new case creation, or changed
         // to Closed from another value if existing case was edited.
         // Only Cases with Status changed to Closed will receive a survey.
         statusChangedToClosed = false;
         if ((Trigger.isInsert && caseToProcess.Status == 'Closed') ||
             (Trigger.isUpdate && caseToProcess.Status == 'Closed' && Trigger.oldMap.get(caseToProcess.Id).Status <> 'Closed'))
           {statusChangedToClosed = true;
           }

         // Survey is sent if following criteria is met:
         //   Case Type is External
         //   Case is not Auto Closed
         //   Case Status was changed to Closed
         //   Case Owner is a User (not a Queue); User IDs always start with 005
         //   Account Support Provider is blank/null (indicating Nimble was the provider)
         //   Contact has not already been marked to receive a survey earlier in this batch of cases
         //   Contact Email does not contain nimblestorage.com
         //   Contact Last Survey Sent Date is blank/null or more than 30 days ago
         System.debug('DEBUG: (CaseTrigger) caseToProcess.Case_Type__c = ' + caseToProcess.Case_Type__c);
         System.debug('DEBUG: (CaseTrigger) caseToProcess.Auto_Close__c = ' + caseToProcess.Auto_Close__c);
         System.debug('DEBUG: (CaseTrigger) statusChangedToClosed = ' + statusChangedToClosed);
         System.debug('DEBUG: (CaseTrigger) caseToProcess.OwnerId = ' + caseToProcess.OwnerId);
         System.debug('DEBUG: (CaseTrigger) String.valueof(caseToProcess.OwnerId).startsWith(005) = ' + String.valueof(caseToProcess.OwnerId).startsWith('005'));
         System.debug('DEBUG: (CaseTrigger) relatedAccount.Support_Provider__c = ' + relatedAccount.Support_Provider__c);
         System.debug('DEBUG: (CaseTrigger) caseToProcess.contactId = ' + caseToProcess.contactId);
         System.debug('DEBUG: (CaseTrigger) contactIdsToReceiveSurvey.contains(caseToProcess.contactId) = ' + contactIdsToReceiveSurvey.contains(caseToProcess.contactId));
         System.debug('DEBUG: (CaseTrigger) relatedContact.Email = ' + relatedContact.Email);
         if (relatedContact.Email != null)
           {System.debug('DEBUG: (CaseTrigger) relatedContact.Email.containsIgnoreCase(nimblestorage.com) = ' + relatedContact.Email.containsIgnoreCase('nimblestorage.com'));
           }
         System.debug('DEBUG: (CaseTrigger) relatedContact.contactLastSurveySentDate__c = ' + relatedContact.contactLastSurveySentDate__c);

         if (caseToProcess.Case_Type__c == 'External'                                                        &&
             !caseToProcess.Auto_Close__c                                                                    &&
             statusChangedToClosed                                                                           &&
             String.valueof(caseToProcess.OwnerId).startsWith('005')                                         &&
             relatedAccount.Support_Provider__c == null                                                      &&
             !contactIdsToReceiveSurvey.contains(caseToProcess.contactId)                                    &&
             (relatedContact.Email != null && !relatedContact.Email.containsIgnoreCase('nimblestorage.com')) &&
             (relatedContact.contactLastSurveySentDate__c == null || relatedContact.contactLastSurveySentDate__c.daysbetween(System.today()) > 30)
            )
           {surveyIdsMap = new Map<String, Id>();
            surveyIdsMap.put('caseId',          caseToProcess.Id);
            surveyIdsMap.put('contactId',       caseToProcess.contactId);
            surveyIdsMap.put('emailTemplateId', emailTemplateId);
            surveyIdsList.add(surveyIdsMap);
            contactIdsToReceiveSurvey.add(caseToProcess.contactId);
            System.debug('DEBUG: (CaseTrigger) Added following IDs to be processed for survey:');
            System.debug('DEBUG: (CaseTrigger)   caseId          = ' + caseToProcess.Id);
            System.debug('DEBUG: (CaseTrigger)   contactId       = ' + caseToProcess.contactId);
            System.debug('DEBUG: (CaseTrigger)   emailTemplateId = ' + emailTemplateId);
           }
        }

      // Send the surveys
      surveyUtilities.sendSurveys(surveyIdsList);

      // Update the Contacts' Last Survey Sent Date fields
      System.debug('DEBUG: (CaseTrigger) contactIdsToReceiveSurvey size = ' + contactIdsToReceiveSurvey.size());
      contactsToUpdate = [SELECT Id, contactLastSurveySentDate__c FROM Contact WHERE Id IN :contactIdsToReceiveSurvey];
      System.debug('DEBUG: (CaseTrigger) contactsToUpdate size = ' + contactsToUpdate.size());
      for (Contact contactToUpdate : contactsToUpdate)
        {contactToUpdate.contactLastSurveySentDate__c = System.today();
        }
      update contactsToUpdate;
     }
  }