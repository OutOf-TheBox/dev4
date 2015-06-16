@isTest
private class rmaTriggerSetFaTest
  {// Using an inner class to make it easier to construct
   // test data was inspired from the following article:
   //   https://force201.wordpress.com/2013/02/22/cleaner-inner-class-test-fixture-pattern/

   class TestData
     {Account                         testAccount;
      Contact                         testContact;
      Asset                           testAsset;
      Case                            testCase;
      Depot__c                        testDepot;
      DepotMapNbdNd__c                testDepotMapNbdNd;
      RMAv2__c                        testRma;
      caseEscalationTypeDefinition__c testCaseEscalationTypeDefinition;
      caseEscalation__c               testCaseEscalation;

      TestData()
        {// Create test Account
         insert testAccount = new Account(Name = 'Acme Corporation');

         // Create test Contact
         insert testContact = new Contact(LastName  = 'Doe',
                                          FirstName = 'John',
                                          AccountId = testAccount.Id);

         // Create test Asset
         insert testAsset = new Asset(Name                      = 'AA-987654',
                                      AccountId                 = testAccount.Id,
                                      ContactId                 = testContact.Id,
                                      SLA__c                    = 'Premium',
                                      Install_Street1__c        = '123 Main Street',
                                      Install_Street2__c        = 'Suite 100',
                                      Install_City__c           = 'San Jose',
                                      Install_State_Province__c = 'CA',
                                      Install_Zip_Code__c       = '95151',
                                      Install_Country__c        = 'United States',
                                      Ship_Date__c              = Date.today().addDays(-180));

         // Create test Case
         insert testCase = new Case(AccountId = testAccount.Id,
                                    AssetId   = testAsset.Id,
                                    ContactId = testContact.Id,
                                    Subject   = 'TEST-CASE-SUBJECT');

         // Create test Depot
         insert testDepot = new Depot__c(Name                        = 'TST-001',
                                         depotProvider__c            = 'Flash',
                                         depotStockedFor4Hour__c     = 'No',
                                         depotLocationDescription__c = 'Test depot 001');

         // Create test NBD/ND mapping
         insert testDepotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'United States',
                                                         depotMapNbdNdState__c     = 'N/A',
                                                         depotMapNbdNd_NbdDepot__c = testDepot.Id,
                                                         depotMapNbdNd_NdDepot__c  = testDepot.Id);

         // Create test RMA
         insert testRma = new RMAv2__c(rmaCaseNumber__c                 = testCase.Id,
                                       rmaType__c                       = 'Advance replacement',
                                       rmaFaRequired__c                 = 'No FA Required',
                                       rmaLabArray__c                   = 'No',
                                       rmaComponent__c                  = 'HDD',
                                       rmaNimbleOsVersion__c            = 'HDD: N/A',
                                       rmaModel__c                      = 'HDD: CS210/220/420',
                                       rmaPart__c                       = 'HDD: 1TB - save RMA to compute exact part',
                                       rmaQuantity__c                   = '1',
                                       rmaManufacturer__c               = 'HDD: Seagate',
                                       rmaReason__c                     = 'HDD: Starting to fail (proactive replacement)',
                                       rmaDetailedReason__c             = 'Detailed reason text',
                                       rmaShipmentAddressSelector__c    = 'Asset install address',
                                       rmaOverrideShipmentAttn__c       = 'John Doe',
                                       rmaOverrideShipmentPhone__c      = '408-555-1234',
                                       rmaOverrideShipmentEmail__c      = 'john.doe@nimblestorage.com',
                                       rmaUplift__c                     = 'No: Do not uplift',
                                       rmaTransmitRmaShisWithOrder__c   = 'No SHI',
                                       rmaOutgoingShipmentStatus__c     = 'DRAFT-10: Waiting to order',
                                       rmaReturnShipmentStatus__c       = 'DRAFT-10: Waiting to order',
                                       rmaRetShip2Status__c             = 'DRAFT-10: Waiting to order',
                                       rmaOnsiteTechStatus__c           = 'DRAFT-10: Waiting to order');

         // Create test Case Escalation Type Definition
         insert testCaseEscalationTypeDefinition = new CaseEscalationTypeDefinition__c(caseEscalationTypeDefinitionGroup__c = 'Engineering Escalation');
        }

      void setRmaTypeSystemPartReturn()
        {testRma.rmaType__c               = 'System/part return';
         testRma.rmaFaRequired__c         = 'Engineering FA'; // This should get reset to "No FA Required"
         testRma.rmaCustomerFaRequired__c = true;             // This should get reset to false
         update testRma;
        }

      void setRmaAssetNrdIsInEffect()
        {testAsset.assetNrdStartDate__c = Date.today().addDays(-1);
         testAsset.assetNrdEndDate__c   = Date.today().addDays(1);
         update testAsset;

         testRma.rmaFaRequired__c         = 'Engineering FA'; // This should get reset to "No FA Required"
         testRma.rmaCustomerFaRequired__c = true;             // This should get reset to false
         update testRma;
        }

      void setRmaPartIsAShipOnlyPart()
        {testRma.rmaComponent__c          = 'BEZEL';
         testRma.rmaNimbleOsVersion__c    = 'BEZEL: N/A';
         testRma.rmaModel__c              = 'BEZEL: CS series';
         testRma.rmaPart__c               = 'BEZEL: CS series bezel (SR-Bezel-CS-series)';
         testRma.rmaQuantity__c           = '1';
         testRma.rmaManufacturer__c       = 'N/A';
         testRma.rmaReason__c             = 'Part damaged in shipping';
         testRma.rmaFaRequired__c         = 'Engineering FA'; // This should get reset to "No FA Required"
         testRma.rmaCustomerFaRequired__c = true;             // This should get reset to false
         update testRma;
        }

      void setRmaCaseIsEngOrExecEscalated()
        {insert testCaseEscalation = new CaseEscalation__c(caseEscalationCase__c           = testCase.Id,
                                                           caseEscalationTypeDefinition__c = testCaseEscalationTypeDefinition.Id);

         update testRma;
        }

      void setRmaAssetSlaOnsite()
        {testAsset.SLA__c = 'Premium 4 Hour Onsite';
         update testAsset;

         testRma.rmaOnsiteTechStatus__c                  = 'DRAFT-10: Waiting to order';
         testRma.rmaOverrideOnsiteSchedulingCode__c      = 'WITHIN-4-HOURS-10: Schedule within the next 4 hours';
         testRma.rmaOverrideOnsitePartHandoverCode__c    = 'MANNED-10: Part courier must leave part with somebody at site';
         testRma.rmaOverrideOnsiteCheckInCode__c         = 'CHECK-IN-10: FE must check in upon arrival';
         testRma.rmaOverrideOnsitePartDispositionCode__c = 'LEAVE-PART-10: FE must leave old part at site';
         testRma.rmaOverrideOnsiteArrivalStreet1__c      = '123 Main Street';
         testRma.rmaOverrideOnsiteArrivalStreet2__c      = 'Suite 100';
         testRma.rmaOverrideOnsiteArrivalCity__c         = 'San Jose';
         testRma.rmaOverrideOnsiteArrivalState__c        = 'CA';
         testRma.rmaOverrideOnsiteArrivalPostalCode__c   = '95151';
         testRma.rmaOverrideOnsiteArrivalCountry__c      = 'United States';

         if (testRma.rmaComponent__c == 'SSD' || testRma.rmaComponent__c == 'HDD')
           {testRma.rmaOnsiteHddSsdSlot__c = '1';
           }
         else
           {testRma.rmaOnsiteHddSsdSlot__c = null;
           }

         update testRma;
        }

      void setRmaComponentSsd()
        {testRma.rmaComponent__c       = 'SSD';
         testRma.rmaNimbleOsVersion__c = 'SSD: N/A';
         testRma.rmaModel__c           = 'SSD: CS210/210-X2/220/420';
         testRma.rmaPart__c            = 'SSD: 80GB - save RMA to compute exact part';
         testRma.rmaQuantity__c        = '1';
         testRma.rmaManufacturer__c    = 'SSD: Intel';
         testRma.rmaReason__c          = 'Part damaged in shipping';
         update testRma;
        }

      void setRmaPartFailedWithinOpsTimePeriod()
        {testAsset.Ship_Date__c = Date.today().addDays(-30);
         update testAsset;

         update testRma;
        }

      void setRmaFaRequiredOperationsFa()
        {testRma.rmaFaRequired__c = 'Operations FA';
         update testRma;
        }

      void setRmaFaRequiredEngineeringFa()
        {testRma.rmaFaRequired__c = 'Engineering FA';
         update testRma;
        }


     }

   static testMethod void validateTestData()
     {TestData                              testData;
      List<Account>                         accounts;
      List<Contact>                         contacts;
      List<Asset>                           assets;
      List<Case>                            cases;
      List<Depot__c>                        depots;
      List<DepotMapNbdNd__c>                depotMapNbdNds;
      List<RMAv2__c>                        rmas;
      List<CaseEscalationTypeDefinition__c> caseEscalationTypeDefinitions;

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
                       Ship_Date__c
                FROM   Asset];

      System.assertEquals(1,                          assets.size());
      System.assertEquals('AA-987654',                assets[0].Name);
      System.assertEquals(testData.testAccount.Id,    assets[0].AccountId);
      System.assertEquals(testData.testContact.Id,    assets[0].ContactId);
      System.assertEquals('Premium',                  assets[0].SLA__c);
      System.assertEquals('123 Main Street',          assets[0].Install_Street1__c);
      System.assertEquals('Suite 100',                assets[0].Install_Street2__c);
      System.assertEquals('San Jose',                 assets[0].Install_City__c);
      System.assertEquals('CA',                       assets[0].Install_State_Province__c);
      System.assertEquals('95151',                    assets[0].Install_Zip_Code__c);
      System.assertEquals('United States',            assets[0].Install_Country__c);
      System.assertEquals(Date.today().addDays(-180), assets[0].Ship_Date__c);

      // Validate test Case
      cases = [SELECT Id,
                      AccountId,
                      AssetId,
                      ContactId,
                      Subject
               FROM   Case];

      System.assertEquals(1,                       cases.size());
      System.assertEquals(testData.testAccount.Id, cases[0].AccountId);
      System.assertEquals(testData.testAsset.Id,   cases[0].AssetId);
      System.assertEquals(testData.testContact.Id, cases[0].ContactId);
      System.assertEquals('TEST-CASE-SUBJECT',     cases[0].Subject);

      // Validate test Depot
      depots = [SELECT Id,
                       Name,
                       depotProvider__c,
                       depotStockedFor4Hour__c,
                       depotLocationDescription__c
                FROM   Depot__c];

      System.assertEquals(1,                depots.size());
      System.assertEquals('TST-001',        depots[0].Name);
      System.assertEquals('Flash',          depots[0].depotProvider__c);
      System.assertEquals('No',             depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot 001', depots[0].depotLocationDescription__c);

      // Validate test NBD/ND mapping
      depotMapNbdNds = [SELECT Id,
                               Name,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c];

      System.assertEquals(1,                        depotMapNbdNds.size());
      System.assertEquals('__United States__N/A__', depotMapNbdNds[0].Name);
      System.assertEquals('United States',          depotMapNbdNds[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                    depotMapNbdNds[0].depotMapNbdNdState__c);
      System.assertEquals(testData.testDepot.Id,    depotMapNbdNds[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(testData.testDepot.Id,    depotMapNbdNds[0].depotMapNbdNd_NdDepot__c);

      // Validate test RMA
      rmas = [SELECT Id,
                     rmaCaseNumber__c,
                     rmaType__c,
                     rmaFaRequired__c,
                     rmaLabArray__c,
                     rmaComponent__c,
                     rmaNimbleOsVersion__c,
                     rmaModel__c,
                     rmaPart__c,
                     rmaQuantity__c,
                     rmaManufacturer__c,
                     rmaReason__c,
                     rmaDetailedReason__c,
                     rmaShipmentAddressSelector__c,
                     rmaOverrideShipmentAttn__c,
                     rmaOverrideShipmentPhone__c,
                     rmaOverrideShipmentEmail__c,
                     rmaUplift__c,
                     rmaTransmitRmaShisWithOrder__c,
                     rmaOutgoingShipmentStatus__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaOnsiteTechStatus__c,
                     rmaAssetNrdIsInEffect__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                               rmas.size());
      System.assertEquals(testData.testCase.Id,                            rmas[0].rmaCaseNumber__c);
      System.assertEquals('Advance replacement',                           rmas[0].rmaType__c);
      System.assertEquals('No FA Required',                                rmas[0].rmaFaRequired__c);
      System.assertEquals('No',                                            rmas[0].rmaLabArray__c);
      System.assertEquals('HDD',                                           rmas[0].rmaComponent__c);
      System.assertEquals('HDD: N/A',                                      rmas[0].rmaNimbleOsVersion__c);
      System.assertEquals('HDD: CS210/220/420',                            rmas[0].rmaModel__c);
      System.assertEquals('1TB SAS HDD [SR-HDD-1TB-SAS]',                  rmas[0].rmaPart__c);
      System.assertEquals('1',                                             rmas[0].rmaQuantity__c);
      System.assertEquals('HDD: Seagate',                                  rmas[0].rmaManufacturer__c);
      System.assertEquals('HDD: Starting to fail (proactive replacement)', rmas[0].rmaReason__c);
      System.assertEquals('Detailed reason text',                          rmas[0].rmaDetailedReason__c);
      System.assertEquals('Asset install address',                         rmas[0].rmaShipmentAddressSelector__c);
      System.assertEquals('John Doe',                                      rmas[0].rmaOverrideShipmentAttn__c);
      System.assertEquals('408-555-1234',                                  rmas[0].rmaOverrideShipmentPhone__c);
      System.assertEquals('john.doe@nimblestorage.com',                    rmas[0].rmaOverrideShipmentEmail__c);
      System.assertEquals('No: Do not uplift',                             rmas[0].rmaUplift__c);
      System.assertEquals('No SHI',                                        rmas[0].rmaTransmitRmaShisWithOrder__c);
      System.assertEquals('DRAFT-10: Waiting to order',                    rmas[0].rmaOutgoingShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',                    rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',                    rmas[0].rmaRetShip2Status__c);
      System.assertEquals('DRAFT-10: Waiting to order',                    rmas[0].rmaOnsiteTechStatus__c);
      System.assertEquals('No',                                            rmas[0].rmaAssetNrdIsInEffect__c);

      // Validate test Case Escalation Type Definition
      caseEscalationTypeDefinitions = [SELECT Id,
                                              Name,
                                              caseEscalationTypeDefinitionGroup__c,
                                              caseEscalationTypeDefinitionUser__c
                                       FROM   CaseEscalationTypeDefinition__c];

      System.assertEquals(1,                        caseEscalationTypeDefinitions.size());
      System.assertEquals('Engineering Escalation', caseEscalationTypeDefinitions[0].Name);
      System.assertEquals('Engineering Escalation', caseEscalationTypeDefinitions[0].caseEscalationTypeDefinitionGroup__c);
      System.assertEquals(null,                     caseEscalationTypeDefinitions[0].caseEscalationTypeDefinitionUser__c);
     }

   static testMethod void testRmaTypeSystemPartReturn()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaTypeSystemPartReturn();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                            rmas.size());
      System.assertEquals('System/part return',         rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',             rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order', rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order', rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                        rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaAssetNrdIsInEffectNonOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaAssetNrdIsInEffect();

      rmas = [SELECT Id,
                     rmaAssetNrdIsInEffect__c,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                           rmas.size());
      System.assertEquals('Yes',                                       rmas[0].rmaAssetNrdIsInEffect__c);
      System.assertEquals('Ship Only',                                 rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',                            rmas[0].rmaFaRequired__c);
      System.assertEquals('N/A-10: No part to ship for this RMA Type', rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('N/A-10: No part to ship for this RMA Type', rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                       rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaAssetNrdIsInEffectOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaAssetNrdIsInEffect();
      testData.setRmaAssetSlaOnsite();

      rmas = [SELECT Id,
                     rmaAssetNrdIsInEffect__c,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                           rmas.size());
      System.assertEquals('Yes',                                       rmas[0].rmaAssetNrdIsInEffect__c);
      System.assertEquals('Ship Only w/ Tech',                         rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',                            rmas[0].rmaFaRequired__c);
      System.assertEquals('N/A-10: No part to ship for this RMA Type', rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('N/A-10: No part to ship for this RMA Type', rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                       rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaPartIsAShipOnlyPartNonOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaPartIsAShipOnlyPart();

      rmas = [SELECT Id,
                     rmaPartIsAShipOnlyPart__c,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                           rmas.size());
      System.assertEquals('Yes',                                       rmas[0].rmaPartIsAShipOnlyPart__c);
      System.assertEquals('Ship Only',                                 rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',                            rmas[0].rmaFaRequired__c);
      System.assertEquals('N/A-10: No part to ship for this RMA Type', rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('N/A-10: No part to ship for this RMA Type', rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                       rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaPartIsAShipOnlyPartOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaPartIsAShipOnlyPart();
      testData.setRmaAssetSlaOnsite();

      rmas = [SELECT Id,
                     rmaPartIsAShipOnlyPart__c,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                           rmas.size());
      System.assertEquals('Yes',                                       rmas[0].rmaPartIsAShipOnlyPart__c);
      System.assertEquals('Ship Only w/ Tech',                         rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',                            rmas[0].rmaFaRequired__c);
      System.assertEquals('N/A-10: No part to ship for this RMA Type', rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('N/A-10: No part to ship for this RMA Type', rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                       rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaCaseIsEngOrExecEscalatedNonOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaCaseIsEngOrExecEscalated();

      rmas = [SELECT Id,
                     rmaCaseIsEngOrExecEscalated__c,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                         rmas.size());
      System.assertEquals(true,                                      rmas[0].rmaCaseIsEngOrExecEscalated__c);
      System.assertEquals('Advance Replacement w/ Defective Return', rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',                          rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                     rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaCaseIsEngOrExecEscalatedOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaCaseIsEngOrExecEscalated();
      testData.setRmaAssetSlaOnsite();

      rmas = [SELECT Id,
                     rmaCaseIsEngOrExecEscalated__c,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                         rmas.size());
      System.assertEquals(true,                                      rmas[0].rmaCaseIsEngOrExecEscalated__c);
      System.assertEquals('Advance Replacement w/ Def Rtrn w/ Tech', rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',                          rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                     rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaComponentSsdNonOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaComponentSsd();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                         rmas.size());
      System.assertEquals('Advance Replacement w/ Failure Analysis', rmas[0].rmaOrderType__c);
      System.assertEquals('Engineering FA',                          rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                     rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaComponentSsdOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaComponentSsd();
      testData.setRmaAssetSlaOnsite();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                   rmas.size());
      System.assertEquals('Advance Replacement w/ FA w/ Tech', rmas[0].rmaOrderType__c);
      System.assertEquals('Engineering FA',                    rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',        rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',        rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                               rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaPartFailedWithinOpsTimePeriodNonOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaPartFailedWithinOpsTimePeriod();

      rmas = [SELECT Id,
                     rmaPartFailedWithinOpsTimePeriod__c,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                         rmas.size());
      System.assertEquals('Yes',                                     rmas[0].rmaPartFailedWithinOpsTimePeriod__c);
      System.assertEquals('Advance Replacement w/ Failure Analysis', rmas[0].rmaOrderType__c);
      System.assertEquals('Operations FA',                           rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                     rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaPartFailedWithinOpsTimePeriodOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaPartFailedWithinOpsTimePeriod();
      testData.setRmaAssetSlaOnsite();

      rmas = [SELECT Id,
                     rmaPartFailedWithinOpsTimePeriod__c,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                    rmas.size());
      System.assertEquals('Yes',                                rmas[0].rmaPartFailedWithinOpsTimePeriod__c);
      System.assertEquals('Advance Replacement w/ FA w/ Tech',  rmas[0].rmaOrderType__c);
      System.assertEquals('Operations FA',                      rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',         rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',         rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaFaRequiredOperationsFaNonOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaFaRequiredOperationsFa();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                         rmas.size());
      System.assertEquals('Advance Replacement w/ Failure Analysis', rmas[0].rmaOrderType__c);
      System.assertEquals('Operations FA',                           rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                     rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaFaRequiredOperationsFaOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaFaRequiredOperationsFa();
      testData.setRmaAssetSlaOnsite();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                   rmas.size());
      System.assertEquals('Advance Replacement w/ FA w/ Tech', rmas[0].rmaOrderType__c);
      System.assertEquals('Operations FA',                     rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',        rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',        rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                               rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaFaRequiredEngineeringFaNonOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaFaRequiredEngineeringFa();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                         rmas.size());
      System.assertEquals('Advance Replacement w/ Failure Analysis', rmas[0].rmaOrderType__c);
      System.assertEquals('Engineering FA',                          rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                     rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaFaRequiredEngineeringFaOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaFaRequiredEngineeringFa();
      testData.setRmaAssetSlaOnsite();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                   rmas.size());
      System.assertEquals('Advance Replacement w/ FA w/ Tech', rmas[0].rmaOrderType__c);
      System.assertEquals('Engineering FA',                    rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',        rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',        rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                               rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaNoFaRequiredNonOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                         rmas.size());
      System.assertEquals('Advance Replacement w/ Defective Return', rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',                          rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                     rmas[0].rmaCustomerFaRequired__c);
     }

   static testMethod void testRmaNoFaRequiredOnsite()
     {TestData       testData;
      List<RMAv2__c> rmas;

      testData = new TestData();
      testData.setRmaAssetSlaOnsite();

      rmas = [SELECT Id,
                     rmaOrderType__c,
                     rmaFaRequired__c,
                     rmaReturnShipmentStatus__c,
                     rmaRetShip2Status__c,
                     rmaCustomerFaRequired__c
              FROM   RMAv2__c];

      System.assertEquals(1,                                         rmas.size());
      System.assertEquals('Advance Replacement w/ Def Rtrn w/ Tech', rmas[0].rmaOrderType__c);
      System.assertEquals('No FA Required',                          rmas[0].rmaFaRequired__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaReturnShipmentStatus__c);
      System.assertEquals('DRAFT-10: Waiting to order',              rmas[0].rmaRetShip2Status__c);
      System.assertEquals(false,                                     rmas[0].rmaCustomerFaRequired__c);
     }
  }