@isTest
private class caseExtensionsWithSharingTest
  {// ==================================================================================== createTestData
   static testMethod void createTestData()
     {Account     account;
      Contact     contact;
      Product2    product;
      Asset       asset;
      Case        aCase;
      CaseComment caseComment;
      List<Account>     accounts;
      List<Contact>     contacts;
      List<Product2>    products;
      List<Asset>       assets;
      List<Case>        cases;
      List<CaseComment> caseComments;
      ID testAccountId;
      ID testContactActiveId;
      ID testContactInactiveId;
      ID testProductArrayId;
      ID testProductShelfId;
      ID testAssetShippedId;
      ID testAssetScrappedId;
      ID testAssetShelfId;
      ID testCaseId;
      ID testCaseCommentId;

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

      // Create test product of family SAN Storage Array
      product = new Product2(IsActive    = true,
                             ProductCode = 'CS220',
                             Description = 'CS220 Array',
                             Family      = 'SAN Storage Array',
                             Name        = 'CS220 Array');

      insert product;

      products = [SELECT Id,
                         IsActive,
                         ProductCode,
                         Description,
                         Family,
                         Name
                  FROM   Product2
                  WHERE  Family   = 'SAN Storage Array'
                  LIMIT  1];

      System.assertEquals(1,                   products.size());
      System.assertEquals(true,                products[0].IsActive);
      System.assertEquals('CS220',             products[0].ProductCode);
      System.assertEquals('CS220 Array',       products[0].Description);
      System.assertEquals('SAN Storage Array', products[0].Family);
      System.assertEquals('CS220 Array',       products[0].Name);
      testProductArrayId = products[0].id;

      // Create test product of family Disk Shelf
      product = new Product2(IsActive    = true,
                             ProductCode = 'ES25',
                             Description = 'ES25 Disk Shelf',
                             Family      = 'Disk Shelf',
                             Name        = 'ES25 Disk Shelf');

      insert product;

      products = [SELECT Id,
                         IsActive,
                         ProductCode,
                         Description,
                         Family,
                         Name
                  FROM   Product2
                  WHERE  Family   = 'Disk Shelf'
                  LIMIT  1];

      System.assertEquals(1,                   products.size());
      System.assertEquals(true,                products[0].IsActive);
      System.assertEquals('ES25',              products[0].ProductCode);
      System.assertEquals('ES25 Disk Shelf',   products[0].Description);
      System.assertEquals('Disk Shelf',        products[0].Family);
      System.assertEquals('ES25 Disk Shelf',   products[0].Name);
      testProductShelfId = products[0].id;

      // Create test Shipped asset
      asset = new Asset(Name = 'TEST-ASSET-SHIPPED',
                        Status = 'Shipped',
                        AccountId  = testAccountId,
                        ContactId  = testContactActiveId,
                        product2Id = testProductArrayId,
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
                       Product2Id,
                       Product2.Family,
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
      System.assertEquals(testProductArrayId,            assets[0].Product2Id);
      System.assertEquals('SAN Storage Array',           assets[0].Product2.Family);
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
                        ContactId = testContactActiveId,
                        Product2Id = testProductArrayId,
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
                       Product2Id,
                       Product2.Family,
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
      System.assertEquals(testContactActiveId,           assets[0].ContactId);
      System.assertEquals(testProductArrayId,            assets[0].Product2Id);
      System.assertEquals('SAN Storage Array',           assets[0].Product2.Family);
      System.assertEquals('Premium',                     assets[0].SLA__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
      System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
      System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);
      testAssetScrappedId = assets[0].id;

      // Create test Shelf asset
      asset = new Asset(Name = 'TEST-ASSET-SHELF',
                        Status = 'Shipped',
                        AccountId = testAccountId,
                        ContactId = testContactActiveId,
                        Product2Id = testProductShelfId,
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
                       Product2Id,
                       Product2.Family,
                       SLA__c,
                       Install_Street1__c,
                       Install_Street2__c,
                       Install_City__c,
                       Install_State_Province__c

                FROM   Asset
                WHERE  Name = 'TEST-ASSET-SHELF'];

      System.assertEquals(1,                             assets.size());
      System.assertEquals('TEST-ASSET-SHELF',            assets[0].Name);
      System.assertEquals('Shipped',                     assets[0].Status);
      System.assertEquals(testAccountId,                 assets[0].AccountId);
      System.assertEquals(testContactActiveId,           assets[0].ContactId);
      System.assertEquals(testProductShelfId,            assets[0].Product2Id);
      System.assertEquals('Disk Shelf',                  assets[0].Product2.Family);
      System.assertEquals('Premium',                     assets[0].SLA__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
      System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
      System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);
      testAssetShelfId = assets[0].id;

      // Create test case
      aCase = new Case(AccountId = testAccountId,
                       AssetId   = testAssetShippedId,
                       ContactId = testContactActiveId,
                       Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');
      insert aCase;
      cases = [SELECT Id,
                      AccountId,
                      AssetId,
                      ContactId,
                      Status,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      System.assertEquals(1,                   cases.size());
      System.assertEquals(testAccountId,       cases[0].AccountId);
      System.assertEquals(testAssetShippedId,  cases[0].AssetId);
      System.assertEquals(testContactActiveId, cases[0].ContactId);
      System.assertEquals('Open',              cases[0].Status);
      System.assertEquals('TEST-CASE-SUBJECT', cases[0].Subject);
      testCaseId = cases[0].id;

      // Create test case comment
      caseComment = new CaseComment(ParentID    = testCaseId,
                                    IsPublished = true,
                                    CommentBody = 'TEST-CASE-COMMENT');

      insert caseComment;

      caseComments = [SELECT Id,
                             ParentId,
                             IsPublished,
                             CommentBody
                      FROM   CaseComment
                      WHERE  ParentId = :testCaseId];

      System.assertEquals(1,                   caseComments.size());
      System.assertEquals(testCaseId,          caseComments[0].ParentId);
      System.assertEquals(true,                caseComments[0].IsPublished);
      System.assertEquals('TEST-CASE-COMMENT', caseComments[0].CommentBody);
      testCaseCommentId = caseComments[0].id;
     }

   // ==================================================================================== testViewUrlPortalUser
   static testMethod void testViewUrlPortalUser()
     {List<User> users;
      List<Case> cases;
      Case aCase;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test case under portal user's account
      aCase = new Case(AccountId = users[0].accountId,
                       Status = 'Open',
                       Subject = 'TEST-CASE-OPEN-SUBJECT');
      insert aCase;
      cases = [SELECT Id,
                      AccountId,
                      Status,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-OPEN-SUBJECT'];

      System.assertEquals(1,                        cases.size());
      System.assertEquals(users[0].accountId,       cases[0].AccountId);
      System.assertEquals('Open',                   cases[0].Status);
      System.assertEquals('TEST-CASE-OPEN-SUBJECT', cases[0].Subject);

      System.runAs(users[0])
        {ApexPages.StandardController caseController;
         caseExtensionsWithSharing caseExtension;

         caseController = new ApexPages.StandardController(cases[0]);
         caseExtension  = new caseExtensionsWithSharing(caseController);

         System.assertEquals('Nimble Customer Portal Profile', caseExtension.profileName);
         System.assertEquals('/apex/caseportalviewpage', caseExtension.caseDispatchViewUrl().getUrl());
        }
     }

   // ==================================================================================== testEditUrlPortalUser
   static testMethod void testEditUrlPortalUser()
     {List<User> users;
      List<Case> cases;
      Case aCase;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test case under portal user's account
      aCase = new Case(AccountId = users[0].accountId,
                       Status = 'Open',
                       Subject = 'TEST-CASE-OPEN-SUBJECT');
      insert aCase;
      cases = [SELECT Id,
                      AccountId,
                      Status,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-OPEN-SUBJECT'];

      System.assertEquals(1,                        cases.size());
      System.assertEquals(users[0].accountId,       cases[0].AccountId);
      System.assertEquals('Open',                   cases[0].Status);
      System.assertEquals('TEST-CASE-OPEN-SUBJECT', cases[0].Subject);

      System.runAs(users[0])
        {ApexPages.StandardController caseController;
         caseExtensionsWithSharing caseExtension;

         caseController = new ApexPages.StandardController(cases[0]);
         caseExtension  = new caseExtensionsWithSharing(caseController);

         System.assertEquals('Nimble Customer Portal Profile', caseExtension.profileName);
         System.assertEquals('/apex/caseportaleditpage', caseExtension.caseDispatchEditUrl().getUrl());
        }
     }

   // ==================================================================================== testNewUrlPortalUser
   static testMethod void testNewUrlPortalUser()
     {List<User> users;
      Case aCase;

      users = [SELECT Id,
                      accountId
               FROM   User
               WHERE  Profile.Name = 'Nimble Customer Portal Profile' and
                      IsActive = true
               LIMIT  1];

      System.assertEquals(1, users.size());

      // Create test case under portal user's account
      aCase = new Case(AccountId = users[0].accountId,
                       Status = 'Open',
                       Subject = 'TEST-CASE-OPEN-SUBJECT');

      System.runAs(users[0])
        {ApexPages.StandardController caseController;
         caseExtensionsWithSharing caseExtension;

         caseController = new ApexPages.StandardController(aCase);
         caseExtension  = new caseExtensionsWithSharing(caseController);

         System.assertEquals('Nimble Customer Portal Profile', caseExtension.profileName);
         System.assertEquals('/apex/caseportalnewpage', caseExtension.caseDispatchNewUrl().getUrl());
        }
     }

   // ==================================================================================== testViewUrlNonPortalUser
   static testMethod void testViewUrlNonPortalUser()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;

      createTestData();

      cases = [SELECT Id
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertNotEquals('Nimble Customer Portal Profile', caseExtension.profileName);
      System.assertEquals('/' + cases[0].id + '?nooverride=1', caseExtension.caseDispatchViewUrl().getUrl());
     }

   // ==================================================================================== testEditUrlNonPortalUser
   static testMethod void testEditUrlNonPortalUser()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;

      createTestData();

      cases = [SELECT Id
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertNotEquals('Nimble Customer Portal Profile', caseExtension.profileName);
      System.assertEquals('/' + cases[0].id + '/e?nooverride=1', caseExtension.caseDispatchEditUrl().getUrl());
     }

   // ==================================================================================== testNewUrlNonPortalUser
   static testMethod void testNewUrlNonPortalUser()
     {Case aCase;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertNotEquals('Nimble Customer Portal Profile', caseExtension.profileName);
      System.assertEquals('/500/e' + '?nooverride=1', caseExtension.caseDispatchNewUrl().getUrl());
     }

   // ==================================================================================== testImpactValues
   static testMethod void testImpactValues()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;
      List<SelectOption> returnedValues;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      returnedValues = caseExtension.getCasePortalImpactValues();
      System.assertEquals(4, returnedValues.size());
     }

   // ==================================================================================== testImpactDescriptionLow
   static testMethod void testImpactDescriptionLow()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      caseExtension.casePortalImpact = 'LOW';

      System.assertEquals('(no impact to I/O or operations; administrative/question/etc)', caseExtension.getCasePortalImpactDescription());
     }

   // ==================================================================================== testImpactDescriptionMinor
   static testMethod void testImpactDescriptionMinor()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      caseExtension.casePortalImpact = 'MINOR';

      System.assertEquals('(minor impact to I/O or operations)', caseExtension.getCasePortalImpactDescription());
     }

   // ==================================================================================== testImpactDescriptionMajor
   static testMethod void testImpactDescriptionMajor()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      caseExtension.casePortalImpact = 'MAJOR';

      System.assertEquals('(major impact to I/O or operations)', caseExtension.getCasePortalImpactDescription());
     }

   // ==================================================================================== testImpactDescriptionCritical
   static testMethod void testImpactDescriptionCritical()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      caseExtension.casePortalImpact = 'CRITICAL';

      System.assertEquals('(system down; no I/O being served)', caseExtension.getCasePortalImpactDescription());
     }

   // ==================================================================================== testImpactDescriptionUnknown
   static testMethod void testImpactDescriptionUnknown()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      caseExtension.casePortalImpact = 'UNKNOWN';

      System.assertEquals('(unknown)', caseExtension.getCasePortalImpactDescription());
     }

   // ==================================================================================== testImpactLow
   static testMethod void testImpactLow()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status   = 'Open',
                       Priority = 'P4',
                       Subject  = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals('LOW', caseExtension.casePortalImpact);
     }

   // ==================================================================================== testImpactMinor
   static testMethod void testImpactMinor()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status   = 'Open',
                       Priority = 'P3',
                       Subject  = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals('MINOR', caseExtension.casePortalImpact);
     }

   // ==================================================================================== testImpactMajor
   static testMethod void testImpactMajor()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status   = 'Open',
                       Priority = 'P2',
                       Subject  = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals('MAJOR', caseExtension.casePortalImpact);
     }

   // ==================================================================================== testImpactCritical
   static testMethod void testImpactCritical()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status   = 'Open',
                       Priority = 'P1',
                       Subject  = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals('CRITICAL', caseExtension.casePortalImpact);
     }

   // ==================================================================================== testImpactUnknown
   static testMethod void testImpactUnknown()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status   = 'Open',
                       Priority = 'UNKNOWN',
                       Subject  = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals('Unknown', caseExtension.casePortalImpact);
     }

   // ==================================================================================== testErrorBadAssetStatus
   static testMethod void testErrorBadAssetStatus()
     {List<Asset> assets;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;
      PageReference returnedPageReference;

      createTestData();

      assets = [SELECT Id
                FROM   Asset
                WHERE  Name = 'TEST-ASSET-SCRAPPED'];

      aCase = new Case(Status   = 'Open',
                       Priority = 'P3',
                       assetId  = assets[0].id,
                       Subject  = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      returnedPageReference = caseExtension.caseCustomSave();
      System.assertEquals(null, returnedPageReference);
      System.assertEquals('Asset is not in Shipped status.  Cases cannot be saved for assets not in Shipped status.', caseExtension.saveErrorMessage);
     }

   // ==================================================================================== testErrorDiskShelf
   static testMethod void testErrorDiskShelf()
     {List<Asset> assets;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;
      PageReference returnedPageReference;

      createTestData();

      assets = [SELECT Id
                FROM   Asset
                WHERE  Name = 'TEST-ASSET-SHELF'];

      aCase = new Case(Status   = 'Open',
                       Priority = 'P3',
                       assetId  = assets[0].id,
                       Subject  = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      returnedPageReference = caseExtension.caseCustomSave();
      System.assertEquals(null, returnedPageReference);
      System.assertEquals('Asset is a disk shelf.  Cases cannot be saved for disk shelves.  The asset must be an array.', caseExtension.saveErrorMessage);
     }

   // ==================================================================================== testErrorInactiveContact
   static testMethod void testErrorInactiveContact()
     {List<Contact> contacts;
      List<Asset> assets;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;
      PageReference returnedPageReference;

      createTestData();

      assets = [SELECT Id
                FROM   Asset
                WHERE  Name = 'TEST-ASSET-SHIPPED'];

      contacts = [SELECT Id
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-INACTIVE-LAST-NAME'];

      aCase = new Case(Status    = 'Open',
                       Priority  = 'P3',
                       assetId   = assets[0].id,
                       contactId = contacts[0].id,
                       Subject   = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      returnedPageReference = caseExtension.caseCustomSave();
      System.assertEquals(null, returnedPageReference);
      System.assertEquals('This contact is inactive.  Cases cannot be saved with an inactive contact.', caseExtension.saveErrorMessage);
     }

   // ==================================================================================== testGoodSave
   static testMethod void testGoodSave()
     {List<Contact> contacts;
      List<Asset> assets;
      List<Account> accounts;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;
      PageReference returnedPageReference;

      createTestData();

      assets = [SELECT Id
                FROM   Asset
                WHERE  Name = 'TEST-ASSET-SHIPPED'];

      contacts = [SELECT Id
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      accounts = [SELECT Id
                  FROM   Account
                  WHERE  Name = 'TEST-ACCOUNT'];

      aCase = new Case(Status            = 'Open',
                       Priority          = 'P3',
                       Nimble_Version__c = '1.4.5.0',
                       assetId           = assets[0].id,
                       contactId         = contacts[0].id,
                       accountId         = accounts[0].id,
                       Subject           = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      returnedPageReference = caseExtension.caseCustomSave();
      System.assertNotEquals(null, returnedPageReference);
     }

   // ==================================================================================== testCaseCustomCommentNew
   static testMethod void testCaseCustomCommentNew()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;

      createTestData();

      cases = [SELECT Id,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals('/apex/caseportalnewcommentpage', caseExtension.caseCustomCommentNew().getUrl());
     }

   // ==================================================================================== testCaseCustomCommentSave
   static testMethod void testCaseCustomCommentSave()
     {List<Case> cases;
      List<CaseComment> caseComments;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Integer numCommentsBefore;
      Integer numCommentsAfter;
      PageReference returnedPageReference;

      createTestData();

      cases = [SELECT Id,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseComments = [SELECT Id,
                             ParentId
                      FROM   CaseComment
                      WHERE  ParentId = :cases[0].id];

      if (caseComments.size() == null)
        {numCommentsBefore = 0;
        }
      else
        {numCommentsBefore = caseComments.size();
        }

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      caseExtension.caseCommentNewText = 'TEST-CASE-COMMENT';
      returnedPageReference = caseExtension.caseCustomCommentSave();

      System.assertEquals('/apex/caseportalviewpage', returnedPageReference.getUrl());

      caseComments = [SELECT Id,
                             ParentId
                      FROM   CaseComment
                      WHERE  ParentId = :cases[0].id];

      if (caseComments.size() == null)
        {numCommentsAfter = 0;
        }
      else
        {numCommentsAfter = caseComments.size();
        }

      System.assertEquals(numCommentsBefore + 1, numCommentsAfter);
     }

   // ==================================================================================== testCaseCustomCommentCancel
   static testMethod void testCaseCustomCommentCancel()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      PageReference returnedPageReference;

      createTestData();

      cases = [SELECT Id,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      caseExtension.caseCommentNewText = 'TEST-CASE-COMMENT';
      returnedPageReference = caseExtension.caseCustomCommentCancel();

      System.assertEquals(null, caseExtension.caseCommentNewText);
      System.assertEquals('/apex/caseportalviewpage', returnedPageReference.getUrl());
     }

   // ==================================================================================== testCaseCustomResolve
   static testMethod void testCaseCustomResolve()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;

      createTestData();

      cases = [SELECT Id,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals('/apex/caseportalresolvepage', caseExtension.caseCustomResolve().getUrl());
     }

   // ==================================================================================== testCaseCustomResolveSave
   static testMethod void testCaseCustomResolveSave()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      PageReference returnedPageReference;

      createTestData();

      cases = [SELECT Id,
                      Subject,
                      casePortalResolutionNotes__c
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      cases[0].casePortalResolutionNotes__c = 'TEST-CASE-RESOLUTION-NOTES';
      returnedPageReference = caseExtension.caseCustomResolveSave();

      cases = [SELECT Id,
                      Status,
                      casePortalResolutionNotes__c
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      System.assertEquals('Resolved', cases[0].Status);
      System.assertEquals('TEST-CASE-RESOLUTION-NOTES', cases[0].casePortalResolutionNotes__c);
      System.assertEquals('/apex/caseportalviewpage', returnedPageReference.getUrl());
     }

   // ==================================================================================== testCaseCustomResolveCancel
   static testMethod void testCaseCustomResolveCancel()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      PageReference returnedPageReference;

      createTestData();

      cases = [SELECT Id,
                      Subject,
                      casePortalResolutionNotes__c
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      returnedPageReference = caseExtension.caseCustomResolveCancel();

      System.assertEquals('/apex/caseportalviewpage', returnedPageReference.getUrl());
     }

   // ==================================================================================== testDisplayResolveButton
   static testMethod void testDisplayResolveButton()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;

      createTestData();

      cases = [SELECT Id,
                      Subject,
                      Status
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals(true, caseExtension.displayResolveButton);
     }

   // ==================================================================================== testDisplayNewCommentButton
   static testMethod void testDisplayNewCommentButton()
     {List<Case> cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;

      createTestData();

      cases = [SELECT Id,
                      Subject,
                      Status
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals(true, caseExtension.displayNewCommentButton);
     }

   // ==================================================================================== testGetCaseComments
   static testMethod void testGetCaseComments()
     {List<CaseComment> caseComments;
      List<Case>        cases;
      ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;

      createTestData();

      cases = [SELECT Id
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      caseController = new ApexPages.StandardController(cases[0]);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      caseComments = caseExtension.getCaseComments();

      System.assertEquals(1,                   caseComments.size());
      System.assertEquals('TEST-CASE-COMMENT', caseComments[0].CommentBody);
     }

   // ==================================================================================== testNumMyAttnReqCases
   static testMethod void testNumMyAttnReqCases()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals(0, caseExtension.numMyAttnReqCases);
     }

   // ==================================================================================== testNumNotMyAttnReqCases
   static testMethod void testNumNotMyAttnReqCases()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals(0, caseExtension.numNotMyAttnReqCases);
     }

   // ==================================================================================== testListMyAttnReqCases
   static testMethod void testListMyAttnReqCases()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals(0, caseExtension.listMyAttnReqCases.size());
     }

   // ==================================================================================== testListNotMyAttnReqCases
   static testMethod void testListNotMyAttnReqCases()
     {ApexPages.StandardController caseController;
      caseExtensionsWithSharing caseExtension;
      Case aCase;

      aCase = new Case(Status = 'Open',
                       Subject = 'TEST-CASE-SUBJECT');

      caseController = new ApexPages.StandardController(aCase);
      caseExtension  = new caseExtensionsWithSharing(caseController);

      System.assertEquals(0, caseExtension.listNotMyAttnReqCases.size());
     }
  }