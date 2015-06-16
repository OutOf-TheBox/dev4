global without sharing class InboxController 
{
    public String inId {get; set;}
    public String usrAcctId;
    public String userCntId;
    public Integer mssgSize {get; set;}  
    List<Inbox__c> inRecords = new List<Inbox__c>();
    public InboxController()
    {
        String usrId = UserInfo.getUserId();
        User usr= [Select AccountId, ContactId FROM User Where ID =: usrId];
        usrAcctId = usr.AccountId;
        userCntId = usr.ContactId;
        inRecords = [Select Id, Name, CreatedDate, Subject__c, Reseller_Account__r.Name, Status__c, Message__c, Reseller_Account__c, Reseller_Contact__r.Name, Customer_Account__c FROM Inbox__c Where Customer_Account__c =: usrAcctId order by CreatedDate DESC];
        mssgSize = inRecords.size();       
    }
    
    public InboxWrapper[] getUnreadMssgs()
    {         
      
        List<InboxWrapper> wraperList = new List<InboxWrapper>();       
        for(Inbox__c inb : inRecords)
        {
            InboxWrapper inw = new InboxWrapper();
            inw.inId = inb.Id;
            inw.resAcctName = inb.Reseller_Account__r.Name;
            inw.resContName = inb.Reseller_Contact__r.Name;
            inw.cDate = inb.CreatedDate;
            inw.status = inb.Status__c;
            inw.message = inb.message__c;
            inw.subject= inb.subject__c;
            wraperList.add(inw);          
        }
       
        return wraperList;
                
    }   
    public class InboxWrapper
    {
        public String inId{get;set;}
        public String resAcctName{get;set;}
        public String resContName{get;set;}
        public Datetime cDate{get;set;}
        public String status{get;set;}
        public String message{get;set;}
        public String subject{get;set;}
    } 
    
    @RemoteAction
    global static String updateStatus(String inId)
    {
        Inbox__c inb = new Inbox__c(id = inId, status__c = 'Read');
        update inb;
        return 'success';
    }
    
  
}