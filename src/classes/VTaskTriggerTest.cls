@isTest
private class VTaskTriggerTest 
{
	//Task related to Opportunity with "Email" in Subject
	private static testMethod void test1()
	{
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		
		Opportunity testOpportunity =  new Opportunity(Name = 'testOpprtunity', 
            AccountId = testAccount.id, 
            Type = 'New Business',
            CloseDate = system.today(),
            stageName = '1-Prequalified');
		insert testOpportunity;
		
		Task testTask = new Task(Subject = 'Email test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhatId = testOpportunity.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'Completed';
        update testTask;
        
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
	}

	//Task related to Opportunity with Status != "Completed"
	private static testMethod void test2()
	{
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		
		Opportunity testOpportunity =  new Opportunity(Name = 'testOpprtunity', 
            AccountId = testAccount.id, 
            Type = 'New Business',
            CloseDate = system.today(),
            stageName = '1-Prequalified');
		insert testOpportunity;
		
		Task testTask = new Task(Subject = 'test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhatId = testOpportunity.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'In Progress';
        update testTask;
        
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);		
	}
	
	//Task related to Opportunity with Status = "Completed"
	private static testMethod void test3()
	{
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		
		Opportunity testOpportunity =  new Opportunity(Name = 'testOpprtunity', 
            AccountId = testAccount.id, 
            Type = 'New Business',
            CloseDate = system.today(),
            stageName = '1-Prequalified');
		insert testOpportunity;
		
		Task testTask = new Task(Subject = 'test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhatId = testOpportunity.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'Completed';
        update testTask;
        
        Opportunity actual = [Select Id, Opportunity_Category__c From Opportunity Where Id =: testOpportunity.Id];
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(actual.Opportunity_Category__c, expected.Call_Category__c);		
	}
	
	//Task related to Account with Status = "Completed"
	private static testMethod void test4()
	{
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		
		Task testTask = new Task(Subject = 'test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhatId = testAccount.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'Completed';
        update testTask;
        
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);		
	}
	
	//Task related to Lead with "Email" in Subject
	private static testMethod void test5()
	{
		Lead testLead = new Lead(LastName = 'Lead', Company = 'Test Company', Status = 'Open');
		insert testLead;
		
		Task testTask = new Task(Subject = 'Email test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhoId = testLead.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'Completed';
        update testTask;
        
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
	}
	
	//Task related to Lead with Status != "Completed"
	private static testMethod void test6()
	{
		Lead testLead = new Lead(LastName = 'Lead', Company = 'Test Company', Status = 'Open');
		insert testLead;
		
		Task testTask = new Task(Subject = 'test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhoId = testLead.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'In Progress';
        update testTask;
        
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);		
	}
	
	//Task related to Lead with Status = "Completed"
	private static testMethod void test7()
	{
		Lead testLead = new Lead(LastName = 'Lead', Company = 'Test Company', Status = 'Open');
		insert testLead;
		
		Task testTask = new Task(Subject = 'test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhoId = testLead.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'Completed';
        update testTask;
        
        Lead actual = [Select Id, Lead_Category__c From Lead Where Id =: testLead.Id];
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(actual.Lead_Category__c, expected.Call_Category__c);		
	}
	
	//Task related to Contact with Status = "Completed"
	private static testMethod void test8()
	{
		Contact testContact = new Contact(LastName = 'Test');
		insert testContact;
		
		Task testTask = new Task(Subject = 'test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhoId = testContact.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'Completed';
        update testTask;
        
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);		
	}
	
	//Task related to Opportunity with Status = "Completed" while Insert
	private static testMethod void test9()
	{
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		
		Opportunity testOpportunity =  new Opportunity(Name = 'testOpprtunity', 
            AccountId = testAccount.id, 
            Type = 'New Business',
            CloseDate = system.today(),
            stageName = '1-Prequalified');
		insert testOpportunity;
		
		Task testTask = new Task(Subject = 'test', Status = 'Completed', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhatId = testOpportunity.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        Opportunity actual = [Select Id, Opportunity_Category__c From Opportunity Where Id =: testOpportunity.Id];
        system.assertEquals(actual.Opportunity_Category__c, expected.Call_Category__c);		
	}
	
	//Task related to Lead with Status = "Completed" while Insert
	private static testMethod void test10()
	{
		Lead testLead = new Lead(LastName = 'Lead', Company = 'Test Company', Status = 'Open');
		insert testLead;
		
		Task testTask = new Task(Subject = 'test', Status = 'Completed', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhoId = testLead.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        Lead actual = [Select Id, Lead_Category__c From Lead Where Id =: testLead.Id];
        system.assertEquals(actual.Lead_Category__c, expected.Call_Category__c);		
	}
	
	//Task related to Opportunity with "NOTE" in Subject
	private static testMethod void test11()
	{
		Account testAccount = new Account(Name = 'Test Account');
		insert testAccount;
		
		Opportunity testOpportunity =  new Opportunity(Name = 'testOpprtunity', 
            AccountId = testAccount.id, 
            Type = 'New Business',
            CloseDate = system.today(),
            stageName = '1-Prequalified');
		insert testOpportunity;
		
		Task testTask = new Task(Subject = 'NOTE test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhatId = testOpportunity.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'Completed';
        update testTask;
        
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
	}
	
	//Task related to Lead with "NOTE" in Subject
	private static testMethod void test12()
	{
		Lead testLead = new Lead(LastName = 'Lead', Company = 'Test Company', Status = 'Open');
		insert testLead;
		
		Task testTask = new Task(Subject = 'NOTE test', Status = 'Not Started', Priority = 'Normal', 
            OwnerId = UserInfo.getUserId(),
            WhoId = testLead.Id);
        insert testTask;
        
        Task expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
        
        testTask.Status = 'Completed';
        update testTask;
        
        expected = [Select Id, Call_Category__c From Task Where Id =: testTask.Id];
        system.assertEquals(null, expected.Call_Category__c);
	}
}