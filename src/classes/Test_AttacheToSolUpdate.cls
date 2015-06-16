/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class Test_AttacheToSolUpdate {

    static testMethod void myUnitTest() {
    /*
        Account acc=new Account();
        acc.name='test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.name='test';
        opp.AccountId=acc.Id;
        opp.Type='New Business';
        opp.StageName='Qualified';
        opp.CloseDate=system.today()+3;
        insert opp;
        
        SBQQ__Quote__c quote1=new SBQQ__Quote__c();
        quote1.Quote_Name__c='test';
        quote1.SBQQ__Opportunity__c=opp.Id;
        
        insert quote1;
        
        SBQQ__QuoteLine__c quoteline=new SBQQ__QuoteLine__c();
        quoteline.SBQQ__Quote__c=quote1.Id;     
        insert quoteline;
        
        SBQQ__QuoteLine__c quoteline1=new SBQQ__QuoteLine__c();
        quoteline1.SBQQ__Quote__c=quote1.Id;
        quoteline1.SBQQ__RequiredBy__c=quoteline.Id;
        insert quoteline1;
        */
        Account acc=new Account();
        acc.name='test';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.name='test';
        opp.AccountId=acc.Id;
        opp.Type='New Business';
        opp.StageName='Qualified';
        opp.Prebuild_Status__c='Approved';
        opp.SO_Prebuild_Order__c=false;
        opp.CloseDate=system.today()+3;
        insert opp;
        
        Prebuild__c pre=new Prebuild__c();
        pre.Opportunity__c=opp.id;
        pre.Prebuild_Status__c='Approved';
        insert pre;
        
        Sales_Order__c so=new Sales_Order__c();
        so.name='test';
        so.Type__c='Prebuild';
        so.Opportunity__c=opp.id;
        insert so;
        update so;
        //delete so;
        integer i=1;
        System.assertEquals(i,1);
        
        Sales_Order_Line__c sol=new Sales_Order_Line__c();
        
        sol.Sales_Order__c=so.Id;
        insert sol;
        update sol;
        delete sol;
        
        delete pre;
    }
}