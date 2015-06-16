@isTest
private class caseTriggerSetOwnerEmailTest
  {// ==================================================================================== createTestData
   static testMethod void createTestData()
     {Account          account;
      Contact          contact;
      Asset            asset;
      Case             aCase;
      List<Account>          accounts;
      List<Contact>          contacts;
      List<Asset>            assets;
      List<Case>             cases;
      ID testAccountId;
      ID testContactId;
      ID testAssetId;
      ID testCaseId;

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
      contact = new Contact(LastName = 'TEST-CONTACT-LAST-NAME',
                            AccountId = testAccountId);
      insert contact;
      contacts = [SELECT Id,
                         LastName,
                         AccountId
                  FROM   Contact
                  WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      System.assertEquals(1,                        contacts.size());
      System.assertEquals('TEST-CONTACT-LAST-NAME', contacts[0].LastName);
      System.assertEquals(testAccountId,            contacts[0].AccountId);
      testContactId = contacts[0].id;

      // Create test asset
      asset = new Asset(Name = 'TEST-ASSET',
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
                       AccountId,
                       ContactId,
                       SLA__c,
                       Install_Street1__c,
                       Install_Street2__c,
                       Install_City__c,
                       Install_State_Province__c

                FROM   Asset
                WHERE  Name = 'TEST-ASSET'];

      System.assertEquals(1,                             assets.size());
      System.assertEquals('TEST-ASSET',                  assets[0].Name);
      System.assertEquals(testAccountId,                 assets[0].AccountId);
      System.assertEquals(testContactId,                 assets[0].ContactId);
      System.assertEquals('Premium',                     assets[0].SLA__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
      System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
      System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
      System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);
      testAssetId = assets[0].id;

      // Create test case
      aCase = new Case(AccountId = testAccountId,
                       AssetId   = testAssetId,
                       ContactId = testContactId,
                       Subject = 'TEST-CASE-SUBJECT');
      insert aCase;
      cases = [SELECT Id,
                      AccountId,
                      AssetId,
                      ContactId,
                      Subject
               FROM   Case
               WHERE  Subject = 'TEST-CASE-SUBJECT'];

      System.assertEquals(1,                   cases.size());
      System.assertEquals(testAccountId,       cases[0].AccountId);
      System.assertEquals(testAssetId,         cases[0].AssetId);
      System.assertEquals(testContactId,       cases[0].ContactId);
      System.assertEquals('TEST-CASE-SUBJECT', cases[0].Subject);
      testCaseId = cases[0].id;
     }

   // ==================================================================================== testUserOwnerEmail
   static testMethod void testUserOwnerEmail()
     {List<Case> cases;
      List<User> users;

      createTestData();

      cases = [SELECT id,
                      ownerid
               FROM   Case
               WHERE  subject = 'TEST-CASE-SUBJECT'];

      system.assertEquals(1, cases.size());

      users = [SELECT id,
                      isActive,
                      email
               FROM   User
               WHERE  isActive = true and Name = 'Diana Bocskai'
               LIMIT  1];

      system.assertEquals(1, users.size());

      cases[0].ownerid = users[0].id;
      update cases[0];

      cases = [SELECT id,
                      caseOwnerEmail__c
               FROM   Case
               WHERE  subject = 'TEST-CASE-SUBJECT'];

      system.assertEquals(1,              cases.size());
      system.assertEquals(users[0].email, cases[0].caseOwnerEmail__c);
     }

   // ==================================================================================== testQueueOwnerEmail
   static testMethod void testQueueOwnerEmail()
     {List<Case> cases;
      List<Group> queues;

      createTestData();

      cases = [SELECT id,
                      ownerid
               FROM   Case
               WHERE  subject = 'TEST-CASE-SUBJECT'];

      system.assertEquals(1, cases.size());

      queues = [SELECT Id
                FROM   Group
                WHERE  Type = 'Queue' AND
                       Name = 'Support Queue - General'];

      system.assertEquals(1, queues.size());

      cases[0].ownerid = queues[0].id;
      update cases[0];

      cases = [SELECT id,
                      caseOwnerEmail__c
               FROM   Case
               WHERE  subject = 'TEST-CASE-SUBJECT'];

      system.assertEquals(1,    cases.size());
      system.assertEquals(null, cases[0].caseOwnerEmail__c);
     }
  }