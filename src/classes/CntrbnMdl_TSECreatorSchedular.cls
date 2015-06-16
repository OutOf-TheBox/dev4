//******************************************************************************************************//
//  Version      Date           Author      Comments                                                   //
//  0.1          2014-07-02     Sravan      Contribution data creator batch schedular class            //
//******************************************************************************************************//
global class CntrbnMdl_TSECreatorSchedular implements Schedulable
{   
    global void execute(SchedulableContext sc)
    {
        CntrbnMdl_TSECreator TSE = new CntrbnMdl_TSECreator();
        ID batchprocessid = Database.executeBatch(TSE);
    }
}