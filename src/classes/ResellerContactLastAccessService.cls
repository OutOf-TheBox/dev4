@RestResource(urlMapping='/rclastaccess/*')

global class ResellerContactLastAccessService
{
    static ResponseMsg res = new ResponseMsg();
    @HttpPost
    global static ResponseMsg updateLastAccessDate()
    {        
        Restrequest req = RestContext.request;
        if(Test.isRunningTest()) {
            req = new Restrequest();
            String str = TestResellerCS.TEST_JSON_REQ; 
            req.requestBody = Blob.valueOf(str);
        }  
        try
        {
            ResellerContactType ctType = (ResellerContactType)JSON.deserialize(req.requestBody.toString(), ResellerContactType.class);
            if(ctType != null)
            {   
               Reseller_Contact__c rc = convertJSONObjtoResellerContact(ctType); 
               
               if(rc != null)
               {
                    update rc;
                    res.success = true;
                    res.errors = null;
                   // res.custEmail = ctType.custEmail;
                   // res.resEmail = ctType.resEmail;
               }
            }
        }
        catch(Exception e)
        {
              System.debug('Exception occured..' + e.getMessage());
              res.success = false;
              res.errors = e.getMessage();
        }
        return res;
        
    }
    
    global static Reseller_Contact__c convertJSONObjtoResellerContact(ResellerContactType ctType)
    { 
        Reseller_Contact__c rc;
        try
        {
            List<Account> custAccts = [select Id from Account where Id =: ctType.custAcctId];
            List<Contact> resConts =  [select Id, AccountId from Contact where Email =: ctType.resellerEmail and Account.Type IN('Reseller','Distributor')];                
          //  res.custEmail = ctType.custEmail;
          //  res.resEmail = ctType.resEmail;
            Account custAcct;
            Contact resCont;
            if(custAccts.size() > 0)
                custAcct = custAccts.get(0);
            if(resConts.size() > 0)
                resCont = resConts.get(0);          
            if(custAcct != null && resCont != null)
            {
                String key = custAcct.Id  + '' + resCont.Id;               
                rc = [select Id from Reseller_Contact__c rc where External_Key__c =: key];
                rc.Last_Accessed_Date__c = System.today();               
            }
            else 
            {
                if(custAcct == null)
                {
                    res.success = false;
                    res.errors = 'Customer account doesn\'t exist in SFDC';
                }
                else
                {
                    res.success = false;
                    res.errors = 'Reseller contact doesn\'t exist in SFDC';
                }
            }
           
            
        }
        catch(Exception e)
        {
           res.success = false;
           res.errors = e.getMessage();
        }
       
        return rc;
    }
    
    global class ResponseMsg
    {
        global String errors;
        global Boolean success;
       // String custEmail;
       // String resEmail;      
    }
    global class ResellerContactType
    {
        String custAcctId;
        String resellerEmail;
    }
}