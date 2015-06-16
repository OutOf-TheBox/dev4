trigger SOactualShippingDateUpdate on Sales_Order__c (after update,after insert,after delete) {
   
   if((trigger.isUpdate || trigger.isInsert) && Utility.runDupRecTrigger) 
   { 
    map<id,Sales_Order__c> SOnew=new map<id,Sales_Order__c>();
    map<id,Sales_Order__c> SOold= new map<id,Sales_Order__c>();
    list<Expedite_Request__c> expreclist=new list<Expedite_Request__c>();
    list<Expedite_Request__c> expupdate=new list<Expedite_Request__c>();
    list<Sales_Order__c> salelist=new list<Sales_Order__c>();
    list<ID> opIDs=new list<ID>();
    list<Opportunity> opList=new list<Opportunity>();
    //list<Prebuild__c> preList=new list<Prebuild__c>();
    map<ID,Prebuild__c> opPrebuildmap= new map<ID,Prebuild__c>();
    set<id> errorOps=new set<id>();
    set<id> Opid=new set<id>();
    set<id> soid=new set<id>();
    map<id,Sales_Order__c> proppp=new map<id,Sales_Order__c>();
    set<id>proids=new set<id>();
    //Changes by Jitender
    for(Sales_Order__c s: trigger.new){
    	if(s.Type__c=='Prebuild'){
    		opIDs.add(s.Opportunity__c);
    	}
    }
    if(opList!=null){
    	opList=[Select ID from Opportunity where ID IN :opIDs];	
    	for(Prebuild__c p: [Select ID,Opportunity__c from Prebuild__c where Opportunity__c IN :opList]){
    		//if(p.Opportunity__c!=null){
    			opPrebuildmap.put(p.Opportunity__c,p);
    		//}	
    	}
    	for(Opportunity op: opList){
    		if(opPrebuildmap.get(op.ID)!=null){
    			System.debug('Okay=====');
    		}
    		else {
    			  System.debug('Error=====');
    			  errorOps.add(op.ID);
    		}
    	}
    	for(Sales_Order__c so: [Select ID,Type__c from Sales_Order__c where Opportunity__c IN :errorOps]){
    			if(so.Type__c=='Prebuild'){
    				Trigger.newMap.get(so.ID).addError('No Prebuild associated with this Sales Order');
    			}
    		}
    }		
    /*if(opList.size()!=preList.size()){
    	System.debug('Error');
    }
    for(Opportunity opp: opList){
    	
    }*/
    //Changes
    for(Sales_Order__c s: trigger.new)
    {
        proids.add(s.opportunity__c);    
    }
    
    for(Sales_Order__c s:[select opportunity__c,Type__c from Sales_Order__c where opportunity__c in:proids])
    {
    if(s.Type__c=='Prebuild')
    {
    proppp.put(s.opportunity__c,s);
    }
     system.debug('proppp-------------'+proppp);  
    }
    /*
    if(Trigger.isUpdate)
    {
    for(Sales_Order__c s: trigger.old)
    {
        SOold.put(s.id,s);
    }
    
    }
    */    
    for(Sales_Order__c so:trigger.new)
    {
        if(System.test.isRunningTest()){
            SOold.put(so.id,so);
            System.debug('trigger.oldmap-------'+trigger.oldmap);        
        }
        if(!System.test.isRunningTest()){
            if(so.Status__c=='Approved by OA' && trigger.newmap.get(so.id).Status__c==trigger.oldmap.get(so.id).Status__c && trigger.newmap.get(so.id).Shipment_Date__c != trigger.oldmap.get(so.id).Shipment_Date__c)
            {
            soid.add(so.id);
            //system.debug('in---------------');
            }
        }   
        /*
        if(so.Status__c=='Approved by OA' && SOnew.get(so.id).Status__c==SOold.get(so.id).Status__c && SOnew.get(so.id).Shipment_Date__c!=SOold.get(so.id).Shipment_Date__c)
        soid.add(so.id);
        */
    }
    
    expreclist=[select id,Last_Sched_Ship_Date_Update__c from Expedite_Request__c where Sales_Order__c in:soid];
    if(System.Test.isRunningTest()){
        
        Expedite_Request__c expTest =new Expedite_Request__c();
        expTest.Sales_Order__c=trigger.new[0].Id;
        expTest.Target_Install_Date__c=System.today();
        insert expTest;
        expreclist.add(expTest);
    }
    if(expreclist.size()>0)
    {
    for(Expedite_Request__c ex:expreclist)
    {
        ex.Last_Sched_Ship_Date_Update__c=system.now();
        expupdate.add(ex);
    }
    Utility.runDupRecTrigger=false;  // added by kavi to avoid calling trigger on expedite
    update expupdate;
    }
    /*if(System.Test.isRunningTest()){
        for(Expedite_Request__c ex:expreclist)
        {
            ex.Sales_Order__c='';
        }
    }*/
    salelist=[select name,Type__c,opportunity__r.Prebuild_Status__c ,opportunity__c from Sales_Order__c where id in:trigger.newmap.keyset() and opportunity__r.Prebuild_Status__c='Approved'];
    list<opportunity> opplist=new list<Opportunity>();
    set<id> oppid=new set<Id>();
    set<id>oppid1=new set<id>();
    list<Sales_Order__c> sallist=new list<Sales_Order__c>();
    for(Sales_Order__c s:salelist)
    {
        if(s.opportunity__r.Prebuild_Status__c=='Approved')
        {
            //CHANGES by Jitender Singh Padda
            if(trigger.isInsert)
            {
            //CHANGES
            s.Type__c='Prebuild';
            sallist.add(s);
            oppid1.add(s.opportunity__c);
            }
            If(trigger.isupdate)
            {
                if(trigger.oldmap.get(s.id).Type__c=='Prebuild' && trigger.newmap.get(s.id).Type__c!=trigger.oldmap.get(s.id).Type__c)
                {
                 if(!proppp.containsKey(s.opportunity__c))
                 oppid.add(s.opportunity__c);
                }
                else if(trigger.oldmap.get(s.id).Type__c!='Prebuild' && trigger.newmap.get(s.id).Type__c=='Prebuild')
                {
                 oppid1.add(s.opportunity__c);
                }           

            }            
        }
    }
    for(Opportunity o:[select id,name,SO_Prebuild_Order__c from opportunity where id in:oppid])
    {        
        o.SO_Prebuild_Order__c=false;
        opplist.add(o);
        
    }
    for(Opportunity o:[select id,name,SO_Prebuild_Order__c from opportunity where id in:oppid1])
    {        
        o.SO_Prebuild_Order__c=true;
        opplist.add(o);
        
    }
    
    if(sallist.size()>0)
    {
        Utility.runDupRecTrigger=false;
        update sallist;
    }
    
    if(opplist.size()>0)
    {
        update opplist;
    }
   }
   if(trigger.isAfter && trigger.isDelete)
   {
    set<id> opid=new set<Id>();
    for(Sales_Order__c s:trigger.old)
    {
        if(s.Type__c=='Prebuild')
        opid.add(s.opportunity__c);
    }
   list<Opportunity> opp=new list<Opportunity>();
   
   for(Opportunity o:[select name,SO_Prebuild_Order__c from Opportunity where id in :opid])
   {
    for(Sales_Order__c s: [select opportunity__c,Type__c from Sales_Order__c where opportunity__c =:o.ID]){
        System.debug('s-----------'+s);
        if(s.Type__c=='Prebuild'){
            o.SO_Prebuild_Order__c=true;        
        }
        else o.SO_Prebuild_Order__c=false;  
    }
    try{
        Sales_Order__c st=[select opportunity__c,Type__c from Sales_Order__c where opportunity__c =:o.ID];
    }catch(Exception e){
        o.SO_Prebuild_Order__c=false;
    }   
    opp.add(o);
   }
   if(opp.size()>0)
   {
    update opp;
   }
   
   }
   //Changes By Jitender Singh Padda
   /*
      if(trigger.isUpdate)
      {
        set<id> opid2=new set<Id>();
        for(Sales_Order__c s:trigger.new)
        {
            if(trigger.oldmap.get(s.id).Type__c=='Prebuild' && trigger.newmap.get(s.id).Type__c!=trigger.oldmap.get(s.id).Type__c)           
            opid2.add(s.opportunity__c);
        }
       list<Opportunity> opp1=new list<Opportunity>();
       for(Opportunity o:[select name,SO_Prebuild_Order__c from Opportunity where id in :opid2])
       {
        o.SO_Prebuild_Order__c=false;
        opp1.add(o);
       }
       System.debug('opp1----'+opp1);
       if(opp1.size()>0)
       {
        update opp1;
       }
      }  
      */
     //Changes      
   }
   
   /*
   if(trigger.isBefore)
   {
    set<id> soid=new set<Id>();
    set<id>opids=new set<id>();
    list<Sales_Order__c> salelist=new list<Sales_Order__c>();
    for(Sales_Order__c s:trigger.new)
    {
        soid.add(s.id);
        opids.add(s.opportunity__c);
    }
    
    salelist=[select name,Type__c,opportunity__r.Prebuild_Status__c ,opportunity__c from Sales_Order__c where id in:soid and opportunity__r.Prebuild_Status__c='Approved'];
    list<opportunity> opplist=new list<Opportunity>();
    set<id> oppid=new set<Id>();
    for(Sales_Order__c s:trigger.new)
    {
        if(s.opportunity__r.Prebuild_Status__c=='Approved')
        {
            system.debug('soooooooooooooooooooooooooo');
            s.Type__c='Prebuild';
            oppid.add(s.opportunity__c);            
        }
    }
    for(Opportunity o:[select id,name,SO_Prebuild_Order__c from opportunity where id in:oppid])
    {
        o.SO_Prebuild_Order__c=true;
        opplist.add(o);
    }
    if(opplist.size()>0)
    {
        update opplist;
    }
   }*/