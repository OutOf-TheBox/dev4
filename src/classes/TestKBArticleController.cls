@isTest(SeeAllData=true)
public class TestKBArticleController 
{

    static testMethod void testKBArticleForCatAndSubCat()
    {
        Category_Notes__c cn = new Category_Notes__c(Notes__c='Question1:',Category__c='Cisco UCS Integration',Sub_Category__c='Boot from SAN');
        insert cn;
        KB_Article__kav kb = [select Id, KnowledgeArticleId, title from KB_Article__kav where PublishStatus = 'Online' AND language ='en_US' limit 1];
        //Test the KBArticleAddPage
        ApexPages.StandardController sc = new ApexPages.StandardController(cn);
        KBArticleAddController cnctrl = new KBArticleAddController(sc);
        PageReference pageRef = Page.KBArticleAddPage;
        Test.setCurrentPage(pageRef);
        cnctrl.cn = cn;
        KBArticleAddController.KBType kbType = new KBArticleAddController.KBType();
        kbType.kbId = kb.KnowledgeArticleId;
        kbType.title = kb.Title;
        kbType.include = true;
        List<KBArticleAddController.KBType> kbTypes = new List<KBArticleAddController.KBType>();
        kbTypes.add(kbType);
        cnctrl.kbTypes = kbTypes;
        PageReference pgref = cnctrl.saveKBArticles();
        Category_Notes__c cn1 = [select Id, Article_Ids__c from Category_Notes__c where id =: cn.Id];
        System.assertEquals(kb.KnowledgeArticleId + ':', cn1.Article_Ids__c);
        System.assertEquals(pgref.getUrl(),'/' + cn.Id);
        
        //Test the KBArticleDisplayPage
        ApexPages.StandardController sc1 = new ApexPages.StandardController(cn);
        KBArticleDisplayController cnctrl1 = new KBArticleDisplayController(sc1);
        PageReference pageRef1 = Page.KBArticleDisplayPage;
        Test.setCurrentPage(pageRef1);
        
        //Test the CaseKBArticlePage
        Case c = new Case(casecatcategory__c='Cisco UCS Integration',casesubcategory__c='Boot from SAN');
        insert c;
        ApexPages.StandardController sc2 = new ApexPages.StandardController(c);
        CaseKBArticleController cnctrl2 = new CaseKBArticleController(sc2);
        PageReference pageRef2 = Page.CaseKBArticlePage;
        Test.setCurrentPage(pageRef2);
        cnctrl2.c = c;
    }
}