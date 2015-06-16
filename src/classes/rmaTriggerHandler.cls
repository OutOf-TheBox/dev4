public class rmaTriggerHandler extends TriggerHandler {
    
    //Following Map and Set are used to store all the data needed, before processing the bulk RMA data
    private static Map<String, String> mapPartNumbers;
    private static Map<String, depotMapNbdNd__c> depotMapNbdNd = new Map<String, depotMapNbdNd__c>();
    private static Map<String, depotMap4Hour__c> depotMap4Hour = new Map<String, depotMap4Hour__c>();
    private static Map<Id, Asset> assetMap = new Map<Id, Asset>();
    private static Map<Id, Case> caseMap = new Map<Id, Case>() ;
    private static Map<Id, Account> accountMap = new Map<Id, Account>();
    private static Set<Id> rmaAssetToUseIds = new Set<Id>();
    private static Set<Id> rmaAccountToUseIds = new Set<Id>();
    private static Map<String, List<PostalCode__c>> postalCodeMap = new Map<String, List<PostalCode__c>>();
    
    private static Map<Id,RMAv2__c> rmaMap = new Map<Id,RMAv2__c>();
    private static Map<String,AddressBook__c> mapExistingAbRecords = new Map<String,AddressBook__c>(); 
    
    //Constructor(called only when class is initialized)
    public rmaTriggerHandler() {
      
    }

    public static void bulkQueries()
    {
       //This Map consist of the PartNumber of HDD and SSD Assignments 
       getHddSsdPartNumberAssignment();

       //This Map consists of the Postal Code data
       getPostalCodeMap();

       //This Set Used to the collect all the Countries in the incoming records
       Set<String> sSoqlCountries = new Set<String>();

       //This Set Used to the collect all the States in the incoming records
       Set<String> sSoqlStates = new Set<String>(); 

       //This Set Used to the collect all the TempKeyPatterns in the incoming records(used in 4 hour logic)
       Set<String> sTemp4HourKeyPatterns = new Set<String>();

       //This Set Used to the collect all the rmaCaseNumber in the incoming records(used in Onsite Compiled Notes etc.,)
       Set<Id> rmaCaseIds = new Set<Id>();

       //Ensure the Trigger is Before 
       if(Trigger.isBefore) 
       {
            //Looping through the incoming RMA Records 
            //Storing the required SET Values respectively(These SET used in bulk soql Query Processing)
            for(RMAv2__c rmas:(List<RMAv2__c>) Trigger.new)
            {
               //Check the current RMA record Postal code is Valid. If valid collect the Value in respective SET else Skip
               //rmaVerifyCountryAndPostalCode method needed to called here bzoc postal code format is required for quering 4HourDepot
               //Example if postal code is "22222-2222", the rmaVerifyCountryAndPostalCode method return "22222"(used for getting 4HourDepot Record)
               String soqlPostalCode = rmaVerifyCountryAndPostalCode(rmas); 
               if(soqlPostalCode != '')
               {
                   string soqlCountry = rmas.rmaShipmentCountry__c;
                   soqlCountry = soqlCountry.replaceAll(' \\([A-Z]{2}\\)$', '');
                   sSoqlCountries.add(soqlCountry);
                   sSoqlStates.add(rmas.rmaShipmentState__c);                  
                   sTemp4HourKeyPatterns.add('\\_\\_' + soqlCountry + '\\_\\_' + soqlPostalCode + '\\_\\_%');//Set Forms SOQL like statement with bulk records
                   rmaAssetToUseIds.add(rmas.rmaDiskShelfAsset__c);
                   rmaCaseIds.add(rmas.rmaCaseNumber__c);
                   
               }
                else
                {
                    return;
                }
               
            }
       }
        

        //Using Collected SET values - quering the following object used in RMA process and store the result data in the respective map's
        //The collected Map value are used in processing bulk records one by one
        getDepotMapNbdNd(sSoqlCountries,sSoqlStates);        
        getDepotMap4Hour(sTemp4HourKeyPatterns);        
        getCaseMap(rmaCaseIds);
        getAssetMap(); 
        getAccountMap();
        
    }
    
     /**
     * beforeInsert
     *
     * This method is called iteratively for each record to be inserting during a BEFORE
     * trigger.
     */
     public override void beforeInsert() {
         
         //Process all the Assignments and SOQL Queries prior execution of bulk RMA data 
        //and store it in the respective map's and set's
        bulkQueries();
         
          for (SObject so : Trigger.new)
          {              
               RMAv2__c rmaToProcess = (RMAv2__c)so;
               rmaMain(rmaToProcess);
          }
     }
    
    /**
     * beforeUpdate
     *
     * This method is called iteratively for each record to be updating during a BEFORE
     * trigger.
     */
     public override void beforeUpdate() {
         
        //Process all the Assignments and SOQL Queries prior execution of bulk RMA data 
        //and store it in the respective map's and set's
        bulkQueries();
           
         for (SObject so : Trigger.new)
          {              
               RMAv2__c rmaToProcess = (RMAv2__c)so;
               rmaMain(rmaToProcess);
          }
     }
    
    
    /**
     * afterInsert
     */
     //public override void afterInsert() {
         //Insert entries to the address book if does not exit, after Inserting RMA records(bulk)
         //rmaTriggerEntriesToAddressBook();
     //}
    
    /**
     * afterUpdate
     */
     //public override void afterUpdate() {
         //Insert entries to the address book if does not exit, after Updating RMA records(bulk)
         //rmaAfterUpdateMain();
     //}
       
    //Bulk - HDD and SSD Part Assignment
     public static void getHddSsdPartNumberAssignment()
    {
        
         mapPartNumbers = new Map<String, String>
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
         'SSD_H85_Before'    => '1600GB SATA SSD [SR-SSD-1600GB]',
         'SSD_H85_After'     => '1600GB SATA SSD [SR-SSD-1600GB]',
         'SSD_H90T_Before'   => '1920GB SATA SSD [SR-SSD-1920GB]',
         'SSD_H90T_After'    => '1920GB SATA SSD [SR-SSD-1920GB]',
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
         'SSD_6400F_Before'  => '1600GB SATA SSD [SR-SSD-1600GB]',
         'SSD_6400F_After'   => '1600GB SATA SSD [SR-SSD-1600GB]',
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
         'SSD_1600GB_Before' => '1600GB SATA SSD [SR-SSD-1600GB]',
         'SSD_1600GB_After'  => '1600GB SATA SSD [SR-SSD-1600GB]'};
              
    }
    
    //Bulk - Quering NBDND object with the collected set values
    public static void getDepotMapNbdNd(Set<String> sSoqlCountries,Set<String> sSoqlStates)
    {
        //'N/A' is a default value
        sSoqlStates.add('N/A');
      
        for(depotMapNbdNd__c dptMapNbdNd:[SELECT depotMapNbdNd_NbdDepot__r.Name,
                      depotMapNbdNd_NbdDepot__r.depotProvider__c,
                      depotMapNbdNd_NdDepot__r.Name,
                      depotMapNbdNd_NdDepot__r.depotProvider__c,depotMapNbdNdCountry__c,depotMapNbdNdState__c 
                 FROM   depotMapNbdNd__c
                 WHERE  depotMapNbdNdCountry__c In :sSoqlCountries and
                        depotMapNbdNdState__c  In  :sSoqlStates])
        {
            String mapKey = '__' + dptMapNbdNd.depotMapNbdNdCountry__c + '__' + dptMapNbdNd.depotMapNbdNdState__c + '__';
            
            if (!depotMapNbdNd.containsKey(mapKey))             
             depotMapNbdNd.put(mapKey, dptMapNbdNd);
        }
        
    }
    
    //Bulk - Quering 4Hour object with the collected set values
    public static void getDepotMap4Hour(Set<String> sTemp4HourKeyPatterns)
    {
        for(depotMap4Hour__c dptMap4Hour: [SELECT   depotMap4Hour_4HourDepot__r.Name,
                        depotMap4Hour_4HourDepot__r.depotProvider__c,
                        depotMap4HourMiles__c,depotMap4HourKey__c,depotMap4HourCountry__c,depotMap4HourPostalCode__c
               FROM     depotMap4Hour__c
               WHERE    depotMap4HourKey__c LIKE :sTemp4HourKeyPatterns and
                        depotMap4Hour_4HourDepot__r.depotStockedFor4Hour__c = 'Yes'
               ORDER BY depotMap4HourDriveTime__c ASC NULLS LAST])
        {
            
             String mapKey = '__' +dptMap4Hour.depotMap4HourCountry__c + '__' + dptMap4Hour.depotMap4HourPostalCode__c + '__';
           
             if (!depotMap4Hour.containsKey(mapKey))             
             depotMap4Hour.put(mapKey, dptMap4Hour);

        }
    }
    
    //Bulk - Quering Case object with the collected set values
    public static void getCaseMap(Set<Id> rmaCaseNumber)
    {   
         for(Case cse:[SELECT Id, AssetId,AccountId from Case where Id In :rmaCaseNumber])
         {
             caseMap.put(cse.Id, cse);
             rmaAssetToUseIds.add(cse.AssetId);
             rmaAccountToUseIds.add(cse.AccountId);
         }
    }
    
    //Bulk - Quering Asset object with the collected set values
    public static void getAssetMap()
    {
         for(Asset assets:[SELECT Id,
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
                                       assetOnsitePartDispositionNotes__c,
                                       assetRmaShi__c
                                from   Asset
                                where  Id In :rmaAssetToUseIds])
         {
             assetMap.put(assets.Id, assets);
         }
        
    }
    
    //Bulk - Quering Account object with the collected set values
    public static void getAccountMap()
    {
        for(Account acc:[SELECT Id, accountRmaShi__c from Account where Id In :rmaAccountToUseIds])
         {
             accountMap.put(acc.Id, acc);
         } 
    }
    
    
    //Bulk - Quering PostalCode object
    public static void getPostalCodeMap()
    {
       List<PostalCode__c> pc = [SELECT Id, pcErrorMessage__c,pcCountry__c,pcFormatInRegex__c,pcDummyPostalCode__c from PostalCode__c order by pcCountry__c];
       for(Integer i=0; i< pc.size(); i++)
       {
           List<PostalCode__c> lstCurrentPc = new List<PostalCode__c>();
           lstCurrentPc.add(pc[i]);
           
           //United kingdom has 2 format, so storing the country "United Kingdom" as key and the values for the key would be 2 values for United kingdom Record.
           //Example: Key - United Kingdom
           //Value - List of 2 United Kingdom Records
           //
           //For Rest of the country:
           //Example: Key - United States
           //Value - List of 1 United State Record
           if(postalCodeMap.containsKey(pc[i].pcCountry__c))
           {
              List<PostalCode__c> lstExistingPc = postalCodeMap.get(pc[i].pcCountry__c);
              lstExistingPc.add(pc[i]);
              postalCodeMap.put(pc[i].pcCountry__c,lstExistingPc);
           }
           else
           {
                postalCodeMap.put(pc[i].pcCountry__c,lstCurrentPc);               
           }
       }
    }
    
    //All the incoming RMA Records are processed here one by one
    //While processing the current RMA Records looks for the collected MAP whenever required - eliminating SOQL Query
     public static void rmaMain(RMAv2__c rmaToProcess)
    {
        String soqlPostalCode = rmaVerifyCountryAndPostalCode(rmaToProcess);
        
        if(soqlPostalCode != '')
        {
            rmaSetFa(rmaToProcess);
            rmaAssignHddAndSsdPartNumbers(rmaToProcess);
            rmaAssignProviderAndDepot(rmaToProcess,soqlPostalCode);
            rmaSetStatusAndTimestamps(rmaToProcess);
            rmaSetOutgoingShipmentTimeStamps(rmaToProcess);
            rmaSetReturnShipmentTimestamps(rmaToProcess);
            rmaPopulateOnsiteCompiledNotes(rmaToProcess);
            rmaPopulateDeliveryInstructions(rmaToProcess);
        }
        else
        {
            return;
        }
    }
    
    public static string rmaVerifyCountryAndPostalCode(RMAv2__c rmaToProcess)
    {
      // #############################################
      // BEGIN LOGIC TO VERIFY COUNTRY AND POSTAL CODE
      // #############################################

      // Throw error if Address Book is null/blank
      // 
      //if (rmaToProcess.rmaAddressBook__c == null)
        //{rmaToProcess.rmaAddressBook__c.addError('You must enter a value');
         //return '';
        //}

      // Throw error if Shipment Country is null/blank
      // 
      if (rmaToProcess.rmaShipmentCountry__c == null)
        {rmaToProcess.rmaShipmentCountry__c.addError('Based on your address selections, the "Shipment Country" will be blank.  This field cannot be blank.  Override it if needed to provide a valid value.');
         system.debug('DEBUG: Found null Shipment Country');
         return '';
        }

      // Remove any two-letter country codes at the end of the Shipment Country

      String soqlCountry = rmaToProcess.rmaShipmentCountry__c;
      soqlCountry = soqlCountry.replaceAll(' \\([A-Z]{2}\\)$', '');
      
      //Lookup to NBD/ND Depot - State
      String soqlState = rmaToProcess.rmaShipmentState__c;
      

      // Throw error if Shipment Postal Code is null/blank

      if (rmaToProcess.rmaShipmentPostalCode__c == null)
        {rmaToProcess.rmaShipmentPostalCode__c.addError('Based on your address selections, the "Shipment Postal Code" will be blank.  This field cannot be blank.  Override it if needed to provide a valid value.');
          return '';
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

      //Check the incoming Country exist in Postal Code map 
      //
      if (postalCodeMap.containsKey(soqlCountry)) 
      {
          Matcher matcherPostalCode;
          
          //Based on the key(incoming country) get the list of values from Postal Code map
          List<PostalCode__c> lstPcRecord = postalCodeMap.get(soqlCountry);
          
          if(lstPcRecord.size() > 0)
          {
              //Ispassed boolean value - determine the the country has a valid Postal Code or not
              Boolean Ispassed = false;
              String errorPostalCodeMsg = '';
              //Loop through the lst record returned from postal code map
              //United kingdom records iterates 2 times
              //Rest of the country iterate 1 time in the following loop
              for(Integer i=0; i<lstPcRecord.size();i++)
              {
                  if(lstPcRecord[i].pcDummyPostalCode__c != null)
                      soqlPostalCode = lstPcRecord[i].pcDummyPostalCode__c;
                  
                  errorPostalCodeMsg = lstPcRecord[i].pcErrorMessage__c;

                  Pattern patternPostalCode  = Pattern.compile(lstPcRecord[i].pcFormatInRegex__c);
                  matcherPostalCode = patternPostalCode.matcher(soqlPostalCode);
                  if (matcherPostalCode.matches())
                  {
                      soqlPostalCode = matcherPostalCode.group(1);
                      Ispassed = true;
                      break;
                  }
              }
              //When the country has a invalid Postal Code throws an error
              if(Ispassed == false)
              {
                  rmaToProcess.rmaShipmentPostalCode__c.addError(errorPostalCodeMsg);
                  return ''; 
              }
          }
        }
        
        return soqlPostalCode;

      // ###########################################
      // END LOGIC TO VERIFY COUNTRY AND POSTAL CODE
      // ###########################################
    }
    
    public static void rmaAssignHddAndSsdPartNumbers(RMAv2__c rmaToProcess)
    {
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
         else if (rmaToProcess.rmaModel__c.contains('H85'))
           {mapKeyModel = 'H85';
           }
         else if (rmaToProcess.rmaModel__c.contains('H90T'))
           {mapKeyModel = 'H90T';
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


    
    }
    
    public static void rmaAssignProviderAndDepot(RMAv2__c rmaToProcess,String soqlPostalCode)
    {
      // ###########################################
      // BEGIN LOGIC TO DETERMINE PROVIDER AND DEPOT
      // ###########################################
      
      String soqlCountry =rmaToProcess.rmaShipmentCountry__c;
      soqlCountry = soqlCountry.replaceAll(' \\([A-Z]{2}\\)$', '');
      String soqlState=rmaToProcess.rmaShipmentState__c;
      
      String NbdNdMapKey = '__' + soqlCountry + '__' + soqlState + '__';
      //Logic to check the current State is available in depot
        
      if(!depotMapNbdNd.containsKey(NbdNdMapKey))
      {
          //State depot not available - set the default state as 'N/A'
          NbdNdMapKey = '__' + soqlCountry + '__N/A__';
      }
        
      if (rmaToProcess.rmaType__c == 'Advance replacement' && rmaToProcess.rmaPart__c.contains('[SR'))
        {// Old logic prior to onsite service changes
         //  if (rmaToProcess.rmaShipmentSla__c.contains('4-Hour'))

         // New logic for onsite service changes

         rmaToProcess.rma4HourDepotDistanceMiles__c = null;

         if (rmaToProcess.rmaAssetSla__c.contains('4-Hour') || rmaToProcess.rmaUplift__c.contains('4-Hour'))
           {String tempKeyPattern = '__' + soqlCountry + '__' + soqlPostalCode + '__';

            if (depotMap4Hour.containsKey(tempKeyPattern))
              {
               depotMap4Hour__c map4Hour = depotMap4Hour.get(tempKeyPattern);  
               rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = map4Hour.depotMap4Hour_4HourDepot__r.depotProvider__c;
               rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = map4Hour.depotMap4Hour_4HourDepot__r.Name;
               rmaToProcess.rma4HourDepotDistanceMiles__c            = map4Hour.depotMap4HourMiles__c;
               rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'Yes';
              }
            else
              {
               if (depotMapNbdNd.containsKey(NbdNdMapKey))
                 {
                  depotMapNbdNd__c mapNbdNd = depotMapNbdNd.get(NbdNdMapKey);
                  rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = mapNbdNd.depotMapNbdNd_NdDepot__r.depotProvider__c;
                  rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = mapNbdNd.depotMapNbdNd_NdDepot__r.Name;
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
           {
            if (depotMapNbdNd.containsKey(NbdNdMapKey) && rmaToProcess.rmaShipmentSla__c == 'Next Day')
              {
               depotMapNbdNd__c mapNbdNd = depotMapNbdNd.get(NbdNdMapKey);
               rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = mapNbdNd.depotMapNbdNd_NdDepot__r.depotProvider__c;
               rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = mapNbdNd.depotMapNbdNd_NdDepot__r.Name;
               rmaToProcess.rmaOutgoingShipmentOrder4HrDepotFound__c = 'N/A';
              }
            else if (depotMapNbdNd.containsKey(NbdNdMapKey))
              {
               depotMapNbdNd__c mapNbdNd = depotMapNbdNd.get(NbdNdMapKey);   
               rmaToProcess.rmaOutgoingShipmentOrderProvider__c      = mapNbdNd.depotMapNbdNd_NbdDepot__r.depotProvider__c;
               rmaToProcess.rmaOutgoingShipmentOrderDepot__c         = mapNbdNd.depotMapNbdNd_NbdDepot__r.Name;
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

    }
    
    
     public static void rmaSetStatusAndTimestamps(RMAv2__c rmaToProcess)
     {
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

     }
    
    public static void rmaSetOutgoingShipmentTimeStamps(RMAv2__c rmaToProcess)
     {
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
     }
    
     public static void rmaSetReturnShipmentTimestamps(RMAv2__c rmaToProcess)
    {
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
    }
    
    public static void rmaPopulateOnsiteCompiledNotes(RMAv2__c rmaToProcess)
    {
       // #############################################
      // BEGIN LOGIC TO POPULATE ONSITE COMPILED NOTES
      // #############################################

      rmaToProcess.rmaOnsiteCompiledNotes__c = null;
      Case caseRecord = null;
      if (rmaToProcess.rmaType__c == 'Advance replacement' && rmaToProcess.rmaAssetSla__c.contains('Onsite'))
        {// Load asset data, depending on whether the RMA is for a head shelf or disk shelf

         Id rmaAssetToUseKey;

         if (rmaToProcess.rmaDiskShelfAsset__c <> null)
           {
               rmaAssetToUseKey = rmaToProcess.rmaDiskShelfAsset__c;
           }
         else
           {
             if (caseMap.containsKey(rmaToProcess.rmaCaseNumber__c))
             caseRecord = caseMap.get(rmaToProcess.rmaCaseNumber__c);  

            if (caseRecord.AssetId <> null)
              {rmaAssetToUseKey = caseRecord.AssetId;
              }
            else
              {rmaToProcess.addError('Could not find Asset data (Disk Shelf Asset on RMA, nor Asset on Case).  Cannot save RMA without valid Asset.');
               return;
              }
           }

         Asset assetRecord = assetMap.get(rmaAssetToUseKey);  
           
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
           assetRecord.Install_Street1__c + '\n' +
           assetRecord.Install_Street2__c + '\n' +
           assetRecord.Install_City__c + ', ' +
             assetRecord.Install_State_Province__c + ' ' +
             assetRecord.Install_Zip_Code__c + ' ' +
             assetRecord.Install_Country__c + '\n\n' +
           'Asset Specific Location (these fields are optional, and may not be populated):\n' +
           'Building: ' + rmaToProcess.rmaAssetLocBuilding__c + '\n' +
           'Floor: ' + rmaToProcess.rmaAssetLocFloor__c + '\n' +
           'Datacenter: ' + rmaToProcess.rmaAssetLocDatacenter__c + '\n' +
           'Area/Grid: ' + rmaToProcess.rmaAssetLocAreaOrGrid__c + '\n' +
           'Row: ' + rmaToProcess.rmaAssetLocRow__c + '\n' +
           'Rack: ' + rmaToProcess.rmaAssetLocRack__c + '\n' +
           'Position In Rack: ' + rmaToProcess.rmaAssetLocPositionInRack__c + '\n' +
           'Asset Serial Number: ' + assetRecord.Name + '\n\n' +
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

    }
    
    public static void rmaPopulateDeliveryInstructions(RMAv2__c rmaToProcess)
    {
      // #############################################
      // BEGIN LOGIC TO POPULATE DELIVERY INSTRUCTIONS
      // #############################################

      String tmpRmaDeliveryInstructions;

      rmaToProcess.rmaDeliveryInstructions__c = '';

      Case caseRecord = null;
      Account accountRecord = null;
      Asset assetRecord = null;

      if (rmaToProcess.rmaType__c == 'Advance replacement' && rmaToProcess.rmaTransmitRmaShisWithOrder__c != null)
        {String[] rmaTransmitRmaShisWithOrderValues = rmaToProcess.rmaTransmitRmaShisWithOrder__c.split(';');

         // Loop through each value in the multi-select picklist
         for (String rmaTransmitRmaShisWithOrderValue : rmaTransmitRmaShisWithOrderValues)
           {System.debug('DEBUG rmaTransmitRmaShisWithOrderValue = ' + rmaTransmitRmaShisWithOrderValue);

            // Add Account RMA SHI (if selected)
            if (rmaTransmitRmaShisWithOrderValue == 'Account RMA SHI')
              {
                 if (caseMap.containsKey(rmaToProcess.rmaCaseNumber__c))
                    caseRecord = caseMap.get(rmaToProcess.rmaCaseNumber__c);  

               if (caseRecord.AccountId == null)
                 {rmaToProcess.addError('RMA Case has no Account.  Cannot save RMA without valid Account on the Case.');
                  return;
                 }

               if (accountMap.containsKey(caseRecord.AccountId))
               accountRecord = accountMap.get(caseRecord.AccountId); 

               if (accountRecord.accountRmaShi__c != null)
                 {tmpRmaDeliveryInstructions              = rmaToProcess.rmaDeliveryInstructions__c + 'Account RMA SHI:\n' + accountRecord.accountRmaShi__c + '\n\n';
                  rmaToProcess.rmaDeliveryInstructions__c = tmpRmaDeliveryInstructions.left(2000);
                 }
              }

            // Add Asset RMA SHI (if selected)
            else if (rmaTransmitRmaShisWithOrderValue == 'Asset RMA SHI')
              {
               if (rmaToProcess.rmaDiskShelfAsset__c == null)
                 {
                  if (caseMap.containsKey(rmaToProcess.rmaCaseNumber__c))
                  caseRecord = caseMap.get(rmaToProcess.rmaCaseNumber__c); 

                  if (caseRecord.AssetId == null)
                    {rmaToProcess.addError('RMA Case has no Asset.  Cannot save RMA without valid Asset on the Case.');
                     return;
                    }
                  if (assetMap.containsKey(caseRecord.AssetId))   
                  assetRecord = assetMap.get(caseRecord.AssetId); 
                 }
               else
                 {
                      if (assetMap.containsKey(rmaToProcess.rmaDiskShelfAsset__c))
                      assetRecord = assetMap.get(rmaToProcess.rmaDiskShelfAsset__c); 
                 }

               if (assetRecord.assetRmaShi__c != null)
                 {tmpRmaDeliveryInstructions              = rmaToProcess.rmaDeliveryInstructions__c + 'Asset RMA SHI:\n' + assetRecord.assetRmaShi__c + '\n\n';
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

   public static void rmaSetFa(RMAv2__c rmaToProcess)
     {
      // ##################################################
      // BEGIN LOGIC TO SET FA (FAILURE ANALYSIS) VARIABLES
      // ##################################################

      String newFaLogicHistory;

      System.debug('DEBUG: ****************************************');
      System.debug('DEBUG: Timestamp                           = ' + System.now());
      System.debug('DEBUG: User ID                             = ' + UserInfo.getUserId());
      System.debug('DEBUG: User Name                           = ' + UserInfo.getName());
      System.debug('DEBUG: INPUTS:');
      System.debug('DEBUG: rmaType__c                          = ' + rmaToProcess.rmaType__c);
      System.debug('DEBUG: rmaAssetNrdIsInEffect__c            = ' + rmaToProcess.rmaAssetNrdIsInEffect__c);
      System.debug('DEBUG: rmaPartIsAShipOnlyPart__c           = ' + rmaToProcess.rmaPartIsAShipOnlyPart__c);
      System.debug('DEBUG: rmaAssetSla__c                      = ' + rmaToProcess.rmaAssetSla__c);
      System.debug('DEBUG: rmaCaseIsEngOrExecEscalated__c      = ' + rmaToProcess.rmaCaseIsEngOrExecEscalated__c);
      System.debug('DEBUG: rmaComponent__c                     = ' + rmaToProcess.rmaComponent__c);
      System.debug('DEBUG: rmaPartFailedWithinOpsTimePeriod__c = ' + rmaToProcess.rmaPartFailedWithinOpsTimePeriod__c);
      System.debug('DEBUG: rmaFaRequired__c                    = ' + rmaToProcess.rmaFaRequired__c);
      System.debug('DEBUG: rmaOutgoingShipmentStatus__c        = ' + rmaToProcess.rmaOutgoingShipmentStatus__c);
      System.debug('DEBUG: rmaReturnShipmentStatus__c          = ' + rmaToProcess.rmaReturnShipmentStatus__c);
      System.debug('DEBUG: rmaRetShip2Status__c                = ' + rmaToProcess.rmaRetShip2Status__c);
      System.debug('DEBUG: rmaCustomerFaRequired__c            = ' + rmaToProcess.rmaCustomerFaRequired__c);
      System.debug('DEBUG: LOGIC DECISIONS:');

      newFaLogicHistory = rmaToProcess.rmaFaLogicHistory__c +
                          '\n****************************************\n' +
                          'Timestamp                           = ' + System.now() + '\n' +
                          'User ID                             = ' + UserInfo.getUserId() + '\n' +
                          'User Name                           = ' + UserInfo.getName() + '\n' +
                          'INPUTS:\n' +
                          'rmaType__c                          = ' + rmaToProcess.rmaType__c + '\n' +
                          'rmaAssetNrdIsInEffect__c            = ' + rmaToProcess.rmaAssetNrdIsInEffect__c + '\n' +
                          'rmaPartIsAShipOnlyPart__c           = ' + rmaToProcess.rmaPartIsAShipOnlyPart__c + '\n' +
                          'rmaAssetSla__c                      = ' + rmaToProcess.rmaAssetSla__c + '\n' +
                          'rmaCaseIsEngOrExecEscalated__c      = ' + rmaToProcess.rmaCaseIsEngOrExecEscalated__c + '\n' +
                          'rmaComponent__c                     = ' + rmaToProcess.rmaComponent__c + '\n' +
                          'rmaPartFailedWithinOpsTimePeriod__c = ' + rmaToProcess.rmaPartFailedWithinOpsTimePeriod__c + '\n' +
                          'rmaFaRequired__c                    = ' + rmaToProcess.rmaFaRequired__c + '\n' +
                          'rmaOutgoingShipmentStatus__c        = ' + rmaToProcess.rmaOutgoingShipmentStatus__c + '\n' +
                          'rmaReturnShipmentStatus__c          = ' + rmaToProcess.rmaReturnShipmentStatus__c + '\n' +
                          'rmaRetShip2Status__c                = ' + rmaToProcess.rmaRetShip2Status__c + '\n' +
                          'rmaCustomerFaRequired__c            = ' + rmaToProcess.rmaCustomerFaRequired__c + '\n' +
                          'LOGIC DECISIONS:\n';

       // Type = "System/part return"
       if (rmaToProcess.rmaType__c == 'System/part return')
         {System.debug('DEBUG: HERE 0100 - Type = "System/part return"');
          newFaLogicHistory += 'HERE 0100 - Type = "System/part return"\n';

          rmaToProcess.rmaOrderType__c          = 'System/part return';
          rmaToProcess.rmaFaRequired__c         = 'No FA Required';
          rmaToProcess.rmaCustomerFaRequired__c = false;
         }

       // Asset NRD is in Effect
       else if (rmaToProcess.rmaAssetNrdIsInEffect__c == 'Yes')
         {System.debug('DEBUG: HERE 0200 - Asset NRD is in Effect');
          newFaLogicHistory += 'HERE 0200 - Asset NRD is in Effect\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Ship Only w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Ship Only';
            }

          rmaToProcess.rmaFaRequired__c           = 'No FA Required';
          rmaToProcess.rmaReturnShipmentStatus__c = 'N/A-10: No part to ship for this RMA Type';
          rmaToProcess.rmaRetShip2Status__c       = 'N/A-10: No part to ship for this RMA Type';
          rmaToProcess.rmaCustomerFaRequired__c   = false;
         }

       // Part is a Ship Only Part
       else if (rmaToProcess.rmaPartIsAShipOnlyPart__c == 'Yes')
         {System.debug('DEBUG: HERE 0300 - Part is a Ship Only Part');
          newFaLogicHistory += 'HERE 0300 - Part is a Ship Only Part\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Ship Only w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Ship Only';
            }

          rmaToProcess.rmaFaRequired__c           = 'No FA Required';
          rmaToProcess.rmaReturnShipmentStatus__c = 'N/A-10: No part to ship for this RMA Type';
          rmaToProcess.rmaRetShip2Status__c       = 'N/A-10: No part to ship for this RMA Type';
          rmaToProcess.rmaCustomerFaRequired__c   = false;
         }

       // Case is Engineering or Executive Escalated
       // NOTE: Per Alexander Pham's flowchart, marking
       //       the FA Required field as "Engineering FA" is
       //       no longer required just because the case is
       //       escalated.  Commented this out.
       //else if (rmaToProcess.rmaCaseIsEngOrExecEscalated__c)
       //  {System.debug('DEBUG: HERE 0400 - Case is Engineering or Executive Escalated');
       //   newFaLogicHistory += 'HERE 0400 - Case is Engineering or Executive Escalated\n';
       //
       //   if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
       //     {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ FA w/ Tech';
       //     }
       //   else
       //     {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Failure Analysis';
       //     }
       //
       //   rmaToProcess.rmaFaRequired__c = 'Engineering FA';
       //  }

       // Component = "SSD"
       else if (rmaToProcess.rmaComponent__c == 'SSD')
         {System.debug('DEBUG: HERE 0500 - Component = "SSD"');
          newFaLogicHistory += 'HERE 0500 - Component = "SSD"\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ FA w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Failure Analysis';
            }

          rmaToProcess.rmaFaRequired__c = 'Engineering FA';
         }

       // Part Failed within Ops Time Period
       //   and
       // FA Required is not "Engineering FA"
       else if (rmaToProcess.rmaPartFailedWithinOpsTimePeriod__c == 'Yes' &&
                rmaToProcess.rmaFaRequired__c != 'Engineering FA')
         {System.debug('DEBUG: HERE 0600 - Part Failed within Ops Time Period and FA Required is not "Engineering FA"');
          newFaLogicHistory += 'HERE 0600 - Part Failed within Ops Time Period and FA Required is not "Engineering FA"\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ FA w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Failure Analysis';
            }

          rmaToProcess.rmaFaRequired__c = 'Operations FA';
         }

       // FA Required = "Engineering FA" or "Operations FA"
       else if (rmaToProcess.rmaFaRequired__c == 'Engineering FA' ||
                rmaToProcess.rmaFaRequired__c == 'Operations FA')
         {System.debug('DEBUG: HERE 0700 - FA Required = "Engineering FA" or "Operations FA"');
          newFaLogicHistory += 'HERE 0700 - FA Required = "Engineering FA" or "Operations FA"\n';

          if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ FA w/ Tech';
            }
          else
            {rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Failure Analysis';
            }
         }

       // Asset SLA contains "Onsite"
       else if (rmaToProcess.rmaAssetSla__c.contains('Onsite'))
         {System.debug('DEBUG: HERE 0800 - Asset SLA contains "Onsite"');
          newFaLogicHistory += 'HERE 0800 - Asset SLA contains "Onsite"\n';

          rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Def Rtrn w/ Tech';
         }

       // Asset SLA does not contain "Onsite"
       // This section is the last block of logic, and will
       // catch all RMAs that didn't match earlier logic.
       else
         {System.debug('DEBUG: HERE 0900 - Asset SLA does not contain "Onsite"');
          newFaLogicHistory += 'HERE 0900 - Asset SLA does not contain "Onsite"\n';

          rmaToProcess.rmaOrderType__c = 'Advance Replacement w/ Defective Return';
         }

      System.debug('DEBUG: OUTPUTS:');
      System.debug('DEBUG: rmaOrderType__c              = ' + rmaToProcess.rmaOrderType__c);
      System.debug('DEBUG: rmaFaRequired__c             = ' + rmaToProcess.rmaFaRequired__c);
      System.debug('DEBUG: rmaOutgoingShipmentStatus__c = ' + rmaToProcess.rmaOutgoingShipmentStatus__c);
      System.debug('DEBUG: rmaReturnShipmentStatus__c   = ' + rmaToProcess.rmaReturnShipmentStatus__c);
      System.debug('DEBUG: rmaRetShip2Status__c         = ' + rmaToProcess.rmaRetShip2Status__c);
      System.debug('DEBUG: rmaCustomerFaRequired__c     = ' + rmaToProcess.rmaCustomerFaRequired__c);

      newFaLogicHistory += 'OUTPUTS:\n' +
                           'rmaOrderType__c              = ' + rmaToProcess.rmaOrderType__c + '\n' +
                           'rmaFaRequired__c             = ' + rmaToProcess.rmaFaRequired__c + '\n' +
                           'rmaOutgoingShipmentStatus__c = ' + rmaToProcess.rmaOutgoingShipmentStatus__c + '\n' +
                           'rmaReturnShipmentStatus__c   = ' + rmaToProcess.rmaReturnShipmentStatus__c + '\n' +
                           'rmaRetShip2Status__c         = ' + rmaToProcess.rmaRetShip2Status__c + '\n' +
                           'rmaCustomerFaRequired__c     = ' + rmaToProcess.rmaCustomerFaRequired__c;

      rmaToProcess.rmaFaLogicHistory__c = newFaLogicHistory.right(131072);

      // ################################################
      // END LOGIC TO SET FA (FAILURE ANALYSIS) VARIABLES
      // ################################################
     }
    
 /*
    public static void rmaCheckExistingRecordsInAb()
    {
        rmaMap = new Map<Id,RMAv2__c>([SELECT rmaDiskShelfAsset__c,rmaDiskShelfAsset__r.Id,rmaDiskShelfAsset__r.Account.Id,rmaCaseNumber__c,rmaCaseNumber__r.Asset.Account.Id from RMAv2__c where Id In :Trigger.newMap.keySet()]);
       
        Set<String> sAddressKeys = new Set<String>();
        
        for(RMAv2__c rmaToProcess : (List<RMAv2__c>) Trigger.new){
            
              RMAv2__c rmaRecord = rmaMap.get(rmaToProcess.Id);
            
             String addressKey = '';
            
             if(rmaToProcess.rmaAddOverriddenAddressToAddressBook__c == true)
             {
                 if(rmaToProcess.rmaDiskShelfAsset__c != null)
                 addressKey = rmaRecord.rmaDiskShelfAsset__r.Account.Id;
                 else
                 addressKey = rmaRecord.rmaCaseNumber__r.Asset.Account.Id;
                 
                 addressKey += + '_' + rmaToProcess.rmaShipmentStreet1__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentStreet2__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentCity__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentState__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentCountry__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentPostalCode__c;
                 sAddressKeys.add(addressKey);
             }
        }
        
        
        //Check the address already exist in AddressBook
        for (AddressBook__c abs : [SELECT Id, abUniqueField__c,abDescription__c FROM AddressBook__c WHERE abUniqueField__c IN :sAddressKeys]) {
            mapExistingAbRecords.put(abs.abUniqueField__c.toUpperCase(),abs);
        }
    }

   
    public static void rmaAfterUpdateMain()
    {
       rmaCheckExistingRecordsInAb(); 
       
       List<AddressBook__c> newAddressBookEntries = new List<AddressBook__c>();
       List<Asset> lstUpdateAsset = new List<Asset>();
       String addressKey = '';                   
       for(RMAv2__c rmaToProcess : (List<RMAv2__c>) Trigger.new){
           
             RMAv2__c rmaRecord = rmaMap.get(rmaToProcess.Id);

             if(rmaToProcess.rmaAddOverriddenAddressToAddressBook__c == true)
             {
                if(rmaToProcess.rmaDiskShelfAsset__c != null)
                 addressKey = rmaRecord.rmaDiskShelfAsset__r.Account.Id;
                 else
                 addressKey = rmaRecord.rmaCaseNumber__r.Asset.Account.Id;
                 
                 addressKey += + '_' + rmaToProcess.rmaShipmentStreet1__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentStreet2__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentCity__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentState__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentCountry__c;
                 addressKey += + '_' + rmaToProcess.rmaShipmentPostalCode__c;

                if(!mapExistingAbRecords.containsKey(addressKey.toUpperCase()))
                {  
                    AddressBook__c newAddressBookEntry = new AddressBook__c();                 
                    if(rmaToProcess.rmaDiskShelfAsset__c != null)
                     newAddressBookEntry.abAccount__c       = rmaRecord.rmaDiskShelfAsset__r.Account.Id;
                    else
                     newAddressBookEntry.abAccount__c       = rmaRecord.rmaCaseNumber__r.Asset.Account.Id;
    
                    newAddressBookEntry.abStreet1__c       = rmaToProcess.rmaShipmentStreet1__c; 
                    newAddressBookEntry.abStreet2__c       = rmaToProcess.rmaShipmentStreet2__c;
                    newAddressBookEntry.abCity__c          = rmaToProcess.rmaShipmentCity__c;
                    newAddressBookEntry.abStateProvince__c = rmaToProcess.rmaShipmentState__c;
                    newAddressBookEntry.abCountry__c       = rmaToProcess.rmaShipmentCountry__c;
                    newAddressBookEntry.abPostalCode__c    = rmaToProcess.rmaShipmentPostalCode__c;
                    newAddressBookEntry.abDescription__c   = 'From ' + rmaToProcess.Name;
                    newAddressBookEntries.add(newAddressBookEntry);
                }

             }
             else
             {
                 
                 //if(rmaToProcess.rmaShipmentLocationValidatedOn__c != null && rmaToProcess.rmaOutgoingShipmentStatus__c.contains('CLOSED-10: Delivered'))
                 if(rmaToProcess.rmaShipmentLocationValidatedOn__c != null && rmaToProcess.rmaOverrideShipmentStreet1__c == null &&  rmaToProcess.rmaOverrideShipmentStreet2__c == null &&  rmaToProcess.rmaOverrideShipmentCity__c == null &&  rmaToProcess.rmaOverrideShipmentState__c == null && rmaToProcess.rmaOverrideShipmentCountry__c == null &&  rmaToProcess.rmaOverrideShipmentPostalCode__c == null && rmaToProcess.rmaOverrideShipmentAttn__c == null && rmaToProcess.rmaOverrideShipmentPhone__c == null && rmaToProcess.rmaOverrideShipmentEmail__c == null && rmaToProcess.rmaOutgoingShipmentStatus__c.contains('CLOSED-10: Delivered'))
                 {                 
                     Integer lastValidationDateInDays= Integer.valueOf(rmaToProcess.rmaShipmentLocationValidatedOn__c.Date().daysBetween(rmaToProcess.CreatedDate.Date()));

                     if(lastValidationDateInDays>0 && lastValidationDateInDays<=180)
                     {
                        ID AssetId;
                        if(rmaToProcess.rmaDiskShelfAsset__c != null)
                           AssetId = rmaRecord.rmaDiskShelfAsset__r.Id;
                         else
                           AssetId = rmaRecord.rmaCaseNumber__r.Asset.Id;
                         
                         Asset assetToUpdate = [Select Id from Asset where Id=: AssetId];
                         assetToUpdate.assetPartShipLastValidatedDatetime__c = Datetime.now();
                         assetToUpdate.assetPartShipLastValidatedByInfo__c = 'From ' + rmaToProcess.Name;
                         lstUpdateAsset.add(assetToUpdate);
                     }
                 }
             }
        }

        insert newAddressBookEntries;
        update lstUpdateAsset;
    }*/
}