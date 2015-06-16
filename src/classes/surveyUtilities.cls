public class surveyUtilities
  {public static void sendSurveys(List<Map<String, Id>> idsToProcess)
     {List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
      List<OrgWideEmailAddress> orgWideEmailAddresses;
      Id orgWideEmailAddressId;
      Id caseId;
      Id contactId;
      Id emailTemplateId;

      // Get the ID of the 'donotreply' organization wide email address
      orgWideEmailAddresses = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'donotreply@nimblestorage.com'];
      if (orgWideEmailAddresses.size() <> 1)
        {System.debug('DEBUG: (sendSurveyEmail) Failed to find one org wide email address for donotreply@nimblestorage.com');
         System.debug('DEBUG: (sendSurveyEmail) orgWideEmailAddresses size <> 1; size = ' + orgWideEmailAddresses.size());
         return;
        }
      orgWideEmailAddressId = orgWideEmailAddresses[0].Id;

      // Loop through each set of IDs that was passed to us and build the email for it
      for (Map<String, Id> idToProcess : idsToProcess)
        {caseId          = idToProcess.get('caseId');
         contactId       = idToProcess.get('contactId');
         emailTemplateId = idToProcess.get('emailTemplateId');

         System.debug('DEBUG: (sendSurveys) IDS TO PROCESS:');
         System.debug('DEBUG: (sendSurveys)   caseId = ' + caseId);
         System.debug('DEBUG: (sendSurveys)   contactId = ' + contactId);
         System.debug('DEBUG: (sendSurveys)   emailTemplateId = ' + emailTemplateId);

         Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();

         emailToSend.setTemplateId(emailTemplateId);                   // ID of the email template to use
         emailToSend.setOrgWideEmailAddressId(orgWideEmailAddressId);  // ID of the 'donotreply' organization wide email address
         emailToSend.setTargetObjectId(contactId);                     // ID of the contact
         emailToSend.setWhatId(caseId);                                // ID of the case
         emailToSend.setBccSender(false);                              // Do not BCC the sender
         emailToSend.setSaveAsActivity(false);                         // Do not save the email as an activity
         emailToSend.setUseSignature(false);                           // Do not use an email signature

         emailsToSend.add(emailToSend);
        }

      // Send out the survey emails
      try
        {Messaging.sendEmail(emailsToSend);
        }

      catch(Exception e)
        {System.debug('DEBUG: (sendSurveyEmail) Failed to send emails; exception = ' + e.getMessage());
         return;
        }
     }
  }