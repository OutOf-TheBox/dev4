//******************************************************************************************************//
//  Version      Date           Author      Comments                                                   //
//  0.1          2014-06-28     Sravan      Case backlog updator batch schedular class                 //
//******************************************************************************************************//
global class CntrbnMdl_CaseBacklogUpdatorSchedular implements Schedulable
{   
    global void execute(SchedulableContext sc)
    {
        CntrbnMdl_CaseBacklogUpdator CMCBU = new CntrbnMdl_CaseBacklogUpdator();
        ID batchprocessid = Database.executeBatch(CMCBU);
    }
}