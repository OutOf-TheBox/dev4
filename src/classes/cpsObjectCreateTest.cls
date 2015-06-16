@isTest
private class cpsObjectCreateTest
  {// ==================================================================================== createTestObjects
   static testMethod void createTestObjects()
     {ID testAccountId;
      ID testContactId;
      ID testAssetId;
      List<Account> accounts;
      List<Contact> contacts;
      List<Asset> assets;
      Account account;
      Contact contact;
      Asset asset;

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
                        ContactId = testContactId);
      insert asset;
      assets = [SELECT Id,
                       Name,
                       ContactId
                FROM   Asset
                WHERE  Name = 'TEST-ASSET'];

      System.assertEquals(1,             assets.size());
      System.assertEquals('TEST-ASSET',  assets[0].Name);
      System.assertEquals(testContactId, assets[0].ContactId);
      testAssetId = assets[0].id;
     }
  }