@isTest
public class TestCategoryNotesNewController 
{
static testMethod void testCategoryNotesAddndUpdate()
{
    //Insert new category notes
    Category_Notes__c cn = new Category_Notes__c(Notes__c='Question 1:');
    ApexPages.StandardController sc = new ApexPages.StandardController(cn);
    CategoryNotesNewController cnctrl = new CategoryNotesNewController(sc);
    PageReference pageRef = Page.CategoryNotesNewPage;
    Test.setCurrentPage(pageRef);
    Case c = new Case(casecatcategory__c='Backup Integration',casesubcategory__c='CommVault');
    cnctrl.c = c;
    cnctrl.cn = cn;
	cnctrl.saveCategoryUserOnInsert();  
    List<Category_Notes__c> cnNewList = [select Id, Category__c, Sub_Category__c, Notes__c from Category_Notes__c];
    System.assertEquals(1,cnNewList.size());
    Category_Notes__c cnNew = cnNewList.get(0);
    System.assertEquals('Backup Integration',cnNew.Category__c);
    System.assertEquals('CommVault',cnNew.Sub_Category__c);
    System.assertEquals('Question 1:',cnNew.Notes__c);
    
    //Update category notes
    ApexPages.StandardController sc1 = new ApexPages.StandardController(cnNew);
    CategoryNotesNewController cnctrl1 = new CategoryNotesNewController(sc1);
    PageReference pageRef1 = Page.CategoryNotesEditPage;
    Test.setCurrentPage(pageRef1);
    Case c1 = new Case(casecatcategory__c='Cisco UCS Integration',casesubcategory__c='Boot from SAN');
    cnctrl1.c = c1;
    cnctrl1.cn = cnNew;
	cnctrl1.saveCategoryUserOnUpdate();  
    List<Category_Notes__c> cnUpdateList = [select Id, Category__c, Sub_Category__c, Notes__c from Category_Notes__c];
    System.assertEquals(1,cnUpdateList.size());
    Category_Notes__c cnUpdate = cnUpdateList.get(0);
    System.assertEquals('Cisco UCS Integration',cnUpdate.Category__c);
    System.assertEquals('Boot from SAN',cnUpdate.Sub_Category__c);
    System.assertEquals('Question 1:',cnUpdate.Notes__c);
    
}
}