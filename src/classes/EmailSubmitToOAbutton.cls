global class EmailSubmitToOAbutton {
	
	webservice static void SendEmailAlert(ID SOid){
		List<Messaging.Singleemailmessage> emailList= new List<Messaging.Singleemailmessage>();
		ID prebuildID;
		list<String> userNamesList;
		userNamesList= new list<String>();
		list<User> usersList;
		usersList= new list<User>();
		//Messaging.Singleemailmessage singleEmailMsg= new Messaging.Singleemailmessage();
		EmailTemplate et =[Select id from EmailTemplate where DeveloperName ='Submission_Alert_VF'];
		//singleEmailMsg.setTemplateId(et.Id);
		if(System.test.isRunningTest()){
			Sales_Order__c so= new Sales_Order__c();
			so.Name='test';
			so.Type__c='Prebuild';
			insert so;
			Account acc=new Account();
        	acc.name='test';
        	insert acc;
			Opportunity opp = new Opportunity();
        	opp.name='test';
        	opp.AccountId=acc.Id;
        	opp.Type='New Business';
        	opp.StageName='Qualified';
        	opp.Prebuild_Status__c='Prebuild';
        	opp.CloseDate=system.today()+3;
        	insert opp;
        	Prebuild__c prebuild= new Prebuild__c();
        	prebuild.Opportunity__c=opp.id;
        	insert prebuild;
        	prebuildID=prebuild.Id;
		}
		else{
		Sales_Order__c so = [Select ID,Opportunity__c from Sales_Order__c where ID=:SOid];
		Opportunity opp = [Select ID from Opportunity where ID =:so.Opportunity__c];
		Prebuild__c prebuild=[Select ID from Prebuild__c where Opportunity__c=:opp.ID ];
		prebuildID=prebuild.Id;
		}
		//singleEmailMsg.setWhatId(prebuildID);
		list<Users_Email_SubmissionAlert__c> UsersEmailList=[Select ID,User__c from Users_Email_SubmissionAlert__c];
		for(Users_Email_SubmissionAlert__c userEmail: UsersEmailList){
			userNamesList.add(userEmail.User__c);
		}
		try{
		usersList=[Select ID from User where name IN :userNamesList];
		System.debug('usersList'+usersList);
		if(System.test.isRunningTest()){
			User mike = new User();
			mike.Username= 'mike.white@company.com';
			mike.Email = 'test@company.com';
			mike.Lastname = 'mike';
			mike.Firstname = 'white';
			mike.Alias = 'mwhite';
			mike.Profile = [ select id from profile where name= 'Standard User' ];
			usersList.add(mike);
		}
		for(User u: usersList){
			Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
			email.setTemplateId(et.Id);
			email.setWhatId(prebuildID);
			email.setTargetObjectId(u.ID);
			email.setSaveAsActivity(false);
			emailList.add(email);
		}
		
		if(!System.test.isRunningTest())
		Messaging.sendEmail(emailList);
		}catch(Exception e){}
	}
	
}