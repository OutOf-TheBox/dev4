trigger UniversityCourseRequest on University_Course_Request__c (after insert, before update, before insert) {
	
	//Bunhor @ 17-May-15: Before insert/update: Setting TZoffset__c, Registration_Open_Date__c, Registration_Closed_Date__c    
	UniversityCourseRequest.setFieldValues(); 
	
	//Bunhor @ 10-May-15: After insert: Updateing fields (future method to callout): Venue_Time_Zone__c, Venue_Airport_Code__c, Request_Status__c, Problem_Setting_Data_Details__c 
	UniversityCourseRequest.setFieldValues(trigger.new);  
	
}