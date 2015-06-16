@isTest
public class Test_CntrbnMdlTSETrigger 
{
    
    static testMethod void testTSETimeZoneConversion()
    {
        CntrbnMdl_TSE__c tse = new CntrbnMdl_TSE__c();       
        insert tse;
        tse.Enter_Starttime__c = System.now();
        update tse;
        CntrbnMdl_TSE__c utse = [select Id, DateTime_Eastern__c, Datetime_GMT__c, Datetime_Pacific__c, Datetime_Singapore__c from CntrbnMdl_TSE__c where Id =:tse.Id];
        System.assertnotEquals(utse.DateTime_Eastern__c,null);
        System.assertnotEquals(utse.Datetime_GMT__c,null);
        System.assertnotEquals(utse.Datetime_Pacific__c,null);
        System.assertnotEquals(utse.Datetime_Singapore__c,null);        
    }

}