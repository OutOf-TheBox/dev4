trigger CaseOwnerValidation on Case (before update) {
   if(trigger.isUpdate){
        String result = CaseTriggerHelp.validateOwner(Trigger.old,Trigger.new);
        if(result == 'Success'){
        }
        else if(result == 'failed'){
           Trigger.new[0].addError('You can not assign this case to selected User/Queue');
        }
        else{
           Trigger.new[0].addError(result);
        }
        
   }
}