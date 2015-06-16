trigger updateSupportProviderContactEmail on can__c (before insert, before update) {
     if(Trigger.isBefore){
           SupportProviderContactEmailUtility.updateSupportProviderContactEmail(Trigger.new);
     }
}