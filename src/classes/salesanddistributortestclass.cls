@istest
public class salesanddistributortestclass{
   static testmethod void mytestmethod()
   {
   Test.startTest();
 account acc=new account(name='vin',CurrencyIsoCode='',type='distributor');
 insert acc;
 Account acc2 = new Account(name='test account',type='reseller',CurrencyIsoCode='', Distributor__c=acc.id,Distributor_Email__c='vin@gmail.com');
insert acc2;

      Account acc3 = new Account(name='test account',type='reseller',CurrencyIsoCode='');
insert acc3;
opportunity opp = new opportunity(name='test Opp', type='New Business', Sales_Area__c='NA West North',CurrencyIsoCode='', Reseller_Account__c=acc2.id,StageName='prospect', closedate=date.today());
           insert opp;
       
       opportunity opp1 = new opportunity(name='test Opp', type='New Business', Sales_Area__c='NA West North',CurrencyIsoCode='', Reseller_Account__c=acc3.id,StageName='prospect', closedate=date.today());
           insert opp1;
       
    SBQQ__Quote__c qt=new SBQQ__Quote__c( SBQQ__Type__c='Revenue', SBQQ__Status__c='Draft', Quote_Produced_or__c='Reseller', SBQQ__Opportunity__c=opp.id);
           insert qt;
            SBQQ__Quote__c qtsa=[select id,SBQQ__BillingName__c from SBQQ__Quote__c where id=:qt.id];
            System.assertEquals('vin', qtsa.SBQQ__BillingName__c);
       
       SBQQ__Quote__c qt1=new SBQQ__Quote__c( SBQQ__Type__c='Revenue', SBQQ__Status__c='Draft', Quote_Produced_or__c='Reseller', SBQQ__Opportunity__c=opp1.id);
           insert qt1;
            SBQQ__Quote__c qtsa1=[select id,SBQQ__BillingName__c from SBQQ__Quote__c where id=:qt1.id];
            System.assertEquals('test account', qtsa1.SBQQ__BillingName__c);
           
Sales_Order__c sal=new Sales_Order__c(Name='rac', Type__c='Beta', CurrencyIsoCode='', opportunity__c=opp.id);
Insert sal;
           
Test.stopTest(); }}