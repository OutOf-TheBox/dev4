global class schedule_batch_shipping implements Schedulable {
    
    global void execute(SchedulableContext sc)
    {
        
        String query='Select id,Item__c,Tracking_Number__c,Quantity__c,BOM_Line_Number__c ,Start_Date__c,End_Date__c,Serial_Number__c,Sales_Order__c,Actual_Shipping_Date__c from Sales_Order_Line__c where Tracking_Number__c!=null AND Shipping_Email_Indicator__c=false ';
        batch_shipping_emails bse=new batch_shipping_emails();
        bse.query=query;
        Database.executebatch(bse,1);
    }
    
    static testMethod void myUnitTest() {
        Test.StartTest();
        schedule_batch_shipping sh1 = new schedule_batch_shipping();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest();
        integer i=1;
        System.assertEquals(i,1);
    }
    
    

}