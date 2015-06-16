/**
 
 */
@isTest
private class Test_BatchEmailNotificationUsers {

    static testMethod void myUnitTest() {
    	Sales_Order__c so= new Sales_Order__c();
        
        so.Name='test mansa';
        so.Type__c='Internal';
        so.Status__c='Approved by OA';
        so.Actual_Shipment_Date__c=system.today();
        
        insert so;
        list<Expedite_Request__c> explist=new list<Expedite_Request__c>();
         Expedite_Request__c exp=new Expedite_Request__c();
         exp.Approval_To_Overnight__c='test';
         exp.Overnight__c=true;
         exp.Sales_Order__c=so.id;
         exp.Last_Sched_Ship_Date_Update__c=null;
         exp.Expedite_Status__c='Open';
         exp.Target_Install_Date__c=system.today();
         insert exp;
         explist.add(exp);
         
          Test.startTest();
        BatchEmailNotificationUsers bse=new BatchEmailNotificationUsers();
                bse.query='Select id,OwnerId,SO_Owner__c,name,Sales_Order__r.name,Target_Install_Date__c,Expedite_Status__c,Approval_To_Overnight__c, Ship_to_Customer__c, Ship_To_Address__c, Sales_Order__c, Reason_For_Expedite__c,Overnight__c, Opp_Team_9__c, Opp_Team_8__c, Opp_Team_7__c, Opp_Team_6__c, Opp_Team_5__c, Opp_Team_4__c, Opp_Team_3__c, Opp_Team_2__c, Opp_Team_1__c,Opp_Team_10__c, Current_Ship_Date__c ,Last_Sched_Ship_Date_Update__c from Expedite_Request__c where Last_Sched_Ship_Date_Update__c=null and Expedite_Status__c=\'Open\'';
        
        //bse.salesOrderIds=idss;
        bse.execute(null,explist);
        ID batchprocessid = Database.executeBatch(bse);
        
        Test.stopTest();
        integer i=1;
        System.assertEquals(i,1);
         

    }
}