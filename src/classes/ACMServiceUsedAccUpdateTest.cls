@IsTest
private class ACMServiceUsedAccUpdateTest {
    
     static testMethod void createTestData()
     {
           Account account;
           List<Account> accounts;
           ID testAccountId;
           Asset  asset;
           List<Asset> assets;
           ID testAssetId;
         
         
                 // Create test account
              account = new Account(Name = 'Test Account', ACM_Start_Date__c = Date.today(),ACM_End_Date__c = Date.today() + 365,ACM_Service_Purchased_Quantity__c = 1,ACM_Service_Purchased__c = true);
              insert account;
              accounts = [SELECT Id,Name,ACM_Start_Date__c,ACM_End_Date__c,ACM_Service_Purchased_Quantity__c,ACM_Service_Purchased__c FROM   Account WHERE  Name = 'Test Account'];
        
              System.assertEquals(1,              accounts.size());
              System.assertEquals('Test Account', accounts[0].Name);
              System.assertEquals(Date.today(), accounts[0].ACM_Start_Date__c);
              System.assertEquals(Date.today() + 365, accounts[0].ACM_End_Date__c);
              System.assertEquals(1, accounts[0].ACM_Service_Purchased_Quantity__c);
              System.assertEquals(true, accounts[0].ACM_Service_Purchased__c);
              testAccountId = accounts[0].id;
         
             // Create test asset
              asset = new Asset(Name = 'TEST-ASSET',
                                AccountId = testAccountId,
                                SLA__c = 'Premium',
                                Install_Street1__c        = 'TEST-ASSET-INSTALL-STREET1',
                                Install_Street2__c        = 'TEST-ASSET-INSTALL-STREET2',
                                Install_City__c           = 'TEST-ASSET-INSTALL-CITY',
                                Install_State_Province__c = 'TEST-ASSET-INSTALL-STATE',
                                 assetConcierge_Service__c = true);
              insert asset;
              assets = [SELECT Id,
                               Name,
                               AccountId,
                               SLA__c,
                               Install_Street1__c,
                               Install_Street2__c,
                               Install_City__c,
                               Install_State_Province__c,
                               assetConcierge_Service__c
                        FROM   Asset
                        WHERE  Name = 'TEST-ASSET'];
        
              System.assertEquals(1,                             assets.size());
              System.assertEquals('TEST-ASSET',                  assets[0].Name);
              System.assertEquals(testAccountId,                 assets[0].AccountId);
              System.assertEquals('Premium',                     assets[0].SLA__c);
              System.assertEquals('TEST-ASSET-INSTALL-STREET1',  assets[0].Install_Street1__c);
              System.assertEquals('TEST-ASSET-INSTALL-STREET2',  assets[0].Install_Street2__c);
              System.assertEquals('TEST-ASSET-INSTALL-CITY',     assets[0].Install_City__c);
              System.assertEquals('TEST-ASSET-INSTALL-STATE',    assets[0].Install_State_Province__c);
              System.assertEquals(true,    assets[0].assetConcierge_Service__c);
              testAssetId = assets[0].id;
         
     }
}