trigger rmaTriggerV2 on RMAv2__c (before insert, before update,after insert, after update) {
    new rmaTriggerHandler().run();
}