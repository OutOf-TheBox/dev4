public class EvalTriggerHandler {
  private boolean m_isExecuting = false;
  private integer m_BatchSize = 0;
  public EvalTriggerHandler (boolean isExecuting, integer size){
    m_isExecuting = isExecuting;
    m_BatchSize = size;
  }
    public void OnBeforeUpdate(List<Eval__c> newevals, Map<Id,Eval__c> oldOppMap)
    {
        if(newevals!=null && newevals.size()>0)
        {
            for(Eval__c o:newevals)
            {
                if(o.Eval_Notes__c!=oldOppMap.get(o.Id).Eval_Notes__c && oldOppMap.get(o.Id).Eval_Notes__c!=null)
                {
                    if(o.Eval_Notes_Archive__c==null)
                    {
                        o.Eval_Notes_Archive__c='';
                    }
                    o.Eval_Notes_Archive__c=oldOppMap.get(o.Id).Eval_Notes__c+'\n\n'+o.Eval_Notes_Archive__c;
                }
            }
        }
    }
}