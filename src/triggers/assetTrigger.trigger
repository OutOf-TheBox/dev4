trigger assetTrigger on Asset (before insert, before update, after insert, after update) {
  System.debug('DEBUG: (assetTrigger) Entered');
  new assetTriggerHandler().run();
}