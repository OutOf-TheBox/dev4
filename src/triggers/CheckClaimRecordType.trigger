trigger CheckClaimRecordType on SPFRef__c (before insert, before update) {
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) SPIFFClaim.doCheckClaimRecordType(trigger.new);
}