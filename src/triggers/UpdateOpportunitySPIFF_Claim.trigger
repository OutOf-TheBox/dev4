trigger UpdateOpportunitySPIFF_Claim on Opportunity (after update) {	
    if(trigger.isAfter && trigger.isUpdate) SPIFFClaim.updateSPIFFClaim(trigger.new);
}