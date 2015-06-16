public class assetTriggerHandler extends TriggerHandler {

  private static Map<Id, AddressBook__c> addressBooks;
  private static List<AddressBook__c>    newAddressBooks;

  // ###################################################################################################### assetTriggerHandler (constructor)
  public assetTriggerHandler() {
  }

  // ###################################################################################################### beforeInsert
  public override void beforeInsert() {
    setInsertedAssetAddressBook();
  }

  // ###################################################################################################### beforeUpdate
  public override void beforeUpdate() {
    setUpdatedAssetLastValidatedFields();
    setUpdatedAssetAddressBook();
    setUpdatedAssetSameDayPartDeliveryPreference();
  }

  // ###################################################################################################### afterInsert
  public override void afterInsert() {
  }

  // ###################################################################################################### afterUpdate
  public override void afterUpdate() {
  }

  // ###################################################################################################### setUpdatedAssetSameDayPartDeliveryPreference
  public static void setUpdatedAssetSameDayPartDeliveryPreference() {
    Asset oldAsset;

    for (Asset assetToProcess : (List<Asset>) Trigger.new) {
      oldAsset = (Asset) Trigger.oldMap.get(assetToProcess.Id);

      // System.debug('DEBUG: (setUpdatedAssetSameDayPartDeliveryPreference) oldAsset.SLA__c = ' + oldAsset.SLA__c);
      // System.debug('DEBUG: (setUpdatedAssetSameDayPartDeliveryPreference) assetToProcess.SLA__c = ' + assetToProcess.SLA__c);

      if (oldAsset.SLA__c == null                                                                                ||
          assetToProcess.SLA__c == null                                                                          ||
          (oldAsset.SLA__c.containsIgnoreCase('4 Hour')  && !assetToProcess.SLA__c.containsIgnoreCase('4 Hour')) ||
          (!oldAsset.SLA__c.containsIgnoreCase('4 Hour') && assetToProcess.SLA__c.containsIgnoreCase('4 Hour'))) {
        // System.debug('DEBUG: (setUpdatedAssetSameDayPartDeliveryPreference) DIFFERENT - clear fields');
        assetToProcess.assetSameDayPartDeliveryPreference__c = null;
      }
      else {
        // System.debug('DEBUG: (setUpdatedAssetSameDayPartDeliveryPreference) SAME - do not clear fields');
      }
    }
  }

  // ###################################################################################################### setInsertedAssetAddressBook
  public static void setInsertedAssetAddressBook() {
    // System.debug('DEBUG: (setInsertedAssetAddressBook) Entered.');

    // If the user is supportforce, do nothing with the Assets in this trigger.
    if (UserInfo.getUserName().containsIgnoreCase('supportforce')) {
      System.debug('DEBUG: (setInsertedAssetAddressBook) User is supportforce; returning');
      return;
    }

    // Populate the Address Book entries used by the Accounts of the Assets being inserted in this trigger.
    populateAddressBooks();
    // System.debug('DEBUG: (setInsertedAssetAddressBook) addressBooks.size() = ' + addressBooks.size());

    // Create Address Book entries that may not already exist.
    newAddressBooks = new List<AddressBook__c>();

    for (Asset assetToProcess : (List<Asset>) Trigger.new) {

      // If Street1, City, or Country is null, do nothing with this Asset.
      if (assetToProcess.Install_Street1__c == null ||
          assetToProcess.Install_City__c    == null ||
          assetToProcess.Install_Country__c == null) {
        continue;
      }

      // If Address Book entry doesn't exist, create it.
      if (getAddressBookIdForAssetInstallAddress(assetToProcess)     == null  &&
          newAddressBookExistsForAssetInstallAddress(assetToProcess) == false) {
        createNewAddressBookForAssetInstallAddress(assetToProcess);
      }
    }

    // Insert any new Address Book entries that were created.
    // System.debug('DEBUG: (setInsertedAssetAddressBook) newAddressBooks.size() = ' + newAddressBooks.size());
    // System.debug('DEBUG: (setInsertedAssetAddressBook) About to insert newAddressBooks');
    if (newAddressBooks.size() > 0) {
      // insert newAddressBooks;
      Database.insert(newAddressBooks, false);
    }

    // Re-populate the Address Book entries.  This will contain the original list, plus any new ones that were created.
    populateAddressBooks();
    // System.debug('DEBUG: (setInsertedAssetAddressBook) addressBooks.size() = ' + addressBooks.size());

    // Set the Address Book lookup on Assets being inserted by this trigger.
    for (Asset assetToProcess : (List<Asset>) Trigger.new) {

      // If Street1, City, or Country is null, do nothing with this Asset.
      if (assetToProcess.Install_Street1__c == null ||
          assetToProcess.Install_City__c    == null ||
          assetToProcess.Install_Country__c == null) {
        continue;
      }

      // Set the Asset Address Book lookup to the Address Book entry.
      assetToProcess.assetPartShipAddressBook__c = getAddressBookIdForAssetInstallAddress(assetToProcess);
      // System.debug('DEBUG: (setInsertedAssetAddressBook) assetToProcess.assetPartShipAddressBook__c set to: ' + assetToProcess.assetPartShipAddressBook__c);
    }
  }

  // ###################################################################################################### setUpdatedAssetAddressBook
  public static void setUpdatedAssetAddressBook() {
    Asset oldAsset;

    // System.debug('DEBUG: (setUpdatedAssetAddressBook) Entered.');

    // If the user is supportforce, do nothing with the Assets in this trigger.
    if (UserInfo.getUserName().containsIgnoreCase('supportforce')) {
      System.debug('DEBUG: (setUpdatedAssetAddressBook) User is supportforce; returning');
      return;
    }

    // Populate the Address Book entries used by the Accounts of the Assets being updated in this trigger.
    populateAddressBooks();
    // System.debug('DEBUG: (setUpdatedAssetAddressBook) addressBooks.size() = ' + addressBooks.size());

    // Create Address Book entries that may not already exist.
    newAddressBooks = new List<AddressBook__c>();

    for (Asset assetToProcess : (List<Asset>) Trigger.new) {

      // Populate the Asset's old (previous) data
      oldAsset = (Asset) Trigger.oldMap.get(assetToProcess.Id);

      // If none of the Asset Install Address fields changed, do nothing with this Asset.
      if (oldAsset.Install_Street1__c        == assetToProcess.Install_Street1__c        &&
          oldAsset.Install_Street2__c        == assetToProcess.Install_Street2__c        &&
          oldAsset.Install_City__c           == assetToProcess.Install_City__c           &&
          oldAsset.Install_State_Province__c == assetToProcess.Install_State_Province__c &&
          oldAsset.Install_Zip_Code__c       == assetToProcess.Install_Zip_Code__c       &&
          oldAsset.Install_Country__c        == assetToProcess.Install_Country__c) {
        continue;
      }

      // If Street 1, City, or Country is null, do nothing with this Asset.
      if (assetToProcess.Install_Street1__c == null ||
          assetToProcess.Install_City__c    == null ||
          assetToProcess.Install_Country__c == null) {
        continue;
      }

      // If Address Book entry doesn't exist, create it.
      if (getAddressBookIdForAssetInstallAddress(assetToProcess)     == null  &&
          newAddressBookExistsForAssetInstallAddress(assetToProcess) == false) {
        createNewAddressBookForAssetInstallAddress(assetToProcess);
      }
    }

    // Insert any new Address Book entries that were created.
    // System.debug('DEBUG: (setUpdatedAssetAddressBook) newAddressBooks.size() = ' + newAddressBooks.size());
    // System.debug('DEBUG: (setUpdatedAssetAddressBook) About to insert newAddressBooks');
    if (newAddressBooks.size() > 0) {
      // insert newAddressBooks;
      Database.insert(newAddressBooks, false);
    }

    // Re-populate the Address Book entries.  This will contain the original list, plus any new ones that were created.
    populateAddressBooks();
    // System.debug('DEBUG: (setUpdatedAssetAddressBook) addressBooks.size() = ' + addressBooks.size());

    // Set the Address Book lookup on Assets being updated by this trigger.
    for (Asset assetToProcess : (List<Asset>) Trigger.new) {

      // Populate the Asset's old (previous) data
      oldAsset = (Asset) Trigger.oldMap.get(assetToProcess.Id);

      // If none of the Asset Install Address fields changed, do nothing with this Asset.
      if (oldAsset.Install_Street1__c        == assetToProcess.Install_Street1__c        &&
          oldAsset.Install_Street2__c        == assetToProcess.Install_Street2__c        &&
          oldAsset.Install_City__c           == assetToProcess.Install_City__c           &&
          oldAsset.Install_State_Province__c == assetToProcess.Install_State_Province__c &&
          oldAsset.Install_Zip_Code__c       == assetToProcess.Install_Zip_Code__c       &&
          oldAsset.Install_Country__c        == assetToProcess.Install_Country__c) {
        continue;
      }

      // If Street1, City, or Country is null, clear the Validated Date and Validated By-Info fields, and continue to the next Asset.
      if (assetToProcess.Install_Street1__c == null ||
          assetToProcess.Install_City__c    == null ||
          assetToProcess.Install_Country__c == null) {
        continue;
      }

      // If the Asset Address Book lookup is null, set it to the Address Book entry of the install address.
      if (assetToProcess.assetPartShipAddressBook__c == null) {
        assetToProcess.assetPartShipAddressBook__c = getAddressBookIdForAssetInstallAddress(assetToProcess);
        // System.debug('DEBUG: (setInsertedAssetAddressBook) assetToProcess.assetPartShipAddressBook__c was null; set to: ' + assetToProcess.assetPartShipAddressBook__c);
      }
      else {
        // System.debug('DEBUG: (setInsertedAssetAddressBook) assetToProcess.assetPartShipAddressBook__c was not null; did not change');
      }
    }
  }

  // ###################################################################################################### populateAddressBooks
  public static void populateAddressBooks() {
    // Gather all the Address Book entries needed for this trigger's Asset records
    Set<Id> assetAccountIds = new Set<Id>();

    for (Asset assetToProcess : (List<Asset>) Trigger.new) {
      assetAccountIds.add(assetToProcess.AccountId);
    }

    addressBooks = new Map<Id, AddressBook__c>([SELECT Id,
                                                       abAccount__c,
                                                       abStreet1__c,
                                                       abStreet2__c,
                                                       abCity__c,
                                                       abStateProvince__c,
                                                       abPostalCode__c,
                                                       abCountry__c
                                                FROM   AddressBook__c
                                                WHERE  abAccount__c IN :assetAccountIds]);
  }

  // ###################################################################################################### getAddressBookIdForAssetInstallAddress
  public static Id getAddressBookIdForAssetInstallAddress(Asset assetToProcess) {
    for (AddressBook__c addressBook : addressBooks.values()) {
      if (addressBook.abAccount__c       == assetToProcess.accountId                 &&
          addressBook.abStreet1__c       == assetToProcess.Install_Street1__c        &&
          addressBook.abStreet2__c       == assetToProcess.Install_Street2__c        &&
          addressBook.abCity__c          == assetToProcess.Install_City__c           &&
          addressBook.abStateProvince__c == assetToProcess.Install_State_Province__c &&
          addressBook.abPostalCode__c    == assetToProcess.Install_Zip_Code__c       &&
          addressBook.abCountry__c       == assetToProcess.Install_Country__c) {

         return(addressBook.id);
      }
    }
    return(null);
  }

  // ###################################################################################################### newAddressBookExistsForAssetInstallAddress
  public static Boolean newAddressBookExistsForAssetInstallAddress(Asset assetToProcess) {
    for (AddressBook__c addressBook : newAddressBooks) {
      if (addressBook.abAccount__c       == assetToProcess.accountId                 &&
          addressBook.abStreet1__c       == assetToProcess.Install_Street1__c        &&
          addressBook.abStreet2__c       == assetToProcess.Install_Street2__c        &&
          addressBook.abCity__c          == assetToProcess.Install_City__c           &&
          addressBook.abStateProvince__c == assetToProcess.Install_State_Province__c &&
          addressBook.abPostalCode__c    == assetToProcess.Install_Zip_Code__c       &&
          addressBook.abCountry__c       == assetToProcess.Install_Country__c) {

         return(true);
      }
    }
    return(false);
  }

  // ###################################################################################################### createNewAddressBookForAssetInstallAddress
  public static void createNewAddressBookForAssetInstallAddress(Asset assetToProcess) {
    System.debug('DEBUG: (createNewAddressBookForAssetInstallAddress) Creating new entry with:');
    System.debug('DEBUG:   abAccount__c       = ' + assetToProcess.accountId);
    System.debug('DEBUG:   abStreet1__c       = ' + assetToProcess.Install_Street1__c);
    System.debug('DEBUG:   abStreet2__c       = ' + assetToProcess.Install_Street2__c);
    System.debug('DEBUG:   abCity__c          = ' + assetToProcess.Install_City__c);
    System.debug('DEBUG:   abStateProvince__c = ' + assetToProcess.Install_State_Province__c);
    System.debug('DEBUG:   abPostalCode__c    = ' + assetToProcess.Install_Zip_Code__c);
    System.debug('DEBUG:   abCountry__c       = ' + assetToProcess.Install_Country__c);
    System.debug('DEBUG:   abDescription__c   = ' + assetToProcess.Name + ' install address');

    newAddressBooks.add(new AddressBook__c(abAccount__c       = assetToProcess.accountId,
                                           abStreet1__c       = assetToProcess.Install_Street1__c,
                                           abStreet2__c       = assetToProcess.Install_Street2__c,
                                           abCity__c          = assetToProcess.Install_City__c,
                                           abStateProvince__c = assetToProcess.Install_State_Province__c,
                                           abPostalCode__c    = assetToProcess.Install_Zip_Code__c,
                                           abCountry__c       = assetToProcess.Install_Country__c,
                                           abDescription__c   = assetToProcess.Name + ' install address'));
  }

  // ###################################################################################################### setUpdatedAssetLastValidatedFields
  public static void setUpdatedAssetLastValidatedFields() {
    String newLastValidatedLogicHistory;

    for (Asset assetToProcess : (List<Asset>) Trigger.new) {
      Asset oldAsset = (Asset) Trigger.oldMap.get(assetToProcess.id);

      /* System.debug('DEBUG: ****************************************');
      System.debug('Entered evaluatePartShipLastValidatedFields');
      System.debug('Timestamp                                     = ' + System.now());
      System.debug('User ID                                       = ' + UserInfo.getUserId());
      System.debug('User Name                                     = ' + UserInfo.getUserName());
      System.debug('INPUTS:');
      System.debug('old Install_Street1__c                        = ' + oldAsset.Install_Street1__c);
      System.debug('old Install_Street2__c                        = ' + oldAsset.Install_Street2__c);
      System.debug('old Install_City__c                           = ' + oldAsset.Install_City__c);
      System.debug('old Install_State_Province__c                 = ' + oldAsset.Install_State_Province__c);
      System.debug('old Install_Zip_Code__c                       = ' + oldAsset.Install_Zip_Code__c);
      System.debug('old Install_Country__c                        = ' + oldAsset.Install_Country__c);
      System.debug('old assetPartShipLastValidatedDatetime__c     = ' + oldAsset.assetPartShipLastValidatedDatetime__c);
      System.debug('old assetPartShipLastValidatedByInfo__c       = ' + oldAsset.assetPartShipLastValidatedByInfo__c);
      System.debug('new Install_Street1__c                        = ' + assetToProcess.Install_Street1__c);
      System.debug('new Install_Street2__c                        = ' + assetToProcess.Install_Street2__c);
      System.debug('new Install_City__c                           = ' + assetToProcess.Install_City__c);
      System.debug('new Install_State_Province__c                 = ' + assetToProcess.Install_State_Province__c);
      System.debug('new Install_Zip_Code__c                       = ' + assetToProcess.Install_Zip_Code__c);
      System.debug('new Install_Country__c                        = ' + assetToProcess.Install_Country__c);
      System.debug('new assetPartShipLastValidatedDatetime__c     = ' + assetToProcess.assetPartShipLastValidatedDatetime__c);
      System.debug('new assetPartShipLastValidatedByInfo__c       = ' + assetToProcess.assetPartShipLastValidatedByInfo__c);
      System.debug('LOGIC DECISIONS:'); */

      newLastValidatedLogicHistory = assetToProcess.assetLastValidatedLogicHistory__c +
                                     'Timestamp                                     = ' + System.now() + '\n' +
                                     'User ID                                       = ' + UserInfo.getUserId() + '\n' +
                                     'User Name                                     = ' + UserInfo.getUserName() + '\n' +
                                     'INPUTS:\n' +
                                     'old Install_Street1__c                        = ' + oldAsset.Install_Street1__c + '\n' +
                                     'old Install_Street2__c                        = ' + oldAsset.Install_Street2__c + '\n' +
                                     'old Install_City__c                           = ' + oldAsset.Install_City__c + '\n' +
                                     'old Install_State_Province__c                 = ' + oldAsset.Install_State_Province__c + '\n' +
                                     'old Install_Zip_Code__c                       = ' + oldAsset.Install_Zip_Code__c + '\n' +
                                     'old Install_Country__c                        = ' + oldAsset.Install_Country__c + '\n' +
                                     'old assetPartShipLastValidatedDatetime__c     = ' + oldAsset.assetPartShipLastValidatedDatetime__c + '\n' +
                                     'old assetPartShipLastValidatedByInfo__c       = ' + oldAsset.assetPartShipLastValidatedByInfo__c + '\n' +
                                     'new Install_Street1__c                        = ' + assetToProcess.Install_Street1__c + '\n' +
                                     'new Install_Street2__c                        = ' + assetToProcess.Install_Street2__c + '\n' +
                                     'new Install_City__c                           = ' + assetToProcess.Install_City__c + '\n' +
                                     'new Install_State_Province__c                 = ' + assetToProcess.Install_State_Province__c + '\n' +
                                     'new Install_Zip_Code__c                       = ' + assetToProcess.Install_Zip_Code__c + '\n' +
                                     'new Install_Country__c                        = ' + assetToProcess.Install_Country__c + '\n' +
                                     'new assetPartShipLastValidatedDatetime__c     = ' + assetToProcess.assetPartShipLastValidatedDatetime__c + '\n' +
                                     'new assetPartShipLastValidatedByInfo__c       = ' + assetToProcess.assetPartShipLastValidatedByInfo__c + '\n' +
                                     'LOGIC DECISIONS:\n';

      if (UserInfo.getUserName().containsIgnoreCase('supportforce')) {
        // System.debug('HERE 0100 - User is supportforce; Ignore address change');
        newLastValidatedLogicHistory += 'HERE 0100 - User is supportforce; Ignore address change\n';
      }
      else {
        // System.debug('HERE 0200 - User is not supportforce; Do not ignore address change');
        newLastValidatedLogicHistory += 'HERE 0200 - User is not supportforce; Do not ignore address change\n';

        if (oldAsset.Install_Street1__c        != assetToProcess.Install_Street1__c        ||
            oldAsset.Install_Street2__c        != assetToProcess.Install_Street2__c        ||
            oldAsset.Install_City__c           != assetToProcess.Install_City__c           ||
            oldAsset.Install_State_Province__c != assetToProcess.Install_State_Province__c ||
            oldAsset.Install_Zip_Code__c       != assetToProcess.Install_Zip_Code__c       ||
            oldAsset.Install_Country__c        != assetToProcess.Install_Country__c) {

          // System.debug('HERE 0300 - Address is different; clear Last Validated fields');
          newLastValidatedLogicHistory += 'HERE 0300 - Address is different; clear Last Validated fields\n';

          assetToProcess.assetPartShipLastValidatedDatetime__c = null;
          assetToProcess.assetPartShipLastValidatedByInfo__c   = null;
        }
        else {
          // System.debug('HERE 0400 - Address is not different; do not clear Last Validated fields');
          newLastValidatedLogicHistory += 'HERE 0400 - Address is not different; do not clear Last Validated fields\n';
        }
      }

      /* System.debug('OUTPUTS:');
      System.debug('old Install_Street1__c                        = ' + oldAsset.Install_Street1__c);
      System.debug('old Install_Street2__c                        = ' + oldAsset.Install_Street2__c);
      System.debug('old Install_City__c                           = ' + oldAsset.Install_City__c);
      System.debug('old Install_State_Province__c                 = ' + oldAsset.Install_State_Province__c);
      System.debug('old Install_Zip_Code__c                       = ' + oldAsset.Install_Zip_Code__c);
      System.debug('old Install_Country__c                        = ' + oldAsset.Install_Country__c);
      System.debug('old assetPartShipLastValidatedDatetime__c     = ' + oldAsset.assetPartShipLastValidatedDatetime__c);
      System.debug('old assetPartShipLastValidatedByInfo__c       = ' + oldAsset.assetPartShipLastValidatedByInfo__c);
      System.debug('new Install_Street1__c                        = ' + assetToProcess.Install_Street1__c);
      System.debug('new Install_Street2__c                        = ' + assetToProcess.Install_Street2__c);
      System.debug('new Install_City__c                           = ' + assetToProcess.Install_City__c);
      System.debug('new Install_State_Province__c                 = ' + assetToProcess.Install_State_Province__c);
      System.debug('new Install_Zip_Code__c                       = ' + assetToProcess.Install_Zip_Code__c);
      System.debug('new Install_Country__c                        = ' + assetToProcess.Install_Country__c);
      System.debug('new assetPartShipLastValidatedDatetime__c     = ' + assetToProcess.assetPartShipLastValidatedDatetime__c);
      System.debug('new assetPartShipLastValidatedByInfo__c       = ' + assetToProcess.assetPartShipLastValidatedByInfo__c); */

      newLastValidatedLogicHistory += 'OUTPUTS:\n' +
                                      'old Install_Street1__c                        = ' + oldAsset.Install_Street1__c + '\n' +
                                      'old Install_Street2__c                        = ' + oldAsset.Install_Street2__c + '\n' +
                                      'old Install_City__c                           = ' + oldAsset.Install_City__c + '\n' +
                                      'old Install_State_Province__c                 = ' + oldAsset.Install_State_Province__c + '\n' +
                                      'old Install_Zip_Code__c                       = ' + oldAsset.Install_Zip_Code__c + '\n' +
                                      'old Install_Country__c                        = ' + oldAsset.Install_Country__c + '\n' +
                                      'old assetPartShipLastValidatedDatetime__c     = ' + oldAsset.assetPartShipLastValidatedDatetime__c + '\n' +
                                      'old assetPartShipLastValidatedByInfo__c       = ' + oldAsset.assetPartShipLastValidatedByInfo__c + '\n' +
                                      'new Install_Street1__c                        = ' + assetToProcess.Install_Street1__c + '\n' +
                                      'new Install_Street2__c                        = ' + assetToProcess.Install_Street2__c + '\n' +
                                      'new Install_City__c                           = ' + assetToProcess.Install_City__c + '\n' +
                                      'new Install_State_Province__c                 = ' + assetToProcess.Install_State_Province__c + '\n' +
                                      'new Install_Zip_Code__c                       = ' + assetToProcess.Install_Zip_Code__c + '\n' +
                                      'new Install_Country__c                        = ' + assetToProcess.Install_Country__c + '\n' +
                                      'new assetPartShipLastValidatedDatetime__c     = ' + assetToProcess.assetPartShipLastValidatedDatetime__c + '\n' +
                                      'new assetPartShipLastValidatedByInfo__c       = ' + assetToProcess.assetPartShipLastValidatedByInfo__c;

      assetToProcess.assetLastValidatedLogicHistory__c = newLastValidatedLogicHistory.right(131072);
    }
  }
}