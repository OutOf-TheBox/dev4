/**
 * Test class for: UniversityCourseRequest.cls and GoogleServices.cls
 * @Author : Bunhor
 * @CreatedDate : 10-May-15 
 */
@isTest
private class UniversityCourseRequestTest {
	static University_Course_Request__c courseReq;
	
	static void setupData(){ 
		courseReq = new University_Course_Request__c();
		courseReq.Desired_Course_Date_Start_Time__c = UniversityCourseRequest.getDateTimeAtNparam(system.now(), 9); 
		courseReq.Venue_Name__c = 'test';
		courseReq.Venue_Street__c = '123';
		courseReq.Requester_City__c = 'San Francisco';
		courseReq.Venue_City__c = 'San Francisco';
		courseReq.Requester_State__c = 'CA';
		courseReq.Venue_State__c = 'CA';
		courseReq.Venue_Zip__c = '123456';
		courseReq.Requester_Country__c = 'USA';
		courseReq.Venue_Country__c = 'USA';
		courseReq.Class_Type__c = 'Public';
		courseReq.Requested_Instructor__c = null;
		courseReq.AE_Name__c = null;
		courseReq.SE_Name__c = null;
		courseReq.Projector_Required__c = 'Yes';
		courseReq.Assistance_with_Venue_Required__c = 'No';  
		courseReq.Assistance_with_Catering_Required__c = 'No';  
		courseReq.Student_Manuals_Required__c = 'No';  
		courseReq.Room_Capacity__c  = 123;
	}
	 
    static testMethod void insertUniversityCourseRequest() {  
        setupData(); 
        Test.startTest();
        insert courseReq; // the logic are fired  
        Test.stopTest();
        // asserting 
        courseReq = [select id,TZoffset__c,Registration_Open_Date__c,Registration_Closed_Date__c,Venue_Time_Zone__c,Venue_Airport_Code__c,Request_Status__c,Problem_Setting_Data_Details__c from University_Course_Request__c where id=:courseReq.id];
        
        // These fields are auto popuplated
        system.assertNotEquals(courseReq.TZoffset__c, null); 
        system.assertNotEquals(courseReq.Registration_Open_Date__c, null); 
        system.assertNotEquals(courseReq.Registration_Closed_Date__c, null); 
        
        // These fields are populated by callout without errors
        system.assertEquals(courseReq.Venue_Time_Zone__c, 'America/Los_Angeles'); // GoogleServices.MOCKRESPONE_TIMEZONE
        system.assertEquals(courseReq.Venue_Airport_Code__c, 'MOD'); // GoogleServices.MOCKRESPONE_TIMEZONE  
        system.assertEquals(courseReq.Request_Status__c, null);  
        system.assertEquals(courseReq.Problem_Setting_Data_Details__c, null);  
        
        // Try Errors
        GoogleServices.MOCKRESPONE_GEO = '<GeocodeResponse><status>fail</status></GeocodeResponse>';
        UniversityCourseRequest.setFieldValues(courseReq.id);
        courseReq = [select id,TZoffset__c,Registration_Open_Date__c,Registration_Closed_Date__c,Venue_Time_Zone__c,Venue_Airport_Code__c,Request_Status__c,Problem_Setting_Data_Details__c from University_Course_Request__c where id=:courseReq.id];
        system.assertNotEquals(courseReq.Request_Status__c, null);  
        system.assertNotEquals(courseReq.Problem_Setting_Data_Details__c, null);  
    }
}