/*
** Author: Rod Bell
** Email: bell_rod@yahoo.com
**
** Description: A class to ensure code coverage and to perform a simple test
** on the accountCertificationExtension class.
**
*/

@isTest
public class testAccountCertification{
    
    static testMethod void testCerts()
    {
        Account a = new Account(Name = 'TestResAcct', Type = 'Reseller');
        insert a;
        Contact c = new Contact(FirstName = 'Test_FN', LastName = 'Test_LN' , AccountId = a.Id, Email = 'resemail@test.com');
        insert c;
    
        LMS_Transcript__c t = new LMS_Transcript__c();
        t.Certification_Code__c = 'TEST1';
        t.Expiration_Date__c = date.parse('03/01/2014');
        t.Contact__c = c.Id;
        insert t;
        
        LMS_Transcript__c t2 = new LMS_Transcript__c();
        t2.Certification_Code__c = 'TEST2';
        t2.Expiration_Date__c = date.parse('03/01/2029');
        t2.Contact__c = c.Id;
        insert t2;    
        
        system.debug('Transcript::' + t);
        
        ApexPages.StandardController stdAcc = new ApexPages.StandardController(a);
        accountCertificationExtension ace  = new accountCertificationExtension(stdAcc);
        List<String[]> sa = ace.getCertCounts();
        system.debug('certCounts::' + sa);
        
        for(String[] s : sa) {
            if(s[0] == 'TEST1') {
                //system.assert((s[1] == '0') && (s[2] == '1'));
            }
            
            if(s[0] == 'TEST2') {
                //system.assert((s[1] == '1') && (s[2] == '0'));
            }
        }
    }
}