trigger CaseOwnertoSupportQueue on Case (after insert) {
 
    string user = UserInfo.getUserId();
    User u = [SELECT name from User where Id = :user]; 

    if (u.name == 'Nimble Support') { 
         Case[] cases = Trigger.new;
         for(Case c : cases) {

            if (c.Auto_Open__c == true) {
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
                                        
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.assignmentRuleId= AR.Id;
                if (c.Auto_Close__c != true) {
                    dmo.EmailHeader.triggerUserEmail = true;
                }
                                               
                Case this_case = [SELECT Id from Case where Id = :c.Id];  
                this_case.setOptions(dmo);             
                database.update(this_case);
             }
        }
    }
}