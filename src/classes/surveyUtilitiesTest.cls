@isTest
private class surveyUtilitiesTest
  {// ==================================================================================== createTestData
   static testMethod void createTestData()
     {// Create test account
      Account testAccount;
      List<Account> testAccounts;
      Id testAccountId;

      testAccount = new Account(Name = 'TEST-ACCOUNT');

      insert testAccount;

      testAccounts = [SELECT Id,
                             Name
                      FROM   Account
                      WHERE  Name = 'TEST-ACCOUNT'];

      System.assertEquals(1,              testAccounts.size());
      System.assertEquals('TEST-ACCOUNT', testAccounts[0].Name);
      testAccountId = testAccounts[0].id;

      // Create test contact
      Contact testContact;
      List<Contact> testContacts;
      Id testContactId;

      testContact = new Contact(LastName  = 'TEST-CONTACT-LAST-NAME',
                                AccountId = testAccountId,
                                Email     = 'test-contact@nowhere.com');

      insert testContact;

      testContacts = [SELECT Id,
                             LastName,
                             Email,
                             AccountId
                      FROM   Contact
                      WHERE  LastName = 'TEST-CONTACT-LAST-NAME'];

      System.assertEquals(1,                          testContacts.size());
      System.assertEquals('TEST-CONTACT-LAST-NAME',   testContacts[0].LastName);
      System.assertEquals('test-contact@nowhere.com', testContacts[0].Email);
      System.assertEquals(testAccountId,              testContacts[0].AccountId);

      testContactId = testContacts[0].id;

      // Create test case
      Case testCase;
      List<Case> testCases;
      Id testCaseId;

      testCase = new Case(AccountId = testAccountId,
                          ContactId = testContactId,
                          Subject = 'TEST-CASE-SUBJECT');

      insert testCase;

      testCases = [SELECT Id,
                          AccountId,
                          ContactId,
                          Subject
                   FROM   Case
                   WHERE  Subject = 'TEST-CASE-SUBJECT'];

      System.assertEquals(1,                   testCases.size());
      System.assertEquals(testAccountId,       testCases[0].AccountId);
      System.assertEquals(testContactId,       testCases[0].ContactId);
      System.assertEquals('TEST-CASE-SUBJECT', testCases[0].Subject);

      testCaseId = testCases[0].id;
     }

   static testMethod void testSendSurveys()
     {List<Case> testCases;
      List<Contact> testContacts;
      List<EmailTemplate> emailTemplates;
      Id testCaseId;
      Id testContactId;
      Id emailTemplateId;
      Map<String, Id> surveyIdsMap;
      List<Map<String, Id>> surveyIdsList;

      createTestData();

      testCases = [SELECT Id FROM Case WHERE Subject = 'TEST-CASE-SUBJECT'];
      System.assertEquals(1, testCases.size(), 'FATAL: Failed to select test case');
      testCaseId = testCases[0].Id;

      testContacts = [SELECT Id FROM Contact WHERE LastName = 'TEST-CONTACT-LAST-NAME'];
      System.assertEquals(1, testContacts.size(), 'FATAL: Failed to select test contact');
      testContactId = testContacts[0].Id;

      emailTemplates = [SELECT Id FROM EmailTemplate WHERE Name = 'Survey: Support Closed Case 01'];
      System.assertEquals(1, emailTemplates.size(), 'FATAL: Failed to find one email template named "Survey: Support Closed Case 01"; num found = ' + emailTemplates.size());
      emailTemplateId = emailTemplates[0].Id;

      surveyIdsMap = new Map<String, Id>();
      surveyIdsList = new List<Map<String, Id>>();

      surveyIdsMap.put('caseId',          testCaseId);
      surveyIdsMap.put('contactId',       testContactId);
      surveyIdsMap.put('emailTemplateId', emailTemplateId);
      surveyIdsList.add(surveyIdsMap);

      surveyUtilities.sendSurveys(surveyIdsList);
     }
 }