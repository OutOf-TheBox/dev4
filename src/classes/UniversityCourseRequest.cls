/**
 * https://gaeasys.plan.io/issues/5470 
 * @Bussiness : set the University_Course_Request__c fields, according to the "Venue City"
 * @Author : Bunhor
 * @CreatedDate : 10-May-15
 */ 
public with sharing class UniversityCourseRequest {
	/** Error string */
	public static final string ERR = 'Problem Setting Data';
	public static final string ERR_TIMEZONE = 'Failed to set Time Zone';
	public static final string ERR_AIRPORT = 'Failed to set Airport Code';
	
	/**
	 * Called from University_Course_Request__c trigger after insert.
	 * TODO: Update some fields, according to the "Venue City"
	 * @param : lstCourseReqId is the set of University_Course_Request__c id
	 */
	@future (callout=true) 
	public static void setFieldValues(Set<id> lstCourseReqId){
		University_Course_Request__c[] lstCourseReq = [select id, Venue_City__c, Desired_Course_Date_Start_Time__c from University_Course_Request__c where id in:lstCourseReqId and Venue_City__c!=null];
		
		// Getting set of cities
		Set<String> setCity = new Set<String>(); 
		for(University_Course_Request__c cReq: lstCourseReq){ 
			String city = cReq.Venue_City__c.trim().tolowercase();
			setCity.add(city); 
		}
		
		// Getting Map of city to latlong ****Callout in loop****
		Map<String, String> mCity2LatLng = new Map<String, String>();
		for(String ct : setCity){
			GoogleServices.Geo geo = GoogleServices.getGeo(ct); // Callout
			if(Geo!=null){
				mCity2LatLng.put(ct, geo.getLatLong());
			}
		}
		
		// Getting Map of city to TimeZone ****Callout in loop****
		Map<String, GoogleServices.TimeZone> mCity2TimeZone = new Map<String, GoogleServices.TimeZone>();
		for(String ct : mCity2LatLng.keyset()){ 
			GoogleServices.TimeZone timeZone = GoogleServices.getTimeZone(mCity2LatLng.get(ct), (DateTime.now().getTime()/1000) ); // Callout
			if(TimeZone!=null){
				mCity2TimeZone.put(ct, timeZone);
			}
		}
		
		// Getting Map of city to a nearest Airport ****Callout in loop****
		Map<String, GoogleServices.Airport> mCity2ClosestAirport = new Map<String, GoogleServices.Airport>();
		for(String ct : mCity2LatLng.keyset()){ 
			GoogleServices.Airport airport = GoogleServices.getNearestAirport(mCity2LatLng.get(ct)); // Callout
			if(airport!=null){
				mCity2ClosestAirport.put(ct, airport);
			}
		}
		
		// Updating the fields
		for(University_Course_Request__c cReq: lstCourseReq){
			GoogleServices.TimeZone timeZone = mCity2TimeZone.get(cReq.Venue_City__c.trim().tolowercase());
			GoogleServices.Airport airport = mCity2ClosestAirport.get(cReq.Venue_City__c.trim().tolowercase());
			
			cReq.Request_Status__c = '';
			cReq.Problem_Setting_Data_Details__c = '';
			
			if(timeZone!=null){
				// Update with today at 12pm in the current user’s time zone
				cReq.Registration_Open_Date__c = getDateTimeAtNparam(system.now(), 12);
				
				// Update with the day of course start date at 12pm in the current user’s time zone
				if(cReq.Desired_Course_Date_Start_Time__c!=null){ 
					cReq.Registration_Closed_Date__c = getDateTimeAtNparam(cReq.Desired_Course_Date_Start_Time__c, 12);
				} 
				cReq.Venue_Time_Zone__c = timeZone.time_zone_id;
				cReq.TZoffset__c = timeZone.getOffsetAsHour(); 
				
			}else{
				cReq.Request_Status__c = ERR;
				cReq.Problem_Setting_Data_Details__c = ERR_TIMEZONE;
			}
			 
			if(airport!=null){
				cReq.Venue_Airport_Code__c = airport.code; 
			}else{
				cReq.Request_Status__c = ERR;
				cReq.Problem_Setting_Data_Details__c = ERR_AIRPORT;
			}
			 
			if(timeZone==null && airport==null){
				cReq.Problem_Setting_Data_Details__c = ERR_TIMEZONE +', '+ ERR_AIRPORT; 
			} 
		} 
		update lstCourseReq; 
	}
	
	/**
	 * Getting a DateTime at N:00:00
	 * @param : dt is DateTime. Used to get a Date
	 * @param : N is hour
	 */ 
	public static DateTime getDateTimeAtNparam(DateTime dt, integer N){
		return DateTime.newInstance(dt.year(), dt.month(), dt.day(), N, 0, 0);
	}
}