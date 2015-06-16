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
		courseReq.Requester_City__c = 'San Francisco';
		courseReq.Venue_City__c = 'San Francisco';
		courseReq.Requester_State__c = 'CA';
		courseReq.Requester_Country__c = 'USA';
		courseReq.Class_Type__c = 'Public';
		courseReq.Requested_Instructor__c = null;
		courseReq.AE_Name__c = null;
		courseReq.SE_Name__c = null;
		courseReq.Projector_Required__c = 'Yes'; 
	}
	 
    static testMethod void insertUniversityCourseRequest() {  
        setupData();
        System.debug('=============='+courseReq.Desired_Course_Date_Start_Time__c);
        Test.startTest();
        insert courseReq; // the logic are fired when inserting asynchronously
        Test.stopTest();
        // asserting   
    }
}