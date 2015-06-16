/**
 test class for controller Salesorderlinectrl
 */
@isTest
private class Test_Salesorderlinectrl {

    static testMethod void myUnitTest() {
    	Sales_Order__c so= new Sales_Order__c();
        
        so.Name='test mansa';
        so.Type__c='Internal';
        so.Status__c='Approved by OA';
        so.Actual_Shipment_Date__c=system.today();
        
        insert so;
        Sales_Order_Line__c soline=new Sales_Order_Line__c();
        
        soline.Sales_Order__c=so.id;
        insert soline;
        
         Expedite_Request__c exp=new Expedite_Request__c();
         exp.Approval_To_Overnight__c=' test mansa';
         exp.Overnight__c=true;
         exp.Sales_Order__c=so.id;
         exp.Target_Install_Date__c=system.today();
         insert exp;
         
        apexpages.currentPage().getParameters().put('Id',exp.Id);
        
        salesorderlinectrl test= new salesorderlinectrl();
        ApexPages.StandardController sc = new ApexPages.StandardController(exp);
        salesorderlinectrl salelines=new salesorderlinectrl(sc);
        salelines.salesorderline();
       
        
    	
    }
}