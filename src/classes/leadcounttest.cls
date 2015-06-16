@istest
public class leadcounttest{
static testmethod void mytestmethod()
   {
   Test.startTest();
       lead la=new lead(LastName='testclass', company='tecom', CurrencyIsoCode='', Status='open');
       insert la;
       
       task ta1=new task(CurrencyIsoCode='', Subject='NOTE: lead status changed to OPEN', whoid=la.id, status='Completed');
       insert ta1;
       
       task ta=new task(CurrencyIsoCode='', Subject='Call:Not In', whoid=la.id, status='Completed');
       insert ta;
       
      task ta2=[select id, subject from task where id=:ta.id];
     delete ta2;
       
       Test.stopTest();
   }}