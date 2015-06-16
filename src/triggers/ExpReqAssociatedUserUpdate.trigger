/* Description: insert or updates opportunity team members related to Salesorder__c related to opportunity  
  on expedite request record whenever expedite record is created or updated*/ 

trigger ExpReqAssociatedUserUpdate on Expedite_Request__c (after insert, before update) {
    public boolean checkupdate=false;
    if(trigger.isinsert)
    {
        set<id> exid =new set<id>();
        for(Expedite_Request__c e:trigger.new)
        {
            exid.add(e.id);
        }
        map<id,id> ex_opid_map=new map<id,id>();
        map<id,list<OpportunityTeamMember>> opid_opt = new  map<id,list<OpportunityTeamMember>>();
        list<OpportunityTeamMember> opteamlist= new list<OpportunityTeamMember>();
        list<Expedite_Request__c> exlist= [select id,sales_order__r.opportunity__c,Sales_Order__r.OwnerId  from Expedite_Request__c where id in:exid];
        set<id> soid=new set<id>();
        
        for(Expedite_Request__c ex:exlist)
        {
            ex_opid_map.put(ex.id,ex.Sales_Order__r.Opportunity__c);
            soid.add(ex.Sales_Order__c);
        }
        map<id,id> so_opmap= new map<id,id>();
        map<id,id> so_ownerid=new map<id,id>();
        for(Sales_Order__c so:[select id,name,opportunity__c,ownerid from Sales_Order__c where id in:soid])
        {
            so_opmap.put(so.id,so.Opportunity__c);
            so_ownerid.put(so.id,so.ownerid);
            
        }               
        
        for(OpportunityTeamMember op:[select id,OpportunityId,userid from OpportunityTeamMember where OpportunityId in:ex_opid_map.values()])
        {
         
            if(opid_opt.containsKey(op.OpportunityId))
                        opid_opt.get(op.OpportunityId).add(op);
                  else
                        opid_opt.put(op.OpportunityId,new List<OpportunityTeamMember >{op});   
            
        }
        /*
        
        for(id opt:ex_opid_map.values())
        {
            opteamlist=new list<OpportunityTeamMember>();
            for(OpportunityTeamMember op:[select id,OpportunityId,userid from OpportunityTeamMember where OpportunityId =:opt])
            {
                opteamlist.add(op);
            }
            
            opid_opt.put(opt,opteamlist);
        }
        */
        
        list<Expedite_Request__c> exupdatelist=new list<Expedite_Request__c>();
        
        for(Expedite_Request__c e: exlist)
        {
            e.SO_Owner__c=so_ownerid.get(e.sales_order__c);
            
            integer i=0;
            if(opid_opt.containskey(so_opmap.get(e.sales_order__c)))
            {
                i=opid_opt.get(so_opmap.get(e.sales_order__c)).size();
            } 
            
            if(i>=1)
            {
                e.Opp_Team_1__c=opid_opt.get(so_opmap.get(e.sales_order__c))[0].userid;                           
            }            
            if(i>=2)
            {
                e.Opp_Team_2__c=opid_opt.get(so_opmap.get(e.sales_order__c))[1].userid;
            }
            if(i>=3)
            {
                e.Opp_Team_3__c=opid_opt.get(so_opmap.get(e.sales_order__c))[2].userid;
            }
            if(i>=4)
            {
                e.Opp_Team_4__c=opid_opt.get(so_opmap.get(e.sales_order__c))[3].userid;
            }
            if(i>=5)
            {
                e.Opp_Team_5__c=opid_opt.get(so_opmap.get(e.sales_order__c))[4].userid;
            }
            if(i>=6)
            {
                e.Opp_Team_6__c=opid_opt.get(so_opmap.get(e.sales_order__c))[5].userid;
            }
            if(i>=7)
            {
                e.Opp_Team_7__c=opid_opt.get(so_opmap.get(e.sales_order__c))[6].userid;
            }
            if(i>=8)
            {
                e.Opp_Team_8__c=opid_opt.get(so_opmap.get(e.sales_order__c))[7].userid;
            }
            if(i>=9)
            {
                e.Opp_Team_9__c=opid_opt.get(so_opmap.get(e.sales_order__c))[8].userid;
            }
            if(i>=10)
            {
                e.Opp_Team_10__c=opid_opt.get(so_opmap.get(e.sales_order__c))[9].userid;
            }
                exupdatelist.add(e);
            
        }
        update exupdatelist;
        checkupdate=true;
        
    }
    if(trigger.isupdate && checkupdate==false && Utility.runDupRecTrigger==true)
    {
        set<id> soid =new set<id>();
        map<id,id> ex_opid_map=new map<id,id>();
        map<id,list<OpportunityTeamMember>> opid_opt = new  map<id,list<OpportunityTeamMember>>();
        list<OpportunityTeamMember> opteamlist= new list<OpportunityTeamMember>();
        list<Expedite_Request__c> exlist= [select id,sales_order__r.opportunity__c,Sales_Order__r.OwnerId  from Expedite_Request__c where id in:trigger.newmap.keyset()];
        
        for(Expedite_Request__c ex:exlist)
        {
            ex_opid_map.put(ex.id,ex.Sales_Order__r.Opportunity__c);
            soid.add(ex.Sales_Order__c);
        }
        map<id,id> so_opmap= new map<id,id>();
        map<id,id> so_ownerid=new map<id,id>();
        for(Sales_Order__c so:[select id,name,opportunity__c,ownerid from Sales_Order__c where id in:soid])
        {
            so_opmap.put(so.id,so.Opportunity__c);
            so_ownerid.put(so.id,so.ownerid);
            
        }                
        
        
        for(OpportunityTeamMember op:[select id,OpportunityId,userid from OpportunityTeamMember where OpportunityId in:ex_opid_map.values()])
        {
         
            if(opid_opt.containsKey(op.OpportunityId))
                        opid_opt.get(op.OpportunityId).add(op);
                  else
                        opid_opt.put(op.OpportunityId,new List<OpportunityTeamMember >{op});   
            
        }
        /*
        for(id opt:ex_opid_map.values())
        {
            opteamlist=new list<OpportunityTeamMember>();
            for(OpportunityTeamMember op:[select id,OpportunityId,userid from OpportunityTeamMember where OpportunityId =:opt])
            {
                opteamlist.add(op);
            }
            
            opid_opt.put(opt,opteamlist);
        }
        */
        
        list<Expedite_Request__c> exupdatelist=new list<Expedite_Request__c>();
        
        for(Expedite_Request__c e: trigger.new)
        {
            e.SO_Owner__c=so_ownerid.get(e.sales_order__c);
            
            integer i=0;
            if(opid_opt.containskey(so_opmap.get(e.sales_order__c)))
            {
                i=opid_opt.get(so_opmap.get(e.sales_order__c)).size();
            } 
                       
            if(i>=1)
            {
                e.Opp_Team_1__c=opid_opt.get(so_opmap.get(e.sales_order__c))[0].userid;
                           
            }
            
            if(i>=2)
            {
                e.Opp_Team_2__c=opid_opt.get(so_opmap.get(e.sales_order__c))[1].userid;
            }
            if(i>=3)
            {
                e.Opp_Team_3__c=opid_opt.get(so_opmap.get(e.sales_order__c))[2].userid;
            }
            if(i>=4)
            {
                e.Opp_Team_4__c=opid_opt.get(so_opmap.get(e.sales_order__c))[3].userid;
            }
            if(i>=5)
            {
                e.Opp_Team_5__c=opid_opt.get(so_opmap.get(e.sales_order__c))[4].userid;
            }
            if(i>=6)
            {
                e.Opp_Team_6__c=opid_opt.get(so_opmap.get(e.sales_order__c))[5].userid;
            }
            if(i>=7)
            {
                e.Opp_Team_7__c=opid_opt.get(so_opmap.get(e.sales_order__c))[6].userid;
            }
            if(i>=8)
            {
                e.Opp_Team_8__c=opid_opt.get(so_opmap.get(e.sales_order__c))[7].userid;
            }
            if(i>=9)
            {
                e.Opp_Team_9__c=opid_opt.get(so_opmap.get(e.sales_order__c))[8].userid;
            }
            if(i>=10)
            {
                e.Opp_Team_10__c=opid_opt.get(so_opmap.get(e.sales_order__c))[9].userid;
            }
                        exupdatelist.add(e);
            
        }
    }

}