trigger QuoteLineBeforeCustom on SBQQ__QuoteLine__c (before insert, before update) {
	if (Trigger.isInsert && !Trigger.new[0].SBQQ__Incomplete__c) {
		for (SBQQ__QuoteLine__c line : Trigger.new) {
			line.BOMRequiredBy__c = null;
		}
	} else if (Trigger.isUpdate && !Trigger.new[0].SBQQ__Incomplete__c) {
		Map<Id,SBQQ__QuoteLine__c> afsByParentId = new Map<Id,SBQQ__QuoteLine__c>();
		for (SBQQ__QuoteLine__c line : Trigger.new) {
			if ((line.SBQQ__RequiredBy__c != null) && (line.SBQQ__ProductCode__c == 'AFS-UPGRADE')) {
				afsByParentId.put(line.SBQQ__RequiredBy__c, line);
			}
		}
		
		for (SBQQ__QuoteLine__c line : Trigger.new) {
			if ((line.SBQQ__RequiredBy__c != null) && line.SBQQ__ProductCode__c.startsWith('SLA') && line.SBQQ__ProductCode__c.endsWith('AFS')) {
				SBQQ__QuoteLine__c afs = afsByParentId.get(line.SBQQ__RequiredBy__c);
				if (afs != null) {
					line.BOMRequiredBy__c = afs.Id;
				}
			}
		}
	}
}