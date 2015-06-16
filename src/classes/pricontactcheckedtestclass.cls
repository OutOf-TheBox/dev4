@istest
public class pricontactcheckedtestclass{
   static testmethod void mytestmethod()
   {
   Test.startTest();


 account acc=new account(name='pri',CurrencyIsoCode='',type='distributor');
 insert acc;
 Account acc2 = new Account(name='test account',type='reseller',CurrencyIsoCode='', Distributor__c=acc.id,Distributor_Email__c='pri@gmail.com');


insert acc2;
      
opportunity opp = new opportunity(name='test Opp',type='New Business',Sales_Area__c='NA West North',CurrencyIsoCode='',Reseller_Account__c=acc2.id,StageName='prospect',closedate=date.today());


           insert opp;
contact con= new contact(lastname='samplecontact',accountid=acc2.id,CurrencyIsoCode='');
insert con;
       
      OpportunityContactRole opcr=new OpportunityContactRole(ContactId=con.id,OpportunityId=opp.id,IsPrimary=false, Role='Decision Maker');

 
insert opcr; 

opportunity opup=[select id,name,type from opportunity where id=:opp.id];

opup.name='test oppup';
 
Test.stopTest(); }}