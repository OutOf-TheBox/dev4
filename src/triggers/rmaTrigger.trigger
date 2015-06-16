trigger rmaTrigger on RMAv2__c (before insert, before update)
  {for (RMAv2__c rmaToProcess : Trigger.new)
     {// NOTE: This trigger is NOT yet enhanced to work with bulk records.
      //       The SOQL queries need to be moved out of the loop so that
      //       governor limits aren't hit if RMAs are ever updated in bulk.




      // #############################################
      // BEGIN LOGIC TO VERIFY COUNTRY AND POSTAL CODE
      // #############################################

      // Throw error if Shipment Country is null/blank

      if (rmaToProcess.rmaShipmentCountry__c == null)
        {rmaToProcess.rmaShipmentCountry__c.addError('Based on your address selections, the "Shipment Country" will be blank.  This field cannot be blank.  Override it if needed to provide a valid value.');
         system.debug('DEBUG: Found null Shipment Country');
         return;
        }

      // Remove any two-letter country codes at the end of the Shipment Country

      String soqlCountry = rmaToProcess.rmaShipmentCountry__c;
      soqlCountry = soqlCountry.replaceAll(' \\([A-Z]{2}\\)$', '');
      
      //Lookup to NBD/ND Depot - State
      String soqlState = rmaToProcess.rmaShipmentState__c;
      

      // Throw error if Shipment Postal Code is null/blank

      if (rmaToProcess.rmaShipmentPostalCode__c == null)
        {rmaToProcess.rmaShipmentPostalCode__c.addError('Based on your address selections, the "Shipment Postal Code" will be blank.  This field cannot be blank.  Override it if needed to provide a valid value.');
         return;
        }

      // Convert the Shipment Postal Code to all uppercase

      String soqlPostalCode = rmaToProcess.rmaShipmentPostalCode__c;
      // soqlPostalCode        = soqlPostalCode.deleteWhiteSpace();   // NOTE: Removed so UK format requirements could be enforced
      soqlPostalCode        = soqlPostalCode.toUpperCase();

      // Prepare postal code patterns for known countries in which there are 4-hour depots
      // United Kingdom postal code formats were obtained from the following two web pages:
      //   Wikipedia page:      http://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom
      //   UK standard BS7666:  http://webarchive.nationalarchives.gov.uk/20101126012154/http://www.cabinetoffice.gov.uk/govtalk/schemasstandards/e-gif/datastandards/address/postcode.aspx

      // Ireland does not currently use country-wide postal codes, but will be rolling them out in 2015 per the following article:
      // http://www.irishtimes.com/news/ireland/irish-news/every-address-to-have-postcode-by-2015-1.1553971
      //
      // They plan on adopting the format "A99 A9AA" where the first three characters indicate a geographic area.  Based on
      // how Flash has sometimes used only part of a postal code in other countries, I'm guessing they will only use
      // the first three characters to do mappings for Ireland.  If this changes, Ireland's pattern and mappings will need to change.
      //
      // Because Ireland has not yet rolled out country-wide postal codes, the Ireland specific code (later in this trigger) manually
      // sets the SOQL postal code to "A99 A9AA", which is a valid format.  The "A99" part will be stripped out for searching
      // the mappings.  A dummy 4-hour mapping was built for Ireland + A99, and this is the one the trigger will find for 4-hour
      // Ireland RMAs.  Once Ireland rolls out its real postal codes, and we receive valid mappings from Flash for Ireland, the
      // real mappings should be loaded, the code that sets SOQL postal code to "A99 A9AA" should be removed, and the dummy
      // mapping for Ireland + A99 should be deleted.

      // United Arab Emirates does not have a postal code system, so we use a dummy postal code of "AAA" for it.

      Pattern patternPostalCodeAustralia      = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodeAustria        = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodeBelgium        = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodeBermuda        = Pattern.compile('^([A-Z][A-Z]) [0-9][0-9]$');              // Format: "AA 99" ;        Used for lookups: "AA"
      Pattern patternPostalCodeCanada         = Pattern.compile('^([A-Z][0-9][A-Z]) [0-9][A-Z][0-9]$');    // Format: "A9A 9A9" ;      Used for lookups: "A9A"
      Pattern patternPostalCodeChina          = Pattern.compile('^([0-9]{6})$');                           // Format: "999999" ;       Used for lookups: "999999"
      Pattern patternPostalCodeDenmark        = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodeFinland        = Pattern.compile('^([0-9]{5})$');                           // Format: "99999" ;        Used for lookups: "99999"
      Pattern patternPostalCodeFrance         = Pattern.compile('^([0-9]{5})$');                           // Format: "99999" ;        Used for lookups: "99999"
      Pattern patternPostalCodeGermany        = Pattern.compile('^([0-9]{5})$');                           // Format: "99999" ;        Used for lookups: "99999"
      Pattern patternPostalCodeHongKong       = Pattern.compile('^([0-9]{6})$');                           // Format: "999999" ;       Used for lookups: "999999"
      Pattern patternPostalCodeIndia          = Pattern.compile('^([0-9]{6})$');                           // Format: "999999" ;       Used for lookups: "999999"
      Pattern patternPostalCodeIndonesia      = Pattern.compile('^([0-9]{5})$');                           // Format: "99999" ;        Used for lookups: "99999"
      Pattern patternPostalCodeIreland        = Pattern.compile('^([A-Z][0-9]{2}) [A-Z][0-9][A-Z]{2}$');   // Format: "A99 A9AA" ;     Used for lookups: "A99"
      Pattern patternPostalCodeJapan          = Pattern.compile('^([0-9]{3}-[0-9]{2})[0-9]{2}$');          // Format: "999-9999" ;     Used for lookups: "999-99"
      Pattern patternPostalCodeMalaysia       = Pattern.compile('^([0-9]{5})$');                           // Format: "99999" ;        Used for lookups: "99999"
      Pattern patternPostalCodeNetherlands    = Pattern.compile('^([0-9]{4}) [A-Z]{2}$');                  // Format: "9999 AA" ;      Used for lookups: "9999"
      Pattern patternPostalCodeNewZealand     = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodeNorway         = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodePhilippines    = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodeSingapore      = Pattern.compile('^([0-9]{2})[0-9]{4}$');                   // Format: "999999" ;       Used for lookups: "99"
      Pattern patternPostalCodeSouthAfrica    = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodeSouthKorea     = Pattern.compile('^([0-9]{3}-[0-9]{3})$');                  // Format: "999-999" ;      Used for lookups: "999-999"
      Pattern patternPostalCodeSweden         = Pattern.compile('^([0-9]{5})$');                           // Format: "99999" ;        Used for lookups: "99999"
      Pattern patternPostalCodeSwitzerland    = Pattern.compile('^([0-9]{4})$');                           // Format: "9999" ;         Used for lookups: "9999"
      Pattern patternPostalCodeTaiwan         = Pattern.compile('^([0-9]{3})[0-9]{2}$');                   // Format: "99999" ;        Used for lookups: "999"
      Pattern patternPostalCodeUae            = Pattern.compile('^([A-Z]{3})$');                           // Format: "AAA" ;          Used for lookups: "AAA"
      Pattern patternPostalCodeUnitedStates   = Pattern.compile('^([0-9]{5})(-[0-9]{4})?$');               // Format: "99999(-9999)" ; Used for lookups: "99999"
      Pattern patternPostalCodeUnitedKingdom1 = Pattern.compile('^([A-Z]{1,2}[0-9]{1,2}) [0-9][A-Z]{2}$'); // Format: "A9 9AA" ;       Used for lookups: "A9"
                                                                                                           // Formst: "A99 9AA" ;      Used for lookups: "A99"
                                                                                                           // Format: "AA9 9AA" ;      Used for lookups: "AA9"
                                                                                                           // Format: "AA99 9AA" ;     Used for lookups: "AA99"
      Pattern patternPostalCodeUnitedKingdom2 = Pattern.compile('^([A-Z]{1,2}[0-9][A-Z]) [0-9][A-Z]{2}$'); // Format: "A9A 9AA" ;      Used for lookups: "A9A"
                                                                                                           // Format: "AA9A 9AA" ;     Used for lookups: "AA9A"
      Matcher matcherPostalCode;

      // Verify Australia postal code

      if (soqlCountry == 'Australia')
        {matcherPostalCode = patternPostalCodeAustralia.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Australia\'s "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Austria postal code

      else if (soqlCountry == 'Austria')
        {matcherPostalCode = patternPostalCodeAustria.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Austria\'s "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Belgium postal code

      else if (soqlCountry == 'Belgium')
        {matcherPostalCode = patternPostalCodeAustria.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Belgium\'s "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Bermuda postal code
      //   NOTE: Manually sets SOQL postal code to "AA 99" which we're using as the dummy postal code for Bermuda.

      else if (soqlCountry == 'Bermuda')
        {soqlPostalCode = 'AA 99';
         matcherPostalCode = patternPostalCodeBermuda.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Bermuda\'s "AA 99" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Canada postal code

      else if (soqlCountry == 'Canada')
        {matcherPostalCode = patternPostalCodeCanada.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Canada\'s "A9A 9A9" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify China postal code

      else if (soqlCountry == 'China')
        {matcherPostalCode = patternPostalCodeChina.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to China\'s "999999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Denmark postal code

      else if (soqlCountry == 'Denmark')
        {matcherPostalCode = patternPostalCodeDenmark.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Denmark\'s "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Finland postal code

      else if (soqlCountry == 'Finland')
        {matcherPostalCode = patternPostalCodeFinland.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Finland\'s "99999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify France postal code

      else if (soqlCountry == 'France')
        {matcherPostalCode = patternPostalCodeFrance.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to France\'s "99999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Germany postal code

      else if (soqlCountry == 'Germany')
        {matcherPostalCode = patternPostalCodeGermany.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Germany\'s "99999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Hong Kong postal code
      //   NOTE: Manually sets SOQL postal code to "999077" which is the dummy postal code for Hong Kong.

      else if (soqlCountry == 'Hong Kong')
        {soqlPostalCode = '999077';
         matcherPostalCode = patternPostalCodeHongKong.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Hong Kong\'s "999999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify India postal code

      else if (soqlCountry == 'India')
        {matcherPostalCode = patternPostalCodeIndia.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to India\'s "999999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Indonesia postal code

      else if (soqlCountry == 'Indonesia')
        {matcherPostalCode = patternPostalCodeIndonesia.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Indonesia\'s "99999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Ireland postal code
      //   NOTE: Manually sets SOQL postal code to "A99 A9AA" (see more notes on Ireland in the
      //         documentation above where the search patterns are built, above).

      else if (soqlCountry == 'Ireland')
        {soqlPostalCode = 'A99 A9AA';
         matcherPostalCode = patternPostalCodeIreland.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Ireland\'s "A99 A9AA" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Japan postal code

      else if (soqlCountry == 'Japan')
        {matcherPostalCode = patternPostalCodeJapan.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Japan\'s "999-9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Malaysia postal code

      else if (soqlCountry == 'Malaysia')
        {matcherPostalCode = patternPostalCodeMalaysia.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Malaysia\'s "99999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Netherlands postal code

      else if (soqlCountry == 'Netherlands')
        {matcherPostalCode = patternPostalCodeNetherlands.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Netherlands\' "9999 AA" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify New Zealand postal code

      else if (soqlCountry == 'New Zealand')
        {matcherPostalCode = patternPostalCodeNewZealand.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to New Zealand\'s "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Norway postal code

      else if (soqlCountry == 'Norway')
        {matcherPostalCode = patternPostalCodeNorway.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Norway\'s "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Philippines postal code

      else if (soqlCountry == 'Philippines')
        {matcherPostalCode = patternPostalCodePhilippines.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Philippines\' "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Singapore postal code

      else if (soqlCountry == 'Singapore')
        {matcherPostalCode = patternPostalCodeSingapore.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Singapore\'s "999999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify South Africa postal code

      else if (soqlCountry == 'South Africa')
        {matcherPostalCode = patternPostalCodeSouthAfrica.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to South Africa\'s "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify South Korea postal code

      else if (soqlCountry == 'South Korea')
        {matcherPostalCode = patternPostalCodeSouthKorea.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to South Korea\'s "999-999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Sweden postal code

      else if (soqlCountry == 'Sweden')
        {matcherPostalCode = patternPostalCodeSweden.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Sweden\'s "99999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Switzerland postal code

      else if (soqlCountry == 'Switzerland')
        {matcherPostalCode = patternPostalCodeSwitzerland.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Switzerland\'s "9999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify Taiwan postal code

      else if (soqlCountry == 'Taiwan')
        {matcherPostalCode = patternPostalCodeTaiwan.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to Taiwan\'s "99999" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify United Arab Emirates (UAE) postal code
      //   NOTE: Manually sets SOQL postal code to "AAA" because UAE doesn't have a postal code system.

      else if (soqlCountry == 'United Arab Emirates')
        {soqlPostalCode = 'AAA';
         matcherPostalCode = patternPostalCodeUae.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to United Arab Emirates\' "AAA" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify United States postal code

      else if (soqlCountry == 'United States')
        {matcherPostalCode = patternPostalCodeUnitedStates.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to United States\' "99999(-9999)" format.  Override it if needed to provide a valid value.');
            return;
           }
         }

      // Verify United Kingdom postal code

      else if (soqlCountry == 'United Kingdom')
        {matcherPostalCode = patternPostalCodeUnitedKingdom1.matcher(soqlPostalCode);
         if (matcherPostalCode.matches())
           {soqlPostalCode = matcherPostalCode.group(1);
           }
         else
           {matcherPostalCode = patternPostalCodeUnitedKingdom2.matcher(soqlPostalCode);
            if (matcherPostalCode.matches())
              {soqlPostalCode = matcherPostalCode.group(1);
              }
            else
              {rmaToProcess.rmaShipmentPostalCode__c.addError('"Shipment Postal Code" will not conform to one of United Kingdom\'s six formats.  Override it if needed to provide a valid value.');
               return;
              }
           }
        }

      // ###########################################
      // END LOGIC TO VERIFY COUNTRY AND POSTAL CODE
      // ###########################################




      // #################################################
      // BEGIN LOGIC TO DETERMINE HDD AND SSD PART NUMBERS
      // #################################################

      // Below is the map of possible keys to values.  The key is composite, and
      // consists of the following items.  Items are separated by underscores.
      //
      //   1. Component.  This is either 'HDD' or 'SSD'.
      //   2. Model.  This is a substring within the model values for the Component
      //      which is enough to uniquely identify exactly which Model
      //      value was selected.  Note this substring does not mean the
      //      key/value entry applies only to that model, but rather it applies
      //      to all models that use the same type of HDD or SSD.  The substring
      //      just has to be unique enough to identify which picklist Model
      //      value was selected.
      //   3. Serial number cutoff position.  This is either 'Before' or 'After'.
      //
      // The value is the text value, including SR part number, that will be
      // put into the Part field for that combination.

      Map<String, String> mapPartNumbers = new Map<String, String>
        {'HDD_210_Before'    => '1TB SATA HDD [SR-HDD-1TB]',
         'HDD_210_After'     => '1TB SAS HDD [SR-HDD-1TB-SAS]',
         'HDD_H25_Before'    => '1TB SAS HDD [SR-HDD-H25]',
         'HDD_H25_After'     => '1TB SAS HDD [SR-HDD-1TB-SAS]',
         'HDD_240_Before'    => '2TB SATA HDD [SR-HDD-2TB]',
         'HDD_240_After'     => '2TB SAS HDD [SR-HDD-2TB-SAS]',
         'HDD_H45_Before'    => '2TB SAS HDD [SR-HDD-H45]',
         'HDD_H45_After'     => '2TB SAS HDD [SR-HDD-2TB-SAS]',
         'HDD_260_Before'    => '3TB SAS HDD [SR-HDD-3TB]',
         'HDD_260_After'     => '3TB SAS HDD [SR-HDD-3TB-SAS]',
         'HDD_H65_Before'    => '3TB SAS HDD [SR-HDD-3TB]',
         'HDD_H65_After'     => '3TB SAS HDD [SR-HDD-3TB-SAS]',
         'HDD_H85_Before'    => '4TB SAS HDD [SR-HDD-4TB-SAS]',
         'HDD_H85_After'     => '4TB SAS HDD [SR-HDD-4TB-SAS]',
         'HDD_H90T_Before'   => '6TB SAS HDD [SR-HDD-6TB-SAS]',
         'HDD_H90T_After'    => '6TB SAS HDD [SR-HDD-6TB-SAS]',
         'HDD_12T_Before'    => '1TB SAS HDD [SR-HDD-1TB-SAS]',
         'HDD_12T_After'     => '1TB SAS HDD [SR-HDD-1TB-SAS]',
         'HDD_24T_Before'    => '2TB SAS HDD [SR-HDD-2TB-SAS]',
         'HDD_24T_After'     => '2TB SAS HDD [SR-HDD-2TB-SAS]',
         'HDD_36T_Before'    => '3TB SAS HDD [SR-HDD-3TB-SAS]',
         'HDD_36T_After'     => '3TB SAS HDD [SR-HDD-3TB-SAS]',
         'HDD_48T_Before'    => '4TB SAS HDD [SR-HDD-4TB-SAS]',
         'HDD_48T_After'     => '4TB SAS HDD [SR-HDD-4TB-SAS]',
         'HDD_72T_Before'    => '6TB SAS HDD [SR-HDD-6TB-SAS]',
         'HDD_72T_After'     => '6TB SAS HDD [SR-HDD-6TB-SAS]',
         'SSD_210-X2_Before' => '80GB SATA SSD [SR-SSD-80GB]',
         'SSD_210-X2_After'  => '80GB SATA SSD [SR-SSD-3500-80GB]',
         'SSD_210-X4_Before' => '160GB SATA SSD [SR-SSD-160GB]',
         'SSD_210-X4_After'  => '160GB SATA SSD [SR-SSD-3500-160GB]',
         'SSD_H25_Before'    => '160GB SATA SSD [SR-SSD-160GB]',
         'SSD_H25_After'     => '160GB SATA SSD [SR-SSD-3500-160GB]',
         'SSD_220-X4_Before' => '300GB SATA SSD [SR-SSD-300GB]',
         'SSD_220-X4_After'  => '300GB SATA SSD [SR-SSD-3500-300GB]',
         'SSD_H45_Before'    => '300GB SATA SSD [SR-SSD-300GB]',
         'SSD_H45_After'     => '300GB SATA SSD [SR-SSD-3500-300GB]',
         'SSD_220-X8_Before' => '600GB SATA SSD [SR-SSD-600GB]',
         'SSD_220-X8_After'  => '600GB SATA SSD [SR-SSD-3500-600GB]',
         'SSD_H65_Before'    => '600GB SATA SSD [SR-SSD-600GB]',
         'SSD_H65_After'     => '600GB SATA SSD [SR-SSD-3500-600GB]',
         'SSD_320F_Before'   => '80GB SATA SSD [SR-SSD-3500-80GB]',
         'SSD_320F_After'    => '80GB SATA SSD [SR-SSD-3500-80GB]',
         'SSD_640F_Before'   => '160GB SATA SSD [SR-SSD-3500-160GB]',
         'SSD_640F_After'    => '160GB SATA SSD [SR-SSD-3500-160GB]',
         'SSD_1200F_Before'  => '300GB SATA SSD [SR-SSD-3500-300GB]',
         'SSD_1200F_After'   => '300GB SATA SSD [SR-SSD-3500-300GB]',
         'SSD_2400F_Before'  => '600GB SATA SSD [SR-SSD-3500-600GB]',
         'SSD_2400F_After'   => '600GB SATA SSD [SR-SSD-3500-600GB]',
         'SSD_3200F_Before'  => '800GB SATA SSD [SR-SSD-3500-800GB]',
         'SSD_3200F_After'   => '800GB SATA SSD [SR-SSD-3500-800GB]',
         'SSD_6400F_Before'  => '1600GB SATA SSD [SR-SSD-3500-1600GB]',
         'SSD_6400F_After'   => '1600GB SATA SSD [SR-SSD-3500-1600GB]',
         'SSD_3200FS_Before' => '800GB SAS SSD [SR-SSD-800GB-SAS]',
         'SSD_3200FS_After'  => '800GB SAS SSD [SR-SSD-800GB-SAS]',
         'SSD_6400FS_Before' => '1600GB SAS SSD [SR-SSD-1600GB-SAS]',
         'SSD_6400FS_After'  => '1600GB SAS SSD [SR-SSD-1600GB-SAS]',
         'SSD_300GB_Before'  => '300GB SATA SSD [SR-SSD-3500-300GB]',
         'SSD_300GB_After'   => '300GB SATA SSD [SR-SSD-3500-300GB]',
         'SSD_600GB_Before'  => '600GB SATA SSD [SR-SSD-3500-600GB]',
         'SSD_600GB_After'   => '600GB SATA SSD [SR-SSD-3500-600GB]',
         'SSD_800GB_Before'  => '800GB SATA SSD [SR-SSD-3500-800GB]',
         'SSD_800GB_After'   => '800GB SATA SSD [SR-SSD-3500-800GB]',
         'SSD_1600GB_Before' => '1600GB SATA SSD [SR-SSD-3500-1600GB]',
         'SSD_1600GB_After'  => '1600GB SATA SSD [SR-SSD-3500-1600GB]'};

      // Set the map keys for Component and Model

      String mapKeyComponent = '';
      String mapKeyModel     = '';

      if (rmaToProcess.rmaComponent__c.contains('HDD'))
        {mapKeyComponent = 'HDD';

         if (rmaToProcess.rmaModel__c.contains('210'))
           {mapKeyModel = '210';
           }
         else if (rmaToProcess.rmaModel__c.contains('H25'))
           {mapKeyModel = 'H25';
           }
         else if (rmaToProcess.rmaModel__c.contains('240'))
           {mapKeyModel = '240';
           }
         else if (rmaToProcess.rmaModel__c.contains('H45'))
           {mapKeyModel = 'H45';
           }
         else if (rmaToProcess.rmaModel__c.contains('260'))
           {mapKeyModel = '260';
           }
         else if (rmaToProcess.rmaModel__c.contains('H65'))
           {mapKeyModel = 'H65';
           }
         else if (rmaToProcess.rmaModel__c.contains('H85'))
           {mapKeyModel = 'H85';
           }
         else if (rmaToProcess.rmaModel__c.contains('H90T'))
           {mapKeyModel = 'H90T';
           }
         else if (rmaToProcess.rmaModel__c.contains('12T'))
           {mapKeyModel = '12T';
           }
         else if (rmaToProcess.rmaModel__c.contains('24T'))
           {mapKeyModel = '24T';
           }
         else if (rmaToProcess.rmaModel__c.contains('36T'))
           {mapKeyModel = '36T';
           }
         else if (rmaToProcess.rmaModel__c.contains('48T'))
           {mapKeyModel = '48T';
           }
         else if (rmaToProcess.rmaModel__c.contains('72T'))
           {mapKeyModel = '72T';
           }
        }

      if (rmaToProcess.rmaComponent__c.contains('SSD'))
        {mapKeyComponent = 'SSD';

         if (rmaToProcess.rmaModel__c.contains('210-X2'))
           {mapKeyModel = '210-X2';
           }
         else if (rmaToProcess.rmaModel__c.contains('210-X4'))
           {mapKeyModel = '210-X4';
           }
         else if (rmaToProcess.rmaModel__c.contains('H25'))
           {mapKeyModel = 'H25';
           }
         else if (rmaToProcess.rmaModel__c.contains('220-X4'))
           {mapKeyModel = '220-X4';
           }
         else if (rmaToProcess.rmaModel__c.contains('H45'))
           {mapKeyModel = 'H45';
           }
         else if (rmaToProcess.rmaModel__c.contains('220-X8'))
           {mapKeyModel = '220-X8';
           }
         else if (rmaToProcess.rmaModel__c.contains('H65'))
           {mapKeyModel = 'H65';
           }
         else if (rmaToProcess.rmaModel__c.contains('320F'))
           {mapKeyModel = '320F';
           }
         else if (rmaToProcess.rmaModel__c.contains('640F'))
           {mapKeyModel = '640F';
           }
         else if (rmaToProcess.rmaModel__c.contains('1200F'))
           {mapKeyModel = '1200F';
           }
         else if (rmaToProcess.rmaModel__c.contains('2400F'))
           {mapKeyModel = '2400F';
           }
         else if (rmaToProcess.rmaModel__c.contains('3200FS'))
           {mapKeyModel = '3200FS';
           }
         else if (rmaToProcess.rmaModel__c.contains('6400FS'))
           {mapKeyModel = '6400FS';
           }
         else if (rmaToProcess.rmaModel__c.contains('3200F'))
           {mapKeyModel = '3200F';
           }
         else if (rmaToProcess.rmaModel__c.contains('6400F'))
           {mapKeyModel = '6400F';
           }
         else if (rmaToProcess.rmaModel__c.contains('300GB'))
           {mapKeyModel = '300GB';
           }
         else if (rmaToProcess.rmaModel__c.contains('1600GB'))
           {mapKeyModel = '1600GB';
           }
         else if (rmaToProcess.rmaModel__c.contains('800GB'))
           {mapKeyModel = '800GB';
           }
         else if (rmaToProcess.rmaModel__c.contains('600GB'))
           {mapKeyModel = '600GB';
           }
        }

      // Set the map key for whether the asset serial number
      // is before or after the cutoff

      Integer rmaAssetSnNumberOnly        = 1;
      String  mapKeyCutoffPosition        = 'Before';
      Pattern patternRmaAssetSnNumberOnly = Pattern.compile('.*?([0-9]{6})');
      Matcher matcherRmaAssetSnNumberOnly;

      // The rmaAssetSerialNumber__c field is a formula field that contains the serial
      // number of the Asset the RMA is for.  This can be either the Asset on the Case
      // (if the RMA is for a head unit), or the Disk Shelf Asset on the RMA itself
      // (if the RMA is for a disk shelf).

      matcherRmaAssetSnNumberOnly = patternRmaAssetSnNumberOnly.matcher(rmaToProcess.rmaAssetSerialNumber__c);

      if (matcherRmaAssetSnNumberOnly.matches())
        {rmaAssetSnNumberOnly = integer.valueof(matcherRmaAssetSnNumberOnly.group(1));
        }

      if (rmaAssetSnNumberOnly >= 105000)
        {mapKeyCutoffPosition = 'After';
        }
      else
        {mapKeyCutoffPosition = 'Before';
        }

      // Determine the part number for HDD and SSD components

      String mapKey = '';

      if ((mapKeyComponent == 'HDD') || (mapKeyComponent == 'SSD'))
        {mapKey = mapKeyComponent + '_' + mapKeyModel + '_' + mapKeyCutoffPosition;

         rmaToProcess.rmaPart__c = mapPartNumbers.get(mapKey);
        }

      // Set the order's Part Number.  This is just the part number only,
      // extracted from the other verbiage.

      String partNumberSubstring;

      partNumberSubstring = rmaToProcess.rmaPart__c.substringAfterLast('[');
      partNumberSubstring = partNumberSubstring.substringBeforeLast(']');

      if (partNumberSubstring.length() == 0)
        {partNumberSubstring = rmaToProcess.rmaPart__c.substringAfterLast('(');
         partNumberSubstring = partNumberSubstring.substringBeforeLast(')');
        }

      rmaToProcess.rmaPartNumber__c = partNumberSubstring;

      // ###############################################
      // END LOGIC TO DETERMINE HDD AND SSD PART NUMBERS
      // ###############################################




      // ###########################################
      // BEGIN LOGIC TO DETERMINE PROVIDER AND DEPOT
      // ###########################################
      
      
      //Logic to check the current State is available in depot
      
      List<depotMapNbdNd__c> depotState =
                [SELECT Id 
                 FROM   depotMapNbdNd__c
                 WHERE  depotMapNbdNdCountry__c = :soqlCountry and
                        depotMapNbdNdState__c   = :soqlState];
                        
      if (depotState.size() == 0)
      {
        //State depot not available - set the default state as 'N/A'
         soqlState = 'N/A'; 
      }      

      if (rmaToProcess.rmaType__c == 'Advance replacement' && rmaToProcess.rmaPart__c.contains('[SR'))
        {// Old logic prior to onsite service changes
         //  if (rmaToProcess.rmaShipmentSla__c.contains('4-Hour'))

         // New logic for onsite service changes

         rmaToProcess.rma4HourDepotDistanceMiles__c = null;

         if (rmaToProcess.rmaAssetSla__c.contains('4-Hour') || rmaToProcess.rmaUplift__c.contains('4-Hour'))
           {String tempKeyPattern = '\\_\\_' + soqlCountry + '\\_\\_' + soqlPostalCode + '\\_\\_%';

            List<depotMap4Hour__c> depotMap4Hour =
              [SELECT   depotMap4Hour_4HourDepot__r.Name,
                        depotMap4Hour_4HourDepot__r.depotProvider__c,
                        depotMap4HourMiles__c
               FROM     depotMap4Hour__c
               WHERE    depotMap4HourKey__c LIKE :tempKeyPattern and
                        depotMap4Hour_4HourDepot__r.depotStockedFor4Hour__c = 'Yes'
               ORDER BY depotMap4HourDriveTime__c ASC NULLS LAST];

            if (depotMap4Hour.size() > 0)
              {rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = depotMap4Hour[0].depotMap4Hour_4HourDepot__r.depotProvider__c;
               rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = depotMap4Hour[0].depotMap4Hour_4HourDepot__r.Name;
               rmaToProcess.rma4HourDepotDistanceMiles__c            = depotMap4Hour[0].depotMap4HourMiles__c;
               rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'Yes';
              }
            else
              {List<depotMapNbdNd__c> depotMapNbdNd =
                [SELECT depotMapNbdNd_NdDepot__r.Name,
                        depotMapNbdNd_NdDepot__r.depotProvider__c
                 FROM   depotMapNbdNd__c
                 WHERE  depotMapNbdNdCountry__c = :soqlCountry and
                        depotMapNbdNdState__c   = :soqlState];
               if (depotMapNbdNd.size() > 0)
                 {rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = depotMapNbdNd[0].depotMapNbdNd_NdDepot__r.depotProvider__c;
                  rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = depotMapNbdNd[0].depotMapNbdNd_NdDepot__r.Name;
                  rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'No';
                 }
               else
                 {rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = 'Unknown';
                  rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = 'Unknown';
                  rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'Unknown';
                 }
              }
           }
         else
           {List<depotMapNbdNd__c> depotMapNbdNd =
              [SELECT depotMapNbdNd_NbdDepot__r.Name,
                      depotMapNbdNd_NbdDepot__r.depotProvider__c,
                      depotMapNbdNd_NdDepot__r.Name,
                      depotMapNbdNd_NdDepot__r.depotProvider__c
               FROM   depotMapNbdNd__c
               WHERE  depotMapNbdNdCountry__c = :soqlCountry and
                      depotMapNbdNdState__c   = :soqlState];

            if (depotMapNbdNd.size() > 0 && rmaToProcess.rmaShipmentSla__c == 'Next Day')
              {rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = depotMapNbdNd[0].depotMapNbdNd_NdDepot__r.depotProvider__c;
               rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = depotMapNbdNd[0].depotMapNbdNd_NdDepot__r.Name;
               rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'N/A';
              }
            else if (depotMapNbdNd.size() > 0)
              {rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = depotMapNbdNd[0].depotMapNbdNd_NbdDepot__r.depotProvider__c;
               rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = depotMapNbdNd[0].depotMapNbdNd_NbdDepot__r.Name;
               rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'N/A';
              }
            else
              {rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = 'Unknown';
               rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = 'Unknown';
               rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'Unknown';
              }
           }
        }
      else
        {rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = 'Nimble';
         rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = 'SRV-NIMBLE';
         rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'N/A';
        }

      // #########################################
      // END LOGIC TO DETERMINE PROVIDER AND DEPOT
      // #########################################




      // ############################################
      // BEGIN LOGIC TO SET RMA STATUS AND TIMESTAMPS
      // ############################################

         // See if RMA Status should be Draft
         if (rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('DRAFT') ||
             (rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('N/A') && rmaToProcess.rmaReturnShipmentStatus__c.startsWith('DRAFT')))
           {rmaToProcess.rmaStatus__c = 'Draft';
           }

         // See if RMA Status should be Open
         else if (rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('OPEN')                                             ||
                  rmaToProcess.rmaReturnShipmentStatus__c.startsWith('OPEN')                                               ||
                  (rmaToProcess.rmaRetShip2Status__c   != null && rmaToProcess.rmaRetShip2Status__c.startsWith('OPEN'))    ||
                  (rmaToProcess.rmaOnsiteTechStatus__c != null && rmaToProcess.rmaOnsiteTechStatus__c.startsWith('OPEN')))
           {rmaToProcess.rmaStatus__c = 'Open';
            if (rmaToProcess.rmaDateTimeOpened__c == null)
              {rmaToProcess.rmaDateTimeOpened__c = System.now();
              }
           }

         // See if RMA Status should be Closed
         else if ((rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('CLOSED') || rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('N/A'))                                       &&
                  (rmaToProcess.rmaReturnShipmentStatus__c.startsWith('CLOSED')   || rmaToProcess.rmaReturnShipmentStatus__c.startsWith('N/A'))                                         &&
                  (rmaToProcess.rmaRetShip2Status__c   != null && (rmaToProcess.rmaRetShip2Status__c.startsWith('CLOSED')   || rmaToProcess.rmaRetShip2Status__c.startsWith('N/A')))    &&
                  (rmaToProcess.rmaOnsiteTechStatus__c != null && (rmaToProcess.rmaOnsiteTechStatus__c.startsWith('CLOSED') || rmaToProcess.rmaOnsiteTechStatus__c.startsWith('N/A'))))
           {rmaToProcess.rmaStatus__c = 'Closed';
            if (rmaToProcess.rmaDateTimeClosed__c == null)
              {rmaToProcess.rmaDateTimeClosed__c = System.now();
              }
           }

         // See if RMA Status should be Canceled
         else if ((rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('CLOSED') || rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('CANCELED') || rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('N/A'))                                 &&
                  (rmaToProcess.rmaReturnShipmentStatus__c.startsWith('CLOSED')   || rmaToProcess.rmaReturnShipmentStatus__c.startsWith('CANCELED')   || rmaToProcess.rmaReturnShipmentStatus__c.startsWith('N/A'))                                   &&
                  (rmaToProcess.rmaRetShip2Status__c   != null && (rmaToProcess.rmaRetShip2Status__c.startsWith('CLOSED')   || rmaToProcess.rmaRetShip2Status__c.startsWith('CANCELED')   || rmaToProcess.rmaRetShip2Status__c.startsWith('N/A')))    &&
                  (rmaToProcess.rmaOnsiteTechStatus__c != null && (rmaToProcess.rmaOnsiteTechStatus__c.startsWith('CLOSED') || rmaToProcess.rmaOnsiteTechStatus__c.startsWith('CANCELED') || rmaToProcess.rmaOnsiteTechStatus__c.startsWith('N/A'))))
           {rmaToProcess.rmaStatus__c = 'Canceled';
            if (rmaToProcess.rmaDateTimeCanceled__c == null)
              {rmaToProcess.rmaDateTimeCanceled__c = System.now();
              }
           }

         // Set RMA Status to Open as a default if none of the above logic was invoked
         else
           {rmaToProcess.rmaStatus__c = 'Open';
            if (rmaToProcess.rmaDateTimeOpened__c == null)
              {rmaToProcess.rmaDateTimeOpened__c = System.now();
              }
           }

      // ##########################################
      // END LOGIC TO SET RMA STATUS AND TIMESTAMPS
      // ##########################################




      // ###############################################
      // BEGIN LOGIC TO SET OUTGOING SHIPMENT TIMESTAMPS
      // ###############################################

      if (rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('OPEN') &&
          rmaToProcess.rmaOutgoingShipmentDateTimeOpened__c == null)
        {rmaToProcess.rmaOutgoingShipmentDateTimeOpened__c = System.now();
        }
      else if (rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('CLOSED') &&
          rmaToProcess.rmaOutgoingShipmentDateTimeClosed__c == null)
        {rmaToProcess.rmaOutgoingShipmentDateTimeClosed__c = System.now();
        }
      else if (rmaToProcess.rmaOutgoingShipmentStatus__c.startsWith('CANCELED') &&
          rmaToProcess.rmaOutgoingShipmentDateTimeCanceled__c == null)
        {rmaToProcess.rmaOutgoingShipmentDateTimeCanceled__c = System.now();
        }

      // #############################################
      // END LOGIC TO SET OUTGOING SHIPMENT TIMESTAMPS
      // #############################################




      // #############################################
      // BEGIN LOGIC TO SET RETURN SHIPMENT TIMESTAMPS
      // #############################################

      if (rmaToProcess.rmaReturnShipmentStatus__c.startsWith('OPEN') &&
          rmaToProcess.rmaReturnShipmentDateTimeOpened__c == null)
        {rmaToProcess.rmaReturnShipmentDateTimeOpened__c = System.now();
        }
      else if (rmaToProcess.rmaReturnShipmentStatus__c.startsWith('CLOSED') &&
          rmaToProcess.rmaReturnShipmentDateTimeClosed__c == null)
        {rmaToProcess.rmaReturnShipmentDateTimeClosed__c = System.now();
        }
      else if (rmaToProcess.rmaReturnShipmentStatus__c.startsWith('CANCELED') &&
          rmaToProcess.rmaReturnShipmentDateTimeCanceled__c == null)
        {rmaToProcess.rmaReturnShipmentDateTimeCanceled__c = System.now();
        }

      // ###########################################
      // END LOGIC TO SET RETURN SHIPMENT TIMESTAMPS
      // ###########################################




      // #############################################
      // BEGIN LOGIC TO POPULATE ONSITE COMPILED NOTES
      // #############################################

      rmaToProcess.rmaOnsiteCompiledNotes__c = null;

      if (rmaToProcess.rmaType__c == 'Advance replacement' && rmaToProcess.rmaAssetSla__c.contains('Onsite'))
        {// Load asset data, depending on whether the RMA is for a head shelf or disk shelf

         Id rmaAssetToUseId;

         if (rmaToProcess.rmaDiskShelfAsset__c <> null)
           {rmaAssetToUseId = rmaToProcess.rmaDiskShelfAsset__c;
           }
         else
           {List <Case> cases = [SELECT Id, AssetId from Case where Id = :rmaToProcess.rmaCaseNumber__c];

            if (cases[0].AssetId <> null)
              {rmaAssetToUseId = cases[0].AssetId;
              }
            else
              {rmaToProcess.addError('Could not find Asset data (Disk Shelf Asset on RMA, nor Asset on Case).  Cannot save RMA without valid Asset.');
               return;
              }
           }

         List <Asset> assets = [SELECT Id,
                                       Name,
                                       Install_Street1__c,
                                       Install_Street2__c,
                                       Install_City__c,
                                       Install_State_Province__c,
                                       Install_Zip_Code__c,
                                       Install_Country__c,
                                       assetLocBuilding__c,
                                       assetLocFloor__c,
                                       assetLocDatacenter__c,
                                       assetLocAreaOrGrid__c,
                                       assetLocRow__c,
                                       assetLocRack__c,
                                       assetLocPositionInRack__c,
                                       assetOnsiteArrivalStreet1__c,
                                       assetOnsiteArrivalStreet2__c,
                                       assetOnsiteArrivalCity__c,
                                       assetOnsiteArrivalState__c,
                                       assetOnsiteArrivalPostalCode__c,
                                       assetOnsiteArrivalCountry__c,
                                       assetOnsiteSchedulingCode__c,
                                       assetOnsiteSchedulingNotes__c,
                                       assetOnsitePartHandoverCode__c,
                                       assetOnsitePartHandoverNotes__c,
                                       assetOnsiteCheckInCode__c,
                                       assetOnsiteCheckInNotes__c,
                                       assetOnsitePartDispositionCode__c,
                                       assetOnsitePartDispositionNotes__c
                                from   Asset
                                where  Id = :rmaAssetToUseId];

         rmaToProcess.rmaOnsiteCompiledNotes__c =
           'ONSITE SERVICE ORDER DATA\n\n' +
           '*** COMMAND CENTER INSTRUCTIONS ***\n\n' +
           'Scheduling Code: ' + rmaToProcess.rmaOnsiteSchedulingCode__c + '\n' +
           'Scheduling Notes: ' + rmaToProcess.rmaOnsiteSchedulingNotes__c + '\n\n' +
           '*** PART COURIER INSTRUCTIONS ***\n\n' +
           'Shipment Address:\n' +
           rmaToProcess.rmaShipmentStreet1__c + '\n' +
           rmaToProcess.rmaShipmentStreet2__c + '\n' +
           rmaToProcess.rmaShipmentCity__c + ', ' +
             rmaToProcess.rmaShipmentState__c + ' ' +
             rmaToProcess.rmaShipmentPostalCode__c + ' ' +
             rmaToProcess.rmaShipmentCountry__c + '\n' +
           'Attn: ' + rmaToProcess.rmaShipmentAttn__c + '\n' +
           'Phone: ' + rmaToProcess.rmaShipmentPhone__c + '\n' +
           'Email: ' + rmaToProcess.rmaShipmentEmail__c + '\n\n' +
           'Part Handover Code: ' + rmaToProcess.rmaOnsitePartHandoverCode__c + '\n' +
           'Part Handover Notes: ' + rmaToProcess.rmaOnsitePartHandoverNotes__c + '\n\n' +
           '*** FE INSTRUCTIONS ***\n\n' +
           'FE Arrival Address:\n' +
           rmaToProcess.rmaOnsiteArrivalStreet1__c + '\n' +
           rmaToProcess.rmaOnsiteArrivalStreet2__c + '\n' +
           rmaToProcess.rmaOnsiteArrivalCity__c + ', ' +
             rmaToProcess.rmaOnsiteArrivalState__c + ' ' +
             rmaToProcess.rmaOnsiteArrivalPostalCode__c + ' ' +
             rmaToProcess.rmaOnsiteArrivalCountry__c + '\n\n' +
           'FE Check-In Code: ' + rmaToProcess.rmaOnsiteCheckInCode__c + '\n' +
           'FE Check-In Notes: ' + rmaToProcess.rmaOnsiteCheckInNotes__c + '\n\n' +
           'Refer to the PART COURIER INSTRUCTIONS, above, to determine where the part courier left the part, and go pick it up.\n\n' +
           'Asset Install Address:\n' +
           assets[0].Install_Street1__c + '\n' +
           assets[0].Install_Street2__c + '\n' +
           assets[0].Install_City__c + ', ' +
             assets[0].Install_State_Province__c + ' ' +
             assets[0].Install_Zip_Code__c + ' ' +
             assets[0].Install_Country__c + '\n\n' +
           'Asset Specific Location (these fields are optional, and may not be populated):\n' +
           'Building: ' + rmaToProcess.rmaAssetLocBuilding__c + '\n' +
           'Floor: ' + rmaToProcess.rmaAssetLocFloor__c + '\n' +
           'Datacenter: ' + rmaToProcess.rmaAssetLocDatacenter__c + '\n' +
           'Area/Grid: ' + rmaToProcess.rmaAssetLocAreaOrGrid__c + '\n' +
           'Row: ' + rmaToProcess.rmaAssetLocRow__c + '\n' +
           'Rack: ' + rmaToProcess.rmaAssetLocRack__c + '\n' +
           'Position In Rack: ' + rmaToProcess.rmaAssetLocPositionInRack__c + '\n' +
           'Asset Serial Number: ' + assets[0].Name + '\n\n' +
           'Slot Information (for components that are slot-specific):\n' +
           'Controller/Expander: ' + rmaToProcess.rmaOnsiteControllerExpanderSlot__c + '\n' +
           'HDD/SSD: ' + rmaToProcess.rmaOnsiteHddSsdSlot__c + '\n' +
           'Power Supply: ' + rmaToProcess.rmaOnsitePowerSupplySlot__c + '\n' +
           'NIC Card:' + rmaToProcess.rmaOnsiteNicCardSlot__c + '\n\n' +
           'Part Disposition Code: ' + rmaToProcess.rmaOnsitePartDispositionCode__c + '\n' +
           'Part Disposition Notes: ' + rmaToProcess.rmaOnsitePartDispositionNotes__c + '\n\n' +
           '(end of ONSITE SERVICE ORDER DATA)';
        }

      // ###########################################
      // END LOGIC TO POPULATE ONSITE COMPILED NOTES
      // ###########################################




      // #############################################
      // BEGIN LOGIC TO POPULATE DELIVERY INSTRUCTIONS
      // #############################################

      String tmpRmaDeliveryInstructions;

      rmaToProcess.rmaDeliveryInstructions__c = '';

      if (rmaToProcess.rmaType__c == 'Advance replacement' && rmaToProcess.rmaTransmitRmaShisWithOrder__c != null)
        {String[] rmaTransmitRmaShisWithOrderValues = rmaToProcess.rmaTransmitRmaShisWithOrder__c.split(';');

         // Loop through each value in the multi-select picklist
         for (String rmaTransmitRmaShisWithOrderValue : rmaTransmitRmaShisWithOrderValues)
           {System.debug('DEBUG rmaTransmitRmaShisWithOrderValue = ' + rmaTransmitRmaShisWithOrderValue);

            // Add Account RMA SHI (if selected)
            if (rmaTransmitRmaShisWithOrderValue == 'Account RMA SHI')
              {List <Case> cases = [SELECT Id, AccountId from Case where Id = :rmaToProcess.rmaCaseNumber__c];

               if (cases[0].AccountId == null)
                 {rmaToProcess.addError('RMA Case has no Account.  Cannot save RMA without valid Account on the Case.');
                  return;
                 }

               List <Account> accounts = [SELECT Id, accountRmaShi__c from Account where Id = :cases[0].AccountId];

               if (accounts[0].accountRmaShi__c != null)
                 {tmpRmaDeliveryInstructions              = rmaToProcess.rmaDeliveryInstructions__c + 'Account RMA SHI:\n' + accounts[0].accountRmaShi__c + '\n\n';
                  rmaToProcess.rmaDeliveryInstructions__c = tmpRmaDeliveryInstructions.left(2000);
                 }
              }

            // Add Asset RMA SHI (if selected)
            else if (rmaTransmitRmaShisWithOrderValue == 'Asset RMA SHI')
              {List <Asset> assets;

               if (rmaToProcess.rmaDiskShelfAsset__c == null)
                 {List <Case> cases = [SELECT Id, AssetId from Case where Id = :rmaToProcess.rmaCaseNumber__c];

                  if (cases[0].AssetId == null)
                    {rmaToProcess.addError('RMA Case has no Asset.  Cannot save RMA without valid Asset on the Case.');
                     return;
                    }

                  assets = [SELECT Id, assetRmaShi__c from Asset where Id = :cases[0].AssetId];
                 }
               else
                 {assets = [SELECT Id, assetRmaShi__c from Asset where Id = :rmaToProcess.rmaDiskShelfAsset__c];
                 }

               if (assets[0].assetRmaShi__c != null)
                 {tmpRmaDeliveryInstructions              = rmaToProcess.rmaDeliveryInstructions__c + 'Asset RMA SHI:\n' + assets[0].assetRmaShi__c + '\n\n';
                  rmaToProcess.rmaDeliveryInstructions__c = tmpRmaDeliveryInstructions.left(2000);
                 }
              }

            // Add RMA SHI (if selected)
            else if (rmaTransmitRmaShisWithOrderValue == 'RMA SHI')
              {tmpRmaDeliveryInstructions              = rmaToProcess.rmaDeliveryInstructions__c + 'RMA SHI:\n' + rmaToProcess.rmaShi__c + '\n\n';
               rmaToProcess.rmaDeliveryInstructions__c = tmpRmaDeliveryInstructions.left(2000);
              }

           }
        }

      // ###########################################
      // END LOGIC TO POPULATE DELIVERY INSTRUCTIONS
      // ###########################################




     }
  }