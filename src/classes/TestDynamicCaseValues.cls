@isTest
private class TestDynamicCaseValues {
 static testMethod void testPage() {
        PageReference pageRef = Page.NumCasesAsset;
        Test.setCurrentPageReference(pageRef);
        insert new Contact(Email = 'supportforce@nimblestorage.com', LastName = 'Support');  
        insert new Account(Name = 'testAccount');
        insert new Asset(Name = 'AA-TEST1', AccountId = [select Id from Account limit 1].Id);      
        Case myCase = new Case(ContactId = [select Id from Contact limit 1].Id, AssetId = [select Id from Asset limit 1].Id, Status = 'Open');
        insert myCase;       
        ApexPages.StandardController sc = new ApexPages.standardController(myCase);       
        ApexPages.currentPage().getParameters().put('id', myCase.Id);
        DynamicCaseValues myPageCase = new DynamicCaseValues(sc);
        integer numAsset = myPageCase.getNumCasesAsset();
        integer numContact = myPageCase.getNumCasesContact();
    }

}