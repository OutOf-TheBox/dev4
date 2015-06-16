//*************************************************************************************************//
//  Version      Date           Author           Comments                                          //
//  0.1          2014-05-21     Sravan           Batch class to verify and create new TSE details  //
//*************************************************************************************************//

global class CntrbnMdl_TSECreator implements Database.Batchable<AggregateResult>,Database.Stateful{
    global String msg = '';
    //Start method which retrieves the aggregate result of case owners
    global Iterable<AggregateResult> start(Database.BatchableContext BC)
    {
        //String cId = '00580000003xTOl';
        list<AggregateResult> caseOwners = [select ownerid From case where Auto_Close__c = false and Auto_Open__c = false group by ownerId];//[select ownerid From case where group by ownerId];
        return caseOwners;
    }
    //Execute method which creates new TSE's if it finds any new user
    global void execute(Database.BatchableContext BC, list<sobject>  caseOwners)
    {
        try{
            set<Id> userIds= new set<Id>();
            set<Id> tseIds= new set<Id>();
            list<user> userlist= new list<user>();
            list<CntrbnMdl_TSE__c> newtselist = new list<CntrbnMdl_TSE__c>();
            list<CntrbnMdl_TSE__c> tselist = new list<CntrbnMdl_TSE__c>();
            list<AggregateResult>  ShoreTelUsers = new list<AggregateResult>();
            list<AggregateResult>  ProjectUsers = new list<AggregateResult>();
            list<AggregateResult>  TrainingUsers = new list<AggregateResult>();
            list<AggregateResult>  JiveUsers = new list<AggregateResult>();
            list<AggregateResult>  PTOUsers = new list<AggregateResult>();
            list<AggregateResult>  KBUsers = new list<AggregateResult>();
            
            //Adding case owner id's to a set
            for(sobject co: caseOwners){
                userIds.add((Id)co.get('ownerid'));
            }
            //Start of retrieving user data from all data points
            tselist = [select id,Employee_Name__c From CntrbnMdl_TSE__c];
            ShoreTelUsers = [select User__c From CntrbnMdl_ShoreTelCallLog__c group by User__c];
            ProjectUsers = [select User__c From CntrbnMdl_Project__c group by User__c];
            TrainingUsers = [select User__c From CntrbnMdl_Training__c group by User__c];
            JiveUsers = [select User__c From CntrbnMdl_Jive__c group by User__c];
            PTOUsers = [select User__c From CntrbnMdl_PTO__c group by User__c];
            KBUsers = [select CreatedById FROM KnowledgeArticle group by CreatedById];
            //End of retrieving user data from all data points
            
            //Start of Adding aggregated userid's to a set from all data points
            for(sobject st: ShoreTelUsers){
                userIds.add((Id)st.get('User__c'));
            }
            for(sobject prj: ProjectUsers){
                userIds.add((Id)prj.get('User__c'));
            }
            for(sobject trn: TrainingUsers){
                userIds.add((Id)trn.get('User__c'));
            }
            for(sobject jive: JiveUsers){
                userIds.add((Id)jive.get('User__c'));
            }
            for(sobject pto: PTOUsers){
                userIds.add((Id)pto.get('User__c'));
            }
            for(sobject kb: KBUsers){
                userIds.add((Id)kb.get('CreatedById'));
            }
            //End of Adding aggregated userid's to a set from all data points
            
            //Adding existing TSE id's to a set
            for(CntrbnMdl_TSE__c cl: tselist){
                tseIds.add(cl.Employee_Name__c);
            }
            
            //Query for new case ownwers
            userlist = [select id,name From User Where id in: userIds and id not in: tseIds and isActive = true];
            //Creating and Adding new TSE's to a list
            for(User us : userlist){
                CntrbnMdl_TSE__c newtse = new CntrbnMdl_TSE__c();
                newtse.Employee_Name__c = us.id;
                newtselist.add(newtse);
            }
            //Inserting new TSE's 
            if(newtselist.size()>0){
                insert newtselist;
            }
            msg+= 'TSE data created successfully';
        }
        catch(Exception e)
        {
            //msg+= 'TSE data creation failed ,' + e.getmessage(); 
            msg+=  'TSE data creation failed.'+'\n'+'\n'+'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' 
                            + e.getMessage() + '\n' + 'Line #: ' + e.getLineNumber() + '\n' + e.getStackTraceString();
                                   
        }
       
    }
    // Finish method to send an email to the Apex job's submitter notifying of job completion.   
    global void finish(Database.BatchableContext BC)
    {
        system.debug('+++++msg++++'+msg);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        CntrbnMdl_Admin_Email__c CBMAE = CntrbnMdl_Admin_Email__c.getValues('AdminEmail');
        String adminemail = CBMAE.Email_Address__c;
        //String adminemail = 'psravan@exafort.com';
        mail.setToAddresses(new String[] {adminemail});
        mail.setReplyTo(adminemail);
        mail.setSenderDisplayName('TSE batch Process');
        mail.setSubject('TSE data creation update on '+date.today().format());
        if (msg == null) msg = '';
        string header = 'Dear Administrator,'+'\n'+'\n';
        string message = 'TSE data creation batch process is completed on '+date.today().format()+'\n'+'\n'+msg+'\n'+'\n';
        String footer = 'Thanks' +'\n'+
                        'Salesforce';
        mail.setPlainTextBody(header+message+footer);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}