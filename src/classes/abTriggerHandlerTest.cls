@isTest                              
private class abTriggerHandlerTest {
    
    private static ID testAccountId;
    private static ID testAddressBookId;
    
    static testmethod void testCreateAccount() {
        
        Account          account;
        List<Account>    accounts;
        
        
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
            
    }
    
    static testmethod void testAbWithDescription() {
        
        testCreateAccount();
        
        AddressBook__c          addressBook;
        List<AddressBook__c>    addressBooks;
        
        
          // Create test AddressBook
          addressBook = new AddressBook__c(abAccount__c = testAccountId,abStreet1__c = 'TEST-STREET1' ,abStreet2__c = 'TEST-STREET2',abCity__c = 'TEST-CITY',abStateProvince__c ='TEST-STATE',abCountry__c='TEST-COUNTRY',abPostalCode__c='1000',abDescription__c='From RMA');
          insert addressBook;
          addressBooks = [SELECT Id,
                             abAccount__c,
                             abStreet1__c,
                             abStreet2__c,
                             abCity__c,
                             abStateProvince__c,
                             abCountry__c,
                             abPostalCode__c,
                             abDescription__c
                      FROM   AddressBook__c];
    
              System.assertEquals(1, addressBooks.size());
              System.assertEquals(testAccountId,                 addressBooks[0].abAccount__c);
              System.assertEquals('TEST-STREET1',  addressBooks[0].abStreet1__c);
              System.assertEquals('TEST-STREET2',  addressBooks[0].abStreet2__c);
              System.assertEquals('TEST-CITY',     addressBooks[0].abCity__c);
              System.assertEquals('TEST-STATE',    addressBooks[0].abStateProvince__c);             
              System.assertEquals('TEST-COUNTRY',    addressBooks[0].abCountry__c);
              System.assertEquals('1000',    addressBooks[0].abPostalCode__c);
              System.assertEquals('From RMA' ,    addressBooks[0].abDescription__c);
              testAddressBookId = addressBooks[0].id;

    }
    
    static testmethod void testAbWithoutDescription() {
        
        testCreateAccount();
        
        AddressBook__c          addressBook;
        List<AddressBook__c>    addressBooks;
        
        
          // Create test AddressBook
          addressBook = new AddressBook__c(abAccount__c = testAccountId,abStreet1__c = 'TEST-STREET1' ,abStreet2__c = 'TEST-STREET2',abCity__c = 'TEST-CITY',abStateProvince__c ='TEST-STATE',abCountry__c='TEST-COUNTRY',abPostalCode__c='1000');
          insert addressBook;
          addressBooks = [SELECT Id,
                             abAccount__c,
                             abStreet1__c,
                             abStreet2__c,
                             abCity__c,
                             abStateProvince__c,
                             abCountry__c,
                             abPostalCode__c,
                             abDescription__c
                      FROM   AddressBook__c];
    
              System.assertEquals(1, addressBooks.size());
              System.assertEquals(testAccountId,                 addressBooks[0].abAccount__c);
              System.assertEquals('TEST-STREET1',  addressBooks[0].abStreet1__c);
              System.assertEquals('TEST-STREET2',  addressBooks[0].abStreet2__c);
              System.assertEquals('TEST-CITY',     addressBooks[0].abCity__c);
              System.assertEquals('TEST-STATE',    addressBooks[0].abStateProvince__c);             
              System.assertEquals('TEST-COUNTRY',    addressBooks[0].abCountry__c);
              System.assertEquals('1000',    addressBooks[0].abPostalCode__c);
              System.assertEquals('Asset Install Address 1' ,    addressBooks[0].abDescription__c);
              testAddressBookId = addressBooks[0].id;

    }

}