@isTest
private class depotSearchTest
  {// ==================================================================================== createTestData
   static testMethod void createTestData()
     {ID den001Id;
      ID den002Id;
      ID den003Id;
      ID den004Id;
      ID den005Id;
      ID den006Id;
      List<depot__c> depots;
      depot__c depot;
      List<depotMapNbdNd__c> depotMapsNbdNd;
      depotMapNbdNd__c depotMapNbdNd;
      List<depotMap4Hour__c> depotMaps4Hour;
      depotMap4Hour__c depotMap4Hour;

      // Create test depots (if needed)
      depot = new depot__c(Name                        = 'DEN-001',
                           depotProvider__c            = 'Nimble',
                           depotStockedFor4Hour__c     = 'Yes',
                           depotLocationDescription__c = 'Test depot DEN-001');
         insert depot;
         depots = [SELECT Id,
                          Name,
                          depotProvider__c,
                          depotStockedFor4Hour__c,
                          depotLocationDescription__c
                   FROM   depot__c
                   WHERE  Name = 'DEN-001'];

      System.assertEquals(1,                    depots.size());
      System.assertEquals('DEN-001',            depots[0].Name);
      System.assertEquals('Nimble',             depots[0].depotProvider__c);
      System.assertEquals('Yes',                depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot DEN-001', depots[0].depotLocationDescription__c);
      den001Id = depots[0].id;

      depot = new depot__c(Name                        = 'DEN-002',
                           depotProvider__c            = 'Flash',
                           depotStockedFor4Hour__c     = 'Yes',
                           depotLocationDescription__c = 'Test depot DEN-002');
         insert depot;
         depots = [SELECT Id,
                          Name,
                          depotProvider__c,
                          depotStockedFor4Hour__c,
                          depotLocationDescription__c
                   FROM   depot__c
                   WHERE  Name = 'DEN-002'];

      System.assertEquals(1,                    depots.size());
      System.assertEquals('DEN-002',            depots[0].Name);
      System.assertEquals('Flash',              depots[0].depotProvider__c);
      System.assertEquals('Yes',                depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot DEN-002', depots[0].depotLocationDescription__c);
      den002Id = depots[0].id;

      depot = new depot__c(Name                        = 'DEN-003',
                           depotProvider__c            = 'Nimble',
                           depotStockedFor4Hour__c     = 'No',
                           depotLocationDescription__c = 'Test depot DEN-003');
         insert depot;
         depots = [SELECT Id,
                          Name,
                          depotProvider__c,
                          depotStockedFor4Hour__c,
                          depotLocationDescription__c
                   FROM   depot__c
                   WHERE  Name = 'DEN-003'];

      System.assertEquals(1,                    depots.size());
      System.assertEquals('DEN-003',            depots[0].Name);
      System.assertEquals('Nimble',             depots[0].depotProvider__c);
      System.assertEquals('No',                 depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot DEN-003', depots[0].depotLocationDescription__c);
      den003Id = depots[0].id;

      depot = new depot__c(Name                        = 'DEN-004',
                           depotProvider__c            = 'Flash',
                           depotStockedFor4Hour__c     = 'No',
                           depotLocationDescription__c = 'Test depot DEN-004');
         insert depot;
         depots = [SELECT Id,
                          Name,
                          depotProvider__c,
                          depotStockedFor4Hour__c,
                          depotLocationDescription__c
                   FROM   depot__c
                   WHERE  Name = 'DEN-004'];

      System.assertEquals(1,                    depots.size());
      System.assertEquals('DEN-004',            depots[0].Name);
      System.assertEquals('Flash',              depots[0].depotProvider__c);
      System.assertEquals('No',                 depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot DEN-004', depots[0].depotLocationDescription__c);
      den004Id = depots[0].id;

      depot = new depot__c(Name                        = 'DEN-005',
                           depotProvider__c            = 'Nimble',
                           depotStockedFor4Hour__c     = 'Yes',
                           depotLocationDescription__c = 'Test depot DEN-005');
         insert depot;
         depots = [SELECT Id,
                          Name,
                          depotProvider__c,
                          depotStockedFor4Hour__c,
                          depotLocationDescription__c
                   FROM   depot__c
                   WHERE  Name = 'DEN-005'];

      System.assertEquals(1,                    depots.size());
      System.assertEquals('DEN-005',            depots[0].Name);
      System.assertEquals('Nimble',             depots[0].depotProvider__c);
      System.assertEquals('Yes',                depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot DEN-005', depots[0].depotLocationDescription__c);
      den005Id = depots[0].id;

      depot = new depot__c(Name                        = 'DEN-006',
                           depotProvider__c            = 'Flash',
                           depotStockedFor4Hour__c     = 'No',
                           depotLocationDescription__c = 'Test depot DEN-006');
         insert depot;
         depots = [SELECT Id,
                          Name,
                          depotProvider__c,
                          depotStockedFor4Hour__c,
                          depotLocationDescription__c
                   FROM   depot__c
                   WHERE  Name = 'DEN-006'];

      System.assertEquals(1,                    depots.size());
      System.assertEquals('DEN-006',            depots[0].Name);
      System.assertEquals('Flash',              depots[0].depotProvider__c);
      System.assertEquals('No',                 depots[0].depotStockedFor4Hour__c);
      System.assertEquals('Test depot DEN-006', depots[0].depotLocationDescription__c);
      den006Id = depots[0].id;

      // Create test NBD/ND depot maps
      depotMapNbdNd = new depotMapNbdNd__c(depotMapNbdNdCountry__c   = 'United States',
                                           depotMapNbdNdState__c     = 'N/A',
                                           depotMapNbdNd_NbdDepot__c = den005Id,
                                           depotMapNbdNd_NdDepot__c  = den006Id);
      insert depotMapNbdNd;
      depotMapsNbdNd = [SELECT Id,
                               Name,
                               depotMapNbdNdKey__c,
                               depotMapNbdNdCountry__c,
                               depotMapNbdNdState__c,
                               depotMapNbdNd_NbdDepot__c,
                               depotMapNbdNd_NdDepot__c
                        FROM   depotMapNbdNd__c
                        WHERE  depotMapNbdNdCountry__c = 'United States' and
                               depotMapNbdNdState__c = 'N/A'];
      System.assertEquals(1,                        depotMapsNbdNd.size());
      System.assertEquals('__United States__N/A__', depotMapsNbdNd[0].Name);
      System.assertEquals('__United States__N/A__', depotMapsNbdNd[0].depotMapNbdNdKey__c);
      System.assertEquals('United States',          depotMapsNbdNd[0].depotMapNbdNdCountry__c);
      System.assertEquals('N/A',                    depotMapsNbdNd[0].depotMapNbdNdState__c);
      System.assertEquals(den005Id,                 depotMapsNbdNd[0].depotMapNbdNd_NbdDepot__c);
      System.assertEquals(den006Id,                 depotMapsNbdNd[0].depotMapNbdNd_NdDepot__c);

      // Create test 4-hour depot maps
      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United States',
                                           depotMap4HourPostalCode__c  = '80814',
                                           depotMap4Hour_4HourDepot__c = den001Id);
      insert depotMap4Hour;
      depotMaps4Hour = [SELECT Id,
                               Name,
                               depotMap4HourKey__c,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United States' and
                               depotMap4HourPostalCode__c  = '80814' and
                               depotMap4Hour_4HourDepot__c = :den001Id];
      System.assertEquals(1, depotMaps4Hour.size());
      System.assertEquals('__United States__80814__DEN-001__', depotMaps4Hour[0].Name);
      System.assertEquals('__United States__80814__DEN-001__', depotMaps4Hour[0].depotMap4HourKey__c);
      System.assertEquals('United States',                     depotMaps4Hour[0].depotMap4HourCountry__c);
      System.assertEquals('80814',                             depotMaps4Hour[0].depotMap4HourPostalCode__c);
      System.assertEquals(den001Id,                            depotMaps4Hour[0].depotMap4Hour_4HourDepot__c);

      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United States',
                                           depotMap4HourPostalCode__c  = '80814',
                                           depotMap4Hour_4HourDepot__c = den002Id);
      insert depotMap4Hour;
      depotMaps4Hour = [SELECT Id,
                               Name,
                               depotMap4HourKey__c,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United States' and
                               depotMap4HourPostalCode__c  = '80814' and
                               depotMap4Hour_4HourDepot__c = :den002Id];
      System.assertEquals(1, depotMaps4Hour.size());
      System.assertEquals('__United States__80814__DEN-002__', depotMaps4Hour[0].Name);
      System.assertEquals('__United States__80814__DEN-002__', depotMaps4Hour[0].depotMap4HourKey__c);
      System.assertEquals('United States',                     depotMaps4Hour[0].depotMap4HourCountry__c);
      System.assertEquals('80814',                             depotMaps4Hour[0].depotMap4HourPostalCode__c);
      System.assertEquals(den002Id,                            depotMaps4Hour[0].depotMap4Hour_4HourDepot__c);

      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United States',
                                           depotMap4HourPostalCode__c  = '80814',
                                           depotMap4Hour_4HourDepot__c = den003Id);
      insert depotMap4Hour;
      depotMaps4Hour = [SELECT Id,
                               Name,
                               depotMap4HourKey__c,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United States' and
                               depotMap4HourPostalCode__c  = '80814' and
                               depotMap4Hour_4HourDepot__c = :den003Id];
      System.assertEquals(1, depotMaps4Hour.size());
      System.assertEquals('__United States__80814__DEN-003__', depotMaps4Hour[0].Name);
      System.assertEquals('__United States__80814__DEN-003__', depotMaps4Hour[0].depotMap4HourKey__c);
      System.assertEquals('United States',                     depotMaps4Hour[0].depotMap4HourCountry__c);
      System.assertEquals('80814',                             depotMaps4Hour[0].depotMap4HourPostalCode__c);
      System.assertEquals(den003Id,                            depotMaps4Hour[0].depotMap4Hour_4HourDepot__c);

      depotMap4Hour = new depotMap4Hour__c(depotMap4HourCountry__c     = 'United States',
                                           depotMap4HourPostalCode__c  = '80814',
                                           depotMap4Hour_4HourDepot__c = den004Id);
      insert depotMap4Hour;
      depotMaps4Hour = [SELECT Id,
                               Name,
                               depotMap4HourKey__c,
                               depotMap4HourCountry__c,
                               depotMap4HourPostalCode__c,
                               depotMap4Hour_4HourDepot__c
                        FROM   depotMap4Hour__c
                        WHERE  depotMap4HourCountry__c     = 'United States' and
                               depotMap4HourPostalCode__c  = '80814' and
                               depotMap4Hour_4HourDepot__c = :den004Id];
      System.assertEquals(1, depotMaps4Hour.size());
      System.assertEquals('__United States__80814__DEN-004__', depotMaps4Hour[0].Name);
      System.assertEquals('__United States__80814__DEN-004__', depotMaps4Hour[0].depotMap4HourKey__c);
      System.assertEquals('United States',                     depotMaps4Hour[0].depotMap4HourCountry__c);
      System.assertEquals('80814',                             depotMaps4Hour[0].depotMap4HourPostalCode__c);
      System.assertEquals(den004Id,                            depotMaps4Hour[0].depotMap4Hour_4HourDepot__c);
     }

   // ==================================================================================== testGetCountryValues
   static testMethod void testGetCountryValues()
     {depotSearch depotSearchController = new depotSearch();
      List<SelectOption> selectOptions;

      selectOptions = depotSearchController.getCountryValues();

      System.assertEquals('Australia',            selectOptions[0].getLabel());
      System.assertEquals('Australia',            selectOptions[0].getValue());
      System.assertEquals('Austria',              selectOptions[1].getLabel());
      System.assertEquals('Austria',              selectOptions[1].getValue());
      System.assertEquals('Belgium',              selectOptions[2].getLabel());
      System.assertEquals('Belgium',              selectOptions[2].getValue());
      System.assertEquals('Bermuda',              selectOptions[3].getLabel());
      System.assertEquals('Bermuda',              selectOptions[3].getValue());
      System.assertEquals('Canada',               selectOptions[4].getLabel());
      System.assertEquals('Canada',               selectOptions[4].getValue());
      System.assertEquals('China',                selectOptions[5].getLabel());
      System.assertEquals('China',                selectOptions[5].getValue());
      System.assertEquals('Denmark',              selectOptions[6].getLabel());
      System.assertEquals('Denmark',              selectOptions[6].getValue());
      System.assertEquals('Finland',              selectOptions[7].getLabel());
      System.assertEquals('Finland',              selectOptions[7].getValue());
      System.assertEquals('France',               selectOptions[8].getLabel());
      System.assertEquals('France',               selectOptions[8].getValue());
      System.assertEquals('Germany',              selectOptions[9].getLabel());
      System.assertEquals('Germany',              selectOptions[9].getValue());
      System.assertEquals('Hong Kong',            selectOptions[10].getLabel());
      System.assertEquals('Hong Kong',            selectOptions[10].getValue());
      System.assertEquals('India',                selectOptions[11].getLabel());
      System.assertEquals('India',                selectOptions[11].getValue());
      System.assertEquals('Indonesia',            selectOptions[12].getLabel());
      System.assertEquals('Indonesia',            selectOptions[12].getValue());
      System.assertEquals('Ireland',              selectOptions[13].getLabel());
      System.assertEquals('Ireland',              selectOptions[13].getValue());
      System.assertEquals('Japan',                selectOptions[14].getLabel());
      System.assertEquals('Japan',                selectOptions[14].getValue());
      System.assertEquals('Luxembourg',            selectOptions[15].getValue());
      System.assertEquals('Luxembourg',            selectOptions[15].getValue());
      System.assertEquals('Malaysia',             selectOptions[16].getLabel());
      System.assertEquals('Malaysia',             selectOptions[16].getValue());
      System.assertEquals('Netherlands',          selectOptions[17].getLabel());
      System.assertEquals('Netherlands',          selectOptions[17].getValue());
      System.assertEquals('New Zealand',          selectOptions[18].getLabel());
      System.assertEquals('New Zealand',          selectOptions[18].getValue());
      System.assertEquals('Norway',               selectOptions[19].getLabel());
      System.assertEquals('Norway',               selectOptions[19].getValue());
      System.assertEquals('Philippines',          selectOptions[20].getLabel());
      System.assertEquals('Philippines',          selectOptions[20].getValue());
      System.assertEquals('Singapore',            selectOptions[21].getLabel());
      System.assertEquals('Singapore',            selectOptions[21].getValue());
      System.assertEquals('South Africa',         selectOptions[22].getLabel());
      System.assertEquals('South Africa',         selectOptions[22].getValue());
      System.assertEquals('South Korea',          selectOptions[23].getLabel());
      System.assertEquals('South Korea',          selectOptions[23].getValue());
      System.assertEquals('Spain',                selectOptions[24].getLabel());
      System.assertEquals('Spain',                selectOptions[24].getValue());
      System.assertEquals('Sweden',               selectOptions[25].getLabel());
      System.assertEquals('Sweden',               selectOptions[25].getValue());
      System.assertEquals('Switzerland',          selectOptions[26].getLabel());
      System.assertEquals('Switzerland',          selectOptions[26].getValue());
      System.assertEquals('Taiwan',               selectOptions[27].getLabel());
      System.assertEquals('Taiwan',               selectOptions[27].getValue());
      System.assertEquals('United Arab Emirates', selectOptions[28].getLabel());
      System.assertEquals('United Arab Emirates', selectOptions[28].getValue());
      System.assertEquals('United Kingdom',       selectOptions[29].getLabel());
      System.assertEquals('United Kingdom',       selectOptions[29].getValue());
      System.assertEquals('United States',        selectOptions[30].getLabel());
      System.assertEquals('United States',        selectOptions[30].getValue());
     }

   // ==================================================================================== testAustraliaGood
   static testMethod void testAustraliaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Australia';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('Australia', depotSearchController.country);
      System.assertEquals('1234',      depotSearchController.postalCode);
      System.assertEquals(null,        depotSearchController.errorPostalCode);
      System.assertEquals(0,           depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,           depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testAustraliaBad
   static testMethod void testAustraliaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Australia';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('Australia', depotSearchController.country);
      System.assertEquals('ABCD',      depotSearchController.postalCode);
      System.assertEquals('ERROR: Australian postal codes must be in "9999" (four digits) format.  Be sure to include any leading zeroes.', depotSearchController.errorPostalCode);
      System.assertEquals(null,        depotSearchController.searchResults4Hour);
      System.assertEquals(null,        depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testAustriaGood
   static testMethod void testAustriaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Austria';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('Austria', depotSearchController.country);
      System.assertEquals('1234',    depotSearchController.postalCode);
      System.assertEquals(null,      depotSearchController.errorPostalCode);
      System.assertEquals(0,         depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,         depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testAustriaBad
   static testMethod void testAustriaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Austria';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('Austria', depotSearchController.country);
      System.assertEquals('ABCD',    depotSearchController.postalCode);
      System.assertEquals('ERROR: Austrian postal codes must be in "9999" (four digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,        depotSearchController.searchResults4Hour);
      System.assertEquals(null,        depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testBelgiumGood
   static testMethod void testBelgiumGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Belgium';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('Belgium', depotSearchController.country);
      System.assertEquals('1234',    depotSearchController.postalCode);
      System.assertEquals(null,      depotSearchController.errorPostalCode);
      System.assertEquals(0,         depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,         depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testBelgiumBad
   static testMethod void testBelgiumBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Belgium';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('Belgium', depotSearchController.country);
      System.assertEquals('ABCD',    depotSearchController.postalCode);
      System.assertEquals('ERROR: Belgian postal codes must be in "9999" (four digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,        depotSearchController.searchResults4Hour);
      System.assertEquals(null,        depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testBermudaGood
   static testMethod void testBermudaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Bermuda';
      depotSearchController.postalCode = '   aa 12   ';

      depotSearchController.doSearch();

      System.assertEquals('Bermuda', depotSearchController.country);
      System.assertEquals('AA 99',   depotSearchController.postalCode);
      System.assertEquals(null,      depotSearchController.errorPostalCode);
      System.assertEquals(0,         depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,         depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testBermudaBad
   //   This is commented out because the depotSearch controller will always force
   //   Bermuda's postal code to be the dummy value AA 99.  It's not
   //   possible to test a bad value.
   //static testMethod void testBermudaBad()
   //  {depotSearch depotSearchController = new depotSearch();

   //   depotSearchController.country    = 'Bermuda';
   //   depotSearchController.postalCode = '   aa 12z   ';

   //   depotSearchController.doSearch();

   //   System.assertEquals('Bermuda', depotSearchController.country);
   //   System.assertEquals('AA 12Z',  depotSearchController.postalCode);
   //   System.assertEquals('ERROR: Bermuda postal codes must be in "AA 99" (two alpha, space, two digits) format.', depotSearchController.errorPostalCode);
   //   System.assertEquals(null,        depotSearchController.searchResults4Hour);
   //   System.assertEquals(null,        depotSearchController.searchResultsNbdNd);
   //  }

   // ==================================================================================== testCanadaGood
   static testMethod void testCanadaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Canada';
      depotSearchController.postalCode = '   a9a b9b   ';

      depotSearchController.doSearch();

      System.assertEquals('Canada', depotSearchController.country);
      System.assertEquals('A9A',    depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testCanadaBad      
   static testMethod void testCanadaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Canada';
      depotSearchController.postalCode = '   9a9 9a9   ';

      depotSearchController.doSearch();

      System.assertEquals('Canada',  depotSearchController.country);
      System.assertEquals('9A9 9A9', depotSearchController.postalCode);
      System.assertEquals('ERROR: Canadian postal codes must start with "A9A" (alpha digit alpha) format.  You do not have to include the second "A9A".', depotSearchController.errorPostalCode);
      System.assertEquals(null,      depotSearchController.searchResults4Hour);
      System.assertEquals(null,     depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testChinaGood
   static testMethod void testChinaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'China';
      depotSearchController.postalCode = '   123456   ';

      depotSearchController.doSearch();

      System.assertEquals('China',  depotSearchController.country);
      System.assertEquals('123456', depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testChinaBad
   static testMethod void testChinaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'China';
      depotSearchController.postalCode = '   abcdef   ';

      depotSearchController.doSearch();

      System.assertEquals('China',  depotSearchController.country);
      System.assertEquals('ABCDEF', depotSearchController.postalCode);
      System.assertEquals('ERROR: Chinese postal codes must be in "999999" (six digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,     depotSearchController.searchResults4Hour);
      System.assertEquals(null,     depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testDenmarkGood
   static testMethod void testDenmarkGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Denmark';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('Denmark', depotSearchController.country);
      System.assertEquals('1234',    depotSearchController.postalCode);
      System.assertEquals(null,      depotSearchController.errorPostalCode);
      System.assertEquals(0,         depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,         depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testDenmarkBad
   static testMethod void testDenmarkBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Denmark';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('Denmark', depotSearchController.country);
      System.assertEquals('ABCD',    depotSearchController.postalCode);
      System.assertEquals('ERROR: Denmark postal codes must be in "9999" (four digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,      depotSearchController.searchResults4Hour);
      System.assertEquals(null,      depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testFinlandGood
   static testMethod void testFinlandGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Finland';
      depotSearchController.postalCode = '   12345   ';

      depotSearchController.doSearch();

      System.assertEquals('Finland', depotSearchController.country);
      System.assertEquals('12345',   depotSearchController.postalCode);
      System.assertEquals(null,      depotSearchController.errorPostalCode);
      System.assertEquals(0,         depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,         depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testFinlandBad
   static testMethod void testFinlandBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Finland';
      depotSearchController.postalCode = '   abcde   ';

      depotSearchController.doSearch();

      System.assertEquals('Finland', depotSearchController.country);
      System.assertEquals('ABCDE',   depotSearchController.postalCode);
      System.assertEquals('ERROR: Finland postal codes must be in "99999" (five digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,      depotSearchController.searchResults4Hour);
      System.assertEquals(null,      depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testFranceGood
   static testMethod void testFranceGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'France';
      depotSearchController.postalCode = '   12345   ';

      depotSearchController.doSearch();

      System.assertEquals('France', depotSearchController.country);
      System.assertEquals('12345',  depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testFranceBad
   static testMethod void testFranceBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'France';
      depotSearchController.postalCode = '   abcde   ';

      depotSearchController.doSearch();

      System.assertEquals('France', depotSearchController.country);
      System.assertEquals('ABCDE',  depotSearchController.postalCode);
      System.assertEquals('ERROR: French postal codes must be in "99999" (five digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,     depotSearchController.searchResults4Hour);
      System.assertEquals(null,     depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testGermanyGood
   static testMethod void testGermanyGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Germany';
      depotSearchController.postalCode = '   12345   ';

      depotSearchController.doSearch();

      System.assertEquals('Germany', depotSearchController.country);
      System.assertEquals('12345',   depotSearchController.postalCode);
      System.assertEquals(null,      depotSearchController.errorPostalCode);
      System.assertEquals(0,         depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,         depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testGermanyBad
   static testMethod void testGermanyBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Germany';
      depotSearchController.postalCode = '   abcde   ';

      depotSearchController.doSearch();

      System.assertEquals('Germany', depotSearchController.country);
      System.assertEquals('ABCDE',   depotSearchController.postalCode);
      System.assertEquals('ERROR: German postal codes must be in "99999" (five digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,      depotSearchController.searchResults4Hour);
      System.assertEquals(null,      depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testHongKongGood
   static testMethod void testHongKongGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Hong Kong';
      depotSearchController.postalCode = '   999077   ';

      depotSearchController.doSearch();

      System.assertEquals('Hong Kong', depotSearchController.country);
      System.assertEquals('999077',    depotSearchController.postalCode);
      System.assertEquals(null,       depotSearchController.errorPostalCode);
      System.assertEquals(0,          depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,          depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testHongKongBad
   //   This is commented out because the depotSearch controller will always force
   //   Hong Kong's postal code to be the dummy value 999077.  It's not
   //   possible to test a bad value.
   //
   //static testMethod void testHongKongBad()
   //  {depotSearch depotSearchController = new depotSearch();
   //
   //   depotSearchController.country    = 'Hong Kong';
   //   depotSearchController.postalCode = '   999077z   ';
   //
   //   depotSearchController.doSearch();
   //
   //   System.assertEquals('Hong Kong', depotSearchController.country);
   //   System.assertEquals('999077Z',   depotSearchController.postalCode);
   //   System.assertEquals('ERROR: Hong Kong postal code must be "999077".', depotSearchController.errorPostalCode);
   //   System.assertEquals(null,        depotSearchController.searchResults4Hour);
   //   System.assertEquals(null,        depotSearchController.searchResultsNbdNd);
   //  }

   // ==================================================================================== testIndiaGood
   static testMethod void testIndiaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'India';
      depotSearchController.postalCode = '   123456   ';

      depotSearchController.doSearch();

      System.assertEquals('India',  depotSearchController.country);
      System.assertEquals('123456', depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testIndiaBad
   static testMethod void testIndiaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'India';
      depotSearchController.postalCode = '   abcdef   ';

      depotSearchController.doSearch();

      System.assertEquals('India',  depotSearchController.country);
      System.assertEquals('ABCDEF', depotSearchController.postalCode);
      System.assertEquals('ERROR: Indian postal codes must be in "999999" (six digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,     depotSearchController.searchResults4Hour);
      System.assertEquals(null,     depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testIndonesiaGood
   static testMethod void testIndonesiaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Indonesia';
      depotSearchController.postalCode = '   12345   ';

      depotSearchController.doSearch();

      System.assertEquals('Indonesia', depotSearchController.country);
      System.assertEquals('12345',     depotSearchController.postalCode);
      System.assertEquals(null,        depotSearchController.errorPostalCode);
      System.assertEquals(0,           depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,           depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testIndonesiaBad
   static testMethod void testIndonesiaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Indonesia';
      depotSearchController.postalCode = '   abcde   ';

      depotSearchController.doSearch();

      System.assertEquals('Indonesia', depotSearchController.country);
      System.assertEquals('ABCDE',     depotSearchController.postalCode);
      System.assertEquals('ERROR: Indonesian postal codes must be in "99999" (five digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,        depotSearchController.searchResults4Hour);
      System.assertEquals(null,        depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testIrelandGood
   static testMethod void testIrelandGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Ireland';
      depotSearchController.postalCode = '   A11   ';

      depotSearchController.doSearch();

      System.assertEquals('Ireland', depotSearchController.country);
      System.assertEquals('A99',     depotSearchController.postalCode);
      System.assertEquals(null,      depotSearchController.errorPostalCode);
      System.assertEquals(0,         depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,         depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testIrelandBad
   //   This is commented out because the depotSearch controller will always force
   //   Ireland's postal code to a known good value for now (A99).  It's not
   //   possible to test a bad value.
   //
   //static testMethod void testIrelandBad()
   //  {depotSearch depotSearchController = new depotSearch();
   //
   //   depotSearchController.country    = 'Ireland';
   //   depotSearchController.postalCode = '   a9a   ';
   //
   //   depotSearchController.doSearch();
   //
   //   System.assertEquals('Ireland', depotSearchController.country);
   //   System.assertEquals('A9A',     depotSearchController.postalCode);
   //   System.assertEquals('ERROR: Irish postal codes must start with "A99" (alpha digit digit) format.  You do not have to include the other characters afterwards.', depotSearchController.errorPostalCode);
   //   System.assertEquals(null,      depotSearchController.searchResults4Hour);
   //   System.assertEquals(null,      depotSearchController.searchResultsNbdNd);
   //  }

   // ==================================================================================== testJapanGood
   static testMethod void testJapanGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Japan';
      depotSearchController.postalCode = '   555-9911   ';

      depotSearchController.doSearch();

      System.assertEquals('Japan',  depotSearchController.country);
      System.assertEquals('555-99', depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testJapanBad
   static testMethod void testJapanBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Japan';
      depotSearchController.postalCode = '   55-59911   ';

      depotSearchController.doSearch();

      System.assertEquals('Japan',    depotSearchController.country);
      System.assertEquals('55-59911', depotSearchController.postalCode);
      System.assertEquals('ERROR: Japanese postal codes must be in "999-9999" format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,       depotSearchController.searchResults4Hour);
      System.assertEquals(null,       depotSearchController.searchResultsNbdNd);
     }
         // ==================================================================================== testJapanGood
   static testMethod void testLuxembourgGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Luxembourg';
      depotSearchController.postalCode = 'L-1050';

      depotSearchController.doSearch();

      System.assertEquals('Luxembourg',  depotSearchController.country);
      System.assertEquals('L-1050', depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testLuxembourgBad
   static testMethod void testLuxembourgBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Luxembourg';
      depotSearchController.postalCode = 'L-59911';

      depotSearchController.doSearch();

      System.assertEquals('Luxembourg',    depotSearchController.country);
      System.assertEquals('L-59911', depotSearchController.postalCode);
      System.assertEquals('ERROR: Luxembourg postal codes must be in "L-9999" (L-four digits) format.  Be sure to include leading "L-".', depotSearchController.errorPostalCode);
      System.assertEquals(null,       depotSearchController.searchResults4Hour);
      System.assertEquals(null,       depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testLuxembourgGood
   static testMethod void testMalaysiaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Malaysia';
      depotSearchController.postalCode = '   12345   ';

      depotSearchController.doSearch();

      System.assertEquals('Malaysia', depotSearchController.country);
      System.assertEquals('12345',    depotSearchController.postalCode);
      System.assertEquals(null,       depotSearchController.errorPostalCode);
      System.assertEquals(0,          depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,          depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testMalaysiaBad
   static testMethod void testMalaysiaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Malaysia';
      depotSearchController.postalCode = '   abcde   ';

      depotSearchController.doSearch();

      System.assertEquals('Malaysia', depotSearchController.country);
      System.assertEquals('ABCDE',    depotSearchController.postalCode);
      System.assertEquals('ERROR: Malaysian postal codes must be in "99999" (five digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,        depotSearchController.searchResults4Hour);
      System.assertEquals(null,        depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testNetherlandsGood
   static testMethod void testNetherlandsGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Netherlands';
      depotSearchController.postalCode = '   1234 aa   ';

      depotSearchController.doSearch();

      System.assertEquals('Netherlands', depotSearchController.country);
      System.assertEquals('1234',        depotSearchController.postalCode);
      System.assertEquals(null,          depotSearchController.errorPostalCode);
      System.assertEquals(0,             depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,             depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testNetherlandsBad
   static testMethod void testNetherlandsBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Netherlands';
      depotSearchController.postalCode = '   12z4 aa   ';

      depotSearchController.doSearch();

      System.assertEquals('Netherlands', depotSearchController.country);
      System.assertEquals('12Z4 AA',     depotSearchController.postalCode);
      System.assertEquals('ERROR: Netherlands postal codes must start with "9999" (four digits) format.  You do not have to include the two letters afterwards.', depotSearchController.errorPostalCode);
      System.assertEquals(null,          depotSearchController.searchResults4Hour);
      System.assertEquals(null,          depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testNewZealandGood
   static testMethod void testNewZealandGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'New Zealand';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('New Zealand', depotSearchController.country);
      System.assertEquals('1234',        depotSearchController.postalCode);
      System.assertEquals(null,          depotSearchController.errorPostalCode);
      System.assertEquals(0,             depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,             depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testNewZealandBad
   static testMethod void testNewZealandBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'New Zealand';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('New Zealand', depotSearchController.country);
      System.assertEquals('ABCD',        depotSearchController.postalCode);
      System.assertEquals('ERROR: New Zealand postal codes must be in "9999" (four digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,          depotSearchController.searchResults4Hour);
      System.assertEquals(null,          depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testNorwayGood
   static testMethod void testNorwayGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Norway';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('Norway', depotSearchController.country);
      System.assertEquals('1234',   depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testNorwayBad
   static testMethod void testNorwayBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Norway';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('Norway', depotSearchController.country);
      System.assertEquals('ABCD',   depotSearchController.postalCode);
      System.assertEquals('ERROR: Norwegian postal codes must be in "9999" (four digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,     depotSearchController.searchResults4Hour);
      System.assertEquals(null,     depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testPhilippinesGood
   static testMethod void testPhilippinesGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Philippines';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('Philippines', depotSearchController.country);
      System.assertEquals('1234',        depotSearchController.postalCode);
      System.assertEquals(null,          depotSearchController.errorPostalCode);
      System.assertEquals(0,             depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,             depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testPhilippinesBad
   static testMethod void testPhilippinesBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Philippines';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('Philippines', depotSearchController.country);
      System.assertEquals('ABCD',        depotSearchController.postalCode);
      System.assertEquals('ERROR: Philippines postal codes must be in "9999" (four digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,          depotSearchController.searchResults4Hour);
      System.assertEquals(null,          depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testSingaporeGood
   static testMethod void testSingaporeGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Singapore';
      depotSearchController.postalCode = '   559999   ';

      depotSearchController.doSearch();

      System.assertEquals('Singapore', depotSearchController.country);
      System.assertEquals('55',        depotSearchController.postalCode);
      System.assertEquals(null,        depotSearchController.errorPostalCode);
      System.assertEquals(0,           depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,           depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testSingaporeBad
   static testMethod void testSingaporeBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Singapore';
      depotSearchController.postalCode = '   5z9999   ';

      depotSearchController.doSearch();

      System.assertEquals('Singapore', depotSearchController.country);
      System.assertEquals('5Z9999',    depotSearchController.postalCode);
      System.assertEquals('ERROR: Singapore postal codes must start with "99" (two digits) format.  You do not have to include the other digits afterwards.', depotSearchController.errorPostalCode);
      System.assertEquals(null,        depotSearchController.searchResults4Hour);
      System.assertEquals(null,        depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testSouthAfricaGood
   static testMethod void testSouthAfricaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'South Africa';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('South Africa', depotSearchController.country);
      System.assertEquals('1234',         depotSearchController.postalCode);
      System.assertEquals(null,           depotSearchController.errorPostalCode);
      System.assertEquals(0,              depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,              depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testSouthAfricaBad
   static testMethod void testSouthAfricaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'South Africa';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('South Africa', depotSearchController.country);
      System.assertEquals('ABCD',         depotSearchController.postalCode);
      System.assertEquals('ERROR: South African postal codes must be in "9999" (four digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,           depotSearchController.searchResults4Hour);
      System.assertEquals(null,           depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testSouthKoreaGood
   static testMethod void testSouthKoreaGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'South Korea';
      depotSearchController.postalCode = '   123-456   ';

      depotSearchController.doSearch();

      System.assertEquals('South Korea', depotSearchController.country);
      System.assertEquals('123',         depotSearchController.postalCode);
      System.assertEquals(null,          depotSearchController.errorPostalCode);
      System.assertEquals(0,             depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,             depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testSouthKoreaBad
   static testMethod void testSouthKoreaBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'South Korea';
      depotSearchController.postalCode = '   abc-def   ';

      depotSearchController.doSearch();

      System.assertEquals('South Korea', depotSearchController.country);
      System.assertEquals('ABC-DEF',         depotSearchController.postalCode);
      System.assertEquals('ERROR: South Korean postal codes must be in "999-999" format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,           depotSearchController.searchResults4Hour);
      System.assertEquals(null,           depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testSpainGood
   static testMethod void testSpainGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Spain';
      depotSearchController.postalCode = '   12345   ';

      depotSearchController.doSearch();

      System.assertEquals('Spain', depotSearchController.country);
      System.assertEquals('12345', depotSearchController.postalCode);
      System.assertEquals(null,    depotSearchController.errorPostalCode);
      System.assertEquals(0,       depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,       depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testSpainBad
   static testMethod void testSpainBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Spain';
      depotSearchController.postalCode = '   abcde   ';

      depotSearchController.doSearch();

      System.assertEquals('Spain', depotSearchController.country);
      System.assertEquals('ABCDE', depotSearchController.postalCode);
      System.assertEquals('ERROR: Spain postal codes must be in "99999" (five digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,    depotSearchController.searchResults4Hour);
      System.assertEquals(null,    depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testSwedenGood
   static testMethod void testSwedenGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Sweden';
      depotSearchController.postalCode = '   12345   ';

      depotSearchController.doSearch();

      System.assertEquals('Sweden', depotSearchController.country);
      System.assertEquals('12345',  depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testSwedenBad
   static testMethod void testSwedenBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Sweden';
      depotSearchController.postalCode = '   abcde   ';

      depotSearchController.doSearch();

      System.assertEquals('Sweden', depotSearchController.country);
      System.assertEquals('ABCDE',  depotSearchController.postalCode);
      System.assertEquals('ERROR: Swedish postal codes must be in "99999" (five digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,           depotSearchController.searchResults4Hour);
      System.assertEquals(null,           depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testSwitzerlandGood
   static testMethod void testSwitzerlandGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Switzerland';
      depotSearchController.postalCode = '   1234   ';

      depotSearchController.doSearch();

      System.assertEquals('Switzerland', depotSearchController.country);
      System.assertEquals('1234',        depotSearchController.postalCode);
      System.assertEquals(null,          depotSearchController.errorPostalCode);
      System.assertEquals(0,             depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,             depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testSwitzerlandBad
   static testMethod void testSwitzerlandBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Switzerland';
      depotSearchController.postalCode = '   abcd   ';

      depotSearchController.doSearch();

      System.assertEquals('Switzerland', depotSearchController.country);
      System.assertEquals('ABCD',        depotSearchController.postalCode);
      System.assertEquals('ERROR: Switzerland postal codes must be in "9999" (four digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,          depotSearchController.searchResults4Hour);
      System.assertEquals(null,          depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testTaiwanGood
   static testMethod void testTaiwanGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Taiwan';
      depotSearchController.postalCode = '   12345   ';

      depotSearchController.doSearch();

      System.assertEquals('Taiwan', depotSearchController.country);
      System.assertEquals('123',    depotSearchController.postalCode);
      System.assertEquals(null,     depotSearchController.errorPostalCode);
      System.assertEquals(0,        depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,        depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testTaiwanBad
   static testMethod void testTaiwanBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'Taiwan';
      depotSearchController.postalCode = '   12345z   ';

      depotSearchController.doSearch();

      System.assertEquals('Taiwan', depotSearchController.country);
      System.assertEquals('12345Z', depotSearchController.postalCode);
      System.assertEquals('ERROR: Taiwanese postal codes must be in "99999" (five digits) format.', depotSearchController.errorPostalCode);
      System.assertEquals(null,     depotSearchController.searchResults4Hour);
      System.assertEquals(null,     depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testUnitedArabEmiratesGood
   static testMethod void testUnitedArabEmiratesGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'United Arab Emirates';
      depotSearchController.postalCode = '   AAA   ';

      depotSearchController.doSearch();

      System.assertEquals('United Arab Emirates', depotSearchController.country);
      System.assertEquals('AAA',                  depotSearchController.postalCode);
      System.assertEquals(null,                   depotSearchController.errorPostalCode);
      System.assertEquals(0,                      depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,                      depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testUnitedArabEmiratesBad
   //   This is commented out because the depotSearch controller will always force
   //   UAE's postal code to a known good value (AAA).  It's not
   //   possible to test a bad value.
   //
   //static testMethod void testUnitedArabEmiratesBad()
   //  {depotSearch depotSearchController = new depotSearch();
   //
   //   depotSearchController.country    = 'United Arab Emirates';
   //   depotSearchController.postalCode = '   a9a   ';
   //
   //   depotSearchController.doSearch();
   //
   //   System.assertEquals('United Arab Emirates', depotSearchController.country);
   //   System.assertEquals('A9A',                  depotSearchController.postalCode);
   //   System.assertEquals('ERROR: UAE postal codes must be in "AAA" (three alpha) format.', depotSearchController.errorPostalCode);
   //   System.assertEquals(null,      depotSearchController.searchResults4Hour);
   //   System.assertEquals(null,      depotSearchController.searchResultsNbdNd);
   //  }

   // ==================================================================================== testUnitedKingdomGood1
   static testMethod void testUnitedKingdomGood1()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'United Kingdom';
      depotSearchController.postalCode = '   BS3 9zz   ';

      depotSearchController.doSearch();

      System.assertEquals('United Kingdom', depotSearchController.country);
      System.assertEquals('BS3',            depotSearchController.postalCode);
      System.assertEquals(null,             depotSearchController.errorPostalCode);
      System.assertEquals(0,                depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,                depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testUnitedKingdomGood2
   static testMethod void testUnitedKingdomGood2()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'United Kingdom';
      depotSearchController.postalCode = '   BS3A 9zz   ';

      depotSearchController.doSearch();

      System.assertEquals('United Kingdom', depotSearchController.country);
      System.assertEquals('BS3A',           depotSearchController.postalCode);
      System.assertEquals(null,             depotSearchController.errorPostalCode);
      System.assertEquals(0,                depotSearchController.searchResults4Hour.size());
      System.assertEquals(0,                depotSearchController.searchResultsNbdNd.size());
     }

   // ==================================================================================== testUnitedKingdomBad
   static testMethod void testUnitedKingdomBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'United Kingdom';
      depotSearchController.postalCode = '   abc12 9aa   ';

      depotSearchController.doSearch();

      System.assertEquals('United Kingdom', depotSearchController.country);
      System.assertEquals('ABC12 9AA',     depotSearchController.postalCode);
      System.assertEquals('ERROR: United Kingdom postal codes must start with one of six formats: "A9", "A99", "AA9", "AA99", "A9A", or "AA9A" (A = alpha; D = digit).', depotSearchController.errorPostalCode);
      System.assertEquals(null,          depotSearchController.searchResults4Hour);
      System.assertEquals(null,          depotSearchController.searchResultsNbdNd);
     }

   // ==================================================================================== testUnitedStatesGood
   static testMethod void testUnitedStatesGood()
     {createTestData();

      depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'United States';
      depotSearchController.postalCode = '   80814-9999   ';

      depotSearchController.doSearch();

      System.assertEquals('United States', depotSearchController.country);
      System.assertEquals('80814',         depotSearchController.postalCode);
      System.assertEquals(null,            depotSearchController.errorPostalCode);
      System.assertEquals(2,               depotSearchController.searchResults4Hour.size());
      System.assert((depotSearchController.searchResults4Hour[0].depotMap4Hour_4HourDepot__r.Name == 'DEN-001'  ||
                     depotSearchController.searchResults4Hour[0].depotMap4Hour_4HourDepot__r.Name == 'DEN-002') &&
                    (depotSearchController.searchResults4Hour[1].depotMap4Hour_4HourDepot__r.Name == 'DEN-001'  ||
                     depotSearchController.searchResults4Hour[1].depotMap4Hour_4HourDepot__r.Name == 'DEN-002') &&
                    (depotSearchController.searchResults4Hour[0].depotMap4Hour_4HourDepot__r.Name <>
                     depotSearchController.searchResults4Hour[1].depotMap4Hour_4HourDepot__r.Name));
      System.assertEquals(1,         depotSearchController.searchResultsNbdNd.size());
      System.assertEquals('DEN-005', depotSearchController.searchResultsNbdNd[0].depotMapNbdNd_NbdDepot__r.Name);
      System.assertEquals('DEN-006', depotSearchController.searchResultsNbdNd[0].depotMapNbdNd_NdDepot__r.Name);
     }

   // ==================================================================================== testUnitedStatesBad
   static testMethod void testUnitedStatesBad()
     {depotSearch depotSearchController = new depotSearch();

      depotSearchController.country    = 'United States';
      depotSearchController.postalCode = '   12ab5-9999   ';

      depotSearchController.doSearch();

      System.assertEquals('United States', depotSearchController.country);
      System.assertEquals('12AB5-9999',    depotSearchController.postalCode);
      System.assertEquals('ERROR: United States postal codes must start with "99999" (five digits) format.  You do not have to include the "-9999" ZIP+4 afterwards.', depotSearchController.errorPostalCode);
      System.assertEquals(null,            depotSearchController.searchResults4Hour);
      System.assertEquals(null,            depotSearchController.searchResultsNbdNd);
     }
  }