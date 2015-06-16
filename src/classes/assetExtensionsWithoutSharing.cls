public without sharing class assetExtensionsWithoutSharing
  {private final ApexPages.StandardController controller;
   private final Asset asset;
   public String saveErrorMessage {get; set;}

   public assetExtensionsWithoutSharing(ApexPages.StandardController argController)
     {controller = argController;
      asset = (Asset)controller.getRecord();
     }

  public PageReference assetCustomSave()
    {List<Asset> assetsToUpdate;
     PageReference newPage;

     // Throw error if trying to save asset with an inactive contact
     if (contactIsInactive())
       {asset.contactId.addError('This contact is inactive.  Assets cannot be saved with an inactive contact.');
        saveErrorMessage = 'This contact is inactive.  Assets cannot be saved with an inactive contact.';
        return(null);
       }

     // No errors, so update the record, and return a page reference

     saveErrorMessage = null;
     assetsToUpdate = [SELECT id,
                              contactId,
                              Install_Street1__c,
                              Install_Street2__c,
                              Install_City__c,
                              Install_State_Province__c,
                              Install_Zip_Code__c,
                              Install_Country__c
                       FROM   Asset
                       WHERE  id = :asset.id];

     assetsToUpdate[0].contactId                 = asset.contactId;
     assetsToUpdate[0].Install_Street1__c        = asset.Install_Street1__c;
     assetsToUpdate[0].Install_Street2__c        = asset.Install_Street2__c;
     assetsToUpdate[0].Install_City__c           = asset.Install_City__c;
     assetsToUpdate[0].Install_State_Province__c = asset.Install_State_Province__c;
     assetsToUpdate[0].Install_Zip_Code__c       = asset.Install_Zip_Code__c;
     assetsToUpdate[0].Install_Country__c        = asset.Install_Country__c;

     update assetsToUpdate[0];

     if (ApexPages.currentPage().getParameters().get('retURL') == null)
       {newPage = Page.assetPortalViewPage;
       }
     else
       {newPage = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
       }

     return(newPage.setRedirect(true));
    }

  public Boolean contactIsInactive()
    {List<Contact> contacts;

     contacts = [SELECT id,
                        contactInactive__c
                 FROM   Contact
                 WHERE  id = :asset.contactId];

     return(contacts[0].contactInactive__c);
    }
  }