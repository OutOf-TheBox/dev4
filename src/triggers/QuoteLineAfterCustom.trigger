trigger QuoteLineAfterCustom on SBQQ__QuoteLine__c (after insert, after update) {
	if (!Trigger.new[0].SBQQ__Incomplete__c) {
		Map<Id,SBQQ__QuoteLine__c> parentLines = new Map<Id,SBQQ__QuoteLine__c>();
		for (SBQQ__QuoteLine__c line : Trigger.new) {
			if ((line.SBQQ__RequiredBy__c != null) && !String.isBlank(line.SBQQ__ProductFamily__c) && line.SBQQ__ProductFamily__c.equalsIgnoreCase('Support')) {
				if (Trigger.isInsert || (Trigger.oldMap.get(line.Id).SBQQ__RequiredBy__c != line.SBQQ__RequiredBy__c)) {
					parentLines.put(line.SBQQ__RequiredBy__c,new SBQQ__QuoteLine__c(Id=line.SBQQ__RequiredBy__c,Support_Component__c=line.Id));	
				}
			}
		}
		if (!parentLines.isEmpty()) {
			update parentLines.values();
		}
	} 
}