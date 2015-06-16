trigger OpportunityTrigger on Opportunity (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	OpportunityTriggerHandler handler = new OpportunityTriggerHandler(Trigger.isExecuting, Trigger.size);
    if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new,Trigger.oldMap);
    }    
}