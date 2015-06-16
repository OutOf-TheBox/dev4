trigger OpportunityProduct on OpportunityLineItem (before insert, before update, after insert, after update) {    

       
    if(trigger.isAfter && Utility.runDupRecTrigger)
    {
     List<OpportunityLineItem> OppyLines = Trigger.new; 
    Set<Id> prodIds = new Set<Id>();
    Set<Id> OppIds = new Set<Id>();
    
    for(OpportunityLineItem lItem : OppyLines)
    {
        prodIds.add(lItem.Product2Id);
        OppIds.add(lItem.OpportunityID);
        
    }
        
    /******************added by mansa - start******************/
   list<OpportunityLineItem> Opplinelist_child=new list<OpportunityLineItem>();
    
    for(OpportunityLineItem Oppyline:[select Product_Network_Type__c,Product_Sub_Type__c,Product_Type_2__c,OpportunityId,Product2.parent_product__c,Product2.Legacy_product__c,Product_Name_Dynamic__c,SBQQ__QuoteLine__c,SBQQ__QuoteLine__r.SBQQ__RequiredBy__c from OpportunityLineItem where Opportunityid in:OppIds and SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Primary__c=true])
    {
       // OpportunityLineItem OppyLine = Trigger.new.get(i);
        String prodCode = Oppyline.Product_Name_Dynamic__c;
        List<String> prodCodeSplit = new List<String>();
        Oppyline.Product_Network_Type__c = '';
         if(Oppyline.Product2.parent_product__c==false)
         {
                    
            if(Oppyline.Product_Type_2__c=='Networking' && Oppyline.Product_Sub_Type__c=='FC')
            {               
                Opplinelist_child.add(Oppyline);
                Oppyline.Product_Network_Type__c = 'FC';
            }
            else if((Oppyline.Product_Type_2__c=='Networking' && Oppyline.Product_Sub_Type__c=='ISCSI') || (Oppyline.Product2.Legacy_product__c==true))
            {              
                Opplinelist_child.add(Oppyline);                
                Oppyline.Product_Network_Type__c = 'ISCSI';
            }           
            else if(Oppyline.Product_Type_2__c!='Networking')
            {
                Opplinelist_child.add(Oppyline);                
                Oppyline.Product_Network_Type__c = 'Network Agnostic';
            }
            if(Opplinelist_child.size()>0)
            {
                Utility.runDupRecTrigger=false;
                update Opplinelist_child;                
            }
        }
    }
      
        Map<ID,list<OpportunityLineItem>> opp_OpplineParent=new map<Id,list<OpportunityLineItem>>();
        map<Id,OpportunityLineItem> QoOppPro_map=new map<Id,OpportunityLineItem>();
        map<Id,list<Id>> ReqByQLine_QlList=new  map<Id,list<Id>>();      
        set<id> quote_lineids=new set<Id>();
        map<OpportunityLineItem,list<OpportunityLineItem>> OpLine_OplineList=new map<OpportunityLineItem,list<OpportunityLineItem>>();
        
        for(OpportunityLineItem opline:[select Product_Network_Type__c,Product_Sub_Type__c,Product_Type_2__c,OpportunityId,Product2.parent_product__c,Product2.Legacy_product__c,Product_Name_Dynamic__c,SBQQ__QuoteLine__c,SBQQ__QuoteLine__r.SBQQ__RequiredBy__c from OpportunityLineItem where Opportunityid in:OppIds and SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Primary__c=true])
        {           
            QoOppPro_map.put(opline.SBQQ__QuoteLine__c,opline);
            
            if(opline.OpportunityID!=null)
                {           
                    if(opp_OpplineParent.containsKey(opline.OpportunityID))
                        opp_OpplineParent.get(opline.OpportunityID).add(opline);
                    else
                        opp_OpplineParent.put(opline.OpportunityID,new List<OpportunityLineItem>{opline}); 
                } 
        }
        list<OpportunityLineItem> addupdatelistGrand=new list<OpportunityLineItem>();
        
        for(OpportunityLineItem opline:Opplinelist_child)
        {
            if(QoOppPro_map.containskey(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c))
            {
                if(QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c).SBQQ__QuoteLine__r.SBQQ__RequiredBy__c!=null)
                {
                    if(OpLine_OplineList.containsKey(QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c)))
                        OpLine_OplineList.get(QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c)).add(opline);
                    else
                        OpLine_OplineList.put(QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c),new List<OpportunityLineItem>{opline});
                    
                }
                else if(QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c).SBQQ__QuoteLine__r.SBQQ__RequiredBy__c==null)
                {
                    addupdatelistGrand.add(opline);
                }
            }
        }
        
        /*
        
        for(OpportunityLineItem opline:[select Product_Network_Type__c,Product_Sub_Type__c,Product_Type_2__c,OpportunityId,Product2.parent_product__c,Product2.Legacy_product__c,Product_Name_Dynamic__c,SBQQ__QuoteLine__c,SBQQ__QuoteLine__r.SBQQ__RequiredBy__c from OpportunityLineItem where Opportunityid in:OppIds and SBQQ__QuoteLine__r.SBQQ__Quote__r.SBQQ__Primary__c=true])
        {           
            QoOppPro_map.put(opline.SBQQ__QuoteLine__c,opline);
            if(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c!=null)
            {           
                    if(ReqByQLine_QlList.containsKey(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c))
                        ReqByQLine_QlList.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c).add(opline.SBQQ__QuoteLine__c);
                    else
                        ReqByQLine_QlList.put(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c,new List<Id>{opline.SBQQ__QuoteLine__c}); 
            }   
            
            if(opline.OpportunityID!=null)
                {           
                    if(opp_OpplineParent.containsKey(opline.OpportunityID))
                        opp_OpplineParent.get(opline.OpportunityID).add(opline);
                    else
                        opp_OpplineParent.put(opline.OpportunityID,new List<OpportunityLineItem>{opline}); 
                }           
        }
        system.debug('---------ReqByQLine_QlList---------'+ReqByQLine_QlList);
        
        for(Id Qid:ReqByQLine_QlList.keyset())
        {
            system.debug('qid---'+qid);
            if(QoOppPro_map.containskey(qid))
            {
                
                for(Id Subids:ReqByQLine_QlList.get(Qid))
                {   
                        system.debug('-------sub qid---'+QoOppPro_map.get(qid).SBQQ__QuoteLine__r.SBQQ__RequiredBy__c);
                                    
                    if(QoOppPro_map.get(qid).SBQQ__QuoteLine__r.SBQQ__RequiredBy__c!=null && QoOppPro_map.containsKey(Subids))
                    {
                        system.debug('test---');
                        system.debug('QoOppPro_map.get(Subids)--'+QoOppPro_map.get(Subids));
                        if(OpLine_OplineList.containsKey(QoOppPro_map.get(Qid)))
                            OpLine_OplineList.get(QoOppPro_map.get(Qid)).add(QoOppPro_map.get(Subids));
                        else
                            OpLine_OplineList.put(QoOppPro_map.get(Qid),new List<OpportunityLineItem>{QoOppPro_map.get(Subids)});
                    }               
                    
                }
            }
        }
        */
        
        list<OpportunityLineItem> update2childOpp=new list<OpportunityLineItem>();
        map<OpportunityLineItem,list<OpportunityLineItem>> Grand_OpLine_OplineList=new map<OpportunityLineItem,list<OpportunityLineItem>>();
        
        system.debug('size-------'+OpLine_OplineList.size());
        for(OpportunityLineItem opline:OpLine_OplineList.keyset())
        {
            system.debug('--------opline--------'+opline);
            
            Integer FCcount=0;
            Integer ISCSIcount=0;
            //Integer FCISCSIcount=0;
            String OppNetTypeVal='';
            if(opline.Product2.Legacy_product__c==true)
            {                
                opline.Product_Network_Type__c='ISCSI';
                update2childOpp.add(opline);
            }
            
            else if(OpLine_OplineList.containskey(opline))
            {
                for(OpportunityLineItem oppitems:OpLine_OplineList.get(opline))
                { 
                    if(OppItems.Product_Network_Type__c=='FC')
                    {
                        FCcount = FCcount + 1;
                    }
            
                    else if(OppItems.Product_Network_Type__c=='ISCSI')
                    {
                        ISCSIcount = ISCSIcount + 1;
                    }
                
                    else if(OppItems.Product_Network_Type__c=='Network Agnostic')
                    {
                        OppNetTypeVal = 'Network Agnostic';
                    }
                }
                
                if(FCcount>=1)
                {
                    
                opline.Product_Network_Type__c='FC';    
                }
                
                else if(FCcount==0 && ISCSIcount>=1)
                {
                    opline.Product_Network_Type__c='ISCSI';
                }
                
                else if(OppNetTypeVal!='' && OppNetTypeVal=='Network Agnostic')
                {
                opline.Product_Network_Type__c='Network Agnostic';
    
                }
                
                update2childOpp.add(opline);
                }
            }  
        
                    system.debug('Opplinelist_child-------'+Opplinelist_child);
        
        if(update2childOpp.size()>0)
        {
            Utility.runDupRecTrigger=false;         
            update update2childOpp;
            
        }
        if(addupdatelistGrand.size()>0)
        {
            update2childOpp.addall(addupdatelistGrand);
        }
        
        for(OpportunityLineItem opline:update2childOpp)
        {
            system.debug('opline grand------'+opline);
            if(QoOppPro_map.containskey(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c))
            {
                system.debug('--opp pro---'+QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c));
                if(Grand_OpLine_OplineList.containsKey(QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c)))
                    Grand_OpLine_OplineList.get(QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c)).add(opline);
                else
                    Grand_OpLine_OplineList.put(QoOppPro_map.get(opline.SBQQ__QuoteLine__r.SBQQ__RequiredBy__c),new List<OpportunityLineItem>{opline});
            }
        }
        
        system.debug('size map----------'+Grand_OpLine_OplineList.size());
                system.debug('full map map----------'+Grand_OpLine_OplineList);
        
        list<OpportunityLineItem> updateParent=new list<OpportunityLineItem>();
        for(OpportunityLineItem opline: Grand_OpLine_OplineList.keyset())        
        {
            Integer FCcount=0;
            Integer ISCSIcount=0;
            //Integer FCISCSIcount=0;
            String OppNetTypeVal='';
            if(opline.Product2.Legacy_product__c==true)
            {                
                opline.Product_Network_Type__c='ISCSI';
                updateParent.add(opline);
            }
            else if(Grand_OpLine_OplineList.containskey(opline))
            {
                for(OpportunityLineItem oppitems:Grand_OpLine_OplineList.get(opline))
                { 
                    if(OppItems.Product_Network_Type__c=='FC')
                    {
                        FCcount = FCcount + 1;
                    }
            
                    else if(OppItems.Product_Network_Type__c=='ISCSI')
                    {
                        ISCSIcount = ISCSIcount + 1;
                    }
                
                    else if(OppItems.Product_Network_Type__c=='Network Agnostic')
                    {
                        OppNetTypeVal = 'Network Agnostic';
                    }
                }
                
                if(FCcount>=1)
                {
                    
                opline.Product_Network_Type__c='FC';    
                }
                
                else if(FCcount==0 && ISCSIcount>=1)
                {
                    opline.Product_Network_Type__c='ISCSI';
                }
                
                else if(OppNetTypeVal!='' && OppNetTypeVal=='Network Agnostic')
                {
                opline.Product_Network_Type__c='Network Agnostic';
    
                }               
                updateParent.add(opline);
                }
            
        }
                    system.debug('updateParent-------'+updateParent);
        
        if(updateParent.size()>0)
        {
            Utility.runDupRecTrigger=false;         
            update updateParent;
        }
        
       ////////// 
        list<Opportunity> Updateopplist = new list<Opportunity>();
        for(Opportunity op:[select name from opportunity where id in:opp_OpplineParent.keyset()])
        {
            Integer FCcount=0;
            Integer ISCSIcount=0;
            String OppNetTypeVal='';
            for(OpportunityLineItem OppItems:opp_OpplineParent.get(op.id))
            {
                if(OppItems.Product_Network_Type__c=='FC')
                {
                    FCcount = FCcount + 1;
                }
        
                else if(OppItems.Product_Network_Type__c=='ISCSI')
                {
                    ISCSIcount = ISCSIcount + 1;
                }
        
                else if(OppItems.Product_Network_Type__c=='Network Agnostic')
                {
                    OppNetTypeVal = 'Network Agnostic';
                }
            }
            if(FCcount>=1)
            {
              op.Opportunity_Network_Type__c='FC';
              Updateopplist.add(op);   
          
            }
            
            else if(FCcount==0 && ISCSIcount>=1)
            {
              op.Opportunity_Network_Type__c='ISCSI';   
              Updateopplist.add(op);              
            }
            
            else if(OppNetTypeVal!='' && OppNetTypeVal=='Network Agnostic')
            {
                op.Opportunity_Network_Type__c='Network Agnostic';   
                Updateopplist.add(op);          
            }
        }        
     
        if(Updateopplist.size()>0)
        {       
        Update Updateopplist;
        }
       
    }
}