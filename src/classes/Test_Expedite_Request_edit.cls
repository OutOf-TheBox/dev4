/**
 Test class for apex class "ctrl_Expedite_request_update" , trigger "ExpReqAssociatedUserUpdate" and trigger "SOactualShippingUpdate" .
 */
@isTest
private class Test_Expedite_Request_edit {

    static testMethod void myUnitTest() {
    	Account acc=new Account();
    	acc.Name='test mansa';
    	insert acc;
    	
    	Profile p = [select id from profile where name='Standard User'];
    	User use = new User(alias = 'standt', email='standarduserb@testorg.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb@testorg.com');
		insert use;
    	User use1 = new User(alias = 'standt1', email='standarduserb@testorg1.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb1@testorg.com');
		insert use1;
		
    
    	
    	User use2 = new User(alias = 'standt2', email='standarduserb@testorg.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb2@testorg.com');
		insert use2;
    	User use3 = new User(alias = 'standt3', email='standarduserb@testorg1.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb13@testorg.com');
		insert use3;
    	User use4 = new User(alias = 'standt4', email='standarduserb@testorg.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb4@testorg.com');
		insert use4;
    	User use5 = new User(alias = 'standt5', email='standarduserb@testorg1.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb5@testorg.com');
		insert use5;
		
    	User use6 = new User(alias = 'standt6', email='standarduserb@testorg.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb6@testorg.com');
		insert use6;
    	User use7 = new User(alias = 'standt7', email='standarduserb@testorg1.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb7@testorg.com');
		insert use7;
		
		Profile p8 = [select id from profile where name='Standard User'];
    	User use8 = new User(alias = 'standt8', email='standarduserb@testorg.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb8@testorg.com');
		insert use8;
		Profile p9 = [select id from profile where name='Standard User'];
    	User use9 = new User(alias = 'standt9', email='standarduserb@testorg1.com',emailencodingkey='UTF-8',
					lastname='Testingb', languagelocalekey='en_US',localesidkey='en_US',
					profileid = p.Id,timezonesidkey='America/Los_Angeles', username='standarduserb9@testorg.com');
		insert use9;
    	
    	Opportunity opp= new Opportunity();
    	opp.Name='test mansa';
    	opp.AccountId=acc.id;
    	opp.CloseDate=system.today()+3;
    	opp.StageName='Qualified';
    	opp.OwnerId=use.Id;
    	insert opp;
    	
    	OpportunityTeamMember opteam= new OpportunityTeamMember();
    	opteam.OpportunityId=opp.id;
    	opteam.TeamMemberRole='test';
    	opteam.UserId=opp.OwnerId;
    	
    	insert opteam;
    	
    	OpportunityTeamMember opteam1= new OpportunityTeamMember();
    	opteam1.OpportunityId=opp.id;
    	opteam1.TeamMemberRole='test1';
    	opteam1.UserId=use1.Id;
    	
    	insert opteam1;
    	
    	OpportunityTeamMember opteam2= new OpportunityTeamMember();
    	opteam2.OpportunityId=opp.id;
    	opteam2.TeamMemberRole='test2';
    	opteam2.UserId=use2.Id;
    	
    	insert opteam2;
    	
    	
    	
    	OpportunityTeamMember opteam3= new OpportunityTeamMember();
    	opteam3.OpportunityId=opp.id;
    	opteam3.TeamMemberRole='test2';
    	opteam3.UserId=use3.Id;
    	
    	insert opteam3;
    	
    	OpportunityTeamMember opteam4= new OpportunityTeamMember();
    	opteam4.OpportunityId=opp.id;
    	opteam4.TeamMemberRole='test1';
    	opteam4.UserId=use4.Id;
    	
    	insert opteam4;
    	
    	OpportunityTeamMember opteam5= new OpportunityTeamMember();
    	opteam5.OpportunityId=opp.id;
    	opteam5.TeamMemberRole='test2';
    	opteam5.UserId=use5.Id;
    	
    	insert opteam5;
    	
    	OpportunityTeamMember opteam6= new OpportunityTeamMember();
    	opteam6.OpportunityId=opp.id;
    	opteam6.TeamMemberRole='test1';
    	opteam6.UserId=use6.Id;
    	
    	insert opteam6;
    	
    	OpportunityTeamMember opteam7= new OpportunityTeamMember();
    	opteam7.OpportunityId=opp.id;
    	opteam7.TeamMemberRole='test2';
    	opteam7.UserId=use7.Id;
    	
    	insert opteam7;
    	
    	OpportunityTeamMember opteam8= new OpportunityTeamMember();
    	opteam8.OpportunityId=opp.id;
    	opteam8.TeamMemberRole='test1';
    	opteam8.UserId=use8.Id;
    	
    	insert opteam8;
    	
    	OpportunityTeamMember opteam9= new OpportunityTeamMember();
    	opteam9.OpportunityId=opp.id;
    	opteam9.TeamMemberRole='test2';
    	opteam9.UserId=use9.Id;
    	
    	insert opteam9;
    	
    	
        Sales_Order__c so= new Sales_Order__c();
        
        so.Name='test mansa';
        so.Type__c='Internal';
        so.Status__c='Approved by OA';
        so.Actual_Shipment_Date__c=system.today();
        so.Opportunity__c=opp.Id;
        insert so;
        
                
        apexpages.currentPage().getParameters().put('soid',so.id);
         Expedite_Request__c exp=new Expedite_Request__c();
         exp.Approval_To_Overnight__c=' test mansa';
         exp.Overnight__c=true;
         exp.Sales_Order__c=so.id;
         exp.Target_Install_Date__c=system.today();
         insert exp;
         so.Status__c='Approved by OA';
         so.Actual_Shipment_Date__c=system.today()+3;
         update so;
         
         exp.Reason_For_Expedite__c='test mansa';
         update exp;
         
         
       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(exp);
        ctrl_Expedite_Request_edit testexp = new ctrl_Expedite_Request_edit(sc);
        
        testexp.SaveRecord();
    }
   
}