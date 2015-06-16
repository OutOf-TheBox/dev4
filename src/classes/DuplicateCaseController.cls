public class DuplicateCaseController
{
public Case c;
public DuplicateCaseController(ApexPages.StandardController stdController)
{      
   c = (Case)stdController.getRecord();         
}
public PageReference saveDuplicate()
{
    try
    {
        String pId = c.Duplicate_Case__c; // Get the parent case Id
        System.debug('Parent id...' + pId);
        //Query the parent case
        Case pCase = [select Id, Reason, Type, Category__c from Case where Id =: pId];
        c.Status = 'Closed(Duplicate)';
        c.Reason = pCase.Reason;
        c.Type=pCase.Type;
        c.Category__c =pCase.Category__c;
        c.caseAttnReq__c= false;
        update c;
        return new PageReference('/'+c.Id);
    }
    catch(Exception e)
    {
        System.debug('Exception occured..' + e.getMessage());
        ApexPages.addMessages(e);
    }
    return null;
    
}
}