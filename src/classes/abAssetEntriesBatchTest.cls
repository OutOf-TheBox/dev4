@isTest                              
private class abAssetEntriesBatchTest {
    
    static testmethod void testAssetProcessBatch() {
        
        
           Account account;
           List<Account> accounts = new List<Account>();
           List<Id> testAccountIds = new List<Id>();
           
           Asset  asset;          
           List<Asset> assets = new List<Asset>();
        
        
          // Create test Account
           for (Integer i=0;i<5;i++) {
             account = new Account(Name = 'TEST-ACCOUNT' + i);
             accounts.add(account);
           }
        
          insert accounts;
        
          List<Account>  accountLists = [SELECT Id,
                       Name
                FROM   Account order by Name];

          System.assertEquals(accounts.size(),              accountLists.size());
        
          for(Integer i=0;i<accounts.size();i++)
          {
              System.assertEquals('TEST-ACCOUNT' + i,                  accountLists[i].Name, 'Account Name - TEST-ACCOUNT' + i);
              testAccountIds.add(accountLists[i].id);
          }
          
        
        // Create test asset
         for (Integer i=0;i<5;i++) {
           asset = new Asset(Name = 'TEST-ASSET' + i,
                          AccountId = accounts[i].Id,
                          Install_Street1__c        = 'TEST-ASSET-INSTALL-STREET1',
                          Install_Street2__c        = 'TEST-ASSET-INSTALL-STREET2',
                          Install_City__c           = 'TEST-ASSET-INSTALL-CITY',
                          Install_State_Province__c = 'TEST-ASSET-INSTALL-STATE',
                          Install_Country__c        = 'TEST-ASSET-INSTALL-COUNTRY',
                          Install_Zip_Code__c       = 'TEST-ASSET-INSTALL-ZIPCODE');
             assets.add(asset);
         }
        insert assets;
        
         List<Asset>  assetLists = [SELECT Id,
                       Name,
                       AccountId,
                       SLA__c,
                       Install_Street1__c,
                       Install_Street2__c,
                       Install_City__c,
                       Install_Country__c,
                       Install_State_Province__c,
                       Install_Zip_Code__c 
                FROM   Asset order by Name];
        
         System.assertEquals(assets.size(),              assetLists.size());
         
          for(Integer i=0;i<assets.size();i++)
          {
          	  System.assertEquals('TEST-ASSET' + i,                  assetLists[i].Name, 'Asset Name - TEST-ASSET' + i);
              System.assertEquals(accounts[i].id,                 assetLists[i].AccountId,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assetLists[i].Install_Street1__c,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assetLists[i].Install_Street2__c,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-CITY',     assetLists[i].Install_City__c,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-STATE',    assetLists[i].Install_State_Province__c,'Asset Name - TEST-ASSET' + i);              
              System.assertEquals('TEST-ASSET-INSTALL-COUNTRY',    assetLists[i].Install_Country__c,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-ZIPCODE',    assetLists[i].Install_Zip_Code__c,'Asset Name - TEST-ASSET' + i);
          }
        
        
        String Query = 'SELECT id,AccountId,Install_City__c, Install_Country__c, Install_Street1__c, Install_Street2__c, Install_State_Province__c,Install_Zip_Code__c,CreatedDate FROM Asset  where Install_Street1__c != null or Install_Street2__c != null or Install_City__c != null or Install_State_Province__c != null or Install_Country__c != null or Install_Zip_Code__c != null order by AccountId,CreatedDate desc';
        Test.startTest();
        AbAssetEntriesBatch e = new AbAssetEntriesBatch();
        Database.executeBatch(e);
        Test.stopTest();   
        
       // Verify Adress Book for the Records Inserted with Description Unique Name
       List<AddressBook__c> ab = [SELECT abAccount__c,abAccount__r.Name,abStreet1__c,abStreet2__c,abCity__c,abStateProvince__c,abCountry__c,abPostalCode__c,abDescription__c FROM AddressBook__c order by abAccount__c,abDescription__c];
       
        System.assertEquals(5,ab.size());
        
       for(Integer i=0;i<ab.size();i++)
          {
              Integer uniqueAddressCount = i + 1;
              System.assertEquals(accounts[i].id,                 ab[i].abAccount__c,'AB Account Name - ' + ab[i].abAccount__r.Name);
              System.assertEquals('TEST-ASSET-INSTALL-STREET1',  ab[i].abStreet1__c,'AB Account Name - ' + ab[i].abAccount__r.Name);
              System.assertEquals('TEST-ASSET-INSTALL-STREET2',  ab[i].abStreet2__c,'AB Account Name - ' + ab[i].abAccount__r.Name);
              System.assertEquals('TEST-ASSET-INSTALL-CITY',     ab[i].abCity__c,'AB Account Name - ' + ab[i].abAccount__r.Name);
              System.assertEquals('TEST-ASSET-INSTALL-STATE',    ab[i].abStateProvince__c,'AB Account Name - ' + ab[i].abAccount__r.Name);             
              System.assertEquals('TEST-ASSET-INSTALL-COUNTRY',    ab[i].abCountry__c,'AB Account Name - ' + ab[i].abAccount__r.Name);
              System.assertEquals('TEST-ASSET-INSTALL-ZIPCODE',    ab[i].abPostalCode__c,'AB Account Name - ' + ab[i].abAccount__r.Name);
          }
        
         // Verify the updated Asset gets the Ship Address Book Entry
         assetLists = [SELECT  Name,
                       AccountId,
                       SLA__c,
                       Install_Street1__c,
                       Install_Street2__c,
                       Install_City__c,
                       Install_Country__c,
                       Install_State_Province__c,
                       Install_Zip_Code__c,
                       assetPartShipAddressBook__c
                FROM   Asset order by Name];
        
         System.assertEquals(assets.size(),              assetLists.size());
         
          for(Integer i=0;i<assets.size();i++)
          {
          	  System.assertEquals('TEST-ASSET' + i,                  assetLists[i].Name, 'Asset Name - TEST-ASSET' + i);
              System.assertEquals(accounts[i].id,                 assetLists[i].AccountId,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assetLists[i].Install_Street1__c,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assetLists[i].Install_Street2__c,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-CITY',     assetLists[i].Install_City__c,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-STATE',    assetLists[i].Install_State_Province__c,'Asset Name - TEST-ASSET' + i);              
              System.assertEquals('TEST-ASSET-INSTALL-COUNTRY',    assetLists[i].Install_Country__c,'Asset Name - TEST-ASSET' + i);
              System.assertEquals('TEST-ASSET-INSTALL-ZIPCODE',    assetLists[i].Install_Zip_Code__c,'Asset Name - TEST-ASSET' + i);
              System.assertNotEquals(null, assetLists[i].assetPartShipAddressBook__c,'Asset Name - TEST-ASSET' + i);
          }
        
            
    }
}