@isTest
private class rmaTriggerTest
  {// ==================================================================================== createTestData
   static testMethod void createTestData()
     {Account          account;
      Contact          contact;
      Asset            asset;
      Case             aCase;
      depot__c         depot;
      depotMapNbdNd__c depotMapNbdNd;
      depotMap4Hour__c depotMap4Hour;
      RMAv2__c         rma;
      List<Account>          accounts;
      List<Contact>          contacts;
      List<Asset>            assets;
      List<Case>             cases;
      List<depot__c>         depots;
      List<depotMapNbdNd__c> depotMapNbdNds;
      List<depotMap4Hour__c> depotMap4Hours;
      List<RMAv2__c>         rmas;
      ID testAccountId;
      ID testContactId;
      ID testAssetId;
      ID testCaseId;
      ID testDepot001Id;
      ID testDepot002Id;
      ID testDepot003Id;
      ID testDepot004Id;
      ID testDepot005Id;
      ID testRmaId;

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

      // Create test depot 001
      depot = new depot__c(Name                        = 'TEST-001',
                           depotProvider__c            = 'Flash',
                           depotStockedFor4Hour__c     = 'Yes',
                           depotLocationDescription__c = 'Test depot 001');
      insert depot;
      depots = [SELECT Id,
                       Name,
                       depotProvider__c,
                       depotStockedFor4Hour__c,
                       depotLocationDescription__c
                FROM   depot__c
                WHERE  Name = 'TEST-001'];

      System.assertEquals(1,                depots.size());
      System.assertEquals('TEST-001',       depots[0].Name);
      System.assertEquals('Flash',          depots[0].depotProvider__c);
      System.assertEquals('Yes',            depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot 001', depots[0].depotLocationDescription__c);
      testDepot001Id = depots[0].id;

      // Create test depot 002
      depot = new depot__c(Name                        = 'TEST-002',
                           depotProvider__c            = 'Flash',
                           depotStockedFor4Hour__c     = 'Yes',
                           depotLocationDescription__c = 'Test depot 002');
      insert depot;
      depots = [SELECT Id,
                       Name,
                       depotProvider__c,
                       depotStockedFor4Hour__c,
                       depotLocationDescription__c
                FROM   depot__c
                WHERE  Name = 'TEST-002'];

      System.assertEquals(1,                depots.size());
      System.assertEquals('TEST-002',       depots[0].Name);
      System.assertEquals('Flash',          depots[0].depotProvider__c);
      System.assertEquals('Yes',            depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot 002', depots[0].depotLocationDescription__c);
      testDepot002Id = depots[0].id;

      // Create test depot 003
      depot = new depot__c(Name                        = 'TEST-003',
                           depotProvider__c            = 'Flash',
                           depotStockedFor4Hour__c     = 'Yes',
                           depotLocationDescription__c = 'Test depot 003');
      insert depot;
      depots = [SELECT Id,
                       Name,
                       depotProvider__c,
                       depotStockedFor4Hour__c,
                       depotLocationDescription__c
                FROM   depot__c
                WHERE  Name = 'TEST-003'];

      System.assertEquals(1,                depots.size());
      System.assertEquals('TEST-003',       depots[0].Name);
      System.assertEquals('Flash',          depots[0].depotProvider__c);
      System.assertEquals('Yes',            depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot 003', depots[0].depotLocationDescription__c);
      testDepot003Id = depots[0].id;

      // Create test depot 004
      depot = new depot__c(Name                        = 'TEST-004',
                           depotProvider__c            = 'Nimble',
                           depotStockedFor4Hour__c     = 'No',
                           depotLocationDescription__c = 'Test depot 004');
      insert depot;
      depots = [SELECT Id,
                       Name,
                       depotProvider__c,
                       depotStockedFor4Hour__c,
                       depotLocationDescription__c
                FROM   depot__c
                WHERE  Name = 'TEST-004'];

      System.assertEquals(1,                depots.size());
      System.assertEquals('TEST-004',       depots[0].Name);
      System.assertEquals('Nimble',         depots[0].depotProvider__c);
      System.assertEquals('No',             depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot 004', depots[0].depotLocationDescription__c);
      testDepot004Id = depots[0].id;

      // Create test depot 005
      depot = new depot__c(Name                        = 'TEST-005',
                           depotProvider__c            = 'Nimble',
                           depotStockedFor4Hour__c     = 'No',
                           depotLocationDescription__c = 'Test depot 005');
      insert depot;
      depots = [SELECT Id,
                       Name,
                       depotProvider__c,
                       depotStockedFor4Hour__c,
                       depotLocationDescription__c
                FROM   depot__c
                WHERE  Name = 'TEST-005'];

      System.assertEquals(1,                depots.size());
      System.assertEquals('TEST-005',       depots[0].Name);
      System.assertEquals('Nimble',         depots[0].depotProvider__c);
      System.assertEquals('No',             depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot 005', depots[0].depotLocationDescription__c);
      testDepot005Id = depots[0].id;

      // Create the NBD/ND map entries
      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'United States',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot004Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot005Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'United States' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                        depotMapNbdNds.size());
      System.assertEquals('__United States__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('United States',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                    depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot004Id,           depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot005Id,           depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);
      
      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'United Kingdom',
                                           depotMapNbdNdState__c     = 'Isle of Man',
                                           depotMapNbdNd_NbdDepot__c = testDepot004Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot005Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'United Kingdom' and
                               depotMapNbdNdState__c   = 'Isle of Man'];

      System.assertEquals(1,                        depotMapNbdNds.size());
      System.assertEquals('__United Kingdom__Isle of Man__', depotMapNbdNds[0].Name);
      System.assertEquals('United Kingdom',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('Isle of Man',                    depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot004Id,           depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot005Id,           depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Australia',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Australia' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                    depotMapNbdNds.size());
      System.assertEquals('__Australia__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Australia',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Austria',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Austria' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                  depotMapNbdNds.size());
      System.assertEquals('__Austria__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Austria',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',              depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Belgium',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Belgium' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                  depotMapNbdNds.size());
      System.assertEquals('__Belgium__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Belgium',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',              depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Bermuda',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot002Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot002Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Bermuda' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                  depotMapNbdNds.size());
      System.assertEquals('__Bermuda__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Bermuda',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',              depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot002Id,     depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot002Id,     depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Canada',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot002Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot002Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Canada' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                 depotMapNbdNds.size());
      System.assertEquals('__Canada__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Canada',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',             depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot002Id,    depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot002Id,    depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'China',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'China' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                    depotMapNbdNds.size());
      System.assertEquals('__China__N/A__',     depotMapNbdNds[0].Name);
      System.assertEquals('China',              depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Denmark',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Denmark' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                  depotMapNbdNds.size());
      System.assertEquals('__Denmark__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Denmark',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',              depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Finland',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Finland' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                  depotMapNbdNds.size());
      System.assertEquals('__Finland__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Finland',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',              depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'France',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'France' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                 depotMapNbdNds.size());
      System.assertEquals('__France__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('France',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',             depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,    depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,    depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Germany',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Germany' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                  depotMapNbdNds.size());
      System.assertEquals('__Germany__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Germany',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',              depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Hong Kong',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Hong Kong' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                    depotMapNbdNds.size());
      System.assertEquals('__Hong Kong__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Hong Kong',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'India',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'India' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                    depotMapNbdNds.size());
      System.assertEquals('__India__N/A__',     depotMapNbdNds[0].Name);
      System.assertEquals('India',              depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Indonesia',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Indonesia' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                    depotMapNbdNds.size());
      System.assertEquals('__Indonesia__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Indonesia',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,       depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Ireland',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Ireland' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                  depotMapNbdNds.size());
      System.assertEquals('__Ireland__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Ireland',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',              depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,     depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Japan',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Japan' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                depotMapNbdNds.size());
      System.assertEquals('__Japan__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Japan',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',            depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,   depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,   depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Malaysia',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Malaysia' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                   depotMapNbdNds.size());
      System.assertEquals('__Malaysia__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Malaysia',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',               depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,      depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,      depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Netherlands',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot003Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot003Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Netherlands' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                        depotMapNbdNds.size());
      System.assertEquals('__Netherlands__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Netherlands',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                    depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot003Id,           depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot003Id,           depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'New Zealand',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'New Zealand' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                      depotMapNbdNds.size());
      System.assertEquals('__New Zealand__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('New Zealand',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                  depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,         depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,         depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Norway',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Norway' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                 depotMapNbdNds.size());
      System.assertEquals('__Norway__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Norway',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',             depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,    depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,    depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Philippines',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Philippines' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                      depotMapNbdNds.size());
      System.assertEquals('__Philippines__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Philippines',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                  depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,         depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,         depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Singapore',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot003Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot003Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Singapore' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                    depotMapNbdNds.size());
      System.assertEquals('__Singapore__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Singapore',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot003Id,       depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot003Id,       depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'South Africa',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'South Africa' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                       depotMapNbdNds.size());
      System.assertEquals('__South Africa__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('South Africa',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                   depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,          depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,          depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'South Korea',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'South Korea' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                      depotMapNbdNds.size());
      System.assertEquals('__South Korea__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('South Korea',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                  depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,         depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,         depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Spain',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Spain' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                depotMapNbdNds.size());
      System.assertEquals('__Spain__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Spain',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',            depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,   depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,   depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Sweden',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Sweden' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                 depotMapNbdNds.size());
      System.assertEquals('__Sweden__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Sweden',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',             depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,    depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,    depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Switzerland',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Switzerland' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                      depotMapNbdNds.size());
      System.assertEquals('__Switzerland__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Switzerland',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                  depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,         depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,         depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'Taiwan',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'Taiwan' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                 depotMapNbdNds.size());
      System.assertEquals('__Taiwan__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('Taiwan',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',             depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,    depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,    depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'United Arab Emirates',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = testDepot001Id,
                                           depotMapNbdNd_NdDepot__c  = testDepot001Id);
      insert depotMapNbdNd;
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'United Arab Emirates' and
                               depotMapNbdNdState__c   = 'N/A'];

      System.assertEquals(1,                               depotMapNbdNds.size());
      System.assertEquals('__United Arab Emirates__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('United Arab Emirates',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                           depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testDepot001Id,                  depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testDepot001Id,                  depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      // Create the 4-Hour map entries
      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United States',
                                           depotMap4HourPostalCode__c  = '11111',
                                           depotMap4Hour_4HourDepot__c = testDepot001Id,
                                           depotMap4HourDriveTime__c   = 10.5);
      insert depotMap4Hour;
      depotMap4Hours = [SELECT Id,
                               Name,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c,
                               depotMap4HourDrivetime__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United States' and
                               depotMap4HourPostalCode__c  = '11111' and
                               depotMap4Hour_4HourDepot__c = :testDepot001Id];

      System.assertEquals(1,                                    depotMap4Hours.size());
      System.assertEquals('__United States__11111__TEST-001__', depotMap4Hours[0].Name);
      System.assertEquals('United States',                      depotMap4Hours[0].depotMap4HourCountry__c);
      System.assertEquals('11111',                              depotMap4Hours[0].depotMap4HourPostalCode__c);
      System.assertEquals(testDepot001Id,                       depotMap4Hours[0].depotMap4Hour_4HourDepot__c);
      System.assertEquals(10.5,                                 depotMap4Hours[0].depotMap4HourDriveTime__c);

      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United States',
                                           depotMap4HourPostalCode__c  = '22222',
                                           depotMap4Hour_4HourDepot__c = testDepot002Id,
                                           depotMap4HourDriveTime__c   = 20.5);
      insert depotMap4Hour;
      depotMap4Hours = [SELECT Id,
                               Name,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c,
                               depotMap4HourDrivetime__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United States' and
                               depotMap4HourPostalCode__c  = '22222' and
                               depotMap4Hour_4HourDepot__c = :testDepot002Id];

      System.assertEquals(1,                                    depotMap4Hours.size());
      System.assertEquals('__United States__22222__TEST-002__', depotMap4Hours[0].Name);
      System.assertEquals('United States',                      depotMap4Hours[0].depotMap4HourCountry__c);
      System.assertEquals('22222',                              depotMap4Hours[0].depotMap4HourPostalCode__c);
      System.assertEquals(testDepot002Id,                       depotMap4Hours[0].depotMap4Hour_4HourDepot__c);
      System.assertEquals(20.5,                                 depotMap4Hours[0].depotMap4HourDriveTime__c);

      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United States',
                                           depotMap4HourPostalCode__c  = '22222',
                                           depotMap4Hour_4HourDepot__c = testDepot003Id,
                                           depotMap4HourDriveTime__c   = 30.5);
      insert depotMap4Hour;
      depotMap4Hours = [SELECT Id,
                               Name,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c,
                               depotMap4HourDrivetime__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United States' and
                               depotMap4HourPostalCode__c  = '22222' and
                               depotMap4Hour_4HourDepot__c = :testDepot003Id];

      System.assertEquals(1,                                    depotMap4Hours.size());
      System.assertEquals('__United States__22222__TEST-003__', depotMap4Hours[0].Name);
      System.assertEquals('United States',                      depotMap4Hours[0].depotMap4HourCountry__c);
      System.assertEquals('22222',                              depotMap4Hours[0].depotMap4HourPostalCode__c);
      System.assertEquals(testDepot003Id,                       depotMap4Hours[0].depotMap4Hour_4HourDepot__c);
      System.assertEquals(30.5,                                 depotMap4Hours[0].depotMap4HourDriveTime__c);

      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United Kingdom',
                                           depotMap4HourPostalCode__c  = 'BS3',
                                           depotMap4Hour_4HourDepot__c = testDepot001Id,
                                           depotMap4HourDriveTime__c   = 10.5);
      insert depotMap4Hour;
      depotMap4Hours = [SELECT Id,
                               Name,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c,
                               depotMap4HourDrivetime__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United Kingdom' and
                               depotMap4HourPostalCode__c  = 'BS3' and
                               depotMap4Hour_4HourDepot__c = :testDepot001Id];

      System.assertEquals(1,                                   depotMap4Hours.size());
      System.assertEquals('__United Kingdom__BS3__TEST-001__', depotMap4Hours[0].Name);
      System.assertEquals('United Kingdom',                    depotMap4Hours[0].depotMap4HourCountry__c);
      System.assertEquals('BS3',                               depotMap4Hours[0].depotMap4HourPostalCode__c);
      System.assertEquals(testDepot001Id,                      depotMap4Hours[0].depotMap4Hour_4HourDepot__c);
      System.assertEquals(10.5,                                depotMap4Hours[0].depotMap4HourDriveTime__c);

      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United Kingdom',
                                           depotMap4HourPostalCode__c  = 'BS3A',
                                           depotMap4Hour_4HourDepot__c = testDepot002Id,
                                           depotMap4HourDriveTime__c   = 20.5);
      insert depotMap4Hour;
      depotMap4Hours = [SELECT Id,
                               Name,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c,
                               depotMap4HourDrivetime__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United Kingdom' and
                               depotMap4HourPostalCode__c  = 'BS3A' and
                               depotMap4Hour_4HourDepot__c = :testDepot002Id];

      System.assertEquals(1,                                    depotMap4Hours.size());
      System.assertEquals('__United Kingdom__BS3A__TEST-002__', depotMap4Hours[0].Name);
      System.assertEquals('United Kingdom',                     depotMap4Hours[0].depotMap4HourCountry__c);
      System.assertEquals('BS3A',                               depotMap4Hours[0].depotMap4HourPostalCode__c);
      System.assertEquals(testDepot002Id,                       depotMap4Hours[0].depotMap4Hour_4HourDepot__c);
      System.assertEquals(20.5,                                 depotMap4Hours[0].depotMap4HourDriveTime__c);

      // Create test RMA
      rma = new RMAv2__c(rmaCaseNumber__c                 = testCaseId,
                         rmaType__c                       = 'Advance replacement',
                         rmaLabArray__c                   = 'No',
                         rmaComponent__c                  = 'CHASSIS',
                         rmaNimbleOsVersion__c            = 'CHASSIS: N/A',
                         rmaModel__c                      = 'CHASSIS: CS/ES series',
                         rmaPart__c                       = 'CHASSIS: CS/ES series chassis [SR-Chassis-3U-SMC]',
                         rmaQuantity__c                   = '1',
                         rmaReason__c                     = 'CHASSIS: Bad controller slot',
                         rmaManufacturer__c               = 'Super Micro',
                         rmaDetailedReason__c             = 'TEST-RMA-DETAILED-REASON',
                         rmaConfigurationDetails__c       = 'TEST-RMA-CONFIGURATION-DETAILS',
                         rmaShipmentAddressSelector__c    = 'Asset install address',
                         rmaOverrideShipmentPostalCode__c = '11111',
                         rmaOverrideShipmentCountry__c    = 'United States',
                         rmaOverrideShipmentAttn__c       = 'TEST-RMA-OVERRIDE-SHIPMENT-ATTN',
                         rmaOverrideShipmentPhone__c      = 'TEST-RMA-OVERRIDE-SHIPMENT-PHONE',
                         rmaOverrideShipmentEmail__c      = 'test-rma-override-shipment-email@nimblestorage.com',
                         rmaUplift__c                     = 'No: Do not uplift',
                         rmaOutgoingShipmentStatus__c     = 'DRAFT-10: Waiting to order',
                         rmaReturnShipmentStatus__c       = 'DRAFT-10: Waiting to order',
                         rmaRetShip2Status__c             = 'DRAFT-10: Waiting to order',
                         rmaOnsiteTechStatus__c           = 'DRAFT-10: Waiting to order',
                         rmaTransmitRmaShisWithOrder__c   = 'No SHI');
      insert rma;
      rmas = [SELECT Id,
                     rmaCaseNumber__c,
                     rmaType__c,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaReason__c,
                     rmaManufacturer__c,
                     rmaDetailedReason__c,
                     rmaConfigurationDetails__c,
                     rmaShipmentAddressSelector__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOverrideShipmentAttn__c,
                     rmaOverrideShipmentPhone__c,
                     rmaOverrideShipmentEmail__c,
                     rmaUplift__c,
                     rmaOutgoingShipmentStatus__c,
                     rmaReturnShipmentStatus__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                        rmas.size());
      System.assertEquals(testCaseId,                                               rmas[0].rmaCaseNumber__c);
      System.assertEquals('Advance replacement',                                    rmas[0].rmaType__c);
      System.assertEquals('No',                                                     rmas[0].rmaLabArray__c);
      System.assertEquals('CHASSIS' ,                                               rmas[0].rmaComponent__c);
      System.assertEquals('CHASSIS: N/A',                                           rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('CHASSIS: CS/ES series',                                  rmas[0].rmaModel__c);
      System.assertEquals('CHASSIS: CS/ES series chassis [SR-Chassis-3U-SMC]',      rmas[0].rmaPart__c);
      System.assertEquals('1',                                                      rmas[0].rmaQuantity__c);
      System.assertEquals('CHASSIS: Bad controller slot',                           rmas[0].rmaReason__c);
      System.assertEquals('Super Micro',                                            rmas[0].rmaManufacturer__c);
      System.assertEquals('TEST-RMA-DETAILED-REASON',                               rmas[0].rmaDetailedReason__c);
      System.assertEquals('TEST-RMA-CONFIGURATION-DETAILS',                         rmas[0].rmaConfigurationDetails__c);
      System.assertEquals('Asset install address',                                  rmas[0].rmaShipmentAddressSelector__c);
      System.assertEquals('11111',                                                  rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United States',                                          rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('TEST-RMA-OVERRIDE-SHIPMENT-ATTN',                        rmas[0].rmaOverrideShipmentAttn__c);
      System.assertEquals('TEST-RMA-OVERRIDE-SHIPMENT-PHONE',                       rmas[0].rmaOverrideShipmentPhone__c);
      System.assertEquals('test-rma-override-shipment-email@nimblestorage.com',     rmas[0].rmaOverrideShipmentEmail__c);
      System.assertEquals('No: Do not uplift',                                      rmas[0].rmaUplift__c);
      System.assertEquals('DRAFT-10: Waiting to order',                             rmas[0].rmaOutgoingShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',                             rmas[0].rmaReturnShipmentStatus__c);
      testRmaId = rmas[0].id;
      
      
      createPostalCode();
      
     }
      
     // ==================================================================================== createPostalCode
          static void createPostalCode()
     {
          PostalCode__c pc;
          List<PostalCode__c>  insPc = new List<PostalCode__c>();
          Map<String,PostalCode__c> mapExpectedPc= new Map<String,PostalCode__c>();  
         
         // Create test PostalCode 001
          pc = new PostalCode__c(pcCountry__c  = 'Australia',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Australia\'s "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 002
          pc = new PostalCode__c(pcCountry__c  = 'Austria',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Austria\'s "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 003
          pc = new PostalCode__c(pcCountry__c  = 'Belgium',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Belgium\'s "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 004
          pc = new PostalCode__c(pcCountry__c  = 'Bermuda',
                           pcFormatInRegex__c = '^([A-Z][A-Z]) [0-9][0-9]$',
                           pcDummyPostalCode__c     = 'AA 99',                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Bermuda\'s "AA 99" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 005
          pc = new PostalCode__c(pcCountry__c  = 'Canada',
                           pcFormatInRegex__c = '^([A-Z][0-9][A-Z]) [0-9][A-Z][0-9]$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Canada\'s "A9A 9A9" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 006
          pc = new PostalCode__c(pcCountry__c  = 'China',
                           pcFormatInRegex__c = '^([0-9]{6})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to China\'s "999999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 007
          pc = new PostalCode__c(pcCountry__c  = 'Denmark',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Denmark\'s "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 008
          pc = new PostalCode__c(pcCountry__c  = 'Finland',
                           pcFormatInRegex__c = '^([0-9]{5})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Finland\'s "99999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 009
          pc = new PostalCode__c(pcCountry__c  = 'France',
                           pcFormatInRegex__c = '^([0-9]{5})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to France\'s "99999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 010
          pc = new PostalCode__c(pcCountry__c  = 'Germany',
                           pcFormatInRegex__c = '^([0-9]{5})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Germany\'s "99999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 011
          pc = new PostalCode__c(pcCountry__c  = 'Hong Kong',
                           pcFormatInRegex__c = '^([0-9]{6})$',
                           pcDummyPostalCode__c     = '999077',                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Hong Kong\'s "999999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 012
          pc = new PostalCode__c(pcCountry__c  = 'India',
                           pcFormatInRegex__c = '^([0-9]{6})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to India\'s "999999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 013
          pc = new PostalCode__c(pcCountry__c  = 'Indonesia',
                           pcFormatInRegex__c = '^([0-9]{5})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Indonesia\'s "99999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 014
          pc = new PostalCode__c(pcCountry__c  = 'Ireland',
                           pcFormatInRegex__c = '^([A-Z][0-9]{2}) [A-Z][0-9][A-Z]{2}$',
                           pcDummyPostalCode__c     = 'A99 A9AA',                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Ireland\'s "A99 A9AA" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 015
          pc = new PostalCode__c(pcCountry__c  = 'Japan',
                           pcFormatInRegex__c = '^([0-9]{3}-[0-9]{2})[0-9]{2}$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Japan\'s "999-9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 016
          pc = new PostalCode__c(pcCountry__c  = 'Malaysia',
                           pcFormatInRegex__c = '^([0-9]{5})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Malaysia\'s "99999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 017
          pc = new PostalCode__c(pcCountry__c  = 'Netherlands',
                           pcFormatInRegex__c = '^([0-9]{4}) [A-Z]{2}$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Netherlands\' "9999 AA" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 018
          pc = new PostalCode__c(pcCountry__c  = 'New Zealand',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to New Zealand\'s "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 019
          pc = new PostalCode__c(pcCountry__c  = 'Norway',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Norway\'s "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 020
          pc = new PostalCode__c(pcCountry__c  = 'Philippines',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Philippines\' "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 021
          pc = new PostalCode__c(pcCountry__c  = 'Singapore',
                           pcFormatInRegex__c = '^([0-9]{2})[0-9]{4}$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Singapore\'s "999999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 022
          pc = new PostalCode__c(pcCountry__c  = 'South Africa',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to South Africa\'s "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 023
          pc = new PostalCode__c(pcCountry__c  = 'South Korea',
                           pcFormatInRegex__c = '^([0-9]{3}-[0-9]{3})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to South Korea\'s "999-999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);

          // Create test PostalCode 024
          pc = new PostalCode__c(pcCountry__c  = 'Spain',
                           pcFormatInRegex__c = '^([0-9]{5})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Spain\'s "99999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 025
          pc = new PostalCode__c(pcCountry__c  = 'Sweden',
                           pcFormatInRegex__c = '^([0-9]{5})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Sweden\'s "99999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 026
          pc = new PostalCode__c(pcCountry__c  = 'Switzerland',
                           pcFormatInRegex__c = '^([0-9]{4})$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Switzerland\'s "9999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 027
          pc = new PostalCode__c(pcCountry__c  = 'Taiwan',
                           pcFormatInRegex__c = '^([0-9]{3})[0-9]{2}$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to Taiwan\'s "99999" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 028
          pc = new PostalCode__c(pcCountry__c  = 'United Arab Emirates',
                           pcFormatInRegex__c = '^([A-Z]{3})$',
                           pcDummyPostalCode__c     = 'AAA',                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to United Arab Emirates\' "AAA" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 029
          pc = new PostalCode__c(pcCountry__c  = 'United States',
                           pcFormatInRegex__c = '^([0-9]{5})(-[0-9]{4})?$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to United States\' "99999(-9999)" format.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 030
          pc = new PostalCode__c(pcCountry__c  = 'United Kingdom',
                           pcFormatInRegex__c = '^([A-Z]{1,2}[0-9]{1,2}) [0-9][A-Z]{2}$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to one of United Kingdom\'s six formats.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
          // Create test PostalCode 031
          pc = new PostalCode__c(pcCountry__c  = 'United Kingdom',
                           pcFormatInRegex__c = '^([A-Z]{1,2}[0-9][A-Z]) [0-9][A-Z]{2}$',
                           pcDummyPostalCode__c     = null,                           
                           pcErrorMessage__c='"Shipment Postal Code" will not conform to one of United Kingdom\'s six formats.  Override it if needed to provide a valid value.');
          insPc.add(pc);
          mapExpectedPc.put(pc.pcCountry__c + '__' +pc.pcFormatInRegex__c,pc);
         
         
         insert insPC;
         
         List<PostalCode__c>   pcs = [SELECT Id,
                                    pcCountry__c,
                                    pcFormatInRegex__c,
                                    pcDummyPostalCode__c 
                                    FROM   PostalCode__c];
         
          System.assertEquals(insPc.size(),              pcs.size());
         
         
          for(Integer i=0;i<pcs.size();i++)
          {
              pc = mapExpectedPc.get(pcs[i].pcCountry__c + '__' + pcs[i].pcFormatInRegex__c);
              
              System.assertEquals(pc.pcCountry__c , pcs[i].pcCountry__c,'Country Name - ' + pcs[i].pcCountry__c);
              System.assertEquals(pc.pcFormatInRegex__c, pcs[i].pcFormatInRegex__c,'Country Name - ' + pcs[i].pcCountry__c);
              System.assertEquals(pc.pcDummyPostalCode__c, pcs[i].pcDummyPostalCode__c,'Country Name - ' + pcs[i].pcCountry__c);
          }
  
        
     }

   // ==================================================================================== test4Hour_2DepotsStocked
   static testMethod void test4Hour_2DepotsStocked()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'Yes: Uplift to 4-Hour';
      rmas[0].rmaOverrideShipmentPostalCode__c = '22222-2222';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United States (US)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('Yes: Uplift to 4-Hour',  rmas[0].rmaUplift__c);
      System.assertEquals('22222-2222',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United States (US)',     rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-002',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== test4Hour_1DepotsStocked
   static testMethod void test4Hour_1DepotsStocked()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'Yes: Uplift to 4-Hour';
      rmas[0].rmaOverrideShipmentPostalCode__c = '11111-1111';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United States (US)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('Yes: Uplift to 4-Hour',  rmas[0].rmaUplift__c);
      System.assertEquals('11111-1111',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United States (US)',     rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== test4Hour_0DepotsStocked
   static testMethod void test4Hour_0DepotsStocked()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'Yes: Uplift to 4-Hour';
      rmas[0].rmaOverrideShipmentPostalCode__c = '00000-0000';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United States (US)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('Yes: Uplift to 4-Hour',  rmas[0].rmaUplift__c);
      System.assertEquals('00000-0000',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United States (US)',     rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Nimble',                 rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-005',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== test4HourUnknown
   static testMethod void test4HourUnknown()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'Yes: Uplift to 4-Hour';
      rmas[0].rmaOverrideShipmentPostalCode__c = '11111-1111';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Unknownistan';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('Yes: Uplift to 4-Hour',  rmas[0].rmaUplift__c);
      System.assertEquals('11111-1111',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Unknownistan',           rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Unknown',                rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('Unknown',                rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testNbdUnknown
   static testMethod void testNbdUnknown()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '11111-1111';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Unknownistan';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('11111-1111',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Unknownistan',           rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Unknown',                rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('Unknown',                rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testNd
   static testMethod void testNd()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'Yes: Uplift to Next Day';
      rmas[0].rmaOverrideShipmentPostalCode__c = '11111-1111';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United States (US)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                          rmas.size());
      System.assertEquals('Yes: Uplift to Next Day',  rmas[0].rmaUplift__c);
      System.assertEquals('11111-1111',               rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United States (US)',       rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Nimble',                   rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-005',                 rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testNbd
   static testMethod void testNbd()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '11111-1111';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United States (US)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('11111-1111',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United States (US)',     rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Nimble',                 rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-004',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testSystemPartReturn
   static testMethod void testSystemPartReturn()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaType__c,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaType__c                       = 'System/part return';
      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '11111-1111';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United States (US)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaType__c,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('System/part return',     rmas[0].rmaType__c);
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('11111-1111',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United States (US)',     rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Nimble',                 rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('SRV-NIMBLE',             rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBlankCountry
   static testMethod void testBlankCountry()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '11111-1111';
      rmas[0].rmaOverrideShipmentCountry__c    = null;

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('Based on your address selections, the "Shipment Country" will be blank.  This field cannot be blank.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testBlankPostalCode
   static testMethod void testBlankPostalCode()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = null;
      rmas[0].rmaOverrideShipmentCountry__c    = 'United States (US)';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('Based on your address selections, the "Shipment Postal Code" will be blank.  This field cannot be blank.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeAustralia
   static testMethod void testGoodPostalCodeAustralia()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Australia';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('1234',                   rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Australia',              rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeAustralia
   static testMethod void testBadPostalCodeAustralia()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Australia';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Australia\'s "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeAustria
   static testMethod void testGoodPostalCodeAustria()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Austria';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('1234',              rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Austria',           rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeAustria
   static testMethod void testBadPostalCodeAustria()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Austria';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Austria\'s "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeBelgium
   static testMethod void testGoodPostalCodeBelgium()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Belgium';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('1234',              rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Belgium',           rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeBelgium
   static testMethod void testBadPostalCodeBelgium()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Belgium';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Belgium\'s "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeBermuda
   static testMethod void testGoodPostalCodeBermuda()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = 'zy 35';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Bermuda';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('zy 35',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Bermuda',           rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-002',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeBermuda
   //   NOTE: This test is commented out because the rmaTrigger will always set a valid
   //         format postal code for Bermuda.  See Bermuda notes in the rmaTrigger
   //         for more info.
//   static testMethod void testBadPostalCodeBermuda()
//     {List<RMAv2__c> rmas;
//      ID testRmaId;
//      Exception dmlException;

//      createTestData();

//      rmas = [SELECT Id,
//                     rmaUplift__c,
//                     rmaOverrideShipmentPostalCode__c,
//                     rmaOverrideShipmentCountry__c
//              FROM   RMAv2__c];

//      System.assertEquals(1, rmas.size());

//      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
//      rmas[0].rmaOverrideShipmentPostalCode__c = 'aa 99z';
//      rmas[0].rmaOverrideShipmentCountry__c    = 'Bermuda';

//      try
//        {update rmas[0];
//        }
//      catch(Exception ex)
//        {dmlException = ex;
//        }

//      System.assertNotEquals(null, dmlException);
//      System.assert(dmlException instanceOf system.Dmlexception);
//      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
//      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Bermuda\'s "AA 99" format.  Override it if needed to provide a valid value.'));
//     }

   // ==================================================================================== testGoodPostalCodeCanada
   static testMethod void testGoodPostalCodeCanada()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = 'z8y 3g5';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Canada';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('z8y 3g5',                rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Canada',                 rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-002',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeCanada
   static testMethod void testBadPostalCodeCanada()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = 'a9a 9z9z';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Canada';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Canada\'s "A9A 9A9" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeChina
   static testMethod void testGoodPostalCodeChina()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '123456';
      rmas[0].rmaOverrideShipmentCountry__c    = 'China';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('123456',                 rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('China',                  rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeChina
   static testMethod void testBadPostalCodeChina()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'China';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to China\'s "999999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeDenmark
   static testMethod void testGoodPostalCodeDenmark()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Denmark';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('1234',              rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Denmark',           rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeDenmark
   static testMethod void testBadPostalCodeDenmark()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Denmark';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Denmark\'s "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeFinland
   static testMethod void testGoodPostalCodeFinland()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Finland';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('12345',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Finland',           rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeFinland
   static testMethod void testBadPostalCodeFinland()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z34';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Finland';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Finland\'s "99999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeFrance
   static testMethod void testGoodPostalCodeFrance()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'France';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('12345',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('France',            rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeFrance
   static testMethod void testBadPostalCodeFrance()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z34';
      rmas[0].rmaOverrideShipmentCountry__c    = 'France';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to France\'s "99999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeGermany
   static testMethod void testGoodPostalCodeGermany()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Germany';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('12345',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Germany',           rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeGermany
   static testMethod void testBadPostalCodeGermany()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z34';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Germany';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Germany\'s "99999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeHongKong
   static testMethod void testGoodPostalCodeHongKong()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '123456';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Hong Kong';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('123456',            rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Hong Kong',         rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeHongKong
   //   NOTE: This test is commented out because the rmaTrigger will always set a valid
   //         format postal code for Hong Kong.  See Hong Kong notes in the rmaTrigger
   //         for more info.
//   static testMethod void testBadPostalCodeHongKong()
//     {List<RMAv2__c> rmas;
//      ID testRmaId;
//      Exception dmlException;

//      createTestData();

//      rmas = [SELECT Id,
//                     rmaUplift__c,
//                     rmaOverrideShipmentPostalCode__c,
//                     rmaOverrideShipmentCountry__c
//              FROM   RMAv2__c];

//      System.assertEquals(1, rmas.size());

//      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
//      rmas[0].rmaOverrideShipmentPostalCode__c = '123456a';
//      rmas[0].rmaOverrideShipmentCountry__c    = 'Hong Kong';

//      try
//        {update rmas[0];
//        }
//      catch(Exception ex)
//        {dmlException = ex;
//        }

//      System.assertNotEquals(null, dmlException);
//      System.assert(dmlException instanceOf system.Dmlexception);
//      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
//      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Hong Kong\'s "999999" format.  Override it if needed to provide a valid value.'));
//     }

   // ==================================================================================== testGoodPostalCodeIndia
   static testMethod void testGoodPostalCodeIndia()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '123456';
      rmas[0].rmaOverrideShipmentCountry__c    = 'India';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('123456',                 rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('India',                  rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeIndia
   static testMethod void testBadPostalCodeIndia()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'India';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to India\'s "999999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeIndonesia
   static testMethod void testGoodPostalCodeIndonesia()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Indonesia';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('12345',                  rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Indonesia',              rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeIndonesia
   static testMethod void testBadPostalCodeIndonesia()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z34';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Indonesia';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Indonesia\'s "99999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeIreland
   static testMethod void testGoodPostalCodeIreland()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = 'a89 z5cd';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Ireland';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('a89 z5cd',               rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Ireland',                rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeIreland
   //   NOTE: This test is commented out because the rmaTrigger will always set a valid
   //         format postal code for Ireland.  See Ireland notes in the rmaTrigger
   //         for more info.
//   static testMethod void testBadPostalCodeIreland()
//     {List<RMAv2__c> rmas;
//      ID testRmaId;
//      Exception dmlException;

//      createTestData();

//      rmas = [SELECT Id,
//                     rmaUplift__c,
//                     rmaOverrideShipmentPostalCode__c,
//                     rmaOverrideShipmentCountry__c
//              FROM   RMAv2__c];

//      System.assertEquals(1, rmas.size());

//      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
//      rmas[0].rmaOverrideShipmentPostalCode__c = 'a99 z9z5';
//      rmas[0].rmaOverrideShipmentCountry__c    = 'Ireland';

//      try
//        {update rmas[0];
//        }
//      catch(Exception ex)
//        {dmlException = ex;
//        }

//      System.assertNotEquals(null, dmlException);
//      System.assert(dmlException instanceOf system.Dmlexception);
//      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
//      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Ireland\'s "A99 A9AA" format.  Override it if needed to provide a valid value.'));
//     }

   // ==================================================================================== testGoodPostalCodeJapan
   static testMethod void testGoodPostalCodeJapan()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '123-4567';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Japan';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('123-4567',          rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Japan',             rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeJapan
   static testMethod void testBadPostalCodeJapan()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12-34567';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Japan';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Japan\'s "999-9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeMalaysia
   static testMethod void testGoodPostalCodeMalaysia()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Malaysia';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('12345',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Malaysia',          rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeMalaysia
   static testMethod void testBadPostalCodeMalaysia()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z34';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Malaysia';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Malaysia\'s "99999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeNetherlands
   static testMethod void testGoodPostalCodeNetherlands()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '9876 gg';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Netherlands';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('9876 gg',                rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Netherlands',            rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-003',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeNetherlands
   static testMethod void testBadPostalCodeNetherlands()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234 zzz';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Netherlands';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Netherlands\' "9999 AA" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeNewZealand
   static testMethod void testGoodPostalCodeNewZealand()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'New Zealand';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('1234',              rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('New Zealand',       rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeNewZealand
   static testMethod void testBadPostalCodeNewZealand()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'New Zealand';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to New Zealand\'s "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeNorway
   static testMethod void testGoodPostalCodeNorway()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Norway';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('1234',              rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Norway',            rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeNorway
   static testMethod void testBadPostalCodeNorway()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Norway';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Norway\'s "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodePhilippines
   static testMethod void testGoodPostalCodePhilippines()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Philippines';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('1234',              rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Philippines',       rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodePhilippines
   static testMethod void testBadPostalCodePhilippines()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Philippines';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Philippines\' "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeSingapore
   static testMethod void testGoodPostalCodeSingapore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '559999';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Singapore';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('559999',            rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Singapore',         rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-003',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeSingapore
   static testMethod void testBadPostalCodeSingapore()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '5x9999';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Singapore';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Singapore\'s "999999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeSouthAfrica
   static testMethod void testGoodPostalCodeSouthAfrica()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'South Africa';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('1234',              rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('South Africa',      rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeSouthAfrica
   static testMethod void testBadPostalCodeSouthAfrica()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'South Africa';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to South Africa\'s "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeSouthKorea
   static testMethod void testGoodPostalCodeSouthKorea()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '123-456';
      rmas[0].rmaOverrideShipmentCountry__c    = 'South Korea';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('123-456',                rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('South Korea',            rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeSouthKorea
   static testMethod void testBadPostalCodeSouthKorea()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '123-4z6';
      rmas[0].rmaOverrideShipmentCountry__c    = 'South Korea';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to South Korea\'s "999-999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeSpain
   static testMethod void testGoodPostalCodeSpain()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Spain';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('12345',                  rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Spain',                  rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeSpain
   static testMethod void testBadPostalCodeSpain()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z45';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Spain';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Spain\'s "99999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeSweden
   static testMethod void testGoodPostalCodeSweden()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12345';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Sweden';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('No: Do not uplift',      rmas[0].rmaUplift__c);
      System.assertEquals('12345',                  rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Sweden',                 rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeSweden
   static testMethod void testBadPostalCodeSweden()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z45';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Sweden';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Sweden\'s "99999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeSwitzerland
   static testMethod void testGoodPostalCodeSwitzerland()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '1234';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Switzerland';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('1234',              rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Switzerland',       rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeSwitzerland
   static testMethod void testBadPostalCodeSwitzerland()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12z3';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Switzerland';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Switzerland\'s "9999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeTaiwan
   static testMethod void testGoodPostalCodeTaiwan()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '55599';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Taiwan';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                   rmas.size());
      System.assertEquals('No: Do not uplift', rmas[0].rmaUplift__c);
      System.assertEquals('55599',             rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('Taiwan',            rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',             rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',          rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeTaiwan
   static testMethod void testBadPostalCodeTaiwan()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '5x599';
      rmas[0].rmaOverrideShipmentCountry__c    = 'Taiwan';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to Taiwan\'s "99999" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testGoodPostalCodeUnitedArabEmirates
   static testMethod void testGoodPostalCodeUnitedArabEmirates()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = 'abc';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United Arab Emirates';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                      rmas.size());
      System.assertEquals('No: Do not uplift',    rmas[0].rmaUplift__c);
      System.assertEquals('abc',                  rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United Arab Emirates', rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',             rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeUnitedArabEmirates
   //   NOTE: This test is commented out because the rmaTrigger will always set a valid
   //         format postal code for United Arab Emirates.
//   static testMethod void testBadPostalCodeUnitedArabEmirates()
//     {List<RMAv2__c> rmas;
//      ID testRmaId;
//      Exception dmlException;

//      createTestData();

//      rmas = [SELECT Id,
//                     rmaUplift__c,
//                     rmaOverrideShipmentPostalCode__c,
//                     rmaOverrideShipmentCountry__c
//              FROM   RMAv2__c];

//      System.assertEquals(1, rmas.size());

//      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
//      rmas[0].rmaOverrideShipmentPostalCode__c = 'a12';
//      rmas[0].rmaOverrideShipmentCountry__c    = 'United Arab Emirates';

//      try
//        {update rmas[0];
//        }
//      catch(Exception ex)
//        {dmlException = ex;
//        }

//      System.assertNotEquals(null, dmlException);
//      System.assert(dmlException instanceOf system.Dmlexception);
//      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
//      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to United Arab Emirates\' "AAA" format.  Override it if needed to provide a valid value.'));
//     }

   // ==================================================================================== testGoodPostalCodeUnitedKingdom1
   static testMethod void testGoodPostalCodeUnitedKingdom1()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'Yes: Uplift to 4-Hour';
      rmas[0].rmaOverrideShipmentPostalCode__c = 'BS3 9ZZ';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United Kingdom';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('Yes: Uplift to 4-Hour',  rmas[0].rmaUplift__c);
      System.assertEquals('BS3 9ZZ',                rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United Kingdom',         rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-001',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testGoodPostalCodeUnitedKingdom2
   static testMethod void testGoodPostalCodeUnitedKingdom2()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'Yes: Uplift to 4-Hour';
      rmas[0].rmaOverrideShipmentPostalCode__c = 'BS3A 9ZZ';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United Kingdom';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c,
                     rmaOutgoingShipmentOrderProvider__c,
                     rmaOutgoingShipmentOrderDepot__c
              FROM   RMAv2__c];

      System.assertEquals(1,                        rmas.size());
      System.assertEquals('Yes: Uplift to 4-Hour',  rmas[0].rmaUplift__c);
      System.assertEquals('BS3A 9ZZ',               rmas[0].rmaOverrideShipmentPostalCode__c);
      System.assertEquals('United Kingdom',         rmas[0].rmaOverrideShipmentCountry__c);
      System.assertEquals('Flash',                  rmas[0].rmaOutgoingShipmentOrderProvider__c);
      System.assertEquals('TEST-002',               rmas[0].rmaOutgoingShipmentOrderDepot__c);
     }

   // ==================================================================================== testBadPostalCodeUnitedKingdom
   static testMethod void testBadPostalCodeUnitedKingdom()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = 'AA99A 9AA';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United Kingdom';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to one of United Kingdom\'s six formats.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testBadPostalCodeUnitedStates
   static testMethod void testBadPostalCodeUnitedStates()
     {List<RMAv2__c> rmas;
      ID testRmaId;
      Exception dmlException;

      createTestData();

      rmas = [SELECT Id,
                     rmaUplift__c,
                     rmaOverrideShipmentPostalCode__c,
                     rmaOverrideShipmentCountry__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaUplift__c                     = 'No: Do not uplift';
      rmas[0].rmaOverrideShipmentPostalCode__c = '12345-999z';
      rmas[0].rmaOverrideShipmentCountry__c    = 'United States';

      try
        {update rmas[0];
        }
      catch(Exception ex)
        {dmlException = ex;
        }

      System.assertNotEquals(null, dmlException);
      System.assert(dmlException instanceOf system.Dmlexception);
      System.assert(dmlException.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
      System.assert(dmlException.getMessage().contains('"Shipment Postal Code" will not conform to United States\' "99999(-9999)" format.  Override it if needed to provide a valid value.'));
     }

   // ==================================================================================== testHdd210Before
   static testMethod void testHdd210Before()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'HDD';
      rmas[0].rmaNimbleOsVersion__c            = 'HDD: N/A';
      rmas[0].rmaModel__c                      = 'HDD: CS210/220/420';
      rmas[0].rmaPart__c                       = 'HDD: 1TB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'HDD: Seagate';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS210/220/420',                            rmas[0].rmaModel__c);
      System.assertEquals('1TB SATA HDD [SR-HDD-1TB]',                     rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testHdd240Before
   static testMethod void testHdd240Before()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'HDD';
      rmas[0].rmaNimbleOsVersion__c            = 'HDD: N/A';
      rmas[0].rmaModel__c                      = 'HDD: CS240/440';
      rmas[0].rmaPart__c                       = 'HDD: 2TB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'HDD: Seagate';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS240/440',                                rmas[0].rmaModel__c);
      System.assertEquals('2TB SATA HDD [SR-HDD-2TB]',                     rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testHdd260Before
   static testMethod void testHdd260Before()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'HDD';
      rmas[0].rmaNimbleOsVersion__c            = 'HDD: N/A';
      rmas[0].rmaModel__c                      = 'HDD: CS260/460';
      rmas[0].rmaPart__c                       = 'HDD: 3TB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'HDD: Seagate';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS260/460',                                rmas[0].rmaModel__c);
      System.assertEquals('3TB SAS HDD [SR-HDD-3TB]',                      rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testHdd12TBefore
   static testMethod void testHdd12TBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'HDD';
      rmas[0].rmaNimbleOsVersion__c            = 'HDD: N/A';
      rmas[0].rmaModel__c                      = 'HDD: CS215/300/500/700, 12T';
      rmas[0].rmaPart__c                       = 'HDD: 1TB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'HDD: Seagate';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS215/300/500/700, 12T',                   rmas[0].rmaModel__c);
      System.assertEquals('1TB SAS HDD [SR-HDD-1TB-SAS]',                  rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testHdd24TBefore
   static testMethod void testHdd24TBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'HDD';
      rmas[0].rmaNimbleOsVersion__c            = 'HDD: N/A';
      rmas[0].rmaModel__c                      = 'HDD: CS215/300/500/700, 24T';
      rmas[0].rmaPart__c                       = 'HDD: 2TB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'HDD: Seagate';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS215/300/500/700, 24T',                   rmas[0].rmaModel__c);
      System.assertEquals('2TB SAS HDD [SR-HDD-2TB-SAS]',                  rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testHdd36TBefore
   static testMethod void testHdd36TBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'HDD';
      rmas[0].rmaNimbleOsVersion__c            = 'HDD: N/A';
      rmas[0].rmaModel__c                      = 'HDD: CS215/300/500/700, 36T';
      rmas[0].rmaPart__c                       = 'HDD: 3TB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'HDD: Seagate';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS215/300/500/700, 36T',                   rmas[0].rmaModel__c);
      System.assertEquals('3TB SAS HDD [SR-HDD-3TB-SAS]',                  rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testHdd48TBefore
   static testMethod void testHdd48TBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'HDD';
      rmas[0].rmaNimbleOsVersion__c            = 'HDD: N/A';
      rmas[0].rmaModel__c                      = 'HDD: CS215/300/500/700, 48T';
      rmas[0].rmaPart__c                       = 'HDD: 4TB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'HDD: Seagate';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS215/300/500/700, 48T',                   rmas[0].rmaModel__c);
      System.assertEquals('4TB SAS HDD [SR-HDD-4TB-SAS]',                  rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testHdd72TBefore
   static testMethod void testHdd72TBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'HDD';
      rmas[0].rmaNimbleOsVersion__c            = 'HDD: N/A';
      rmas[0].rmaModel__c                      = 'HDD: CS215/300/500/700, 72T';
      rmas[0].rmaPart__c                       = 'HDD: 6TB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'HDD: Seagate';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS215/300/500/700, 72T',                   rmas[0].rmaModel__c);
      System.assertEquals('6TB SAS HDD [SR-HDD-6TB-SAS]',                  rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd210X2Before
   static testMethod void testSsd210X2Before()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS210/210-X2/220/420';
      rmas[0].rmaPart__c                       = 'SSD: 80GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS210/210-X2/220/420',                     rmas[0].rmaModel__c);
      System.assertEquals('80GB SATA SSD [SR-SSD-80GB]',                   rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                    rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd210X4Before
   static testMethod void testSsd210X4Before()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS210-X4/220-X2/240/420-X2/440';
      rmas[0].rmaPart__c                       = 'SSD: 160GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS210-X4/220-X2/240/420-X2/440',           rmas[0].rmaModel__c);
      System.assertEquals('160GB SATA SSD [SR-SSD-160GB]',                 rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                    rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd220X4Before
   static testMethod void testSsd220X4Before()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS220-X4/240-X2/260/420-X4/440-X2/460';
      rmas[0].rmaPart__c                       = 'SSD: 300GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS220-X4/240-X2/260/420-X4/440-X2/460',    rmas[0].rmaModel__c);
      System.assertEquals('300GB SATA SSD [SR-SSD-300GB]',                 rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                    rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                        rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd220X8Before
   static testMethod void testSsd220X8Before()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS220-X8/240-X4/260-X2/420-X8/440-X4/460-X2';
      rmas[0].rmaPart__c                       = 'SSD: 600GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS220-X8/240-X4/260-X2/420-X8/440-X4/460-X2', rmas[0].rmaModel__c);
      System.assertEquals('600GB SATA SSD [SR-SSD-600GB]',                    rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd320FBefore
   static testMethod void testSsd320FBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS215/300/500/700, 320F';
      rmas[0].rmaPart__c                       = 'SSD: 80GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS215/300/500/700, 320F',                     rmas[0].rmaModel__c);
      System.assertEquals('80GB SATA SSD [SR-SSD-3500-80GB]',                 rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd640FBefore
   static testMethod void testSsd640FBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS215/300/500/700, 640F';
      rmas[0].rmaPart__c                       = 'SSD: 160GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS215/300/500/700, 640F',                     rmas[0].rmaModel__c);
      System.assertEquals('160GB SATA SSD [SR-SSD-3500-160GB]',               rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd1200FBefore
   static testMethod void testSsd1200FBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS215/300/500/700, 1200F';
      rmas[0].rmaPart__c                       = 'SSD: 300GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS215/300/500/700, 1200F',                    rmas[0].rmaModel__c);
      System.assertEquals('300GB SATA SSD [SR-SSD-3500-300GB]',               rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd2400FBefore
   static testMethod void testSsd2400FBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS215/300/500/700, 2400F';
      rmas[0].rmaPart__c                       = 'SSD: 600GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS215/300/500/700, 2400F',                    rmas[0].rmaModel__c);
      System.assertEquals('600GB SATA SSD [SR-SSD-3500-600GB]',               rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd3200FBefore
   static testMethod void testSsd3200FBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS215/300/500/700, 3200F';
      rmas[0].rmaPart__c                       = 'SSD: 800GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS215/300/500/700, 3200F',                    rmas[0].rmaModel__c);
      System.assertEquals('800GB SATA SSD [SR-SSD-3500-800GB]',               rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd6400FBefore
   static testMethod void testSsd6400FBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS215/300/500/700, 6400F';
      rmas[0].rmaPart__c                       = 'SSD: 1600GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS215/300/500/700, 6400F',                    rmas[0].rmaModel__c);
      System.assertEquals('1600GB SATA SSD [SR-SSD-1600GB]',                  rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd3200FsBefore
   static testMethod void testSsd3200FsBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS215/300/500/700, 3200FS';
      rmas[0].rmaPart__c                       = 'SSD: 800GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS215/300/500/700, 3200FS',                   rmas[0].rmaModel__c);
      System.assertEquals('800GB SAS SSD [SR-SSD-800GB-SAS]',                 rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }

   // ==================================================================================== testSsd6400FsBefore
   static testMethod void testSsd6400FsBefore()
     {List<RMAv2__c> rmas;
      ID testRmaId;

      createTestData();

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1, rmas.size());

      rmas[0].rmaLabArray__c                   = 'No';
      rmas[0].rmaComponent__c                  = 'SSD';
      rmas[0].rmaNimbleOsVersion__c            = 'SSD: N/A';
      rmas[0].rmaModel__c                      = 'SSD: CS215/300/500/700, 6400FS';
      rmas[0].rmaPart__c                       = 'SSD: 1600GB - save RMA to compute exact part';
      rmas[0].rmaQuantity__c                   = '1';
      rmas[0].rmaManufacturer__c               = 'SSD: Intel';
      rmas[0].rmaHddSsdSerialNumber__c         = 'ABC123';
      rmas[0].rmaReason__c                     = 'SSD: Starting to fail (proactive replacement)';
      update rmas[0];

      rmas = [SELECT Id,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaHddSsdSerialNumber__c,
                     rmaReason__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                                  rmas.size());
      System.assertEquals('No',                                               rmas[0].rmaLabArray__c);
      System.assertEquals('SSD',                                              rmas[0].rmaComponent__c);
      System.assertEquals('SSD: N/A',                                         rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('SSD: CS215/300/500/700, 6400FS',                   rmas[0].rmaModel__c);
      System.assertEquals('1600GB SAS SSD [SR-SSD-1600GB-SAS]',               rmas[0].rmaPart__c);
      System.assertEquals('1',                                                rmas[0].rmaQuantity__c);
      System.assertEquals('SSD: Intel',                                       rmas[0].rmaManufacturer__c);
      System.assertEquals('ABC123',                                           rmas[0].rmaHddSsdSerialNumber__c);
      System.assertEquals('SSD: Starting to fail (proactive replacement)',    rmas[0].rmaReason__c);
     }
  }