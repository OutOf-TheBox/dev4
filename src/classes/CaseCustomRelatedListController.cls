public class CaseCustomRelatedListController {
private List<Case> cases;
private Asset asst{get;set;}
public CaseCustomRelatedListController(ApexPages.StandardController controller) {
 this.asst=(Asset)controller.getRecord();
 }
 public List<Case> getCases()
 { 
     cases = [Select Id, AccountId, CaseNumber, Owner.Name, OwnerId, Category__c, Status, Priority, Subject, Contact.Name, ContactId, CreatedDate, Case_Type__c from Case where AssetId =: asst.Id and Case_Type__c = 'Internal'];
     return cases;
 }
 
}