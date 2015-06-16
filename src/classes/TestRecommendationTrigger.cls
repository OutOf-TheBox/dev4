@isTest
public class TestRecommendationTrigger
{

    static testMethod void testLeadAssignmentonRec()
    {
        Account acc = new Account(Name='Test Acc');
        insert acc;
        Lead l = new Lead(FirstName='Test',LastName='Lead',Company='Test Company',Status='Closed');
        insert l;
        Asset asst = new Asset(Name='Test Asset1', SerialNumber='SN123', AccountId=acc.Id);
        insert asst;
        Asset asst1 = new Asset(Name='Test Asset2',SerialNumber='SN345',Lead__c=l.Id,AccountId=acc.Id);
        insert asst1;
        Recommendation__c rec1 = new Recommendation__c(Asset__c=asst.Id, Asset_SN__c='SN123');
        Recommendation__c rec2 = new Recommendation__c(Asset__c=asst1.Id,Asset_SN__c='SN345');
        Recommendation__c rec3 = new Recommendation__c(Asset__c=asst1.Id,Asset_SN__c='SN678',Status__c='Inactive');
        List<Recommendation__c> recList = new List<Recommendation__c>();
        recList.add(rec1);
        recList.add(rec2);
        recList.add(rec3);
        insert recList;
        Set<Id> recIds = new Set<Id>();
        recIds.add(rec1.Id);
        recIds.add(rec2.Id);
        recIds.add(rec3.Id);
        Map<Id,Recommendation__c> recMap = new Map<Id,Recommendation__c>([select Id, Lead__c,Lead__r.Status,Status__c from Recommendation__c where Id in :recIds]);
        Recommendation__c rec1_v = recMap.get(rec1.Id);
        Recommendation__c rec2_v = recMap.get(rec2.Id);
        System.assertNotEquals(rec1_v.Lead__c,null);
        System.assertEquals(rec2_v.Lead__r.Status,'Open');
        rec2.Status__c = 'Inactive';
        rec2.Recommendation_Text__c = 'Rec text';
        update rec2;
        Lead l_v = [select Id,Lead_Text__c from Lead where Id =: l.Id];
        System.assertEquals(rec2.Recommendation_Text__c,l_v.Lead_Text__c);
        
    }
}