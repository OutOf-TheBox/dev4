@isTest
public class TestResellerCS
{
public static String TEST_JSON_REQ; 
public static String EMAIL_PARAM;
static testMethod void testRCPostResquest()
{
Account resAcct = new Account(Name = 'TestResAcct', Type = 'Reseller');
insert resAcct; //create reseller account
Account custAcct = new Account(Name = 'TestCustAcct', Type = 'Customer');
insert custAcct; //create customer account
Contact resCont = new Contact(FirstName = 'Test_FN', LastName = 'Test_LN' , AccountId = resAcct.Id, Email = 'resemail@test.com');
insert resCont; // create reseller contact
Contact custCont = new Contact(FirstName = 'Test_c_FN', LastName = 'Test_c_LN', AccountId = custAcct.Id, Email = 'custemail@test.com');
insert custCont; // create customer contact
Asset asst = new Asset(Name = 'Test_Asst', AccountId = custAcct.Id, SerialNumber = 'Test_Asst');
insert asst;
Opportunity opp = new Opportunity(Name = 'Test_Opp', AccountId = custAcct.Id, Reseller_Account__c = resAcct.Id,StageName='1-Prequalified',CloseDate=System.today());
insert opp;

String email = resCont.Email;
String acctId = custAcct.Id;
String assetSerialNum = 'Test_Asst';
//test json string
TEST_JSON_REQ = '[{"custAcctId":"' + acctId + '","resellerEmail":"' + email + '","assetSerialNum":"' + assetSerialNum +'"}]';

//Call the service with correct data
List<ResellerContactService.responseMsg> resMss = ResellerContactService.insertResellerContactfromIS();
if(resMss != null)
{
    ResellerContactService.responseMsg res = resMss.get(0);
    System.assertEquals(true,res.success);
}

//Call the service with incorrect data
email = 'wronemail@test.com';
TEST_JSON_REQ = '[{"custAcctId":"' + acctId + '","resellerEmail":"' + email + '","assetSerialNum":"' + assetSerialNum +'"}]';
resMss = ResellerContactService.insertResellerContactfromIS();
if(resMss != null)
{
    ResellerContactService.responseMsg res = resMss.get(1);
    System.assertEquals(false,res.success);
}

//Call the service to test exception
acctId = '00000000000';
TEST_JSON_REQ = '[{"custAcctId":"' + acctId + '","resellerEmail":"' + email + '","assetSerialNum":"' + assetSerialNum +'"}]';
resMss = ResellerContactService.insertResellerContactfromIS();
if(resMss != null)
{
    ResellerContactService.responseMsg res = resMss.get(2);
    System.assertEquals(false,res.success);
}
    
//call service with wrong asset
assetSerialNum = 'Test_wronasset';
TEST_JSON_REQ = '[{"custAcctId":"' + acctId + '","resellerEmail":"' + email + '","assetSerialNum":"' + assetSerialNum +'"}]';
resMss = ResellerContactService.insertResellerContactfromIS();
if(resMss != null)
{
    ResellerContactService.responseMsg res = resMss.get(2);
    System.assertEquals(false,res.success);
}
    
    
acctId = custAcct.Id;
email = resCont.Email;
TEST_JSON_REQ = '{"custAcctId":"' + acctId + '","resellerEmail":"' + email + '"}';
ResellerContactLastAccessService.ResponseMsg  res = ResellerContactLastAccessService.updateLastAccessDate();
if(res != null)
{
   System.assertEquals(true,res.success);
   System.assertEquals(null,res.errors);
}
email = 'wronemail@test.com';
TEST_JSON_REQ = '{"custAcctId":"' + acctId + '","resellerEmail":"' + email + '"}';
res = ResellerContactLastAccessService.updateLastAccessDate();
if(res != null)
{
     System.assertEquals(false,res.success);
     System.assertNotEquals(null,res.errors);
}

//Call the service to test exception
acctId = '00000000000';
TEST_JSON_REQ = '{"custAcctId":"' + acctId + '","resellerEmail":"' + email + '"}';
res = ResellerContactLastAccessService.updateLastAccessDate();
if(res != null)
{
     System.assertEquals(false,res.success);
     System.assertNotEquals(null,res.errors);
}


EMAIL_PARAM = 'resemail@test.com';
GetCustomerAccountService.AccountResponse accRes = GetCustomerAccountService.getCustomerAccounts();
if(accRes != null)
{
    System.assertEquals(true,accRes.success);
}
EMAIL_PARAM  = 'wronemail@test.com';
accRes = GetCustomerAccountService.getCustomerAccounts();
if(accRes != null)
{
   System.assertEquals(true,accRes.success);
   System.assertNotEquals(null,accRes.errors);
}

EMAIL_PARAM = 'custemail@test.com';
InboxService.InboxResponse inRes= InboxService.getUnreadMessages();
if(inRes != null)
{
    System.assertEquals(true,inRes.success);    
}
}
}