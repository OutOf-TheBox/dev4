/* Apex REST Service to create a reseller contact record.
*  Validate customer and reseller account.
*  Upsert the reseller contact record with status 'Pending'
*/
@RestResource(urlMapping='/resellercontact/*')
global class ResellerContactService
{
    static List<responseMsg> resSet = new List<responseMsg>();        
    
    @HttpPost
    global static List<responseMsg> insertResellerContactfromIS()
    {  
        Restrequest req = RestContext.request;  
        
        //if this class is executed by test class, the JSON req is hardcoded   
        if(Test.isRunningTest()) {
            req = new Restrequest();
            String str = TestResellerCS.TEST_JSON_REQ; 
            req.requestBody = Blob.valueOf(str);
        }
        try
        {           
            //Deserialize the JSON request coming from external source           
            ResellerContactType[] ctTypeList = (ResellerContactType[])JSON.deserialize(req.requestBody.toString(), List<ResellerContactType>.class);
            if(ctTypeList != null)
            {   
               
                Reseller_Contact__c[] rcList = convertJSONObjtoResellerContact(ctTypeList);                 
                Database.UpsertResult[] results = Database.upsert(rcList,Reseller_Contact__c.External_Key__c.getDescribe().getSObjectField(),false);               
                for(Integer i = 0;i < results.size(); i++)
                { 
                    responseMsg res = new responseMsg(); 
                    if(results[i].isSuccess())
                    {
                        res.success = true;
                        if(!results[i].created)
                        {
                            res.success = false;
                            res.errors = 'Request already exists.';
                        }
                     //   res.custEmail = ctTypeList[0].custEmail;
                       // res.resellerEmail = ctTypeList[0].resellerEmail;
                    }
                    else
                    {
                        res.success = false;
                        res.errors = results[i].getErrors()[0].getMessage();
                      //  res.custEmail = ctTypeList[0].custEmail;
                      //  res.resellerEmail = ctTypeList[0].resellerEmail;
                    }
                     resSet.add(res); 
                   
                }
                  
            }
        }
        catch(Exception e)
        {
            System.debug('Exception occured..'+e.getMessage());
            responseMsg res = new responseMsg();
            res.success = false;
            res.errors = e.getMessage();
            resSet.add(res);
        }
        return resSet;
    }
    // Type class for deserializing the JSON input
    global class ResellerContactType
    {        
        String custAcctId;
        //String custAccount;
        String resellerEmail;
        String assetSerialNum;
        //String resellerAccount;        
    }
    
   
    global static Reseller_Contact__c[] convertJSONObjtoResellerContact(ResellerContactType[] ctTypes)
    {
        Reseller_Contact__c[] rcList = new Reseller_Contact__c[]{};
        Map<String,Contact> custAcctMap = new Map<String,Contact>();
        Set<String> emailStr = new Set<String>();
        //Set<String> resEmailStr = new Set<String>();
        Set<String> custAcctIds = new Set<String>();
        Set<String> asstSNums = new Set<String>();
        if(ctTypes != null && ctTypes.size() > 0)
        {
           
            for(ResellerContactType ct : ctTypes)
            {
               // emailStr.add(ct.custEmail);
                custAcctIds.add(ct.custAcctId);                
                emailStr.add(ct.resellerEmail);  
                if(ct.assetSerialNum != null)              
                    asstSNums.add(ct.assetSerialNum);
            }
         
            List<Contact> custConts = [select Id,Email,AccountId from Contact where Email in :emailStr and Account.Type IN('Reseller','Distributor','Sub Distributor')];
            Map<Id,Account> acctMap = new Map<Id,Account>([select Id from Account where Id in :custAcctIds]);
            List<Asset> asstList = [select Id, SerialNumber, AccountId from Asset where SerialNumber in :asstSNums];
            for(Contact c : custConts)
            {
                custAcctMap.put(c.Email,c);
            }
            Map<String,Asset> asstMap = new Map<String,Asset>();  
            for(Asset asst : asstList)
            {
                asstMap.put(asst.SerialNumber,asst);
            }        
            for(ResellerContactType ct : ctTypes)
            {
                //Contact custCont = custAcctMap.get(ct.custEmail);
                Contact resellerCont = custAcctMap.get(ct.resellerEmail);
                Account custAcct = acctMap.get(ct.custAcctId);   
                Asset asst  = asstMap.get(ct.assetSerialNum); 
                List<Opportunity> oppList = [select Id from Opportunity where AccountId = :asst.AccountId and Reseller_Account__c = :resellerCont.AccountId];
                
                if(custAcct != null && resellerCont != null && oppList.size() > 0)
                {
                    Reseller_Contact__c rc = new Reseller_Contact__c();
                    rc.resellerCustomerAccount__c = ct.custAcctId;
                    rc.Reseller_Account__c = resellerCont.AccountId;
                    rc.ResellerContact__c = resellerCont.Id;
                    rc.External_Key__c = rc.resellerCustomerAccount__c + '' + rc.ResellerContact__c;
                    List<Reseller_Contact__c>  rc1 = [select Id from Reseller_Contact__c where External_Key__c =: rc.External_Key__c and Status__c = 'Approved'];
                    if(rc1.size() == 0)
                        rc.Status__c = 'Pending';  
                    if(asst != null)
                        rc.Asset__c = asst.Id;
                    rcList.add(rc);  
                }
               
                else 
                {
                    if(custAcct == null)
                    {
                        responseMsg res = new responseMsg();
                        res.success = false;
                        res.errors = 'Customer account doesn\'t exist in SFDC';
                      //  res.custEmail = ct.custEmail;
                     //   res.resellerEmail = ct.resellerEmail;
                        resSet.add(res);
                    }
                    else if(oppList.size() == 0)
                    {
                        responseMsg res = new responseMsg();
                        res.success = false;
                        res.errors = 'Asset is not valid for the reseller contact';
                      //  res.custEmail = ct.custEmail;
                     //   res.resellerEmail = ct.resellerEmail;
                        resSet.add(res);
                    }
                    else
                    {
                        responseMsg res = new responseMsg();
                        res.success = false;
                        res.errors = 'Reseller contact doesn\'t exist in SFDC';
                      //  res.custEmail = ct.custEmail;
                     //   res.resellerEmail = ct.resellerEmail;
                        resSet.add(res);
                    }
                }
                }
               
        }
        
        return rcList;        
    }
    
    //Type class for respone to external source.
    global class responseMsg
    {        
        global String errors;
        global Boolean success;
       // String custEmail;
       // String resellerEmail;
    }
    
    
}