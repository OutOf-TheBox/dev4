trigger caseTriggerSetOwnerEmail on Case (before insert, before update)
  {for (Case triggerCase : trigger.new)
     {List<User> aUser;

      if (triggerCase.ownerid == null)
        {triggerCase.caseOwnerEmail__c = null;
        }
      else
        {aUser = [SELECT email from User where id = :triggerCase.ownerid];

         if (aUser.size() == 1)
           {triggerCase.caseOwnerEmail__c = aUser[0].email;
           }
         else
           {triggerCase.caseOwnerEmail__c = null;
           }
        }
     }
  }