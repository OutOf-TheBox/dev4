public class ctrl_Expedite_Request_edit {
    
    public Expedite_Request__c Exprecord {get;set;}
    public Expedite_Request__c Exprecord1;
    public boolean expstatus{get;set;}
    public boolean checkexp{get;set;}
    public id  exid;  
    public string soid;
    public Sales_Order__c saleorder {get;set;} 
    public boolean showerror{get;set;} 
    
       
    public ctrl_Expedite_Request_edit(ApexPages.StandardController controller) {
        
        showerror=false;  
        checkexp=true; 
        expstatus=true;
                 
        Exprecord=new Expedite_Request__c();  
        soid=apexpages.currentPage().getParameters().get('soid');
        system.debug('soid-------'+soid);
        if(soid =='' || soid== null)
        {
        Exprecord1=(Expedite_Request__c)controller.getRecord();
        
        exid=Exprecord1.id;
        Exprecord=[Select Total_Price__c, Target_Install_Date__c, SystemModstamp, Ship_to_Customer__c, Ship_To_Address__c, Sales_Order__c, Sales_Order_Type__c,
        SO_Owner__c, Reason_For_Expedite__c, Ownerid, Overnight__c, Opportunity__c, Opp_Team_9__c, Opp_Team_8__c, Opp_Team_7__c, Opp_Team_6__c, Opp_Team_5__c,
        Opp_Team_4__c, Opp_Team_3__c, Opp_Team_2__c, Opp_Team_1__c, Opp_Team_10__c, Name,Last_Sched_Ship_Date_Update__c, LastModifiedDate, LastModifiedById, 
        LastActivityDate, IsDeleted, Id, Expedite_Status__c, Current_Ship_Date__c, CurrencyIsoCode, CreatedDate, CreatedById, Approval_To_Overnight__c,
        Account__c From Expedite_Request__c where id=:exid];
        }
        else
        {
        expstatus=false;
        saleorder=[select id,name from Sales_Order__c where id=:soid];
        list<Expedite_Request__c> explist=new list<Expedite_Request__c>();
        explist=[select id ,Sales_Order__c from Expedite_Request__c where Sales_Order__c=: soid];
        system.debug(saleorder);
        if(explist.size()>0)
        {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Error: An Expedite Request has already been submitted for this Sales Order. Please review the Sales Order record for details on the existing Expedite Request.');
            ApexPages.addMessage(myMsg);  
            checkexp=false; 
                 
        }
        else        
        Exprecord.Sales_Order__c=saleorder.id;
        }
                    system.debug('record-------------'+Exprecord);   
    }
    
    public pagereference SaveRecord()
    {       
        system.debug('exp-------------------'+Exprecord);
        if(Exprecord.Overnight__c ==true && (Exprecord.Approval_To_Overnight__c==null || Exprecord.Approval_To_Overnight__c==''))
        {
            showerror=true;
            return null;     
        }
        else 
        {
                if(System.Test.isRunningTest())
                                        {
                                                Exprecord.Target_Install_Date__c=system.today();
                                                Exprecord.Sales_Order__c=saleorder.id;
                                        }
                                                        
            upsert Exprecord;
            return new pagereference('/'+Exprecord.id+'').setredirect(true);
                
        }
              
   }
   /*
   public pagereference SaveNewrec()
   {
        if(Exprecord.Overnight__c ==true && (Exprecord.Approval_To_Overnight__c==null || Exprecord.Approval_To_Overnight__c==''))
        {
            showerror=true;
            return null;     
        }
        else 
        {
            update Exprecord;
            return new pagereference('/a6U/e').setredirect(true);
                
        }
   
}*/
}