public with sharing class ExpediteEmailRequestEdit {
public Expedite_Request__c expemail{get;set;}
public Expedite_Request_Email__c exemail{get;set;}
public Expedite_Request_Email__c exemailold{get;set;}
public Expedite_Request_Email__c exeemailattach{get;set;}
public list<Attachment> attachments{get;set;}
public boolean Soowner{get;set;}
public boolean exporder{get;set;}
public string soemail;
public boolean newexpemail{get;set;}
public boolean detailexpemail{get;set;}
public boolean edtiexpemail{get;set;}
public boolean reply{get;set;}
public boolean replyall{get;set;}
public string InoutBound{get;set;}
public string checkattachment{get;set;}
public boolean attachmentexp {get;set;}
public string  currenturl;
public list<string> custring;
public string emailcc{get;set;}
public map<string,string> useremailmap;
public string attid{get;set;}
 public   Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }
  public   Attachment attachment2 {
  get {
      if (attachment2 == null)
        attachment2 = new Attachment();
      return attachment2;
    }
  set;
  }
  public   Attachment attachment3 {
  get {
      if (attachment3 == null)
        attachment3 = new Attachment();
      return attachment3;
    }
  set;
  }
  public   Attachment attachment4 {
  get {
      if (attachment4 == null)
        attachment4 = new Attachment();
      return attachment4;
    }
  set;
  }
  public   Attachment attachment5 {
  get {
      if (attachment5 == null)
        attachment5 = new Attachment();
      return attachment5;
    }
  set;
  }
   
        
public list<wrapexpemail> wrapexpemail{get;set;}
public list<wrapexpemail> wrapexpemail2{get;set;}
public string emid;
public string exid;
public string expreqid;
public ExpediteEmailRequestEdit(ApexPages.StandardController controller) {
        
        
    newexpemail=true;
    attachmentexp=false;
    custring=new list<string>();
    Soowner=true;
    exporder=true;
    wrapexpemail=new list<wrapexpemail>();
    wrapexpemail2=new list<wrapexpemail>();
    
    exemail=new Expedite_Request_Email__c();
    exemailold=new Expedite_Request_Email__c();
    Id iud=apexpages.currentPage().getParameters().get('Id');    
    
    currenturl=apexpages.currentPage().getUrl();
    currenturl=EncodingUtil.urlDecode(currenturl, 'UTF-8');
    
    
    custring=currenturl.split('retURL=/');
    expreqid=custring[1].substring(0,15);
    
    emid=apexpages.currentPage().getParameters().get('EMId');
    
    if(EMId!=null && EMId!='')
    {
        newexpemail=false;
        detailexpemail=true;
        
        attachments=[select description,LastModifiedById,LastModifiedDate,CreatedById , ParentId, Name, Id From Attachment where ParentId=:EMId];
                exemailold=[select id,name,Email_Body__c,Email_cc__c,Email_From__c,Email_Subject__c,Email_To__c,Expedite_Request__c,Inbound_Indicator__c 
                                from Expedite_Request_Email__c where id=:EMID];
                                if(exemailold.Inbound_Indicator__c==true)
                                {
                                        InoutBound='Inbound';
                                }
                                else
                                InoutBound='Outbound';
    }
    
    if(expreqid!=null && expreqid!='')
    {
    expemail=[Select id,OwnerId,SO_Owner__c,SO_Owner__r.email,name,Sales_Order__r.name,Target_Install_Date__c,Approval_To_Overnight__c, SO_Owner__r.name,
              Ship_to_Customer__c, Ship_To_Address__c, Sales_Order__c, Reason_For_Expedite__c,Overnight__c, Opp_Team_9__c,
              Opp_Team_8__c, Opp_Team_7__c, Opp_Team_6__c, Opp_Team_5__c, Opp_Team_4__c, Opp_Team_3__c, Opp_Team_2__c, 
              Opp_Team_1__c,Opp_Team_1__r.name,Opp_Team_2__r.name,Opp_Team_3__r.name,Opp_Team_4__r.name,Opp_Team_10__c,Opp_Team_5__r.name,
              Opp_Team_6__r.name,Opp_Team_7__r.name,Opp_Team_8__r.name ,Opp_Team_9__r.name,Opp_Team_10__r.name,
              Current_Ship_Date__c ,Opp_Team_1__r.email,Opp_Team_2__r.email,
              Opp_Team_3__r.email,Opp_Team_4__r.email,Opp_Team_5__r.email,Opp_Team_6__r.email,
              Opp_Team_7__r.email,Opp_Team_8__r.email,Opp_Team_9__r.email,Opp_Team_10__r.email
               from Expedite_Request__c where id=:expreqid];
       soemail=' ';         
       soemail=expemail.SO_Owner__r.email;       
      /*        
      list<user> uslist=[select id,name,email from user where id=:expemail.Opp_Team_1__c or id=:expemail.Opp_Team_2__c or id=:expemail.Opp_Team_3__c or 
                                                id=:expemail.Opp_Team_4__c or id=:expemail.Opp_Team_5__c or id=:expemail.Opp_Team_6__c or id=:expemail.Opp_Team_7__c or 
                                        id=:expemail.Opp_Team_8__c or id=:expemail.Opp_Team_9__c or id=:expemail.Opp_Team_10__c ];   
      useremailmap=new map<string,string>();
      for(user u:uslist)
      {
        useremailmap.put(u.name,u.email);
      }  
      */
        if(expemail.Opp_Team_1__r.name==null)
        {
                
            //    wrapexpemail.add(new wrapexpemail('Opp Team 1: ',' '));
                
        }
        else
                wrapexpemail.add(new wrapexpemail('Opp Team 1: '+expemail.Opp_Team_1__r.name,expemail.Opp_Team_1__r.email));
              
        
        if(expemail.Opp_Team_2__r.name==null)
        {
              //  wrapexpemail.add(new wrapexpemail('Opp Team 2: ',' '));             
                
        }
        else
                wrapexpemail.add(new wrapexpemail('Opp Team 2: '+expemail.Opp_Team_2__r.name,expemail.Opp_Team_2__r.email));  
                
                if(expemail.Opp_Team_3__r.name==null)
        {
              //  wrapexpemail.add(new wrapexpemail('Opp Team 3: ',' '));             
                
        }
        else
                wrapexpemail.add(new wrapexpemail('Opp Team 3: '+expemail.Opp_Team_3__r.name,expemail.Opp_Team_3__r.email));  
                
                
        
                if(expemail.Opp_Team_4__r.name==null)
        {
               // wrapexpemail.add(new wrapexpemail('Opp Team 4: ',' '));             
                
        }
        else
                wrapexpemail.add(new wrapexpemail('Opp Team 4: '+expemail.Opp_Team_4__r.name,expemail.Opp_Team_4__r.email));  
                
                
                if(expemail.Opp_Team_5__r.name==null)
        {
              //  wrapexpemail.add(new wrapexpemail('Opp Team 5: ',' '));             
                
        }
        else
                wrapexpemail.add(new wrapexpemail('Opp Team 5: '+expemail.Opp_Team_5__r.name,expemail.Opp_Team_5__r.email));  
                
                
                if(expemail.Opp_Team_6__r.name==null)
        {
               // wrapexpemail2.add(new wrapexpemail('Opp Team 6: ',' '));                    
                
        }
        else
                wrapexpemail2.add(new wrapexpemail('Opp Team 6: '+expemail.Opp_Team_6__r.name,expemail.Opp_Team_6__r.email));  
                
                
                if(expemail.Opp_Team_7__r.name==null)
        {
               // wrapexpemail2.add(new wrapexpemail('Opp Team 7: ',' '));                    
                
        }
        else
                wrapexpemail2.add(new wrapexpemail('Opp Team 7: '+expemail.Opp_Team_7__r.name,expemail.Opp_Team_7__r.email));  
                
                
                if(expemail.Opp_Team_8__r.name==null)
        {
               // wrapexpemail2.add(new wrapexpemail('Opp Team 8: ',' '));                    
                
        }
        else
                wrapexpemail2.add(new wrapexpemail('Opp Team 8: '+expemail.Opp_Team_8__r.name,expemail.Opp_Team_8__r.email));  
                
                
                if(expemail.Opp_Team_9__r.name==null)
        {
              //  wrapexpemail2.add(new wrapexpemail('Opp Team 9: ',' '));                    
                
        }
        else
                wrapexpemail2.add(new wrapexpemail('Opp Team 9: '+expemail.Opp_Team_9__r.name,expemail.Opp_Team_9__r.email));  
                
                if(expemail.Opp_Team_10__r.name==null)
        {
               // wrapexpemail2.add(new wrapexpemail('Opp Team 10: ',' '));                   
                
        }
        else
                wrapexpemail2.add(new wrapexpemail('Opp Team 10: '+expemail.Opp_Team_10__r.name,expemail.Opp_Team_10__r.email));   
                
         
    }
    

   }
   
    public pagereference backtoexpedite()
    {
        return new pagereference('/'+expreqid+'').setredirect(true);

    }
    // mehthod to save expedite email request record
    public pagereference send()
    {
        system.debug('checkattachment---------------'+checkattachment);
        string toemails;
        toemails=' ';
        if(exporder==true)
        {
                toemails+='expedites.orders@nimblestorage.com'+';';
        }
        if(Soowner==true)
        {
                toemails+=soemail+';'; 
        }
        
        for(wrapexpemail wrap:wrapexpemail)
        {
                if(wrap.isselected==true)
                {
                        toemails+=wrap.oppemail+';';
                }               
                
        }
                        toemails=toemails.subString(0,toemails.lastIndexOf(';'));
        
        system.debug('toemails----------------'+toemails);
        if(checkattachment=='False')
        {
                exemail.Attachment_Indicator__c=false;
                exemail.Email_To__c=toemails;
                exemail.Email_cc__c=emailcc;
                exemail.Expedite_Request__c=expemail.id;
                try
                {
                insert exemail;
                return new pagereference('/'+expreqid+'').setredirect(true);
                }
                catch(Exception ee)
                {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'One or more of the email addresses you have entered is in an improper format.  Please review the associated email addresses and make corrections as necessary.');
                        ApexPages.addMessage(myMsg);
                        return null;
                }
        }
        else
        {
                system.debug('inside attachment ------');
                attachmentexp=true;             
                newexpemail=false;
                        exemail.Attachment_Indicator__c=true;
                        exemail.Email_To__c=toemails;
                exemail.Email_cc__c=emailcc;
                exemail.Expedite_Request__c=expemail.id;
                try
                {
                 insert exemail;
                 exeemailattach=exemail;
                 return null;    
                }
                catch(Exception ee)
                {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'One or more of the email addresses you have entered is in an improper format.  Please review the associated email addresses and make corrections as necessary.');
                        ApexPages.addMessage(myMsg);
                        return null;
                }        
                        }
        
        
         
        
    }
    public pagereference ReSend()    
    {
        system.debug('inresend------------');
        Expedite_Request_Email__c exemailinsert=new Expedite_Request_Email__c();
        exemailinsert.Email_Body__c=exemailold.Email_Body__c;
        exemailinsert.Email_Subject__c=exemailold.Email_Subject__c;
        exemailinsert.Email_cc__c=exemailold.Email_cc__c;
        exemailinsert.Email_To__c=exemailold.Email_To__c;
        exemailinsert.Expedite_Request__c=expemail.id;
        if(checkattachment=='False')
        {
                exemailinsert.Attachment_Indicator__c=false;
                try
                {
                insert exemailinsert;        
                return new pagereference('/'+expreqid+'').setredirect(true);
                }
                catch(exception ee)
                {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'One or more of the email addresses you have entered is in an improper format.  Please review the associated email addresses and make corrections as necessary.');
                        ApexPages.addMessage(myMsg);
                        return null;
                }
        }
        else
        {
                attachmentexp=true;
                newexpemail=false;
                edtiexpemail=false;
                        exemailinsert.Attachment_Indicator__c=true;
                        try
                        {
                insert exemailinsert;
                exeemailattach=exemailinsert;
                        return null;  
                        }
                        
                        catch(Exception ee)
                        {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'One or more of the email addresses you have entered is in an improper format.  Please review the associated email addresses and make corrections as necessary.');
                        ApexPages.addMessage(myMsg);
                        return null;
                        }
                                  }
        
        
        
    }
    public pagereference sendwithattachment()
    {
              
       if(attachment.Body!=null) 
       {
               
        
       attachment.ParentId=exeemailattach.ID; 
      // attachment.Name=attachment.filename;
       insert attachment;
       }
       
           
        
       if(attachment2.Body!=null)
       {  
                
        
       attachment2.ParentId=exeemailattach.ID;
     //  attachment2.Name=attachment2.filename; 
              insert attachment2;
       
       }
         
        
       if(attachment3.Body!=null) 
       { 
         
       attachment3.ParentId=exeemailattach.ID; 
     //  attachment3.Name=attachment3.filename;
              insert attachment3;
       
       }
      
          
        if(attachment4.Body!=null) 
        {
                
       attachment4.ParentId=exeemailattach.ID; 
     //  attachment4.Name=attachment4.filename;
              insert attachment4;
       
        }
         
        
      if(attachment5.Body!=null) 
      {  
       attachment5.ParentId=exeemailattach.ID;
     //  attachment5.Name=attachment5.filename; 
              insert attachment5;
       
      }
     
        
        try
        {  
        update exeemailattach; 
        return new pagereference('/'+expreqid+'').setredirect(true);
        }
        catch(Exception ee)
        {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'One or more of the email addresses you have entered is in an improper format.  Please review the associated email addresses and make corrections as necessary.');
                ApexPages.addMessage(myMsg);
                return null;
        }
    }
    public pagereference cancel()
    {
        return new pagereference('/'+expreqid+'').setredirect(true);
        
    }
    public void Reply()
    {
    	if(exemailold.Inbound_Indicator__c==true)
    	{
    		exemailold.Email_To__c=exemailold.Email_From__c;
    	}
        string resubject=' ';
        exemailold.Email_Subject__c='RE: '+exemailold.Email_Subject__c;
        exemailold.Email_Body__c='__________________Original Message__________________\n'+exemailold.Email_Body__c;
        exemailold.Email_cc__c=' ';
        
        reply=true;
        detailexpemail=false;
                 edtiexpemail=true;
    }
    public void replyall()
    {
    	if(exemailold.Inbound_Indicator__c==true)
    	{
    		exemailold.Email_To__c=exemailold.Email_From__c;
    	}
        string resubject=' ';
        exemailold.Email_Subject__c='RE: '+exemailold.Email_Subject__c;
        exemailold.Email_Body__c='__________________Original Message__________________\n'+exemailold.Email_Body__c;
     //   exemailold.Email_cc__c=exemailold.Email_cc__c;
        replyall=true;
        detailexpemail=false;
        edtiexpemail=true;
    }
    public pagereference Editatt()
    {
    	
    	if(attid!=null && EMID!=null)
    	{
    		
      string url1='/apex/ExpediteEmailRequestEdit?retURL=/'+expreqid+'&EMID='+EMID;
      url1=EncodingUtil.urlEncode(url1, 'UTF-8');
           PageReference  pg=new PageReference('/'+attid+'/e?retURL='+url1); 
          
           pg.setRedirect(true);
           return pg;
    	}
    	else
    	
    	return null;
    }
    public pagereference deleteatt()
    {
    	if(attid!=null)
    	{
    		attachment att=[select name from attachment where id=:attid];
    		delete att;
    		if(EMId!=null && EMId!='')
    		{
	        attachments=[select description,LastModifiedById,LastModifiedDate,CreatedById , ParentId, Name, Id From Attachment where ParentId=:EMId];
    		}
    	}
    	return null;
    	
    }
    public pagereference viewatt()
    {
        return new pagereference('/servlet/servlet.FileDownload?file='+attid+'').setredirect(true);
    	
    }
    
   public class wrapexpemail
   {
        public boolean isselected{get;set;}
        public string oppteam{get;set;}
        public string oppemail;
        
   
   public wrapexpemail(string s,string email)
   {
        this.oppteam=s;
        this.oppemail=email;
        this.isselected=true;
   }
   }

}