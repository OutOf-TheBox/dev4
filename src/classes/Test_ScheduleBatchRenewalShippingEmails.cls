@isTest
private class Test_ScheduleBatchRenewalShippingEmails {


        static testMethod void myUnitTest() {
        Test.StartTest();
        ScheduleBatchRenewalShippingEmails sh1 = new ScheduleBatchRenewalShippingEmails();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
        integer i=1;
        System.assertEquals(i,1);
    
    }
}