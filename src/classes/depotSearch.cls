public without sharing class depotSearch
  {public String country {get; set;}
   public String postalCode {get; set;}
   public String errorPostalCode {get; set;}
   public List<depotMap4Hour__c> searchResults4Hour {get; set;}
   public List<depotMapNbdNd__c> searchResultsNbdNd {get; set;}

   public List<SelectOption> getCountryValues()
     {List<SelectOption> values = new List<SelectOption>();
      values.add(new SelectOption('Australia', 'Australia'));
      values.add(new SelectOption('Austria', 'Austria'));
      values.add(new SelectOption('Belgium', 'Belgium'));
      values.add(new SelectOption('Bermuda', 'Bermuda'));
      values.add(new SelectOption('Canada', 'Canada'));
      values.add(new SelectOption('China', 'China'));
      values.add(new SelectOption('Denmark', 'Denmark'));
      values.add(new SelectOption('Finland', 'Finland'));
      values.add(new SelectOption('France', 'France'));
      values.add(new SelectOption('Germany', 'Germany'));
      values.add(new SelectOption('Hong Kong', 'Hong Kong'));
      values.add(new SelectOption('India', 'India'));
      values.add(new SelectOption('Indonesia', 'Indonesia'));
      values.add(new SelectOption('Ireland', 'Ireland'));
      values.add(new SelectOption('Japan', 'Japan'));
      values.add(new SelectOption('Luxembourg', 'Luxembourg'));
      values.add(new SelectOption('Malaysia', 'Malaysia'));
      values.add(new SelectOption('Netherlands', 'Netherlands'));
      values.add(new SelectOption('New Zealand', 'New Zealand'));
      values.add(new SelectOption('Norway', 'Norway'));
      values.add(new SelectOption('Philippines', 'Philippines'));
      values.add(new SelectOption('Singapore', 'Singapore'));
      values.add(new SelectOption('South Africa', 'South Africa'));
      values.add(new SelectOption('South Korea', 'South Korea'));
      values.add(new SelectOption('Spain', 'Spain'));
      values.add(new SelectOption('Sweden', 'Sweden'));
      values.add(new SelectOption('Switzerland', 'Switzerland'));
      values.add(new SelectOption('Taiwan', 'Taiwan'));
      values.add(new SelectOption('United Arab Emirates', 'United Arab Emirates'));
      values.add(new SelectOption('United Kingdom', 'United Kingdom'));
      values.add(new SelectOption('United States', 'United States'));
      return values;
     }

   public void doSearch()
     {                                                                                                 // These patterns and logic are similar to what is used
                                                                                                       // in the RMA trigger (Apex class "rmaTrigger")
      Pattern patternPostalCodeAustralia          = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodeAustria            = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodeBelgium            = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodeBermuda            = Pattern.compile('^([A-Z]{2} [0-9]{2})$');          // Used for lookups: "AA 99"
      Pattern patternPostalCodeCanada             = Pattern.compile('^([A-Z][0-9][A-Z]).*');           // Used for lookups: "A9A"
      Pattern patternPostalCodeChina              = Pattern.compile('^([0-9]{6})$');                   // Used for lookups: "999999"
      Pattern patternPostalCodeDenmark            = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodeFinland            = Pattern.compile('^([0-9]{5})$');                   // Used for lookups: "99999"
      Pattern patternPostalCodeFrance             = Pattern.compile('^([0-9]{5})$');                   // Used for lookups: "99999"
      Pattern patternPostalCodeGermany            = Pattern.compile('^([0-9]{5})$');                   // Used for lookups: "99999"
      Pattern patternPostalCodeHongKong           = Pattern.compile('^([0-9]{6})$');                   // Used for lookups: "999999"
      Pattern patternPostalCodeIndia              = Pattern.compile('^([0-9]{6})$');                   // Used for lookups: "999999"
      Pattern patternPostalCodeIndonesia          = Pattern.compile('^([0-9]{5})$');                   // Used for lookups: "99999"
      Pattern patternPostalCodeIreland            = Pattern.compile('^([A-Z][0-9]{2}).*');             // Used for lookups: "A99"
      Pattern patternPostalCodeJapan              = Pattern.compile('^([0-9]{3}-[0-9]{2})[0-9]{2}$');  // Used for lookups: "999-99"
      Pattern patternPostalCodeLuxembourg         = Pattern.compile('^(L-[0-9]{4})');				   // Used for lookups: "A9A" or "AA9A"
      Pattern patternPostalCodeMalaysia           = Pattern.compile('^([0-9]{5})$');                   // Used for lookups: "99999"
      Pattern patternPostalCodeNetherlands        = Pattern.compile('^([0-9]{4}).*');                  // Used for lookups: "9999"
      Pattern patternPostalCodeNewZealand         = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodeNorway             = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodePhilippines        = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodeSingapore          = Pattern.compile('^([0-9]{2}).*');                  // Used for lookups: "99"
      Pattern patternPostalCodeSouthAfrica        = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodeSouthKorea         = Pattern.compile('^([0-9]{3})-[0-9]{3}$');          // Used for lookups: "999"
      Pattern patternPostalCodeSpain              = Pattern.compile('^([0-9]{5})$');                   // Used for lookups: "99999"
      Pattern patternPostalCodeSweden             = Pattern.compile('^([0-9]{5})$');                   // Used for lookups: "99999"
      Pattern patternPostalCodeSwitzerland        = Pattern.compile('^([0-9]{4})$');                   // Used for lookups: "9999"
      Pattern patternPostalCodeTaiwan             = Pattern.compile('^([0-9]{3})[0-9]{2}$');           // Used for lookups: "9999"
      Pattern patternPostalCodeUnitedArabEmirates = Pattern.compile('^([A-Z]{3})$');                   // Used for lookups: "AAA"
      Pattern patternPostalCodeUnitedStates       = Pattern.compile('^([0-9]{5}).*');                  // Used for lookups: "99999"
      Pattern patternPostalCodeUnitedKingdom1     = Pattern.compile('^([A-Z]{1,2}[0-9]{1,2}).*');      // Used for lookups: "A9", "A99", "AA9", or "AA99"
      Pattern patternPostalCodeUnitedKingdom2     = Pattern.compile('^([A-Z]{1,2}[0-9][A-Z]).*'); 
      
      Matcher matcherPostalCode;
      String depotMap4HourKey;
      String depotMapNbdNdKey;

      postalCode = postalCode.normalizeSpace();  // Remove leading, trailing, and repeating whitespace
      postalCode = postalCode.toUpperCase();     // Convert to upper case

      if (country == 'Australia')
        {matcherPostalCode = patternPostalCodeAustralia.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Australian postal codes must be in "9999" (four digits) format.  Be sure to include any leading zeroes.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Austria')
        {matcherPostalCode = patternPostalCodeAustria.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Austrian postal codes must be in "9999" (four digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Belgium')
        {matcherPostalCode = patternPostalCodeBelgium.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Belgian postal codes must be in "9999" (four digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Bermuda')
        {// Bermuda uses a dummy postal code of AA 99
         postalCode = 'AA 99';
         matcherPostalCode = patternPostalCodeBermuda.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Bermuda postal codes must be in "AA 99" (two alpha, space, two digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Canada')
        {matcherPostalCode = patternPostalCodeCanada.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Canadian postal codes must start with "A9A" (alpha digit alpha) format.  You do not have to include the second "A9A".';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'China')
        {matcherPostalCode = patternPostalCodeChina.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Chinese postal codes must be in "999999" (six digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Denmark')
        {matcherPostalCode = patternPostalCodeDenmark.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Denmark postal codes must be in "9999" (four digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Finland')
        {matcherPostalCode = patternPostalCodeFinland.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Finland postal codes must be in "99999" (five digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'France')
        {matcherPostalCode = patternPostalCodeFrance.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: French postal codes must be in "99999" (five digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Germany')
        {matcherPostalCode = patternPostalCodeGermany.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: German postal codes must be in "99999" (five digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Hong Kong')
        {// Hong Kong uses a dummy postal code of 999077
         postalCode = '999077';
         matcherPostalCode = patternPostalCodeHongKong.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Hong Kong postal code must be "999077".';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'India')
        {matcherPostalCode = patternPostalCodeIndia.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Indian postal codes must be in "999999" (six digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Indonesia')
        {matcherPostalCode = patternPostalCodeIndonesia.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Indonesian postal codes must be in "99999" (five digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Ireland')
        {// Ireland will not use real postal codes until sometime in 2015, so we force
         // the value to be a known good value (A99) that matches one dummy 4-hour
         // mappings record.  See the rmaTrigger for more documentation on this.
         postalCode = 'A99';
         matcherPostalCode = patternPostalCodeIreland.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Irish postal codes must start with "A99" (alpha digit digit) format.  You do not have to include the other characters afterwards.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Japan')
        {matcherPostalCode = patternPostalCodeJapan.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Japanese postal codes must be in "999-9999" format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Luxembourg')
        {matcherPostalCode = patternPostalCodeLuxembourg.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Luxembourg postal codes must be in "L-9999" (L-four digits) format.  Be sure to include leading "L-".';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Malaysia')
        {matcherPostalCode = patternPostalCodeMalaysia.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Malaysian postal codes must be in "99999" (five digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Netherlands')
        {matcherPostalCode = patternPostalCodeNetherlands.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Netherlands postal codes must start with "9999" (four digits) format.  You do not have to include the two letters afterwards.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'New Zealand')
        {matcherPostalCode = patternPostalCodeNewZealand.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: New Zealand postal codes must be in "9999" (four digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Norway')
        {matcherPostalCode = patternPostalCodeNorway.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Norwegian postal codes must be in "9999" (four digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Philippines')
        {matcherPostalCode = patternPostalCodePhilippines.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Philippines postal codes must be in "9999" (four digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Singapore')
        {matcherPostalCode = patternPostalCodeSingapore.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Singapore postal codes must start with "99" (two digits) format.  You do not have to include the other digits afterwards.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'South Africa')
        {matcherPostalCode = patternPostalCodeSouthAfrica.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: South African postal codes must be in "9999" (four digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'South Korea')
        {matcherPostalCode = patternPostalCodeSouthKorea.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: South Korean postal codes must be in "999-999" format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Spain')
        {matcherPostalCode = patternPostalCodeSpain.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Spain postal codes must be in "99999" (five digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Sweden')
        {matcherPostalCode = patternPostalCodeSweden.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Swedish postal codes must be in "99999" (five digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Switzerland')
        {matcherPostalCode = patternPostalCodeSwitzerland.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Switzerland postal codes must be in "9999" (four digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'Taiwan')
        {matcherPostalCode = patternPostalCodeTaiwan.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: Taiwanese postal codes must be in "99999" (five digits) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'United Arab Emirates')
        {// UAE has no postal code system, so we use a dummy code of "AAA" for it.
         postalCode = 'AAA';
         matcherPostalCode = patternPostalCodeUnitedArabEmirates.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: UAE postal codes must be in "AAA" (three alpha) format.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'United States')
        {matcherPostalCode = patternPostalCodeUnitedStates.matcher(postalCode);
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {errorPostalCode = 'ERROR: United States postal codes must start with "99999" (five digits) format.  You do not have to include the "-9999" ZIP+4 afterwards.';
            searchResults4Hour = null;
            searchResultsNbdNd = null;
            return;
           }
        }
      else if (country == 'United Kingdom')
        {matcherPostalCode = patternPostalCodeUnitedKingdom2.matcher(postalCode); // Pattern 2 must be checked before pattern 1, otherwise certain pattern 2
                                                                                  // postcodes (like "BS3A") could be identified as pattern 1 by mistake.
         if (matcherPostalCode.matches())
           {postalCode = matcherPostalCode.group(1);
           }
         else
           {matcherPostalCode = patternPostalCodeUnitedKingdom1.matcher(postalCode);
            if (matcherPostalCode.matches())
              {postalCode = matcherPostalCode.group(1);
              }
            else
              {errorPostalCode = 'ERROR: United Kingdom postal codes must start with one of six formats: "A9", "A99", "AA9", "AA99", "A9A", or "AA9A" (A = alpha; D = digit).';
               searchResults4Hour = null;
               searchResultsNbdNd = null;
               return;
              }
           }
        }

     depotMap4HourKey = '\\_\\_' + country + '\\_\\_' + postalCode + '\\_\\_%';

     searchResults4Hour =
       [SELECT   depotMap4Hour_4HourDepot__r.Name,
                 depotMap4Hour_4HourDepot__r.depotProvider__c,
                 depotMap4Hour_4HourDepot__r.depotLocationDescription__c,
                 depotMap4Hour__c.depotMap4HourDriveTime__c,
                 depotMap4Hour__c.depotMap4HourMiles__c
        FROM     depotMap4Hour__c
        WHERE    depotMap4HourKey__c LIKE :depotMap4HourKey and
                 depotMap4Hour_4HourDepot__r.depotStockedFor4Hour__c = 'Yes'
        ORDER BY depotMap4Hour__c.depotMap4HourDriveTime__c];

     depotMapNbdNdKey = '\\_\\_' + country + '\\_\\_N/A\\_\\_';

     searchResultsNbdNd =
       [SELECT depotMapNbdNd_NbdDepot__r.Name,
               depotMapNbdNd_NbdDepot__r.depotProvider__c,
               depotMapNbdNd_NbdDepot__r.depotLocationDescription__c,
               depotMapNbdNd_NdDepot__r.Name,
               depotMapNbdNd_NdDepot__r.depotProvider__c,
               depotMapNbdNd_NdDepot__r.depotLocationDescription__c
        FROM   depotMapNbdNd__c
        WHERE  depotMapNbdNdKey__c LIKE :depotMapNbdNdKey];

     errorPostalCode = null;
     return;
     }
  }