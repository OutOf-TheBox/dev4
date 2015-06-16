trigger EvalTrigger on Eval__c(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
  EvalTriggerHandler handler = new EvalTriggerHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new,Trigger.oldMap);
    }    
}