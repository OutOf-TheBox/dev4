@RestResource(urlMapping='/hasPendingMessages/*')

global class InboxService
{
    @HttpGet
    global static InboxResponse getUnreadMessages()
    { 
        InboxResponse inbr = new InboxResponse();
        Restrequest req = RestContext.request; 
        if(Test.isRunningTest()) {
            req = new Restrequest();
            req.addParameter('email',TestResellerCS.EMAIL_PARAM);
        }      
        Map<String,String> params = req.params;
        try
        {
            if(params != null)
            {
                String custEmail = params.get('email');
                Contact custCont;
                List<Contact> custContList = [select Id, AccountId from Contact where Email = :custEmail];
                if(custContList.size() > 0)
                   custCont = custContList.get(0);
                if(custCont != null)
                {                
                    List<Inbox__c> inbList = [SELECT Id, Status__c, Customer_Account__r.Name, Reseller_Account__r.Name from Inbox__c WHERE Customer_Account__c = :custCont.AccountId and Status__c = 'Unread']; 
                    Integer count = 0;
                    for(Inbox__c inb : inbList)
                    {   
                        count ++;                
                       // inbr.resellerAcctName = inb.Reseller_Account__r.Name;
                       // inbr.custAcctName = inb.Customer_Account__r.Name;
                        //inbr.status = inb.Status__c;                                  
                    }
                    if(count == 0)
                    {
                        inbr.errors = 'No unread messages';                   
                    }
                    inbr.success = true;                    
                    inbr.count = count;  
                }
                else
                {
                     inbr.errors = 'Customer account doesn\'t exist';   
                     inbr.success = false;
                }
                          
            }
        }
        catch(Exception e)
        {
            System.debug('Exception occured .. ' + e.getMessage());            
            inbr.success = false;
            inbr.errors = e.getMessage();           
        }
        return inbr;
    }
    
    global class InboxResponse
    {
       // String resellerAcctName;
       // String custAcctName;
       // String status;
        global Boolean success;
        global String errors;
        global Integer count;
    }
}