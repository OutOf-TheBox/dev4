/**
 * This class is the controller of page Forecasting.
 */
 
public with sharing class ForecastingController 
{
    public ForecastingController()
    {
        //Set Fiscal Quarter
        String q = ApexPages.currentPage().getParameters().get('quarter');
        if(String.isNotBlank(q))
        {
            CurrentFiscalQuarter = new ForecastingDataModel.FiscalQuarterInfo(q);
        }
        else
        {
            CurrentFiscalQuarter = new ForecastingDataModel.FiscalQuarterInfo();
        }
        
        //Set User Nav Path
        String p = ApexPages.currentPage().getParameters().get('path');
        UserNavPath = GetUserNavPath(p);
        if(UserNavPath.size() > 0)
        {
            CurrentViewingUser = ForecastingService.GetUser(UserNavPath[UserNavPath.size() - 1].UserId);
        }
        else
        {
            ForecastingDataModel.UserInfo user = ForecastingService.GetUser(UserInfo.getUserId());
            CurrentViewingUser = (user.ForecastEnabled) ? user : user.ViewForecastAs;
            UserNavPath.add(CurrentViewingUser);
        }

        CurrentWeek = new ForecastingDataModel.WeekInfo();
    }
    
    public ForecastingDataModel.FiscalQuarterInfo CurrentFiscalQuarter { get; private set; }
    public ForecastingDataModel.WeekInfo CurrentWeek { get; private set; }
    public ForecastingDataModel.UserInfo CurrentViewingUser { get; private set; }
    public List<ForecastingDataModel.UserInfo> UserNavPath { get; set; }
    public String UserPath
    {
        get
        {
            String result = '';
            for(ForecastingDataModel.UserInfo usr : UserNavPath)
            {
                if(usr != null)
                {
                    result += '/' + usr.UserId;
                }
            }
            return result;
        }
    }
    
    public static List<ForecastingDataModel.UserInfo> GetUserNavPath(String path)
    {
        List<ForecastingDataModel.UserInfo> result = new List<ForecastingDataModel.UserInfo>();
        if(isValidPath(path))
        {
            ForecastingDataModel.UserInfo usr;
            for(String pathEntry : path.split('/'))
            {
                if(String.isNotBlank(pathEntry))
                {
                    usr = ForecastingService.GetUser(pathEntry);
                    if(usr != null)
                    {
                        result.add(usr);
                    }
                }
            }
        }
        return result;
    }
    
    public PageReference setupForecast()
    {
        if(CurrentViewingUser.ForecastEnabled)
        {
            List<CustomForecast__c> forecastsOfThisUser = [select Id from CustomForecast__c where User__c=:CurrentViewingUser.UserId and Locked__c=false limit 1];
            if(forecastsOfThisUser.size() == 0)
            {
                List<CustomForecast__c> forecastsOfOtherUser = [select Id, FYFQ__c, YYWW__c from CustomForecast__c where Locked__c=false and User__r.ForecastLevel__c=:CurrentViewingUser.ForecastLevel and User__r.IsActive=true limit 1];
                if(forecastsOfOtherUser.size() > 0)
                {
                    String fyfq = forecastsOfOtherUser[0].FYFQ__c;
                    String yyww = forecastsOfOtherUser[0].YYWW__c;
                    
                    CustomForecast__c newForecast = new CustomForecast__c(FYFQ__c=fyfq, User__c=CurrentViewingUser.UserId, YYWW__c=yyww, LastEdited__c=DateTime.now());
                    insert newForecast;
                }
            }
        }
        return null;
    }
    
    private static Boolean isValidPath(String path)
    {
        return String.isNotBlank(path) && Pattern.matches('/?(\\w{18}|\\w{15})(/(\\w{18}|\\w{15}))*', path);
    }
    
    //Gets all direct subordinate users of specified user
    @Readonly @RemoteAction
    public static List<ForecastingDataModel.UserInfo> GetDirectSubordinateUsers(Id userOrRoleId)
    {
        return ForecastingService.GetDirectSubordinateUsers(userOrRoleId);
    }
    
    //Gets all users role down the specified user
    @Readonly @RemoteAction
    public static List<ForecastingDataModel.UserInfo> GetAllSubordinateUsers(String userId)
    {
        return ForecastingService.GetAllSubordinateUsers(userId);
    }
}