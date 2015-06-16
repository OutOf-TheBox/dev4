public class KBArticleAddController
{
public List<KBType> kbTypes{get;set;}
public Category_Notes__c cn;
public KBArticleAddController(ApexPages.StandardController stdController)
{
kbTypes = new List<KBType>();
cn = (Category_Notes__c)stdController.getRecord();
cn = [select Id, Article_Ids__c from Category_Notes__c where Id =: cn.Id];
Set<String> artIdSet = new Set<String>();
if(cn.Article_Ids__c != null)
{
List<String> artIds = cn.Article_Ids__c.split(':');
artIdSet.addAll(artIds);
}
List<KB_Article__kav> kbarticles = [SELECT Id, KnowledgeArticleId, Title FROM KB_Article__kav where PublishStatus = 'Online' AND language ='en_US'];
for(KB_Article__kav kb : kbarticles)
{
KBType kt = new KBType();
kt.title = kb.Title;
kt.kbId = kb.KnowledgeArticleId;
if(artIdSet.contains(kb.KnowledgeArticleId))
{
kt.include = true;
}
else
{
kt.include = false;
}
kbTypes.add(kt);
}
}
public PageReference saveKBArticles()
{
String artIds = '';
for(KBType kt : kbTypes)
{
if(kt.include)
{
artIds = artIds + kt.kbId + ':';
}
}
cn.Article_Ids__c = artIds;
update cn;
PageReference pg = new PageReference('/' + cn.Id);
return pg;
}
public class KBType
{
public String kbId{get;set;}
public String title{get;set;}
public boolean include{get;set;}
}

}