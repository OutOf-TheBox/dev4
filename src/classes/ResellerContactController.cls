public class ResellerContactController {
    public String resId {get; set;}
    public String usrAcctId;
    public String userCntId;
    public PageReference approve()
    {       
       Reseller_contact__c  rc = new Reseller_contact__c(Id = resId, Status__c = 'Approved', Approved_Rejected_By__c = userCntId);
       update rc;
       return null;
    }

    public PageReference reject() 
    {   
       Reseller_contact__c  rc = new Reseller_contact__c(Id = resId, Status__c = 'Rejected', Approved_Rejected_By__c = userCntId);
       update rc;
       return null;
    }
    public ResellerContactController()
    {
        String usrId = UserInfo.getUserId();
        User usr= [Select AccountId, ContactId FROM User Where ID =: usrId];
        usrAcctId = usr.AccountId;
        userCntId = usr.ContactId;
    }
    public ResellerContactWrapper[] getResconts()
    { 
        List<ResellerContactWrapper> rsWrapList = new List<ResellerContactWrapper>();
        List<Reseller_Contact__c> reConts = [Select Id, Name, Reseller_Account__r.Name, status__c,resellerCustomerAccount__c,Res_Email__c, Reseller_Contact_Name__c, CreatedDate, Last_Accessed_Date__c FROM Reseller_Contact__c Where resellerCustomerAccount__c =: usrAcctId];
        for(Reseller_Contact__c rc : reConts)
        {
            ResellerContactWrapper rcw = new ResellerContactWrapper();
            rcw.Id = rc.Id;
            rcw.resAccName = rc.Reseller_Account__r.Name;
            rcw.status = rc.status__c;
            rcw.resEmail = rc.Res_Email__c;
            rcw.resName = rc.Reseller_Contact_Name__c;
            rcw.resCreatedDate = rc.CreatedDate;
            rcw.resLastAccessedDate = rc.Last_Accessed_Date__c;
            rsWrapList.add(rcw);
        }
        
        return rsWrapList;
                
    }
    class ResellerContactWrapper
    {
        public String Id{get;set;}
        public String resAccName{get;set;}
        public String status{get;set;}
        public String resEmail{get;set;}
        public String resName{get;set;}
        public Datetime resCreatedDate{get;set;}
        public Datetime resLastAccessedDate{get;set;}
    }
    }