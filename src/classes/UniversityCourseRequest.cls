/**
 * https://gaeasys.plan.io/issues/5470 
 * @Bussiness : set the University_Course_Request__c fields, according to the Venue Location fields (City, State/Province, Country) and Desired_Course_Date_Start_Time__c
 * @Author : Bunhor
 * @CreatedDate : 10-May-15
 */ 
global with sharing class UniversityCourseRequest {
	/** Error string */
	public static final string ERR = 'Problem Setting Data';
	public static final string ERR_TIMEZONE = 'Failed to set Time Zone';
	public static final string ERR_AIRPORT = 'Failed to set Airport Code';
	
	/**
	 * Called from University_Course_Request__c detail page button
	 * TODO: Update some fields, according to the Venue Location fields (City, State/Province, Country)
	 * @param : reqId is University_Course_Request__c id
	 */
	webService static String setFieldValues(id reqId){ 
		calloutAndUpdate(new Set<id>{reqId}); 
		return 'OK';
	}
	
	/**
	 * Called from University_Course_Request__c before insert/update 
	 * TODO: Setting fields value: TZoffset__c, Registration_Open_Date__c, Registration_Closed_Date__c 
	 * Fired upon creation and every time the “Desired Course Date & Start Time” field is updated 
	 */
	public static void setFieldValues(){
		if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
			integer offset = getCurrentUserTimeZoneOffsetAsHour();
			for(University_Course_Request__c cReq : (List<University_Course_Request__c>)trigger.new){
				boolean isUpdateStartDT = (trigger.isUpdate && cReq.get('Desired_Course_Date_Start_Time__c')!=trigger.oldmap.get(cReq.id).get('Desired_Course_Date_Start_Time__c')); 
				  
				if(trigger.isInsert || isUpdateStartDT){
					// Set TZoffset 				: with an integer representing the difference between the current user’s time zone and GMT  
					cReq.TZoffset__c = offset; 
					// Set Registration_Open_Date	: with today at 12pm in the current user’s time zone
					cReq.Registration_Open_Date__c = getDateTimeAtNparam(system.now(), 12);
					// Set Registration_Closed_Date	: with the day of course start date at 12pm in the current user’s time zone 
					cReq.Registration_Closed_Date__c = getDateTimeAtNparam(cReq.Desired_Course_Date_Start_Time__c, 12); 
				}	
			}//-----end for loop-------	
		} 
	}
	
	/**
	 * Called from University_Course_Request__c trigger after insert.
	 * TODO: Update some fields, according to the Venue Location fields (City, State/Province, Country)
	 * @param : lstCourseReq is a list of University_Course_Request__c 
	 */
	public static void setFieldValues(University_Course_Request__c[] lstCourseReq){
		if(trigger.isAfter && trigger.isInsert){
			Set<id> lstCourseReqId = new Set<id>();
			for(University_Course_Request__c cReq: lstCourseReq){  
				if(cReq.Assistance_with_Venue_Required__c == 'No'){
					lstCourseReqId.add(cReq.id);		
				}	  
			}
			if(!lstCourseReqId.isEmpty())
			setFieldValues(lstCourseReqId);// future callout
		}	  
	}
	
	/** 
	 * TODO: Update some fields at future, according to the Venue Location fields (City, State/Province, Country)
	 * @param : lstCourseReqId is the set of University_Course_Request__c id
	 */
	@future (callout=true) 
	private static void setFieldValues(Set<id> lstCourseReqId){
		 calloutAndUpdate(lstCourseReqId);
	}
	
	/** 
	 * TODO: Update some fields, according to the Venue Location fields (City, State/Province, Country)
	 * @param : lstCourseReqId is the set of University_Course_Request__c id
	 */
	private static void calloutAndUpdate(Set<id> lstCourseReqId){
		// Set TimeZone and Airport Code functions to fire only for Assistance with Venue Required (NA)? = No
		University_Course_Request__c[] lstCourseReq = [ select id, Venue_City__c, Venue_State__c, Venue_Country__c, Desired_Course_Date_Start_Time__c 
														from University_Course_Request__c 
														where id in:lstCourseReqId and Assistance_with_Venue_Required__c = 'No'];
		
		// Getting set of addresses
		Set<String> setAddress = new Set<String>(); 
		for(University_Course_Request__c cReq: lstCourseReq){
			// only city is maintianed
			if(cReq.Venue_City__c!=null)  
			setAddress.add(getAddress(cReq)); 
		}
		
		// Getting Map of address to latlong ****Callout in loop****
		Map<String, String> mAddress2LatLng = new Map<String, String>();
		for(String addr : setAddress){
			GoogleServices.Geo geo = GoogleServices.getGeoFullMatch(addr); // Callout
			if(Geo!=null){
				mAddress2LatLng.put(addr, geo.getLatLong());
			}
		}
		
		// Getting Map of address to TimeZone ****Callout in loop****
		Map<String, GoogleServices.TimeZone> mAddress2TimeZone = new Map<String, GoogleServices.TimeZone>();
		for(String addr : mAddress2LatLng.keyset()){ 
			GoogleServices.TimeZone timeZone = GoogleServices.getTimeZone(mAddress2LatLng.get(addr), (DateTime.now().getTime()/1000) ); // Callout
			if(TimeZone!=null){
				mAddress2TimeZone.put(addr, timeZone);
			}
		}
		
		// Getting Map of city to a nearest Airport ****Callout in loop****
		Map<String, List<GoogleServices.Airport>> mAddress2ClosestAirportsAsc = new Map<String, List<GoogleServices.Airport>>();
		for(String addr : mAddress2LatLng.keyset()){ 
			GoogleServices.Airport[] airports = GoogleServices.getNearestAirportsAsc(mAddress2LatLng.get(addr)); // Callout
			if(airports!=null && !airports.isEmpty()){
				mAddress2ClosestAirportsAsc.put(addr, airports);
			}
		}
		
		// Updating the fields
		for(University_Course_Request__c cReq: lstCourseReq){
			GoogleServices.TimeZone timeZone = mAddress2TimeZone.get(getAddress(cReq));
			GoogleServices.Airport airport = getMajorAirport(mAddress2ClosestAirportsAsc.get(getAddress(cReq)));
			
			cReq.Request_Status__c = '';
			cReq.Problem_Setting_Data_Details__c = '';
			
			if(timeZone!=null){ 
				cReq.Venue_Time_Zone__c = timeZone.time_zone_id; 
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
	 * Getting a major airport by: Type=='Airports' and runway_length >= 8000 
	 * @param : airports list of Airport DTO 
	 */ 
	private static GoogleServices.Airport getMajorAirport(GoogleServices.Airport[] airports){
		if(airports!=null)
		for(GoogleServices.Airport ap : airports){
			if(ap.airportType=='Airports' && ap.runway_length >= 8000)
			return ap;
		}
		return null;
	}
	
	/**
	 * Getting a DateTime at N:00:00
	 * @param : dt is DateTime. Used to get a Date
	 * @param : N is hour
	 */ 
	public static DateTime getDateTimeAtNparam(DateTime dt, integer N){
		return dt==null? null : DateTime.newInstance(dt.year(), dt.month(), dt.day(), N, 0, 0);
	}
	
	/**
	 * Getting an address of the University_Course_Request__c
	 * @cReq : University_Course_Request__c record
	 */ 
	private static string getAddress(University_Course_Request__c cReq){
		String city 	=  cReq.Venue_City__c==null		? '' : cReq.Venue_City__c.trim().tolowercase();
		String state 	=  cReq.Venue_State__c==null	? '' : cReq.Venue_State__c.trim().tolowercase();
		String country 	=  cReq.Venue_Country__c==null	? '' : cReq.Venue_Country__c.trim().tolowercase(); 
		return city+' '+state+', '+country;
	}
	
	/** Getting an integer representing the difference between the current user’s time zone and GMT */
	private static integer getCurrentUserTimeZoneOffsetAsHour(){
		long offsetInMillisecodn = UserInfo.getTimeZone().getOffset(system.today());
		return Integer.valueOf(offsetInMillisecodn/1000/60/60); // converting to hour 
	} 
}