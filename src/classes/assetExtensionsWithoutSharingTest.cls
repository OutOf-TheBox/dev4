@isTest
private class assetExtensionsWithoutSharingTest
  {// ==================================================================================== createTestData
   static testMethod void createTestData()
     {Account  account;
      Contact  contact;
      Asset    asset;
      List<Account>  accounts;
      List<Contact>  contacts;
      List<Asset>    assets;
      ID testAccountId;
      ID testContactActiveId;
      ID testContactInactiveId;
      ID testAssetShippedId;

      // Create test account
      account = new Account(Name = 'TEST-ACCOUNT');
      insert account;
      accounts = [SELECT Id,
                         Name
                  FROM   Account
                  WHERE  Name = 'TEST-ACCOUNT'];

      System.assertEquals(1,              accounts.size());
      System.assertEquals('TEST-ACCOUNT', accounts[0].Name);
      testAccountId = accounts[0].id;

      // Create test active contact
      contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                            LastName    = 'TEST-CONTACT-LAST-NAME',
                            Phone       = 'TEST-CONTACT-PHONE',
                            MobilePhone = 'TEST-CONTACT-MOBILE',
                            AccountId   = testAccountId);
      insert contact;
      contacts = [SELECT Id,
                         FirstName,
                         LastName,
                         Phone,
                         MobilePhone,
                         AccountId
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      System.assertEquals(1,                         contacts.size());
      System.assertEquals('TEST-CONTACT-FIRST-NAME', contacts[0].FirstName);
      System.assertEquals('TEST-CONTACT-LAST-NAME',  contacts[0].LastName);
      System.assertEquals('TEST-CONTACT-PHONE',      contacts[0].Phone);
      System.assertEquals('TEST-CONTACT-MOBILE',     contacts[0].MobilePhone);
      System.assertEquals(testAccountId,             contacts[0].AccountId);
      testContactActiveId = contacts[0].id;

      // Create test inactive contact
      contact = new Contact(FirstName          = 'TEST-CONTACT-INACTIVE-FIRST-NAME',
                            LastName           = 'TEST-CONTACT-INACTIVE-LAST-NAME',
                            Phone              = 'TEST-CONTACT-INACTIVE-PHONE',
                            MobilePhone        = 'TEST-CONTACT-INACTIVE-MOBILE',
                            AccountId          = testAccountId,
                            contactInactive__c = true);
      insert contact;
      contacts = [SELECT Id,
                         FirstName,
                         LastName,
                         Phone,
                         MobilePhone,
                         AccountId,
                         contactInactive__c
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-INACTIVE-LAST-NAME'];

      System.assertEquals(1,                                  contacts.size());
      System.assertEquals('TEST-CONTACT-INACTIVE-FIRST-NAME', contacts[0].FirstName);
      System.assertEquals('TEST-CONTACT-INACTIVE-LAST-NAME',  contacts[0].LastName);
      System.assertEquals('TEST-CONTACT-INACTIVE-PHONE',      contacts[0].Phone);
      System.assertEquals('TEST-CONTACT-INACTIVE-MOBILE',     contacts[0].MobilePhone);
      System.assertEquals(testAccountId,                      contacts[0].AccountId);
      System.assertEquals(true,                               contacts[0].contactInactive__c);
      testContactInactiveId = contacts[0].id;

      // Create test Shipped asset
      asset = new Asset(Name = 'TEST-ASSET-SHIPPED',
                        Status = 'Shipped',
                        AccountId  = testAccountId,
                        ContactId  = testContactActiveId,
                        SLA__c = 'Premium',
                        Install_Street1__c        = 'TEST-ASSET-INSTALL-STREET1',
                        Install_Street2__c        = 'TEST-ASSET-INSTALL-STREET2',
                        Install_City__c           = 'TEST-ASSET-INSTALL-CITY',
                        Install_State_Province__c = 'TEST-ASSET-INSTALL-STATE');
      insert asset;
      assets = [SELECT Id,
                       Name,
                       Status,
                       AccountId,
                       ContactId,
                       SLA__c,
                       Install_Street1__c,
                       Install_Street2__c,
                       Install_City__c,
                       Install_State_Province__c

                FROM   Asset
                WHERE  Name = 'TEST-ASSET-SHIPPED'];

      System.assertEquals(1,                             assets.size());
      System.assertEquals('TEST-ASSET-SHIPPED',          assets[0].Name);
      System.assertEquals('Shipped',                     assets[0].Status);
      System.assertEquals(testAccountId,                 assets[0].AccountId);
      System.assertEquals(testContactActiveId,           assets[0].ContactId);
      System.assertEquals('Premium',                     assets[0].SLA__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
      System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
      System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);
      testAssetShippedId = assets[0].id;
     }

   // ==================================================================================== testErrorInactiveContact
   static testMethod void testErrorInactiveContact()
     {List<Contact> contacts;
      List<Asset>   assets;
      ApexPages.StandardController assetController;
      assetExtensionsWithoutSharing assetExtension;
      PageReference returnedPageReference;

      createTestData();

      contacts = [SELECT Id
                  FROM   Contact
                  WHERE  FirstName = 'TEST-CONTACT-INACTIVE-FIRST-NAME'];

      assets = [SELECT Id
                FROM   Asset
                WHERE  Name = 'TEST-ASSET-SHIPPED'];

      assets[0].contactId = contacts[0].id;

      assetController = new ApexPages.StandardController(assets[0]);
      assetExtension  = new assetExtensionsWithoutSharing(assetController);

      returnedPageReference = assetExtension.assetCustomSave();
      System.assertEquals(null, returnedPageReference);
      System.assertEquals('This contact is inactive.  Assets cannot be saved with an inactive contact.', assetExtension.saveErrorMessage);
     }

   // ==================================================================================== testGoodSave
   static testMethod void testGoodSave()
     {List<Contact> contacts;
      List<Asset>   assets;
      ApexPages.StandardController assetController;
      assetExtensionsWithoutSharing assetExtension;
      PageReference returnedPageReference;

      createTestData();

      contacts = [SELECT Id
                  FROM   Contact
                  WHERE  FirstName = 'TEST-CONTACT-FIRST-NAME'];

      assets = [SELECT Id
                FROM   Asset
                WHERE  Name = 'TEST-ASSET-SHIPPED'];

      assets[0].contactId = contacts[0].id;

      assetController = new ApexPages.StandardController(assets[0]);
      assetExtension  = new assetExtensionsWithoutSharing(assetController);

      returnedPageReference = assetExtension.assetCustomSave();
      System.assertNotEquals(null, returnedPageReference);
      System.assertEquals(null, assetExtension.saveErrorMessage);
     }
  }