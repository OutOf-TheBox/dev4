/*Purpose:Test class for DuplicateCaseController
* Change Log: 
*/
@isTest
private class TestDuplicateCaseController
{
    static testMethod void testDupCaseController()
    {
        Account acc = new Account(Name='TestAcct');
        insert acc;
        Contact cont = new Contact(LastName='TestContact',AccountId=acc.Id);
        insert cont;
        Asset asst = new Asset(Name='TestAsset',ContactId=cont.Id);
        insert asst;
        Case parentC = new Case(Status='Open',Category__c='Alerts',Type='Problem',
                                Origin='Web',Reason='Administrative', Nimble_Version__c='1.0.2.0',
                                AssetId=asst.Id);
        insert parentC;
        Case childC = new Case(Status='Open',
                                Origin='Web',Nimble_Version__c='1.0.2.0',
                                AssetId=asst.Id,Duplicate_Case__c=parentC.Id);
        insert childC;
        ApexPages.Standardcontroller sc1 = New ApexPages.StandardController(childC);
        DuplicateCaseController dc = new DuplicateCaseController(sc1);
        dc.saveDuplicate();
        Case c = [select Id, Status, Type, Reason,Category__c from Case where Id =: childC.Id];
        System.assertEquals(c.Status,'Closed(Duplicate)');
        System.assertEquals(c.Type,'Problem');
        System.assertEquals(c.Reason,'Administrative');
        System.assertEquals(c.Category__c,'Alerts');
        
    }

}