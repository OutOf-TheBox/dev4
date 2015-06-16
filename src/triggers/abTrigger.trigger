trigger abTrigger on AddressBook__c (before insert, before update,after insert,after update,after delete) {
    
     new abTriggerHandler().run();
 
}