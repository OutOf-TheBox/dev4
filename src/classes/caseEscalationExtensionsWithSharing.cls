public with sharing class caseEscalationExtensionsWithSharing
  {private final ApexPages.StandardController controller;
   private final caseEscalation__c caseEscalation;

   private final List<String> groups;
   public String groupValue
     {get
        {System.debug('DEBUG: (getGroupValue) Returning groupValue = ' + groupValue);
         return(groupValue);
        }
      set
        {groupValue = value;
         System.debug('DEBUG: (setGroupValue) Set groupValue = ' + groupValue);

         // #
         // # If we built a list of user IDs for the group, that
         // # means the user field is required, so so don't disable it.
         // # Otherwise, user field is not required, so disable it.
         // #
         if (userIdsByGroup.containsKey(groupValue))
           {disableUser = false;
            System.debug('DEBUG: (setGroupValue) Set disableUser = false');
           }
         else
           {disableUser = true;
            System.debug('DEBUG: (setGroupValue) Set disableUser = true');
           }
        }
     }

   private final Map<String, Set<Id>> userIdsByGroup = new Map<String, Set<Id>>();
   private final Map<Id, String> userNameById = new Map<Id, String>();
   private final Map<String, Id> userIdByName = new Map<String, Id>();
   public String userValue
     {get
        {System.debug('DEBUG: (getUserValue) Returning userValue = ' + userValue);
         return(userValue);
        }
      set
        {userValue = value;
         System.debug('DEBUG: (setUserValue) Set userValue = ' + userValue);
        }
     }

   public Boolean disableUser
     {get
        {System.debug('DEBUG: (getDisableUser) Returning disableUser = ' + disableUser);
         return(disableUser);
        }
      set
        {disableUser = value;
         System.debug('DEBUG: (setDisableUser) Set disableUser = ' + disableUser);
        }
     }

// NOTE: See the below URL for more info on creating select lists with similar
//       functionality to dependent picklists:
//       http://salesforce.stackexchange.com/questions/11588/how-to-make-a-cascading-dependent-select-list-drop-down-in-a-data-table-in-v

// ################################################################################### CONSTRUCTOR
   public caseEscalationExtensionsWithSharing(ApexPages.StandardController argController)
     {List<caseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;
      Set<String> groupsTempSet = new Set<String>();
      List<caseEscalation__c> caseEscalations;

      System.debug('DEBUG: (constructor) Constructor called');

      controller     = argController;
      caseEscalation = (caseEscalation__c)controller.getRecord();

      caseEscalationTypeDefinitions = [SELECT   Id,
                                                Name,
                                                caseEscalationTypeDefinitionGroup__c,
                                                caseEscalationTypeDefinitionUser__c,
                                                caseEscalationTypeDefinitionUser__r.Name
                                       FROM     caseEscalationTypeDefinition__c
                                       ORDER BY Name];

      // #
      // # Iterate through each Case Escalation Type Definition record
      // #
      for (caseEscalationTypeDefinition__c caseEscalationTypeDefinition : caseEscalationTypeDefinitions)
        {// #
         // # Store the group name in a temporary set.  This will
         // # be used later for sorting purposes.
         // #
         groupsTempSet.add(caseEscalationTypeDefinition.caseEscalationTypeDefinitionGroup__c);

         // #
         // # If there is a user ID, store it in a map where the
         // # group name is the key, and the values are a set of
         // # user IDs for that group name.
         // #
         // # Also store the user name and ID in maps for later
         // # use in building select list options.
         // #
         if (caseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__c != null)
           {if (!userIdsByGroup.containsKey(caseEscalationTypeDefinition.caseEscalationTypeDefinitionGroup__c))
              {userIdsByGroup.put(caseEscalationTypeDefinition.caseEscalationTypeDefinitionGroup__c, new Set<Id>());
              }
            userIdsByGroup.get(caseEscalationTypeDefinition.caseEscalationTypeDefinitionGroup__c).add(caseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__c);

            userNameById.put(caseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__c, caseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__r.Name);
            userIdByName.put(caseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__r.Name, caseEscalationTypeDefinition.caseEscalationTypeDefinitionUser__c);
           }
        }

      // #
      // # Create a new list from the temporary set of group names,
      // # then sort the list.  We do this because sets do not have
      // # a sort() method, but lists do, and we can initialize a
      // # list from the temporary set.
      // #
      groups = new List<String>(groupsTempSet);
      groups.sort();

      // #
      // # If this is a new record, go ahead and set the 
      // # group and user values to their "null" equivalents.
      // #
      // # Otherwise, this is an existing record, so get the
      // # initial group and user values from the case escalation
      // # type definition record.
      // #
      if (caseEscalation.Id == null)
        {groupValue = 'None';
         userValue  = '000000000000000';
        }
      else
        {caseEscalations = [SELECT Id,
                                   caseEscalationTypeDefinition__r.caseEscalationTypeDefinitionGroup__c,
                                   caseEscalationTypeDefinition__r.caseEscalationTypeDefinitionUser__c
                            FROM   caseEscalation__c
                            WHERE  Id = :caseEscalation.Id];

         groupValue = caseEscalations[0].caseEscalationTypeDefinition__r.caseEscalationTypeDefinitionGroup__c;
         userValue  = caseEscalations[0].caseEscalationTypeDefinition__r.caseEscalationTypeDefinitionUser__c;
        }
     }

// ################################################################################### getGroupOptions
   public List<SelectOption> getGroupOptions()
     {List<SelectOption> groupOptions = new List<SelectOption>();

      groupOptions.add(new SelectOption('None','--None--'));

      for (String aGroup : groups)
        {groupOptions.add(new SelectOption(aGroup, aGroup));
        }

      System.debug('DEBUG: (getGroupOptions) returning groupOptions = ' + groupOptions);

      return(groupOptions);
     }

// ################################################################################### getUserOptions
   public List<SelectOption> getUserOptions()
     {List<SelectOption> userOptions = new List<SelectOption>();
      Set<String> userNamesTempSet = new Set<String>();
      List<String> userNamesTempList;

      userOptions.add(new SelectOption('000000000000000','--None--'));

      if (groupValue != null)
        {if (userIdsByGroup.containsKey(groupValue))
           {for (Id userId : userIdsByGroup.get(groupValue))
              {userNamesTempSet.add(userNameById.get(userId));
              }

            userNamesTempList = new List<String>(userNamesTempSet);
            userNamesTempList.sort();

            for (String userName : userNamesTempList)
              {userOptions.add(new SelectOption(userIdByName.get(userName), userName));
              }
           }
        }

      System.debug('DEBUG: (getUserOptions) groupValue = ' + groupValue);
      System.debug('DEBUG: (getUserOptions) returning userOptions = ' + userOptions);

      return(userOptions);
     }

// ################################################################################### customSave
   public PageReference customSave()
     {PageReference pageRef;
      List<caseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;
      Id userId;

      System.debug('DEBUG: (customSave) ENTERED');

      System.debug('DEBUG: (customSave) groupValue = ' + groupValue);
      if (groupValue == 'None')
        {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: Group value cannot be empty.  Select the appropriate Group.'));
         return(null);
        }

      if (userIdsByGroup.containsKey(groupValue))
        {if (userValue == '000000000000000')
           {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: User value cannot be empty for this Group.  Select the appropriate User.'));
            return(null);
           }
         else
           {userId = userValue;
           }
        }
      else
        {userId = null;
        }

      caseEscalationTypeDefinitions = [SELECT   Id
                                       FROM     caseEscalationTypeDefinition__c
                                       WHERE    caseEscalationTypeDefinitionGroup__c = :groupValue AND
                                                caseEscalationTypeDefinitionUser__c  = :userId];

      if (caseEscalationTypeDefinitions.size() != 1)
        {ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: Failed to find one Case Escalation Type Definition record with these Group and User values.  size = ' + caseEscalationTypeDefinitions.size()));
         return(null);
        }

      try
        {caseEscalation.caseEscalationTypeDefinition__c = caseEscalationTypeDefinitions[0].Id;
         upsert(caseEscalation);
        }
      catch(System.DMLException e)
        {ApexPages.addMessages(e);
         return(null);
        }

      pageRef = new PageReference('/' + caseEscalation.caseEscalationCase__c);

      return(pageRef);
     }
  }