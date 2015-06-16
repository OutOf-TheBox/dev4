@istest
public class testevalasset{
   static testmethod void mytestmethod()
   {
   Test.startTest();
 account acc=new account(name='pri',CurrencyIsoCode='',type='distributor');
 insert acc;
       
       
       opportunity opp = new opportunity(name='test Opp',type='New Business',Sales_Area__c='NA West North',CurrencyIsoCode='',Reseller_Account__c=acc.id,StageName='prospect',closedate=date.today());
           insert opp;
              
Asset ase=new asset(name='assettest', CurrencyIsoCode='', Accountid=acc.id, Order_Type__c='Eval Unit', Opportunity__c=opp.id);
       Insert ase;
       Asset ase2=new asset(name='assettest2',CurrencyIsoCode='',Accountid=acc.id, Order_Type__c='Eval Unit', Opportunity__c=opp.id);
       Insert ase2;
       
      
       
       Test.stopTest(); }
}