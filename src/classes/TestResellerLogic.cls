@IsTest

public class TestResellerLogic
{

    private static Account customerAccount;
    private static Account resellerAccount;

    private static Contact resellerContactOne;
    private static Contact resellerContactTwo;
    private static Contact customerContactOne;
    
    private static String resellerContactEmailOne = 'mhayashi@nimblestorage.com';
    private static String resellerContactEmailTwo = 'ssrinivas@nimblestorage.com';
    private static String customerContactEmailOne = 'paitha@nimblestorage.com';
    
    
    public static testMethod void testResellerApproveReject()
    {
        init();
        System.debug('customer account = ' + customerAccount);
    }
    
    private static void init()
    {
        customerAccount = createAccount('TestEbay', true);
        createContact(customerContactEmailOne, customerAccount);
        
        
        resellerAccount = createAccount('TestResellerFoo', false);
        createContact(resellerContactEmailOne, resellerAccount);
        createContact(resellerContactEmailTwo, resellerAccount);

        
    }
    
    private static Account createAccount(String name, boolean isCustomer)
    {
    
        Account acc = new Account();
        acc.name = name;
        acc.CurrencyIsoCode='USD';
        if (isCustomer)
        { 
            acc.type = 'Customer';
        }
        else
        {
            acc.type = 'Reseller';
        }
        insert acc;
        return acc;
     }
     
     private static Contact createContact(String email, Account acc)
     {
         Contact c = new Contact();
         c.lastName = email;
         c.email = email;
         c.account = acc;
         insert c;
         return c;
     }

}