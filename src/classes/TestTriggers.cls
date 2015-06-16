@isTest
private class TestTriggers {
    
    static testMethod void Test1() {
        insert new Case( Auto_Open__c = true);
        insert new EmailMessage(ParentId = [select Id from Case].Id);
    }
    
    static testMethod void Test2() {
        CaseCommentMailerToOwnerUtils.DoNothing();
        CaseCommentMailerUtils.DoNothing();
    }
   
    static testMethod void testSendMail() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(IsActive = true, Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='xxx@testorg.com');
        insert u;
 
    System.runAs(u) {

        string user = UserInfo.getUserId();
        List<User> uuu = [ SELECT Id, IsActive, Alias from User where Id = :user limit 1];

         system.debug(LoggingLevel.ERROR, 'XXXXX ' + uuu + ' XXX');

        insert new Contact(Email = 'dddddddd@nimblestorage.com', LastName = 'DDDDDD');
        insert new Case(ContactId = [select Id from Contact limit 1].Id, OwnerId = [SELECT Id from User where Id = :user limit 1].Id, Status = 'Open', Supportforce_Comment_Flag__c = true, Auto_Open__c = true, Auto_Close__c = false);     
        insert new CaseComment(ParentId = [select Id from Case where Supportforce_Comment_Flag__c = true limit 1].Id, CommentBody = 'testing123456', IsPublished = false);
        insert new CaseComment(ParentId = [select Id from Case where Supportforce_Comment_Flag__c = true limit 1].Id, CommentBody = 'testing123456789', IsPublished = false);
}
        List<CaseComment> cc = [ SELECT Id, ParentId, CommentBody, IsPublished from CaseComment limit 1 ];  
        

        if(cc.isEmpty()) {
                system.debug(LoggingLevel.ERROR, 'LIST CC IS EMPTY');
        } else {
            CaseCommentMailerUtils.sendError('testing Error Handling in CaseComment Trigger');
            system.debug(LoggingLevel.ERROR, 'LIST CC CONTAINS ' + cc.size() + ' MEMBERS');
            for(integer i=0;i<cc.size();i++) {
                CaseComment item = cc[i];
                system.debug(LoggingLevel.ERROR, 'Id: ' + item.get('Id'));
             }
        }
        
        CaseCommentMailerUtils.sendMail(cc, 'XXXXXXXXXXXXXXXXXX', true);
         
        CaseCommentMailerToOwnerUtils.sendMail(cc, 'User Name', true);
        CaseCommentMailerToOwnerUtils.sendError('test error'); 
        
    }

    static testMethod void testSendMail2() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(IsActive = true, Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='xxx@testorg.com');
        insert u;

    System.runAs(u) {

        string user = UserInfo.getUserId();
        insert new Contact(Email = 'supportforce@nimblestorage.com', LastName = 'Support');
        insert new Case(ContactId = [select Id from Contact limit 1].Id, OwnerId = [SELECT Id from User where Id = :user limit 1].Id, Supportforce_Comment_Flag__c = true, Auto_Open__c = true, Auto_Close__c = false);
        insert new CaseComment(ParentId = [select Id from Case where Supportforce_Comment_Flag__c = true limit 1].Id, CommentBody = 'testing123456', IsPublished = true);
}       
        List<CaseComment> cc = [ SELECT Id, ParentId, CommentBody, IsPublished from CaseComment limit 1 ];  
        if(cc.isEmpty()) {
                system.debug(LoggingLevel.ERROR, 'LIST CC IS EMPTY');
        } else {
            CaseCommentMailerUtils.sendError('testing Error Handling in CaseComment Trigger');
            system.debug(LoggingLevel.ERROR, 'LIST CC CONTAINS ' + cc.size() + ' MEMBERS');
            for(integer i=0;i<cc.size();i++) {
                CaseComment item = cc[i];
                system.debug(LoggingLevel.ERROR, 'Id: ' + item.get('Id'));
             }
        }
        //CaseCommentMailerUtils.sendMail(cc, '00X80000001RZpEEAW');  //sandbox
        CaseCommentMailerToOwnerUtils.sendMail(cc, 'User Name', true); 

        CaseCommentMailerUtils.sendMail(cc, '00X80000001v7FDEAY', true); //production  
    }

}