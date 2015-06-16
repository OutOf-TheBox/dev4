trigger OpenCase on EmailMessage (after insert)
  {EmailMessage[] emailMessages = Trigger.new;
    
   for(EmailMessage emailMessage : emailMessages)
     {Boolean rejectSubject = emailMessage.subject != null &&
                              (emailMessage.subject.containsIgnoreCase('Out of office ')    ||
                               emailMessage.subject.containsIgnoreCase('OOO')               ||
                               emailMessage.subject.containsIgnoreCase('out of the office') ||
                               emailMessage.subject.containsIgnoreCase('PTO')               ||
                               emailMessage.subject.containsIgnoreCase('Auto Reply' )       ||
                               emailMessage.subject.containsIgnoreCase('Auto Response')     ||
                               emailMessage.subject.containsIgnoreCase('[Auto-Reply]')      ||
                               emailMessage.subject.containsIgnoreCase('[Out of office]')   ||
                               emailMessage.subject.containsIgnoreCase('Out-of-office')     ||
                               emailMessage.subject.containsIgnoreCase('auto-response')     ||
                               emailMessage.subject.containsIgnoreCase('[Out-of-office]')   ||
                               emailMessage.subject.containsIgnoreCase('autoresponse RE')   ||
                               emailMessage.subject.containsIgnoreCase('autoreply')         ||
                               emailMessage.subject.containsIgnoreCase('autoresponse')      ||
                               emailMessage.subject.containsIgnoreCase('vacation')          ||
                               emailMessage.subject.containsIgnoreCase('auto response')     ||
                               emailMessage.subject.containsIgnoreCase('Out of Office' )    ||
                               emailMessage.subject.containsIgnoreCase('Automatic reply')   ||
                               emailMessage.subject.containsIgnoreCase('Undeliverable')
                              );

      Boolean rejectSurvey = !emailMessage.incoming &&
                             (emailMessage.fromaddress != null && emailMessage.fromaddress.containsIgnoreCase('donotreply')) &&
                             ((emailMessage.HtmlBody != null && emailMessage.HtmlBody.containsIgnoreCase('clicktools.com'))  ||
                              (emailMessage.TextBody != null && emailMessage.TextBody.containsIgnoreCase('clicktools.com'))
                             );

      Boolean rejectUndeliverable = false;

      if (emailMessage.subject != null)
        {Pattern patternUndeliverable = Pattern.compile('(?i).*?undeliverable.*');
         Matcher matcherUndeliverable = patternUndeliverable.matcher(emailMessage.subject);
         rejectUndeliverable  = matcherUndeliverable.matches();
        }

      if (!rejectSubject && !rejectSurvey && !rejectUndeliverable)
        {List<Case> cases = [SELECT Status from Case where Id = :emailMessage.ParentId];           
         if(!cases.isEmpty())
           {Case aCase = cases[0];
            if (aCase.Status == 'Closed')
              {aCase.Status = 'Open';
               update aCase;
              }
           }            
        }        
     }
  }