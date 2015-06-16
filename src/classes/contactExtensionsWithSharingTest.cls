@isTest
private class contactExtensionsWithSharingTest
  {// ==================================================================================== createTestData
   static testMethod void createTestData()
     {Account account;
      Contact contact;
      Asset   asset;
      Case    aCase;
      List<Account> accounts;
      List<Contact> contacts;
      List<Asset>   assets;
      List<Case>    cases;
      ID testAccountId;
      ID testContactId;
      ID testAssetShippedId;
      ID testAssetScrappedId;
      ID testCaseOpenId;
      ID testCaseClosedId;

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

      // Create test contact
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
      testContactId = contacts[0].id;

      // Create test Shipped asset
      asset = new Asset(Name = 'TEST-ASSET-SHIPPED',
                        Status = 'Shipped',
                        AccountId = testAccountId,
                        ContactId = testContactId,
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
      System.assertEquals(testContactId,                 assets[0].ContactId);
      System.assertEquals('Premium',                     assets[0].SLA__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
      System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
      System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);
      testAssetShippedId = assets[0].id;

      // Create test Scrapped asset
      asset = new Asset(Name = 'TEST-ASSET-SCRAPPED',
                        Status = 'Scrapped',
                        AccountId = testAccountId,
                        ContactId = testContactId,
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
                WHERE  Name = 'TEST-ASSET-SCRAPPED'];

      System.assertEquals(1,                             assets.size());
      System.assertEquals('TEST-ASSET-SCRAPPED',         assets[0].Name);
      System.assertEquals('Scrapped',                    assets[0].Status);
      System.assertEquals(testAccountId,                 assets[0].AccountId);
      System.assertEquals(testContactId,                 assets[0].ContactId);
      System.assertEquals('Premium',                     assets[0].SLA__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
      System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
      System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);
      testAssetScrappedId = assets[0].id;

      // Create test Open case
      aCase = new Case(AccountId = testAccountId,
                       AssetId   = testAssetShippedId,
                       ContactId = testContactId,
                       Status = 'Open',
                       Subject = 'TEST-CASE-OPEN-SUBJECT');
      insert aCase;
      cases = [SELECT Id,
                      AccountId,
                      AssetId,
                      ContactId,
                      Status,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-OPEN-SUBJECT'];

      System.assertEquals(1,                        cases.size());
      System.assertEquals(testAccountId,            cases[0].AccountId);
      System.assertEquals(testAssetShippedId,       cases[0].AssetId);
      System.assertEquals(testContactId,            cases[0].ContactId);
      System.assertEquals('Open',                   cases[0].Status);
      System.assertEquals('TEST-CASE-OPEN-SUBJECT', cases[0].Subject);
      testCaseOpenId = cases[0].id;

      // Create test Closed case
      aCase = new Case(AccountId = testAccountId,
                       AssetId   = testAssetShippedId,
                       ContactId = testContactId,
                       Status = 'Closed',
                       Subject = 'TEST-CASE-CLOSED-SUBJECT');
      insert aCase;
      cases = [SELECT Id,
                      AccountId,
                      AssetId,
                      ContactId,
                      Status,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-CLOSED-SUBJECT'];

      System.assertEquals(1,                          cases.size());
      System.assertEquals(testAccountId,              cases[0].AccountId);
      System.assertEquals(testAssetShippedId,         cases[0].AssetId);
      System.assertEquals(testContactId,              cases[0].ContactId);
      System.assertEquals('Closed',                   cases[0].Status);
      System.assertEquals('TEST-CASE-CLOSED-SUBJECT', cases[0].Subject);
      testCaseClosedId = cases[0].id;
     }

   // ==================================================================================== testViewUrlPortalUser
   static testMethod void testViewUrlPortalUser()
     {List<User> users;
      List<Contact> contacts;
      Contact contact;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test contact under portal user's account
      contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                            LastName    = 'TEST-CONTACT-LAST-NAME',
                            Phone       = 'TEST-CONTACT-PHONE',
                            MobilePhone = 'TEST-CONTACT-MOBILE',
                            AccountId   = users[0].accountId);
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
      System.assertEquals(users[0].accountId,        contacts[0].AccountId);

      System.runAs(users[0])
        {ApexPages.StandardController contactController;
         contactExtensionsWithSharing contactExtension;

         contactController = new ApexPages.StandardController(contacts[0]);
         contactExtension  = new contactExtensionsWithSharing(contactController);

         System.assertEquals('Nimble Customer Portal Profile', contactExtension.profileName);
         System.assertEquals(users[0].accountId, contactExtension.accountId);
         System.assertEquals('/apex/contactportalviewpage', contactExtension.contactDispatchViewUrl().getUrl());
        }
     }

   // ==================================================================================== testEditUrlPortalUser
   static testMethod void testEditUrlPortalUser()
     {List<User> users;
      List<Contact> contacts;
      Contact contact;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test contact under portal user's account
      contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                            LastName    = 'TEST-CONTACT-LAST-NAME',
                            Phone       = 'TEST-CONTACT-PHONE',
                            MobilePhone = 'TEST-CONTACT-MOBILE',
                            AccountId   = users[0].accountId);
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
      System.assertEquals(users[0].accountId,        contacts[0].AccountId);

      System.runAs(users[0])
        {ApexPages.StandardController contactController;
         contactExtensionsWithSharing contactExtension;

         contactController = new ApexPages.StandardController(contacts[0]);
         contactExtension  = new contactExtensionsWithSharing(contactController);

         System.assertEquals('Nimble Customer Portal Profile', contactExtension.profileName);
         System.assertEquals(users[0].accountId, contactExtension.accountId);
         System.assertEquals('/apex/contactportaleditpage', contactExtension.contactDispatchEditUrl().getUrl());
        }
     }

   // ==================================================================================== testNewUrlPortalUser
   static testMethod void testNewUrlPortalUser()
     {List<User> users;
      Contact contact;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test contact under portal user's account
      contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                            LastName    = 'TEST-CONTACT-LAST-NAME',
                            Phone       = 'TEST-CONTACT-PHONE',
                            MobilePhone = 'TEST-CONTACT-MOBILE',
                            AccountId   = users[0].accountId);

      System.runAs(users[0])
        {ApexPages.StandardController contactController;
         contactExtensionsWithSharing contactExtension;

         contactController = new ApexPages.StandardController(contact);
         contactExtension  = new contactExtensionsWithSharing(contactController);

         System.assertEquals('Nimble Customer Portal Profile', contactExtension.profileName);
         System.assertEquals(users[0].accountId, contactExtension.accountId);
         System.assertEquals('/apex/contactportalnewpage', contactExtension.contactDispatchNewUrl().getUrl());
        }
     }

   // ==================================================================================== testViewUrlNonPortalUser
   static testMethod void testViewUrlNonPortalUser()
     {List<Contact> contacts;
      ApexPages.StandardController contactController;
      contactExtensionsWithSharing contactExtension;

      createTestData();

      contacts = [SELECT Id
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      contactController = new ApexPages.StandardController(contacts[0]);
      contactExtension  = new contactExtensionsWithSharing(contactController);

      System.assertNotEquals('Nimble Customer Portal Profile', contactExtension.profileName);
      System.assertEquals(null, contactExtension.accountId);
      System.assertEquals('/' + contacts[0].id + '?nooverride=1', contactExtension.contactDispatchViewUrl().getUrl());
     }

   // ==================================================================================== testEditUrlNonPortalUser
   static testMethod void testEditUrlNonPortalUser()
     {List<Contact> contacts;
      ApexPages.StandardController contactController;
      contactExtensionsWithSharing contactExtension;

      createTestData();

      contacts = [SELECT Id
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      contactController = new ApexPages.StandardController(contacts[0]);
      contactExtension  = new contactExtensionsWithSharing(contactController);

      System.assertNotEquals('Nimble Customer Portal Profile', contactExtension.profileName);
      System.assertEquals(null, contactExtension.accountId);
      System.assertEquals('/' + contacts[0].id + '/e?nooverride=1', contactExtension.contactDispatchEditUrl().getUrl());
     }

   // ==================================================================================== testNewUrlNonPortalUser
   static testMethod void testNewUrlNonPortalUser()
     {Contact contact;
      ApexPages.StandardController contactController;
      contactExtensionsWithSharing contactExtension;

      contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                            LastName    = 'TEST-CONTACT-LAST-NAME',
                            Phone       = 'TEST-CONTACT-PHONE',
                            MobilePhone = 'TEST-CONTACT-MOBILE');

      contactController = new ApexPages.StandardController(contact);
      contactExtension  = new contactExtensionsWithSharing(contactController);

      System.assertNotEquals('Nimble Customer Portal Profile', contactExtension.profileName);
      System.assertEquals(null, contactExtension.accountId);
      System.assertEquals('/003/e' + '?nooverride=1', contactExtension.contactDispatchNewUrl().getUrl());
     }

   // ==================================================================================== testNumActiveAssetsContactIsOn
   static testMethod void testNumActiveAssetsContactIsOn()
     {List<Contact> contacts;
      ApexPages.StandardController contactController;
      contactExtensionsWithSharing contactExtension;

      createTestData();

      contacts = [SELECT Id
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      contactController = new ApexPages.StandardController(contacts[0]);
      contactExtension  = new contactExtensionsWithSharing(contactController);

      System.assertEquals(1, contactExtension.numActiveAssetsContactIsOn());
     }

   // ==================================================================================== testNumActiveCasesContactIsOn
   static testMethod void testNumActiveCasesContactIsOn()
     {List<Contact> contacts;
      ApexPages.StandardController contactController;
      contactExtensionsWithSharing contactExtension;

      createTestData();

      contacts = [SELECT Id
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      contactController = new ApexPages.StandardController(contacts[0]);
      contactExtension  = new contactExtensionsWithSharing(contactController);

      System.assertEquals(1, contactExtension.numActiveCasesContactIsOn());
     }

   // ==================================================================================== testErrorDuplicateContact
   static testMethod void testErrorDuplicateContact()
     {List<User> users;
      List<Contact> contacts;
      Contact contact;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test contact under portal user's account
      contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                            LastName    = 'TEST-CONTACT-LAST-NAME',
                            Phone       = 'TEST-CONTACT-PHONE',
                            MobilePhone = 'TEST-CONTACT-MOBILE',
                            AccountId   = users[0].accountId);
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
      System.assertEquals(users[0].accountId,        contacts[0].AccountId);

      // Try to create duplicate contact
      System.runAs(users[0])
        {ApexPages.StandardController contactController;
         contactExtensionsWithSharing contactExtension;
         PageReference returnedPageReference;

         contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                               LastName    = 'TEST-CONTACT-LAST-NAME',
                               Phone       = 'TEST-CONTACT-PHONE',
                               MobilePhone = 'TEST-CONTACT-MOBILE');

         contactController = new ApexPages.StandardController(contact);
         contactExtension  = new contactExtensionsWithSharing(contactController);

         System.assertEquals('Nimble Customer Portal Profile', contactExtension.profileName);
         System.assertEquals(users[0].accountId, contactExtension.accountId);

         returnedPageReference = contactExtension.contactCustomSave();
         System.assertEquals(null, returnedPageReference);
         System.assertEquals('Duplicate contact exists for this same First Name and Last Name.  Contact cannot be saved for duplicate contacts.', contactExtension.saveErrorMessage);
        }
     }

   // ==================================================================================== testErrorPhones
   static testMethod void testErrorPhones()
     {List<User> users;
      Contact contact;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Try to create contact with both phones missing
      System.runAs(users[0])
        {ApexPages.StandardController contactController;
         contactExtensionsWithSharing contactExtension;
         PageReference returnedPageReference;

         contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                               LastName    = 'TEST-CONTACT-LAST-NAME');

         contactController = new ApexPages.StandardController(contact);
         contactExtension  = new contactExtensionsWithSharing(contactController);

         System.assertEquals('Nimble Customer Portal Profile', contactExtension.profileName);
         System.assertEquals(users[0].accountId, contactExtension.accountId);

         returnedPageReference = contactExtension.contactCustomSave();
         System.assertEquals(null, returnedPageReference);
         System.assertEquals('Phone and Mobile Phone are both blank.  At least one is required to save contact.', contactExtension.saveErrorMessage);
        }
     }

   // ==================================================================================== testErrorActiveAsset
   static testMethod void testErrorActiveAsset()
     {List<User> users;
      List<Contact> contacts;
      List<Asset> assets;
      Contact contact;
      Asset asset;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test contact under portal user's account
      contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                            LastName    = 'TEST-CONTACT-LAST-NAME',
                            Phone       = 'TEST-CONTACT-PHONE',
                            MobilePhone = 'TEST-CONTACT-MOBILE',
                            AccountId   = users[0].accountId);
      insert contact;
      contacts = [SELECT Id,
                         FirstName,
                         LastName,
                         Phone,
                         MobilePhone,
                         AccountId,
                         contactInactive__c
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      System.assertEquals(1,                         contacts.size());
      System.assertEquals('TEST-CONTACT-FIRST-NAME', contacts[0].FirstName);
      System.assertEquals('TEST-CONTACT-LAST-NAME',  contacts[0].LastName);
      System.assertEquals('TEST-CONTACT-PHONE',      contacts[0].Phone);
      System.assertEquals('TEST-CONTACT-MOBILE',     contacts[0].MobilePhone);
      System.assertEquals(users[0].accountId,        contacts[0].AccountId);
      System.assertEquals(false,                     contacts[0].contactInactive__c);

      // Create test asset under portal user's account
      asset = new Asset(Name = 'TEST-ASSET-SHIPPED',
                        Status = 'Shipped',
                        AccountId = users[0].accountId,
                        ContactId = contacts[0].id,
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
      System.assertEquals(users[0].accountId,            assets[0].AccountId);
      System.assertEquals(contacts[0].id,                assets[0].ContactId);
      System.assertEquals('Premium',                     assets[0].SLA__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
      System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
      System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);

      // Try to mark contact inactive
      System.runAs(users[0])
        {ApexPages.StandardController contactController;
         contactExtensionsWithSharing contactExtension;
         PageReference returnedPageReference;

         contacts[0].contactInactive__c = true;

         contactController = new ApexPages.StandardController(contacts[0]);
         contactExtension  = new contactExtensionsWithSharing(contactController);

         System.assertEquals('Nimble Customer Portal Profile', contactExtension.profileName);
         System.assertEquals(users[0].accountId, contactExtension.accountId);

         returnedPageReference = contactExtension.contactCustomSave();
         System.assertEquals(null, returnedPageReference);
         System.assertEquals('Cannot store contact as Inactive because it is a contact on active assets (assets in Shipped or Return Pending status).', contactExtension.saveErrorMessage);
        }
     }

   // ==================================================================================== testErrorActiveCase
   // NOTE: SeeAllData must be set to true for this test method because it uses an
   //       active portal user account
   @isTest(SeeAllData=true)
   static void testErrorActiveCase()
     {List<User> users;
      List<Contact> contacts;
      List<Asset> assets;
      List<Case> cases;
      Contact contact;
      Asset asset;
      Case aCase;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test contact under portal user's account
      contact = new Contact(FirstName   = 'TEST-CONTACT-FIRST-NAME',
                            LastName    = 'TEST-CONTACT-LAST-NAME',
                            Phone       = 'TEST-CONTACT-PHONE',
                            MobilePhone = 'TEST-CONTACT-MOBILE',
                            AccountId   = users[0].accountId);
      insert contact;
      contacts = [SELECT Id,
                         FirstName,
                         LastName,
                         Phone,
                         MobilePhone,
                         AccountId,
                         contactInactive__c
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      System.assertEquals(1,                         contacts.size());
      System.assertEquals('TEST-CONTACT-FIRST-NAME', contacts[0].FirstName);
      System.assertEquals('TEST-CONTACT-LAST-NAME',  contacts[0].LastName);
      System.assertEquals('TEST-CONTACT-PHONE',      contacts[0].Phone);
      System.assertEquals('TEST-CONTACT-MOBILE',     contacts[0].MobilePhone);
      System.assertEquals(users[0].accountId,        contacts[0].AccountId);
      System.assertEquals(false,                     contacts[0].contactInactive__c);

      // Create test asset under portal user's account
      asset = new Asset(Name = 'TEST-ASSET-SCRAPPED',
                        Status = 'Scrapped',
                        AccountId = users[0].accountId,
                        ContactId = contacts[0].id,
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
                WHERE  Name = 'TEST-ASSET-SCRAPPED'];

      System.assertEquals(1,                             assets.size());
      System.assertEquals('TEST-ASSET-SCRAPPED',         assets[0].Name);
      System.assertEquals('Scrapped',                    assets[0].Status);
      System.assertEquals(users[0].accountId,            assets[0].AccountId);
      System.assertEquals(contacts[0].id,                assets[0].ContactId);
      System.assertEquals('Premium',                     assets[0].SLA__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
      System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
      System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);

      // Create test case under portal user's account
      aCase = new Case(AccountId = users[0].accountId,
                       AssetId   = assets[0].id,
                       ContactId = contacts[0].id,
                       Status = 'Open',
                       Subject = 'TEST-CASE-OPEN-SUBJECT');
      insert aCase;
      cases = [SELECT Id,
                      AccountId,
                      AssetId,
                      ContactId,
                      Status,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-OPEN-SUBJECT'];

      System.assertEquals(1,                        cases.size());
      System.assertEquals(users[0].accountId,       cases[0].AccountId);
      System.assertEquals(assets[0].id,             cases[0].AssetId);
      System.assertEquals(contacts[0].id,           cases[0].ContactId);
      System.assertEquals('Open',                   cases[0].Status);
      System.assertEquals('TEST-CASE-OPEN-SUBJECT', cases[0].Subject);

      // Try to mark contact inactive
      System.runAs(users[0])
        {ApexPages.StandardController contactController;
         contactExtensionsWithSharing contactExtension;
         PageReference returnedPageReference;

         contacts[0].contactInactive__c = true;

         contactController = new ApexPages.StandardController(contacts[0]);
         contactExtension  = new contactExtensionsWithSharing(contactController);

         System.assertEquals('Nimble Customer Portal Profile', contactExtension.profileName);
         System.assertEquals(users[0].accountId, contactExtension.accountId);

         returnedPageReference = contactExtension.contactCustomSave();
         System.assertEquals(null, returnedPageReference);
         System.assertEquals('Cannot store contact as Inactive because it is a contact on active cases (cases not in Closed status).', contactExtension.saveErrorMessage);
        }
     }

   // ==================================================================================== testGoodSave
   static testMethod void testGoodSave()
     {List<User> users;
      List<Contact> contacts;
      Contact contact;
      String tempIdString;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create new contact and save
      System.runAs(users[0])
        {ApexPages.StandardController contactController;
         contactExtensionsWithSharing contactExtension;
         PageReference returnedPageReference;

         contact = new Contact(FirstName         = 'TEST-CONTACT-FIRST-NAME',
                               LastName          = 'TEST-CONTACT-LAST-NAME',
                               Email             = 'TEST@TEST.COM',
                               Phone             = 'TEST-CONTACT-PHONE',
                               MobilePhone       = 'TEST-CONTACT-MOBILE',
                               MailingStreet     = '123 Main',
                               MailingCity       = 'Divide',
                               MailingState      = 'CO',
                               MailingPostalCode = '80814',
                               MailingCountry    = 'United States');

         contactController = new ApexPages.StandardController(contact);
         contactExtension  = new contactExtensionsWithSharing(contactController);

         System.assertEquals('Nimble Customer Portal Profile', contactExtension.profileName);
         System.assertEquals(users[0].accountId, contactExtension.accountId);

         returnedPageReference = contactExtension.contactCustomSave();
         System.assertNotEquals(null, returnedPageReference);

         contacts = [SELECT Id,
                            FirstName,
                            LastName,
                            Email,
                            Phone,
                            MobilePhone,
                            MailingStreet,
                            MailingCity,
                            MailingState,
                            MailingPostalCode,
                            MailingCountry,
                            AccountId,
                            contactInactive__c
                     FROM   Contact
                     WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

         System.assertEquals(1,                         contacts.size());
         System.assertEquals('TEST-CONTACT-FIRST-NAME', contacts[0].FirstName);
         System.assertEquals('TEST-CONTACT-LAST-NAME',  contacts[0].LastName);
         System.assertEquals('test@test.com',           contacts[0].Email);
         System.assertEquals('TEST-CONTACT-PHONE',      contacts[0].Phone);
         System.assertEquals('TEST-CONTACT-MOBILE',     contacts[0].MobilePhone);
         System.assertEquals('123 Main',                contacts[0].MailingStreet);
         System.assertEquals('Divide',                  contacts[0].MailingCity);
         System.assertEquals('CO',                      contacts[0].MailingState);
         System.assertEquals('80814',                   contacts[0].MailingPostalCode);
         System.assertEquals('United States',           contacts[0].MailingCountry);
         System.assertEquals(users[0].accountId,        contacts[0].AccountId);
         System.assertEquals(false,                     contacts[0].contactInactive__c);
         tempIdString = (String)contacts[0].id;
         System.assertEquals('/' + tempIdString.left(15), returnedPageReference.getUrl());
        }
     }
  }