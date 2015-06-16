@isTest
private class Test_ContractManagementInline {

    static testMethod void myUnitTest() {
        
        Account acc = new Account();
        acc.name='test';
        insert acc;
        
        Contract_Management__c conmgmt = new Contract_Management__c();
        conmgmt.Account__c = acc.id;
        conmgmt.Agreement_Name__c = 'testName';
        insert conmgmt;
        
        Contract_Management__c conmgmt1 = new Contract_Management__c();
        conmgmt.Account__c = acc.id;
        conmgmt.Agreement_Name__c = 'testName';
        update conmgmt;
        
        Contract_Management__c myTestTrainee = [select id from Contract_Management__c limit 1];
        ApexPAges.StandardController sc = new ApexPages.StandardController(myTestTrainee);
        ContractManagementInline conInline = new ContractManagementInline(sc);
        conInline.editBtn();
        conInline.saveBtn();
        conInline.cancelBtn();
        conInline.saveBtnforInline();
        conInline.cancelBtnforInline();
        
    }
}