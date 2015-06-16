public class CaseKBArticleController 
{ 
public List<KBType> kbTypes{get;set;}
public Case c;
public CaseKBArticleController(ApexPages.StandardController stdController)
{
kbTypes = new List<KBType>();
c = (Case)stdController.getRecord();
c = [select Id,casecatcategory__c,casesubcategory__c from Case where Id =: c.Id];
List<Category_Notes__c> cnList = [select Id, Article_Ids__c from Category_Notes__c where Category__c =: c.casecatcategory__c and sub_category__c =: c.casesubcategory__c];
if(cnList.size() > 0)
{
Category_Notes__c cn = cnList.get(0);
Set<String> artIdSet = new Set<String>();
if(cn.Article_Ids__c != null)
{
List<String> artIds = cn.Article_Ids__c.split(':');
artIdSet.addAll(artIds);
}
List<KB_Article__kav> kbarticles = [SELECT Id,KnowledgeArticleId, Title FROM KB_Article__kav where PublishStatus = 'Online' AND language ='en_US' and KnowledgeArticleId in :artIdSet];
for(KB_Article__kav kb : kbarticles)
{
KBType kt = new KBType();
kt.title = kb.Title;
kt.kbId = kb.KnowledgeArticleId;
kbTypes.add(kt);
}
}
}
public class KBType
{
public String kbId{get;set;}
public String title{get;set;}
}

}