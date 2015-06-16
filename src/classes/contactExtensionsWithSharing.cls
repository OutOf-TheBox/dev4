public with sharing class contactExtensionsWithSharing
  {private final ApexPages.StandardController controller;
   private final Contact contact;
   public String profileName {get; set;}
   public Id accountId {get; set;}
   public Id conaccountId {get; set;}
   public String saveErrorMessage {get; set;}
   private List<Case> cases;

   public contactExtensionsWithSharing(ApexPages.StandardController argController)
     {Id userId;
      List<User> users;

      controller = argController;
      contact = (Contact)controller.getRecord();
      //Added by pradeep 
      if(contact.Id != null)
      {
          Contact c1 = [select Id, AccountId from Contact where Id =: contact.Id];
          conaccountId = c1.AccountId;
      }
      // Retrieve the user's profile name and account ID.
      // Only portal users will have account ID populated, and it's only needed when saving a new contact record.
      userId = UserInfo.getUserId();
      users = [SELECT Profile.Name, AccountId from User where Id = :userId];
      accountId = users[0].AccountId;
      profileName = users[0].Profile.Name;
     }
 public List<Case> getCases()
   { 
       cases = [Select Id, AccountId, CaseNumber, Owner.Name, OwnerId, Category__c, Status, Priority, Subject, Contact.Name, ContactId, CreatedDate, Case_Type__c from Case where ContactId =: contact.Id and (Case_Type__c = null or Case_Type__c = 'External')];
       return cases;
   }
  public PageReference contactCustomSave()
    {List<Contact> contacts;

     // Throw error if trying to save contact with same First and Last Name as existing contact
     contacts = [SELECT Id
                 FROM   Contact
                 WHERE  Id        <> :contact.id and
                        FirstName  = :contact.FirstName and
                        LastName   = :contact.LastName];

     if (contacts.size() >= 1)
       {contact.FirstName.addError('Duplicate contact exists for this same First Name and Last Name.  Contact cannot be saved for duplicate contacts.');
        saveErrorMessage = 'Duplicate contact exists for this same First Name and Last Name.  Contact cannot be saved for duplicate contacts.';
        return(null);
       }

     // Throw error if trying to save contact as inactive, and it's still the contact on active assets
     if (contact.contactInactive__c && (numActiveAssetsContactIsOn() >= 1))
       {contact.addError('Cannot store contact as Inactive because it is a contact on active assets (assets in Shipped or Return Pending status).');
        saveErrorMessage = 'Cannot store contact as Inactive because it is a contact on active assets (assets in Shipped or Return Pending status).';
        return(null);
       }

     // Throw error if trying to save contact as inactive, and it's still the contact on active cases
     if (contact.contactInactive__c && (numActiveCasesContactIsOn() >= 1))
       {contact.addError('Cannot store contact as Inactive because it is a contact on active cases (cases not in Closed status).');
        saveErrorMessage = 'Cannot store contact as Inactive because it is a contact on active cases (cases not in Closed status).';
        return(null);
       }

     // Throw error if both Phone and Mobile Phone are blank
     if (contact.Phone == null && contact.MobilePhone == null)
       {contact.Phone.addError('Phone and Mobile Phone are both blank.  At least one is required to save contact.');
        saveErrorMessage = 'Phone and Mobile Phone are both blank.  At least one is required to save contact.';
        return(null);
       }

     // If we got this far, there were no errors thrown, so proceed with saving the record

     // If this is a new contact, set initial values of some fields
     if (contact.id == null)
       {contact.accountid = accountId;
       }

     // Invoke standard controller save method and return its PageReference
     saveErrorMessage = null;
     return(controller.save());
    }

   public Integer numActiveAssetsContactIsOn()
     {List<Asset> assets;

      if(contact.id == null)
        {return(0);
        }
      else
        {assets = [SELECT Id
                   FROM   Asset
                   WHERE  contactId = :contact.id and
                          status <> 'Decommissioned' and
                          status <> 'Returned' and
                          status <> 'Scrapped'];

         return(assets.size());
        }
     }

   public Integer numActiveCasesContactIsOn()
     {List<Case> cases;

      if(contact.id == null)
        {return(0);
        }
      else
        {cases = [SELECT Id
                  FROM   Case
                  WHERE  contactId = :contact.id and
                         status <> 'Duplicate' and
                         status <> 'Closed'];

         return(cases.size());
        }
     }

   public PageReference contactDispatchViewUrl()
     {PageReference       newPage;
      Map<String, String> mapParameters;

      if (profileName == 'Nimble Customer Portal Profile' || profileName == 'NS-PORT-CustomerPortal' )
        {// Redirect to custom Visualforce page
         newPage = Page.contactPortalViewPage;
        }
      else
        {// Redirect to standard page
         newPage = new PageReference('/' + contact.id);
         newPage.getParameters().put('nooverride', '1');
        }

      // Transfer any URL parameters we received to the next page reference
      mapParameters = ApexPages.currentPage().getParameters();
      for (String parameterName:mapParameters.keySet())
        {if (parameterName <> 'save_new')
           {newPage.getParameters().put(parameterName, mapParameters.get(parameterName));
           }
        }

      return newPage.setRedirect(true);
     }

   public PageReference contactDispatchEditUrl()
     {PageReference newPage;
      Map<String, String> mapParameters;

      if (profileName == 'Nimble Customer Portal Profile' || profileName == 'NS-PORT-CustomerPortal')
        {// Redirect to custom Visualforce page
         newPage = Page.contactPortalEditPage;
        }
      else
        {// Redirect to standard page
         newPage = new PageReference('/' + contact.id + '/e');
         newPage.getParameters().put('nooverride', '1');
        }

      // Transfer any URL parameters we received to the next page reference
      mapParameters = ApexPages.currentPage().getParameters();
      for (String parameterName:mapParameters.keySet())
        {if (parameterName <> 'save_new')
           {newPage.getParameters().put(parameterName, mapParameters.get(parameterName));
           }
        }

      return newPage.setRedirect(true);
     }

   public PageReference contactDispatchNewUrl()
     {PageReference newPage;
      Map<String, String> mapParameters;

      if (profileName == 'Nimble Customer Portal Profile' || profileName == 'NS-PORT-CustomerPortal')
        {// Redirect to custom Visualforce page
         newPage = Page.contactPortalNewPage;
        }
      else
        {// Redirect to standard page
         newPage = new PageReference('/003/e');
         newPage.getParameters().put('nooverride', '1');
        }

      // Transfer any URL parameters we received to the next page reference
      mapParameters = ApexPages.currentPage().getParameters();
      for (String parameterName:mapParameters.keySet())
        {if (parameterName <> 'save_new')
           {newPage.getParameters().put(parameterName, mapParameters.get(parameterName));
           }
        }

      return newPage.setRedirect(true);
     }
  }