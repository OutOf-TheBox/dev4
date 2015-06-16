public class CategoryNotesNewController 
{
    public Case c{get;set;}
    public Category_Notes__c cn{get;set;}
    public CategoryNotesNewController(ApexPages.StandardController stdController)
    {
        this.cn = (Category_Notes__c)stdController.getRecord();
        if(this.cn == null)
        {
             c = new case(casecatCategory__c='', casesubcategory__c ='');
             cn = new Category_Notes__C();// added
        }
        else
        {
            List<Category_Notes__c> cnList = [select Id, Category__c,sub_category__c, notes__c from Category_Notes__c where Id =: cn.Id];
            if(cnList.size() > 0)
            {
                cn = cnList.get(0);
             	c = new case(casecatcategory__c=cn.Category__c, casesubcategory__c = cn.Sub_Category__c );
            }
            else
            {
                c = new case(casecatcategory__c='',casesubcategory__c ='');
                cn = new Category_Notes__C();// added
            }
        }
    }
    public PageReference saveCategoryUserOnInsert()
    {
        cn.Category__c=c.casecatCategory__c; //added
        cn.Sub_Category__c=c.caseSubCategory__c;//added
        insert cn;
        PageReference pg = new PageReference('/' + cn.Id);
        return pg;
    }
    public PageReference saveCategoryUserOnUpdate()
    { 
        cn.Category__c=c.casecatCategory__c;
        cn.Sub_Category__c=c.caseSubCategory__c;
        update cn;
        PageReference pg = new PageReference('/' + cn.Id);
        return pg;
    }

}