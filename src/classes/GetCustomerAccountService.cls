@RestResource(urlMapping='/customeracct/*')
global class GetCustomerAccountService
{
    @HttpGet
    global static AccountResponse getCustomerAccounts()
    { 
        AccountResponse ar = new AccountResponse();
        try
        {
            Restrequest req = RestContext.request;
            if(Test.isRunningTest()) {
            req = new Restrequest();
            req.addParameter('email',TestResellerCS.EMAIL_PARAM);
            }
            Map<String,String> params = req.params;
            if(params != null)
            {
               
                String resEmail = params.get('email');           
                List<Reseller_Contact__c> rcList = [SELECT Id, Status__c, resellerCustomerAccount__r.Name, Reseller_Account__r.Name, Reseller_Account__c, resellerCustomerAccount__c, Res_Email__c, Asset__r.SerialNumber from Reseller_Contact__c WHERE Res_Email__c = :resEmail]; 
                List<AccountData> customers = new List<AccountData>();             
                for(Reseller_Contact__c rc : rcList)
                {
                   AccountData ad = new AccountData();
                   if(rc.Status__c == 'Approved'){
                       ad.name = rc.resellerCustomerAccount__r.Name;
                       }
                   else{
                       ad.name = rc.Asset__r.SerialNumber;                   
                   }
                   ad.status =  rc.Status__c;
                   ad.Id= rc.resellerCustomerAccount__c;
                   ar.resellerAcctName=   rc.Reseller_Account__r.Name;   
                   ar.resellerAcctId =    rc.reseller_account__c  ;               
                   customers.add(ad);
                }
                if(rcList.size() == 0)
                {                   
                    ar.errors = 'No customer accounts';                    
                }
                ar.resellerEmail = resEmail ;
                ar.customers = customers;                
                ar.success = true;  
            }
        }
        catch(Exception e)
        {                                   
            ar.success = false;
            ar.errors = e.getMessage();           
        }
      
        return ar;
    }
    
    global class AccountResponse
    {
        global String resellerEmail;
        global String resellerAcctId;
        global String resellerAcctName;
        global List<AccountData> customers;       
        global Boolean success;
        global String errors;
    }
    global class AccountData
    {
        String name;
        String status; 
        String id;
    }
}