//******************************************************************************************************//
//  Version      Date           Author      Comments                                                   //
//  0.1          2014-06-28     Sravan      Contribution data creator batch schedular class            //
//******************************************************************************************************//
global class CntrbnMdl_CntrbnDataCreatorSchedular implements Schedulable
{   
    global void execute(SchedulableContext sc)
    {
        CntrbnMdl_CntrbnDataCreator CMDC = new CntrbnMdl_CntrbnDataCreator();
        ID batchprocessid = Database.executeBatch(CMDC);
    }
}