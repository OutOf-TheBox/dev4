/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class VOpportunityTriggerTest {

    static testMethod void testResellerDistributorUpdate() {
      /*  Account testerAcc = new Account(Name='Test Account Name');
        insert testerAcc;

        Contact testerCon = new Contact(LastName = 'Contact Last Name', AccountId = testerAcc.id);
        insert testerCon;*/
        
        Profile sysAdminProfile = [Select Id From Profile Where Name='System Administrator' limit 1];
        
        UserRole execRole = [SELECT Id FROM UserRole where DeveloperName = 'ExecutiveStaff' limit 1];
        
        User testerAsUser = new User();
        testerAsUser.ProfileID = sysAdminProfile.id;
        testerAsUser.EmailEncodingKey = 'ISO-8859-1';
        testerAsUser.LanguageLocaleKey = 'en_US';
        testerAsUser.TimeZoneSidKey = 'America/New_York';
        testerAsUser.LocaleSidKey = 'en_US';
        testerAsUser.FirstName = 'first';
        testerAsUser.LastName = 'last';
        testerAsUser.Username = 'test@runasuser.com';   
        testerAsUser.CommunityNickname = 'testUser123';
        testerAsUser.Alias = 't1';
        testerAsUser.Email = 'no@email.com';
        testerAsUser.IsActive = true;
        testerAsUser.UserRoleId = execRole.Id;

        insert testerAsUser;

        System.RunAs(testerAsUser) {
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name = 'Test Reseller', Type='Reseller'));
        accList.add(new Account(Name = 'Test Distributor1'));
        accList.add(new Account(Name = 'Test Distributor2'));
        insert accList;
        
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(AccountId = accList[0].Id, FirstName = 'Test', LastName = 'Reseller1', Email = 'testuser1@testcompany.com'));
        conList.add(new Contact(AccountId = accList[0].Id, FirstName = 'Test', LastName = 'Reseller2', Email = 'testuser2@testcompany.com'));
        conList.add(new Contact(AccountId = accList[1].Id, FirstName = 'Test', LastName = 'Distributor1', Email = 'testuser3@testcompany.com'));
        conList.add(new Contact(AccountId = accList[2].Id, FirstName = 'Test', LastName = 'Distributor2', Email = 'testuser4@testcompany.com'));
        insert conList;
        
        List<Profile> resellerProfile = [Select Id From Profile Where Name = 'NS-SALES-PartnerPortal-Reseller'];
        system.assert(resellerProfile.size() == 1, 'Reseller Profile NS-SALES-PartnerPortal-Reseller not found.');
        
        List<Profile> distributorProfile = [Select Id From Profile Where Name = 'NS-SALES-PartnerPortal-Disti-No Orders'];
        system.assert(distributorProfile.size() == 1, 'Distributor Profile NS-SALES-PartnerPortal-Disti-No Orders not found.');
        
        User resellerUser1 = new User(FirstName = conList[0].FirstName,
                        LastName = conList[0].LastName,
                        Email = conList[0].Email,
                        UserName = conList[0].Email, 
                        ContactId = conList[0].Id,
                        alias = (conList[0].FirstName + conList[0].LastName).right(8),
                        profileid = resellerProfile[0].Id,
                        CommunityNickName = (conList[0].FirstName + conList[0].LastName).right(8),
                        TimeZoneSidKey = 'America/New_York',
                        LocaleSidKey = 'en_US',
                        EmailEncodingKey = 'ISO-8859-1', 
                        LanguageLocaleKey = 'en_US',
                        IsActive = false);
        insert resellerUser1;
        
        User resellerUser2 = new User(FirstName = conList[1].FirstName,
                        LastName = conList[1].LastName,
                        Email = conList[1].Email,
                        UserName = conList[1].Email, 
                        ContactId = conList[1].Id,
                        alias = (conList[1].FirstName + conList[1].LastName).right(8),
                        profileid = distributorProfile[0].Id,
                        CommunityNickName = (conList[1].FirstName + conList[1].LastName).right(8),
                        TimeZoneSidKey = 'America/New_York',
                        LocaleSidKey = 'en_US',
                        EmailEncodingKey = 'ISO-8859-1', 
                        LanguageLocaleKey = 'en_US',
                        IsActive = false);
        insert resellerUser2;
        
        User distributorUser2 = new User(FirstName = conList[2].FirstName,
                        LastName = conList[2].LastName,
                        Email = conList[2].Email,
                        UserName = conList[2].Email, 
                        ContactId = conList[2].Id,
                        alias = (conList[2].FirstName + conList[2].LastName).right(8),
                        profileid = distributorProfile[0].Id,
                        CommunityNickName = (conList[2].FirstName + conList[2].LastName).right(8),
                        TimeZoneSidKey = 'America/New_York',
                        LocaleSidKey = 'en_US',
                        EmailEncodingKey = 'ISO-8859-1', 
                        LanguageLocaleKey = 'en_US',
                        IsActive = false);
        insert distributorUser2;
        
        User distributorUser3 = new User(FirstName = conList[3].FirstName,
                        LastName = conList[3].LastName,
                        Email = conList[3].Email,
                        UserName = conList[3].Email, 
                        ContactId = conList[3].Id,
                        alias = (conList[3].FirstName + conList[3].LastName).right(8),
                        profileid = distributorProfile[0].Id,
                        CommunityNickName = (conList[3].FirstName + conList[3].LastName).right(8),
                        TimeZoneSidKey = 'America/New_York',
                        LocaleSidKey = 'en_US',
                        EmailEncodingKey = 'ISO-8859-1', 
                        LanguageLocaleKey = 'en_US',
                        IsActive = false);
        insert distributorUser3;
        
        Opportunity opp = new Opportunity(AccountId = accList[0].Id, Name = 'Test Opportunity', CloseDate = Date.Today(), 
                                StageName = '1-Prequalified', Type='New Business', Sales_Forecast_Category__c='Expected',
                                Reseller_Rep__c=conList[0].Id, Reseller_Account__c=accList[0].Id, Distributor_Lookup__c=accList[1].Id);
        insert opp;
        
        opp.Reseller_Rep__c=conList[1].Id;
        opp.Distributor_Lookup__c=accList[2].Id;
        update opp;
    }    
    }
}