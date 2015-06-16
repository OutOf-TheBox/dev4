/*
** Author: Rod Bell
** Email: bell_rod@yahoo.com
**
** Description: A class to allow users to change the integration ID of transcript records so changes will not
** the record. This is a hack until the whole process has ben thougth out.
**
*/

public without sharing class LMSTranscriptExtension {
	private final ApexPages.StandardController controller;
	private final LMS_Transcript__c aTranscript;
    
    
    public LMSTranscriptExtension(ApexPages.StandardController argController) {
        controller = argController;
        aTranscript = (LMS_Transcript__c)controller.getRecord();   
    }

    public PageReference toggleIntegrationId() {
    	String newUniqueId = null;
    	LMS_Transcript__c t = [select Id, Unique_Integration_Id__c from LMS_Transcript__c where Id = :aTranscript.Id];
  
  		if(t.Unique_Integration_Id__c.startsWith('MOVED-')) {
			newUniqueId = t.Unique_Integration_Id__c.replaceFirst('MOVED-', '');
		} else {
			newUniqueId = 'MOVED-' + t.Unique_Integration_Id__c;
		}

		t.Unique_Integration_Id__c = newUniqueId;
		update t;

		PageReference p = new PageReference('/' + t.Id);
		p.setRedirect(true);
		return p;
    }
}