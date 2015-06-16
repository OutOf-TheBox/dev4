public with sharing class PopUpUser {
        public list<user> userlist;
        public list<string> uservalues{get;set;}
        public list<string> rightvalues{get;set;}
        public string selectedvalues{get;set;}
        public list<string> selectring{get;set;}
        public map<string,string> usermap{get;set;}
        public string test{get;set;}
        public string newexpemail{get;set;}
        public string reply{get;set;}
        public string replyall{get;set;}
        public string ccemail{get;set;}
        public integer intr{get;set;}
        public string selectedemails{get;set;}
        public string searchtext{get;set;}
        public list<Integer> iter{get;set;}
        public PopUpUser()
        {
                        
                list<string> selectring=new list<string>(); 
                usermap=new map<string,string>();
              
                uservalues=new list<string>();
                userlist=new list<user>();
                rightvalues=new list<string>();
                selectring=new list<string>();
                //rightvalues.add('---None---');
                userlist=[select id,name,email from user where email!=null limit 1000];
               reply=apexpages.currentPage().getParameters().get('reply');
               replyall=apexpages.currentPage().getParameters().get('replyall');
               newexpemail=apexpages.currentPage().getParameters().get('newexp');
               ccemail=apexpages.currentPage().getParameters().get('cc');
               system.debug('new-------------'+newexpemail);
               system.debug('reply------------------'+reply);
               system.debug('replyall--------------------'+replyall);
                for(user u:userlist)
                {
                        usermap.put(u.name,u.Email);
                    uservalues.add(u.name);
                        //selectedmail.add(u.email);
                }
                system.debug('usermap------------'+usermap);
                uservalues.sort();
        }
       
        public void SaveTest()
        {
                iter=new list<Integer>();
                
                test='gdfgdgddg';
                system.debug('inhere-----------');
                list<string> selectring=new list<string>();               
                list<string> userlist=new list<string>();
                userlist=selectedvalues.split(',');
                list<user> uslist=new list<user>();
                uslist=[select id,name,email from user where name in:userlist and email!=null];
                for(user u:uslist)
                {
                    selectring.add(u.email);
                    selectedemails+=u.email+';';
                }
                if(uslist.size()>0)
                {
                        selectedemails=selectedemails.subString(0,selectedemails.lastIndexOf(';'));     
                }               
                
                
               
                system.debug('selectring-----------------------------'+selectring);
                
        }
        public void cancel()
        {
                
        }
        public void Go()
        {
                string searcht='%'+searchtext+'%';
                                system.debug('searchtext------------'+searchtext);
                
                usermap=new map<string,string>();
                        
                uservalues=new list<string>();
       // userlist=Database.query('select id,name,email from user where email!=null and name LIKE: searcht limit 100');
       userlist=[select id,name,email from user where email!=null and name LIKE: searcht limit 100];
        for(user u:userlist)
                {
                        usermap.put(u.name,u.Email);
                    uservalues.add(u.name);
                        //selectedmail.add(u.email);
                }
                
                
                system.debug('usermap1------------'+usermap);
                selectedvalues.trim();
                rightvalues=selectedvalues.split(',');
                list<string> rightvals=new list<string>();
                for(string s:rightvalues)
                {
                        if(s!='' && s!= null)
                        {
                                rightvals.add(s);
                        }
                }
                system.debug('rightvals------------'+rightvals.size());
                /*set<string> rightval=new set<string>();
                rightval.addAll(rightvalues);
                
                if(rightval.contains(' '))
                rightval.remove(' ');
                rightvalues=new list<string>();
                rightvalues.addall(rightval);
                */
                rightvalues=new list<string>(); 
                if(rightvals.size()>0)               
                rightvalues=rightvals;
                uservalues.sort();
                                system.debug('uservalues------------'+uservalues);
                
        }
}