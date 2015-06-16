trigger UpdateSPFRefSPIFF_Claim on SPFRef__c (after update) {
    if(trigger.isAfter && trigger.isUpdate) SPIFFClaim.updateSPIFFClaim(trigger.new);
}