global with sharing class CaseRecommendation{
private List<Outstanding_Recommendation__c> recz;
public Case cse{get;set;}
public String cseAccountID = null;

public integer list_size=30; //sets the page size or number of rows
public integer total_size; //used to show user the total size of the list

    public CaseRecommendation(ApexPages.StandardController controller) {
        this.cse=(Case)controller.getRecord();
        
        if(cse.id != null)
        { 
            Case cas = [Select id, Account.id FROM Case where id =:cse.id];
            
            if(cas.Account!=null)
            {
                this.cseAccountID = cas.Account.Id;
                executeCount();
            }
        }
    }
    
    public void executeCount()
    {
            this.total_size = [select count() from Outstanding_Recommendation__c where Account__r.Id =:cseAccountID];
    }
    
     public List<Outstanding_Recommendation__c> getRecz()
    {
        if(cseAccountID == null)
        return null;
        recz = [Select id, Name,Status__c,Recommended_Action__c, Account__r.Name,Case__r.CaseNumber,Asset__r.Name,Contact__r.Name from Outstanding_Recommendation__c where Account__r.Id =:cseAccountID ORDER BY Case__r.CaseNumber limit:list_size];
        return recz;
    }
    
    public PageReference showMore() { 
       list_size = list_size + 10;
       return null;
   }
   
   public String getFooter()
   {
     
     if(total_size > list_size)
     {
        return 'Showing Record(s) ' + list_size + ' out of ' + total_size;
     }
     else if(total_size <= list_size && total_size != 0)
     {
        return 'Showing Record(s) ' + total_size+ ' out of ' + total_size;
     }
     else
     {
        return 'No Records to Display';
     }
   }
   
   public Boolean getdisableValue()
   {
     if(total_size <= list_size || total_size ==0)
     {
        return true;
     }
     else
     {
        return false;
     }
   }
   
}