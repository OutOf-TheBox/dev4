trigger UniversityCourseRequest on University_Course_Request__c (after insert) {
	
	//Bunhor @ 10-May-15: init fields by calling future method to callout 
	if(trigger.isAfter && trigger.isInsert){
		UniversityCourseRequest.setFieldValues(trigger.newMap.keyset());
	}
}