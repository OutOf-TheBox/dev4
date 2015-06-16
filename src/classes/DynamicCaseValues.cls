public class DynamicCaseValues  {

    private Case c;
    private Integer NumContacts;
    private Integer NumAssets;
          
    public DynamicCaseValues(ApexPages.StandardController  controller)  {
        String  qid  =  ApexPages.currentPage().getParameters().get('id');
        String  theQuery  =  'SELECT  Id, AssetId, ContactId FROM  Case WHERE Id = :qid';
        this.c =  Database.query(theQuery);
    } 
    
    public Integer getNumCasesContact()  {
            this.numContacts = [select count() from Case where Status NOT IN( 'Closed','Closed(Duplicate)') AND ContactId = :c.ContactId];
            return  this.numContacts;
    }  
   
    public Integer getNumCasesAsset()  {    
            this.numAssets = [select count() from Case where Status NOT IN ( 'Closed','Closed(Duplicate)') AND AssetId = :c.AssetId];
            return  this.numAssets;
    }    
       public List<Case> listOpenCasesWithAsset
     {get
        {List<Case> cases;

         cases = [Select   Id,
                           CaseNumber,
                           Status,
                           Priority,CreatedDate,
                           Subject,
                           Account.Name,
                           Asset.Name,
                           Contact.Name,
                           caseAttnReqSource__c,
                           caseAttnReqDateTime__c,
                           caseAttnReqCreator__c
                  FROM     Case WHERE AssetId = :c.AssetId AND Status NOT IN ( 'Closed','Closed(Duplicate)') ORDER BY CreatedDate DESC ];

          return(cases);
         }
      set;
     }
    
 }