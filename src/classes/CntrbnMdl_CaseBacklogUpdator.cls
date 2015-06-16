//*************************************************************************************************//
//  Version      Date           Author      Comments                                               //
//  0.1          2014-05-26     Sravan      Batch class to calculate cumulative case backlog count //
//*************************************************************************************************//
global class CntrbnMdl_CaseBacklogUpdator implements Database.Batchable<sobject>,Database.Stateful{
    global String msg = '';
    //Start method which retrieves the TSE details
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name,Employee_Name__c FROM CntrbnMdl_TSE__c WHERE Dont_show_in_Report__c = false';
        return Database.getQueryLocator(query);
    }
    //Execute method which create/update cumulative case backlog count
    global void execute(Database.BatchableContext BC, list<CntrbnMdl_TSE__c>  tselist)
    {
        try{
            //Initializing helper class object
            CntrbnMdl_CaseBacklogHelper CB =new CntrbnMdl_CaseBacklogHelper();
            msg+= CB.updateCaseBacklog(tselist);
            
        }
        catch(Exception e)
        {
            //msg+= 'Case backlog update batch failed ,' + e.getmessage(); 
            msg+=  'Case backlog data update failed.'+'\n'+'\n'+'Type: ' + e.getTypeName() + '\n' + 'Cause: ' + e.getCause() + '\n' + 'Message: ' 
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
        mail.setToAddresses(new String[] {adminemail});
        mail.setReplyTo(adminemail);
        mail.setSenderDisplayName('Case backlog batch Process');
        mail.setSubject('Case backlog update on '+date.today().format());
        if (msg == null) msg = '';
        string header = 'Dear Administrator,'+'\n'+'\n';
        string message = 'Case backlog batch process is completed on '+date.today().format()+'\n'+'\n'+msg+'\n'+'\n';
        String footer = 'Thanks' +'\n'+
                        'Salesforce';
        mail.setPlainTextBody(header+message+footer);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}