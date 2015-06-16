@isTest
private class assetTriggerTest {
  // Using an inner class to make it easier to construct
  // test data was inspired from the following article:
  //   https://force201.wordpress.com/2013/02/22/cleaner-inner-class-test-fixture-pattern/

  class TestData {
    Account testAccount;
    Contact testContact;
    Asset   testAsset1;
    Asset   testAsset2;

    TestData() {
      System.debug('DEBUG: (TestData constructor) Entered as user: ' + UserInfo.getUserName());

      // Create test Account
      insert testAccount = new Account(Name = 'Acme Corporation');

      // Create test Contact
      insert testContact = new Contact(LastName  = 'Doe',
                                       FirstName = 'John',
                                       AccountId = testAccount.Id);

      // Create test Asset
      insert testAsset1 = new Asset(Name                                      = 'AA-111111',
                                    AccountId                                 = testAccount.Id,
                                    ContactId                                 = testContact.Id,
                                    SLA__c                                    = 'Premium',
                                    Install_Street1__c                        = '123 Main Street',
                                    Install_Street2__c                        = 'Suite 100',
                                    Install_City__c                           = 'San Jose',
                                    Install_State_Province__c                 = 'CA',
                                    Install_Zip_Code__c                       = '95151',
                                    Install_Country__c                        = 'United States',
                                    Ship_Date__c                              = Date.today().addDays(-180),
                                    assetPartShipLastValidatedDatetime__c     = Date.today(),
                                    assetPartShipLastValidatedByInfo__c       = 'Test part ship last validated by info');
    }

    void insertAsset2() {
      insert testAsset2 = new Asset(Name                                      = 'AA-222222',
                                    AccountId                                 = testAccount.Id,
                                    ContactId                                 = testContact.Id,
                                    SLA__c                                    = 'Premium',
                                    Install_Street1__c                        = '123 Main Street',
                                    Install_Street2__c                        = 'Suite 100',
                                    Install_City__c                           = 'San Jose',
                                    Install_State_Province__c                 = 'CA',
                                    Install_Zip_Code__c                       = '95151',
                                    Install_Country__c                        = 'United States',
                                    Ship_Date__c                              = Date.today().addDays(-180),
                                    assetPartShipLastValidatedDatetime__c     = Date.today(),
                                    assetPartShipLastValidatedByInfo__c       = 'Test part ship last validated by info');
    }

    void insertAsset2WithNullStreet1() {
      insert testAsset2 = new Asset(Name                                      = 'AA-222222',
                                    AccountId                                 = testAccount.Id,
                                    ContactId                                 = testContact.Id,
                                    SLA__c                                    = 'Premium',
                                    Install_Street1__c                        = null,
                                    Install_Street2__c                        = 'Suite 100',
                                    Install_City__c                           = 'San Jose',
                                    Install_State_Province__c                 = 'CA',
                                    Install_Zip_Code__c                       = '95151',
                                    Install_Country__c                        = 'United States',
                                    Ship_Date__c                              = Date.today().addDays(-180),
                                    assetPartShipLastValidatedDatetime__c     = Date.today(),
                                    assetPartShipLastValidatedByInfo__c       = 'Test part ship last validated by info');
    }

    void doNotChangeInstallAddress() {
      update testAsset1;
    }

    void doNotChangeInstallAddressAndClearAddressBookId() {
      testAsset1.assetPartShipAddressBook__c = null;
      update testAsset1;
    }

    void changeStreet1() {
      System.debug('DEBUG: (changeStreet1) Entered as user: ' + UserInfo.getUserName());
      testAsset1.Install_Street1__c = '456 Main Street';
      update testAsset1;
    }

    void changeStreet1AndClearAddressBookId() {
      testAsset1.Install_Street1__c          = '456 Main Street';
      testAsset1.assetPartShipAddressBook__c = null;
      update testAsset1;
    }

    void changeStreet1ToNullAndClearAddressBookId() {
      testAsset1.Install_Street1__c          = null;
      testAsset1.assetPartShipAddressBook__c = null;
      update testAsset1;
    }

    void doNotChangeSla() {
      // Set Same Day Part Delivery Preference
      testAsset1.assetSameDayPartDeliveryPreference__c = 'SAME-DAY-10: Always deliver (site is manned 24x7)';
      update testAsset1;
    }

    void changeSlaNbdTo4Hour() {
      // Set to NBD, set Same Day Part Delivery Preference, then change to 4 Hour
      testAsset1.SLA__c = 'Premium';
      update testAsset1;

      testAsset1.assetSameDayPartDeliveryPreference__c = 'SAME-DAY-10: Always deliver (site is manned 24x7)';
      update testAsset1;

      testAsset1.SLA__c = 'Premium 4 Hour';
      update testAsset1;
    }

    void changeSla4HourToNbd() {
      // Set to 4 Hour, set Same Day Part Delivery Preference, then change to NBD
      testAsset1.SLA__c = 'Premium 4 Hour';
      update testAsset1;

      testAsset1.assetSameDayPartDeliveryPreference__c = 'SAME-DAY-10: Always deliver (site is manned 24x7)';
      update testAsset1;

      testAsset1.SLA__c = 'Premium';
      update testAsset1;
    }
  }

  // ###################################################################################################### validateTestData
  static testMethod void validateTestData() {
    TestData      testData;
    List<Account> accounts;
    List<Contact> contacts;
    List<Asset>   assets;

    testData = new TestData();

    // Validate test Account
    accounts = [SELECT Id,
                       Name
                FROM   Account];

    System.assertEquals(1,                  accounts.size());
    System.assertEquals('Acme Corporation', accounts[0].Name);

    // Validate test Contact
    contacts = [SELECT Id,
                       LastName,
                       FirstName,
                       AccountId
                FROM   Contact];

    System.assertEquals(1,                       contacts.size());
    System.assertEquals('Doe',                   contacts[0].LastName);
    System.assertEquals('John',                  contacts[0].FirstName);
    System.assertEquals(testData.testAccount.Id, contacts[0].AccountId);

    // Validate test Asset
    assets = [SELECT Id,
                     Name,
                     AccountId,
                     ContactId,
                     SLA__c,
                     Install_Street1__c,
                     Install_Street2__c,
                     Install_City__c,
                     Install_State_Province__c,
                     Install_Zip_Code__c,
                     Install_Country__c,
                     Ship_Date__c,
                     assetPartShipLastValidatedDatetime__c,
                     assetPartShipLastValidatedByInfo__c
              FROM   Asset];

    System.assertEquals(1,                                       assets.size());
    System.assertEquals('AA-111111',                             assets[0].Name);
    System.assertEquals(testData.testAccount.Id,                 assets[0].AccountId);
    System.assertEquals(testData.testContact.Id,                 assets[0].ContactId);
    System.assertEquals('Premium',                               assets[0].SLA__c);
    System.assertEquals('123 Main Street',                       assets[0].Install_Street1__c);
    System.assertEquals('Suite 100',                             assets[0].Install_Street2__c);
    System.assertEquals('San Jose',                              assets[0].Install_City__c);
    System.assertEquals('CA',                                    assets[0].Install_State_Province__c);
    System.assertEquals('95151',                                 assets[0].Install_Zip_Code__c);
    System.assertEquals('United States',                         assets[0].Install_Country__c);
    System.assertEquals(Date.today().addDays(-180),              assets[0].Ship_Date__c);
    System.assertEquals(Date.today(),                            assets[0].assetPartShipLastValidatedDatetime__c);
    System.assertEquals('Test part ship last validated by info', assets[0].assetPartShipLastValidatedByInfo__c);
  }

  // ###################################################################################################### test_setUpdatedAssetSameDayPartDeliveryPreference_doNotChangeSla
  static testMethod void test_setUpdatedAssetSameDayPartDeliveryPreference_doNotChangeSla() {
    TestData    testData;
    List<Asset> assets;

    testData = new TestData();
    testData.doNotChangeSla();

    assets = [SELECT Id,
                     Name,
                     SLA__c,
                     assetSameDayPartDeliveryPreference__c
              FROM   Asset];

    System.assertEquals(1,                                                   assets.size());
    System.assertEquals('AA-111111',                                         assets[0].Name);
    System.assertEquals('Premium',                                           assets[0].SLA__c);
    System.assertEquals('SAME-DAY-10: Always deliver (site is manned 24x7)', assets[0].assetSameDayPartDeliveryPreference__c);
  }

  // ###################################################################################################### test_setUpdatedAssetSameDayPartDeliveryPreference_changeSlaNbdTo4Hour
  static testMethod void test_setUpdatedAssetSameDayPartDeliveryPreference_changeSlaNbdTo4Hour() {
    TestData    testData;
    List<Asset> assets;

    testData = new TestData();
    testData.changeSlaNbdTo4Hour();

    assets = [SELECT Id,
                     Name,
                     SLA__c,
                     assetSameDayPartDeliveryPreference__c
              FROM   Asset];

    System.assertEquals(1,                assets.size());
    System.assertEquals('AA-111111',      assets[0].Name);
    System.assertEquals('Premium 4 Hour', assets[0].SLA__c);
    System.assertEquals(null,             assets[0].assetSameDayPartDeliveryPreference__c);
  }

  // ###################################################################################################### test_setUpdatedAssetSameDayPartDeliveryPreference_changeSla4HourToNbd
  static testMethod void test_setUpdatedAssetSameDayPartDeliveryPreference_changeSla4HourToNbd() {
    TestData    testData;
    List<Asset> assets;

    testData = new TestData();
    testData.changeSla4HourToNbd();

    assets = [SELECT Id,
                     Name,
                     SLA__c,
                     assetSameDayPartDeliveryPreference__c
              FROM   Asset];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-111111', assets[0].Name);
    System.assertEquals('Premium',   assets[0].SLA__c);
    System.assertEquals(null,        assets[0].assetSameDayPartDeliveryPreference__c);
  }

  // ###################################################################################################### test_setInsertedAssetAddressBook_runAsSupportForce
  static testMethod void test_setInsertedAssetAddressBook_runAsSupportForce() {
    TestData    testData;
    List<Asset> assets;
    List<User>  users;

    users = [SELECT Id,
                    UserName
             FROM   User
             WHERE  UserName LIKE 'supportforce@nimblestorage.com%'];

    System.assertEquals(1, users.size());

    System.runAs(users[0]) {
      System.debug('DEBUG: (test_setInsertedAssetAddressBook_runAsSupportForce) About to create test data as user: ' + users[0].UserName);
      testData = new TestData();
    }

    assets = [SELECT Id,
                     Name,
                     assetPartShipAddressBook__c
              FROM   Asset];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-111111', assets[0].Name);
    System.assertEquals(null,        assets[0].assetPartShipAddressBook__c);
  }

  // ###################################################################################################### test_setInsertedAssetAddressBook_insertAsset2
  static testMethod void test_setInsertedAssetAddressBook_insertAsset2() {
    TestData    testData;
    List<Asset> assets1;
    List<Asset> assets2;

    testData = new TestData();
    // System.debug('DEBUG: (test_setInsertedAssetAddressBook_insertAsset2) testData.testAsset1.assetPartShipAddressBook__c = ' + testData.testAsset1.assetPartShipAddressBook__c);
    testData.insertAsset2();

    assets1 = [SELECT Id,
                      Name,
                      assetPartShipAddressBook__c
               FROM   Asset
               WHERE  Name = 'AA-111111'];

    assets2 = [SELECT Id,
                      Name,
                      assetPartShipAddressBook__c
               FROM   Asset
               WHERE  Name = 'AA-222222'];

    System.assertEquals(1,                                      assets1.size());
    System.assertEquals('AA-111111',                            assets1[0].Name);
    System.assertEquals(1,                                      assets2.size());
    System.assertEquals('AA-222222',                            assets2[0].Name);
    System.assertNotEquals(null,                                assets1[0].assetPartShipAddressBook__c);
    System.assertEquals(assets1[0].assetPartShipAddressBook__c, assets2[0].assetPartShipAddressBook__c);
  }

  // ###################################################################################################### test_setInsertedAssetAddressBook_insertAsset2WithNullStreet1
  static testMethod void test_setInsertedAssetAddressBook_insertAsset2WithNullStreet1() {
    TestData    testData;
    List<Asset> assets;

    testData = new TestData();
    testData.insertAsset2WithNullStreet1();

    assets = [SELECT Id,
                     Name,
                     assetPartShipAddressBook__c
              FROM   Asset
              WHERE  Name = 'AA-222222'];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-222222', assets[0].Name);
    System.assertEquals(null,        assets[0].assetPartShipAddressBook__c);
  }

  // ###################################################################################################### test_setInsertedAssetAddressBook_addressBookPopulated
  static testMethod void test_setUpdatedAssetAddressBook_addressBookPopulated() {
    TestData             testData;
    List<Asset>          assets;
    List<AddressBook__c> addressBooks;

    testData = new TestData();

    assets = [SELECT Id,
                     Name,
                     assetPartShipAddressBook__c
              FROM   Asset];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-111111', assets[0].Name);
    System.assertNotEquals(null,     assets[0].assetPartShipAddressBook__c);

    addressBooks = [SELECT Id,
                           abStreet1__c,
                           abStreet2__c,
                           abCity__c,
                           abStateProvince__c,
                           abPostalCode__c,
                           abCountry__c
                    FROM   AddressBook__c
                    WHERE  Id = :assets[0].assetPartShipAddressBook__c];

    System.assertEquals(1,                 addressBooks.size());
    System.assertEquals('123 Main Street', addressBooks[0].abStreet1__c);
    System.assertEquals('Suite 100',       addressBooks[0].abStreet2__c);
    System.assertEquals('San Jose',        addressBooks[0].abCity__c);
    System.assertEquals('CA',              addressBooks[0].abStateProvince__c);
    System.assertEquals('95151',           addressBooks[0].abPostalCode__c);
    System.assertEquals('United States',   addressBooks[0].abCountry__c);
  }

  // ###################################################################################################### test_setUpdatedAssetAddressBook_runAsSupportForce
  static testMethod void test_setUpdatedAssetAddressBook_runAsSupportForce() {
    TestData             testData;
    List<Asset>          assets;
    List<User>           users;
    List<AddressBook__c> addressBooks;

    testData = new TestData();

    users = [SELECT Id,
                    UserName
             FROM   User
             WHERE  UserName LIKE 'supportforce@nimblestorage.com%'];

    System.assertEquals(1, users.size());

    System.runAs(users[0]) {
      System.debug('DEBUG: (test_setUpdatedAssetAddressBook_runAsSupportForce) About to run changeStreet1() as user: ' + users[0].UserName);
      testData.changeStreet1();
    }

    assets = [SELECT Id,
                     Name,
                     assetPartShipAddressBook__c
              FROM   Asset];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-111111', assets[0].Name);
    System.assertNotEquals(null,     assets[0].assetPartShipAddressBook__c);

    addressBooks = [SELECT Id,
                           abStreet1__c,
                           abStreet2__c,
                           abCity__c,
                           abStateProvince__c,
                           abPostalCode__c,
                           abCountry__c
                    FROM   AddressBook__c
                    WHERE  Id = :assets[0].assetPartShipAddressBook__c];

    System.assertEquals(1,                 addressBooks.size());
    System.assertEquals('123 Main Street', addressBooks[0].abStreet1__c);
    System.assertEquals('Suite 100',       addressBooks[0].abStreet2__c);
    System.assertEquals('San Jose',        addressBooks[0].abCity__c);
    System.assertEquals('CA',              addressBooks[0].abStateProvince__c);
    System.assertEquals('95151',           addressBooks[0].abPostalCode__c);
    System.assertEquals('United States',   addressBooks[0].abCountry__c);
  }

  // ###################################################################################################### test_setUpdatedAssetAddressBook_changeStreet1
  static testMethod void test_setUpdatedAssetAddressBook_changeStreet1() {
    TestData             testData;
    List<Asset>          assets;
    List<AddressBook__c> addressBooks;

    testData = new TestData();
    testData.changeStreet1();

    assets = [SELECT Id,
                     Name,
                     assetPartShipAddressBook__c
              FROM   Asset];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-111111', assets[0].Name);
    System.assertNotEquals(null,     assets[0].assetPartShipAddressBook__c);

    addressBooks = [SELECT Id,
                           abStreet1__c,
                           abStreet2__c,
                           abCity__c,
                           abStateProvince__c,
                           abPostalCode__c,
                           abCountry__c
                    FROM   AddressBook__c
                    WHERE  Id = :assets[0].assetPartShipAddressBook__c];

    System.assertEquals(1,                 addressBooks.size());
    System.assertEquals('123 Main Street', addressBooks[0].abStreet1__c);
    System.assertEquals('Suite 100',       addressBooks[0].abStreet2__c);
    System.assertEquals('San Jose',        addressBooks[0].abCity__c);
    System.assertEquals('CA',              addressBooks[0].abStateProvince__c);
    System.assertEquals('95151',           addressBooks[0].abPostalCode__c);
    System.assertEquals('United States',   addressBooks[0].abCountry__c);
  }

  // ###################################################################################################### test_setUpdatedAssetAddressBook_changeStreet1AndClearAddressBookId
  static testMethod void test_setUpdatedAssetAddressBook_changeStreet1AndClearAddressBookId() {
    TestData             testData;
    List<Asset>          assets;
    List<AddressBook__c> addressBooks;

    testData = new TestData();
    testData.changeStreet1AndClearAddressBookId();

    assets = [SELECT Id,
                     Name,
                     assetPartShipAddressBook__c
              FROM   Asset];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-111111', assets[0].Name);
    System.assertNotEquals(null,     assets[0].assetPartShipAddressBook__c);

    addressBooks = [SELECT Id,
                           abStreet1__c,
                           abStreet2__c,
                           abCity__c,
                           abStateProvince__c,
                           abPostalCode__c,
                           abCountry__c
                    FROM   AddressBook__c
                    WHERE  Id = :assets[0].assetPartShipAddressBook__c];

    System.assertEquals(1,                 addressBooks.size());
    System.assertEquals('456 Main Street', addressBooks[0].abStreet1__c);
    System.assertEquals('Suite 100',       addressBooks[0].abStreet2__c);
    System.assertEquals('San Jose',        addressBooks[0].abCity__c);
    System.assertEquals('CA',              addressBooks[0].abStateProvince__c);
    System.assertEquals('95151',           addressBooks[0].abPostalCode__c);
    System.assertEquals('United States',   addressBooks[0].abCountry__c);
  }

  // ###################################################################################################### test_setUpdatedAssetAddressBook_changeStreet1ToNullAndClearAddressBookId
  static testMethod void test_setUpdatedAssetAddressBook_changeStreet1ToNullAndClearAddressBookId() {
    TestData             testData;
    List<Asset>          assets;

    testData = new TestData();
    testData.changeStreet1ToNullAndClearAddressBookId();

    assets = [SELECT Id,
                     Name,
                     assetPartShipAddressBook__c
              FROM   Asset];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-111111', assets[0].Name);
    System.assertEquals(null,        assets[0].assetPartShipAddressBook__c);
  }

  // ###################################################################################################### test_setUpdatedAssetAddressBook_doNotChangeInstallAddressAndClearAddressBookId
  static testMethod void test_setUpdatedAssetAddressBook_doNotChangeInstallAddressAndClearAddressBookId() {
    TestData             testData;
    List<Asset>          assets;

    testData = new TestData();
    testData.doNotChangeInstallAddressAndClearAddressBookId();

    assets = [SELECT Id,
                     Name,
                     assetPartShipAddressBook__c
              FROM   Asset];

    System.assertEquals(1,           assets.size());
    System.assertEquals('AA-111111', assets[0].Name);
    System.assertEquals(null,        assets[0].assetPartShipAddressBook__c);
  }

  // ###################################################################################################### test_setUpdatedAssetLastValidatedFields_runAsSupportForce
  static testMethod void test_setUpdatedAssetLastValidatedFields_runAsSupportForce() {
    TestData    testData;
    List<Asset> assets;
    List<User>  users;

    testData = new TestData();

    users = [SELECT Id,
                    UserName
             FROM   User
             WHERE  UserName LIKE 'supportforce@nimblestorage.com%'];

    System.assertEquals(1, users.size());

    System.runAs(users[0]) {
      testData.changeStreet1();
    }

    assets = [SELECT Id,
                     Name,
                     assetPartShipLastValidatedDatetime__c,
                     assetPartShipLastValidatedByInfo__c
              FROM   Asset];

    System.assertEquals(1,                                       assets.size());
    System.assertEquals('AA-111111',                             assets[0].Name);
    System.assertEquals(Date.today(),                            assets[0].assetPartShipLastValidatedDatetime__c);
    System.assertEquals('Test part ship last validated by info', assets[0].assetPartShipLastValidatedByInfo__c);
  }

  // ###################################################################################################### test_setUpdatedAssetLastValidatedFields_changeStreet1
  static testMethod void test_setUpdatedAssetLastValidatedFields_changeStreet1() {
    TestData    testData;
    List<Asset> assets;

    testData = new TestData();
    testData.changeStreet1();

    assets = [SELECT Id,
                     Name,
                     assetPartShipLastValidatedDatetime__c,
                     assetPartShipLastValidatedByInfo__c
              FROM   Asset];

    System.assertEquals(1,                          assets.size());
    System.assertEquals('AA-111111',                assets[0].Name);
    System.assertEquals(null,                       assets[0].assetPartShipLastValidatedDatetime__c);
    System.assertEquals(null,                       assets[0].assetPartShipLastValidatedByInfo__c);
  }

  // ###################################################################################################### test_setUpdatedAssetLastValidatedFields_doNotChangeInstallAddress
  static testMethod void test_setUpdatedAssetLastValidatedFields_doNotChangeInstallAddress() {
    TestData    testData;
    List<Asset> assets;

    testData = new TestData();
    testData.doNotChangeInstallAddress();

    assets = [SELECT Id,
                     Name,
                     assetPartShipLastValidatedDatetime__c,
                     assetPartShipLastValidatedByInfo__c
              FROM   Asset];

    System.assertEquals(1,                                       assets.size());
    System.assertEquals('AA-111111',                             assets[0].Name);
    System.assertEquals(Date.today(),                            assets[0].assetPartShipLastValidatedDatetime__c);
    System.assertEquals('Test part ship last validated by info', assets[0].assetPartShipLastValidatedByInfo__c);
  }
}