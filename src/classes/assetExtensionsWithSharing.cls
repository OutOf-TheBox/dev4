public with sharing class assetExtensionsWithSharing
  {private final ApexPages.StandardController controller;
   private final Asset asset;
   public String profileName {get; set;}
   private List<Case> cases;
   public assetExtensionsWithSharing(ApexPages.StandardController argController)
     {
       Id userId;
      List<User> users;

      controller = argController;
      asset = (Asset)controller.getRecord();

      // Retrieve the user's profile name
      userId = UserInfo.getUserId();
      users = [SELECT Profile.Name from User where Id = :userId];
      profileName = users[0].Profile.Name;
     }
   public List<Case> getCases()
   { 
       cases = [Select Id, AccountId, CaseNumber, Owner.Name, OwnerId, Category__c, Status, Priority, Subject, Contact.Name, ContactId, CreatedDate, Case_Type__c from Case where AssetId =: asset.Id and (Case_Type__c = null or Case_Type__c = 'External')];
       return cases;
   }
   public PageReference assetDispatchViewUrl() 
     {PageReference       newPage;
      Map<String, String> mapParameters;

      if (profileName == 'Nimble Customer Portal Profile' || profileName == 'NS-PORT-CustomerPortal')
        {// Redirect to custom Visualforce page
         newPage = Page.assetPortalViewPage;
        }
      else
        {// Redirect to standard page
         newPage = new PageReference('/' + asset.id);
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

   public PageReference assetDispatchEditUrl()
     {PageReference newPage;
      Map<String, String> mapParameters;

      if (profileName == 'Nimble Customer Portal Profile' || profileName == 'NS-PORT-CustomerPortal')
        {// Redirect to custom Visualforce page
         newPage = Page.assetPortalEditPage;
        }
      else
        {// Redirect to standard page
         newPage = new PageReference('/' + asset.id + '/e');
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