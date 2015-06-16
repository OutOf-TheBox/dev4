global class schedule_batch_EvalConversion_emails implements Schedulable {
 
    global void execute(SchedulableContext sc)
    {
        String query='Select id,Item__c,Tracking_Number__c,Quantity__c,Serial_Number__c,Sales_Order__c,Actual_Shipping_Date__c from Sales_Order_Line__c where Shipping_Email_Indicator__c=false AND Eval_Conversion_Indicator__c=true';
        batch_EvalConversion_emails bse = new batch_EvalConversion_emails();
        bse.query=query;
        Database.executebatch(bse,1);
    }

}