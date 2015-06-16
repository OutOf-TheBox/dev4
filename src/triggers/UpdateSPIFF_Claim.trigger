trigger UpdateSPIFF_Claim on SPIFF_Claim__c (before insert, before update) {
    if(trigger.isBefore && trigger.isInsert) SPIFFClaim.updateSPIFFClaim(trigger.new);
     if(trigger.isBefore && trigger.isUpdate) SPIFFClaim.updateSPIFFClaimByFieldCheck(trigger.new);
}