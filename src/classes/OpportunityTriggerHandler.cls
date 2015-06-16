public class OpportunityTriggerHandler {
  private boolean m_isExecuting = false;
  private integer m_BatchSize = 0;
  public OpportunityTriggerHandler(boolean isExecuting, integer size){
    m_isExecuting = isExecuting;
    m_BatchSize = size;
  }
    public void OnBeforeUpdate(List<Opportunity> newOpportunities, Map<Id,Opportunity> oldOppMap)
    {
        if(newOpportunities!=null && newOpportunities.size()>0)
        {
            for(Opportunity o:newOpportunities)
            {
                if(o.NextStep!=oldOppMap.get(o.Id).NextStep && oldOppMap.get(o.Id).NextStep!=null)
                {
                    if(o.Next_Steps_Archive__c==null)
                    {
                        o.Next_Steps_Archive__c='';
                    }
                    o.Next_Steps_Archive__c=oldOppMap.get(o.Id).NextStep+'\n\n'+o.Next_Steps_Archive__c;
                }
            }
        }
    }
}