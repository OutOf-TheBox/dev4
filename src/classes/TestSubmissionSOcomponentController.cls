@isTest
private class TestSubmissionSOcomponentController {

    static testMethod void myUnitTest() {
        SubmissionTemplateSOcomponentController test=new SubmissionTemplateSOcomponentController();
        Sales_Order__c sotest= new Sales_Order__c();
		sotest.Name='test';
		sotest.Type__c='Prebuild';
		upsert sotest;
        test.SOid=sotest.Id;
        test.getSOlines();
    }
}