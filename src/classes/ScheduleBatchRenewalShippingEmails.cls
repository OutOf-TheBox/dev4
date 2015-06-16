global class ScheduleBatchRenewalShippingEmails implements Schedulable{
	
	
	global void execute(SchedulableContext sc)
    {
        String query='Select id,Item__c,Tracking_Number__c,Quantity__c,Serial_Number__c,Sales_Order__c,Actual_Shipping_Date__c from Sales_Order_Line__c where Shipping_Email_Indicator__c=false AND Support_Renewal_Indicator__c=true';
        BatchRenewalShippingEmails bse=new BatchRenewalShippingEmails();
        bse.query=query;
        Database.executebatch(bse,1);
    }

}