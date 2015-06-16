/**
 * This class contains remote actions of Forecasting page.
 */
 
public class ForecastingService
{
    private static Map<Id, List<Id>> subRoleMapping;
    private static Map<Id, List<User>> forecastingUsers;
    
    //Gets all direct subordinate users of specified user
    @Readonly @RemoteAction
    public static List<ForecastingDataModel.UserInfo> GetDirectSubordinateUsers(Id userOrRoleId)
    {
        List<ForecastingDataModel.UserInfo> result = new List<ForecastingDataModel.UserInfo>();
        List<Id> roleIds = new List<Id>();
        if(userOrRoleId == null)
        {
            roleIds = getSubRoles(null, false);
        }
        else if(userOrRoleId.getSObjectType() == Schema.User.SObjectType)
        {
            List<User> users = [select Id, Name, UserRoleId, UserRole.Name, ViewForecastAs__c, ForecastEnabled__c, ForecastLevel__c from User where Id=:userOrRoleId limit 1];
            if(users.size() > 0)
            {
                roleIds.add(users[0].UserRoleId);
            }
        }
        else if(userOrRoleId.getSObjectType() == Schema.UserRole.SObjectType)
        {
            roleIds.add(userOrRoleId);
        }
        if(roleIds.size() > 0)
        {
            for(Id roleId : roleIds)
            {
                List<Id> subRoles = getSubRoles(roleId, false);
                for(Id rid : subRoles)
                {
                    List<ForecastingDataModel.UserInfo> users = getUsersByRole(rid, true);
                    if(users.size() > 0)
                    {
                        result.addAll(users);
                    }
                    else
                    {
                        result.addAll(GetDirectSubordinateUsers(rid));
                    }
                }
            }
        }
        return result;
    }

    //Gets all users role down the specified user
    @Readonly @RemoteAction
    public static List<ForecastingDataModel.UserInfo> GetAllSubordinateUsers(String userId)
    {
        List<ForecastingDataModel.UserInfo> result = new List<ForecastingDataModel.UserInfo>();
        List<User> users = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :userId LIMIT 1];
        if(users.size() > 0)
        {
            List<String> subRoles = getSubRoles(users[0].UserRoleId, true);
            for(User usr : [SELECT Id, Name, UserRoleId, UserRole.Name, ViewForecastAs__c, ForecastEnabled__c, ForecastLevel__c FROM User WHERE UserRoleId in :subRoles])
            {
                result.add(new ForecastingDataModel.UserInfo(usr));
            }
        }
        return result;
    }

    public static List<Id> GetAllSubordinateUserIds(String userId)
    {
        List<Id> result = new List<Id>();
        List<ForecastingDataModel.UserInfo> users = GetAllSubordinateUsers(userId);
        for(ForecastingDataModel.UserInfo user : users)
        {
            result.add(user.UserId);
        }
        return result;
    }

    public static List<Id> GetDirectSubordinateUserIds(String userId)
    {
        List<Id> result = new List<Id>();
        List<ForecastingDataModel.UserInfo> users = GetDirectSubordinateUsers(userId);
        for(ForecastingDataModel.UserInfo user : users)
        {
            result.add(user.UserId);
        }
        return result;
    }
    
    public static List<Id> getSubRoles(Id roleId, Boolean traverseAll)
    {
        List<Id> result = new List<Id>();
        subRoleMapping = getSubRoleMapping();
        List<Id> directRoles = subRoleMapping.get(roleId);
        if(directRoles != null)
        {
            result.addAll(directRoles);
            if(traverseAll)
            {
                for(Id rid : directRoles)
                {
                    result.addAll(getSubRoles(rid, true));
                }
            }
        }
        return result;
    }
    
    static Map<Id, List<Id>> getSubRoleMapping()
    {
        if(subRoleMapping == null)
        {
            subRoleMapping = new Map<Id, List<Id>>();
            for(UserRole role : [SELECT Id, Name, ParentRoleId FROM UserRole WHERE PortalType = 'None'])
            {
                if(!subRoleMapping.containsKey(role.ParentRoleId))
                {
                    subRoleMapping.put(role.ParentRoleId, new List<Id> {role.Id});
                }
                else
                {
                    subRoleMapping.get(role.ParentRoleId).add(role.Id);
                }
            }
        }
        return subRoleMapping;
    }
    
    private static List<ForecastingDataModel.UserInfo> getUsersByRole(Id roleId, Boolean forecastOnly)
    {
        List<ForecastingDataModel.UserInfo> result = new List<ForecastingDataModel.UserInfo>();
        List<User> users = new List<User>();
        if(!forecastOnly)
        {
            users = [SELECT Id, Name, UserRoleId, UserRole.Name, ViewForecastAs__c, ForecastEnabled__c, ForecastLevel__c FROM User WHERE UserRoleId = :roleId and IsActive=true];
            
        }
        else
        {
            if(forecastingUsers == null)
            {
                forecastingUsers = new Map<Id, List<User>>();
                for(User usr : [SELECT Id, Name, UserRoleId, UserRole.Name, ViewForecastAs__c, ForecastEnabled__c, ForecastLevel__c FROM User WHERE ForecastEnabled__c=true and IsActive=true])
                {
                    if(forecastingUsers.containsKey(usr.UserRoleId))
                    {
                        forecastingUsers.get(usr.UserRoleId).add(usr);
                    }
                    else
                    {
                        forecastingUsers.put(usr.UserRoleId, new List<User> { usr });
                    }
                }
            }
            users = forecastingUsers.get(roleId);
            users = (users == null) ? new List<User>() : users;
        }
        for(User usr : users)
        {
            result.add(new ForecastingDataModel.UserInfo(usr));
        }
        return result;
    }

    public static ForecastingDataModel.UserInfo GetUser(String userId)
    {
        List<User> users = [SELECT Id, Name, UserRoleId, UserRole.Name, ViewForecastAs__c, ForecastEnabled__c, ForecastLevel__c FROM User WHERE Id = :userId LIMIT 1];
        if(users.size() > 0)
        {
            return new ForecastingDataModel.UserInfo(users[0]);
        }
        else
        {
            return null;
        }
    }
    
    public static Date GetStartOfCurrentFiscalYear()
    {
        List<Period> periods = [SELECT StartDate FROM Period WHERE Type = 'Year' AND StartDate <= Today AND EndDate >= Today LIMIT 1];
        if(periods.size() > 0)
        {
            return periods[0].StartDate;
        }
        return null;
    }
}