global class abAssetEntriesBatch implements Database.Batchable<sObject>{
   global final String Query;
   //Query all the Asset Address - order by Account,CreatedDate
   ////Inprogress
   global abAssetEntriesBatch(){
               Query='SELECT assetInstallAddressUniqueKey__c,assetPartShipAddressBook__c,Id,Account.Id,Install_City__c, Install_Country__c, Install_Street1__c, Install_Street2__c, Install_State_Province__c,Install_Zip_Code__c,CreatedDate FROM Asset  where Account.ID !=null and (Install_Street1__c != null and Install_City__c != null and Install_Country__c != null) order by Account.Id,CreatedDate';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
       //Start Method to Execute the query
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
      
      Set<Id> aAssetIds = new Set<Id>();
      Set<Id> aAccountIds = new Set<Id>();
      Map<String,AddressBook__c> mapAbIncomingRecords = new Map<String,AddressBook__c>();
      Map<String,AddressBook__c> mapExistingAbRecords = new Map<String,AddressBook__c>(); 
                           
      List<AddressBook__c> lstInsertAbRecords = new List<AddressBook__c>();
      List<AddressBook__c> lstUpdateAbRecords = new List<AddressBook__c>();
                           
     
      
       //Loop Through all the incoming records and store it a map                           
       for(sObject s : scope){
            Asset a = (Asset)s;

                   AddressBook__c currentAbRecord = new AddressBook__c();
                   currentAbRecord.abAccount__c = a.Account.Id;
                   currentAbRecord.abStreet1__c = a.Install_Street1__c; 
                   currentAbRecord.abStreet2__c = a.Install_Street2__c;
                   currentAbRecord.abCity__c = a.Install_City__c;
                   currentAbRecord.abStateProvince__c = a.Install_State_Province__c;
                   currentAbRecord.abCountry__c = a.Install_Country__c;
                   currentAbRecord.abPostalCode__c = a.Install_Zip_Code__c; 
                   currentAbRecord.abDescription__c = 'Asset Install Address 1';
                   currentAbRecord.abAssetRecordIdentifierKey__c = a.assetInstallAddressUniqueKey__c;
                   aAssetIds.add(a.Id);
                   mapAbIncomingRecords.put(a.assetInstallAddressUniqueKey__c, currentAbRecord); 
            }
            
            //Check the address already exist in AddressBook
            for (AddressBook__c abs : [SELECT Id, abUniqueField__c,abDescription__c FROM AddressBook__c WHERE abUniqueField__c IN :mapAbIncomingRecords.keySet()]) {
                  mapExistingAbRecords.put(abs.abUniqueField__c,abs);
            }
             
            //Based on the previous step check the record is for Insert/Update
            for (String abIncomingKey : mapAbIncomingRecords.keySet()){
                
                if(mapExistingAbRecords.containsKey(abIncomingKey))
                {
                    AddressBook__c abRecord = mapAbIncomingRecords.get(abIncomingKey);
                    AddressBook__c oldRecord = mapExistingAbRecords.get(abIncomingKey);
                    abRecord.Id = oldRecord.Id;
                    abRecord.abDescription__c = oldRecord.abDescription__c;
                    lstUpdateAbRecords.add(abRecord);
                }
                else
                {
                    AddressBook__c abRecord = mapAbIncomingRecords.get(abIncomingKey);
                    lstInsertAbRecords.add(abRecord); 
                    aAccountIds.add(abRecord.abAccount__c);
                }
            }
            
            //First perform Insert
            insert lstInsertAbRecords;
            //Then perform Update
            update lstUpdateAbRecords;
              
            //Based on the asset Unique Key query the Address Book object              
            Map<String, Id> mapAbAssetKeys = new Map<String, Id>();    
             for (AddressBook__c ab : [SELECT Id, abAssetRecordIdentifierKey__c FROM AddressBook__c WHERE abAssetRecordIdentifierKey__c IN :mapAbIncomingRecords.keySet()]) {
               mapAbAssetKeys.put(ab.abAssetRecordIdentifierKey__c,ab.Id);         
            }

            //Based on the incoming record Asset Id query the Asset Object
            //Check for the RecordIndentifier Address
            //Assign the Address Book to the current Asset              
            List<Asset> lstUpdAssets = new List<Asset>();   
            for (Asset asset : [SELECT Id,assetInstallAddressUniqueKey__c FROM Asset WHERE Id IN:aAssetIds and assetPartShipAddressBook__c=null]) {
                
                Id abId = mapAbAssetKeys.get(asset.assetInstallAddressUniqueKey__c);
                asset.assetPartShipAddressBook__c =abId; 
                lstUpdAssets.add(asset);
                
            }
          
            update lstUpdAssets;

   }

   global void finish(Database.BatchableContext BC){

   }

}