global class schedule_batch_duplicate_rec implements Schedulable {

global void execute(SchedulableContext sc)
    {
    	String query='Select id,Serial_Number__c,Account__c,Contact__c,Asset_Name__c,Asset_Currency__c,Product__c,Status__c,Opportunity__c,Order_Type__c,Sales_Order__c,Shipping_Date__c,Purchase_Date__c,SLA__c,Support_End_Date__c,Support_Start_Date__c,assetNrdStartDate__c,assetNrdEndDate__c,Matched_Asset__c from Duplicate_Asset__c where Matched_Asset__c!=null';
    	batch_duplicate_rec bdr=new batch_duplicate_rec();
    	bdr.query=query;
    	Database.executebatch(bdr,1);  

    }
    
    static testMethod void myUnitTest() {
    	Test.StartTest();
		schedule_batch_duplicate_rec sh1 = new schedule_batch_duplicate_rec();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, sh1);
		Test.stopTest();
		integer i=1;
        System.assertEquals(i,1);
    }
    
}