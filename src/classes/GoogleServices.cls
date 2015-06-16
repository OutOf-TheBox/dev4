/**
 * A service class used to integrate other webservices:
 * 	- Google Geo service
 * 	- Google TimeZone service
 *	- airports.pidgets.com service
 *
 * @Author : Bunhor
 * @CreatedDate : 10-May-15
 */ 
public with sharing class GoogleServices {
	/** End points */ 
	private static final string ENDPOINT_GOOGLE_GEOCODE = 'https://maps.googleapis.com/maps/api/geocode/xml';
	private static final string ENDPOINT_GOOGLE_TIMEZONE = 'https://maps.googleapis.com/maps/api/timezone/xml';
	private static final string ENDPOINT_AIRPORT = 'http://airports.pidgets.com/v1/airports';
	
	/** Callout to get Geo information by city name */
	public static Geo getGeo(string city){
		Geo geo;
		HTTPResponse res = doCallOut(ENDPOINT_GOOGLE_GEOCODE+'?sensor=false&address='+ EncodingUtil.urlEncode(city,'UTF-8'));
		if(res.getStatusCode()==200){
			geo = new geo(res.getBody()); 
			if(!geo.isStatusOK){geo=null;}
		}  
		return geo;
	}
	
	/** Callout to get TimeZone information by latitude, longtitude and timestamp. 
	 * @Param : latLong a string of latitude and longtitude separated by a comma.
	 * @Param : timestampInSecond specifies the desired time as seconds since midnight, January 1, 1970 UTC. Use to determine whether or not DST should be applied. (Before 1970 can be expressed as negative values)
	 */
	public static TimeZone getTimeZone(string latLong, long timestampInSecond){
		TimeZone timeZone;
		HTTPResponse res = doCallOut(ENDPOINT_GOOGLE_TIMEZONE+'?sensor=false&timestamp='+timestampInSecond+'&location='+ EncodingUtil.urlEncode(latLong,'UTF-8'));
		if(res.getStatusCode()==200){
			timeZone = new timeZone(res.getBody()); 
			if(!timeZone.isStatusOK){timeZone=null;}
		}  
		return timeZone;
	}
	
	/** Callout to get the closest airport information by city name. 
	 * @Param : latLong a string of latitude and longtitude separated by a comma. 
	 */
	public static Airport getNearestAirport(string latLong){ 
		Airport airport;
		HTTPResponse res = doCallOut(ENDPOINT_AIRPORT+'?format=xml&near='+EncodingUtil.urlEncode(latLong,'UTF-8'));
		if(res.getStatusCode()==200){
			// Geting xml from response body: becuase it contain html and xml mixed together
			String separator = '<?xml version=';
	 		String resXML = separator + res.getBody().substringAfterLast(separator) ;
	 		airport = new Airport(resXML);
	 		if(!airport.isStatusOK){airport=null;}
		}  
		return airport; 
	}
	
	/** Callout handler for all webservices 
	 * @Param : fullURL a full URL containing endpoit and params. 
	 */
	private static HTTPResponse doCallOut(string fullURL){ 
		// Avoiding hitting the salesforce callout limit
        if(Limits.getCallouts()==Limits.getLimitCallouts()) return new HTTPResponse();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(fullURL);
        req.setMethod('GET');  
        req.setHeader('Accept', 'application/xml');
      	req.setHeader('Content-Type', 'application/xml');
      	req.setTimeout(6000);
      	
        // Sending the request and Recieving the response
        Http http = new Http();
        HTTPResponse res = Test.isRunningTest()? getMockResponse(req) : http.send(req);  
        return res; 
    } 
    
    //---------Inner Classes--------------
    
    /** XMLParser as a parent class, used to load xml string into XMLNode*/
    public abstract class XMLParser{
    	public boolean isStatusOK;
    	protected DOM.XMLNode root;
    	/** Constructor */
    	protected XMLParser(String xml){ root = getRootNode(xml); }
    	/** Getting XMLNode root from xml */
    	private DOM.XMLNode getRootNode(String xml){
            DOM.Document doc = new DOM.Document();
            try{ doc.load(xml); }catch(Exception e){ return null;  }             
            return doc.getRootElement();
        }  
    }
    
    /** DTO class for Geo */
    public class Geo extends XMLParser{
    	private Decimal lat;
    	private Decimal lng;
    	
    	/** Constructor */
    	public Geo(String xml){
    		super(xml);
    		isStatusOK = 'OK' == getNode(root, 'GeocodeResponse', 'GeocodeResponse/status').getText();
    		if(isStatusOK){
	    		lat = Decimal.valueOf(getNode(root, 'GeocodeResponse', 'GeocodeResponse/result/geometry/location/lat').getText());
	    		lng = Decimal.valueOf(getNode(root, 'GeocodeResponse', 'GeocodeResponse/result/geometry/location/lng').getText());
    		}
    	}
    	
    	/** Getting latitude and longtitude separated by a comma*/
    	public string getLatLong(){ return lat+','+lng;}
    }
    
    /** DTO class for TimeZone */
    public class TimeZone extends XMLParser{
    	private Decimal raw_offset;
    	private Decimal dst_offset;
    	public String time_zone_id;
    	
    	/** Constructor */
    	public TimeZone(String xml){
    		super(xml);
    		isStatusOK = 'OK' == getNode(root, 'TimeZoneResponse', 'TimeZoneResponse/status').getText();	
    		if(isStatusOK){
	    		raw_offset = Decimal.valueOf(getNode(root, 'TimeZoneResponse', 'TimeZoneResponse/raw_offset').getText());
	    		dst_offset = Decimal.valueOf(getNode(root, 'TimeZoneResponse', 'TimeZoneResponse/dst_offset').getText());
	    		time_zone_id = getNode(root, 'TimeZoneResponse', 'TimeZoneResponse/time_zone_id').getText(); 
    		}
    	}
    	
    	/** Getting offset as hour, regarding DST */
    	public Integer getOffsetAsHour(){ return math.abs(Integer.valueOf((raw_offset+dst_offset)/3600)) ;} // raw_offset and dst_offset are in seconds: convert to hour by dividing 3600 
    } 
    
    /** DTO class for Airport */
    public class Airport extends XMLParser{ 
    	public String code;
    	
    	/** Constructor */
    	public Airport(String xml){
    		super(xml);
    		List<DOM.XMLNode> lstAirport = getNodes(root, 'airports');
    		try{ // Use try: in case fail response (out of bound, null pointer) 
    			code = getNode(lstAirport[0], 'airport', 'airport/code').getText(); // Airports are sorted by distance asc, so the closest is at index 0 
    			isStatusOK = true;
    		}catch(Exception ex){}
    	} 
    } 
     
    //---------Utils---------------
    
    /**	
	 *  Getting a list of Node
	 *  Ex:  xPath = 'airports/airport' will return a list of airport node
	 *	@param root
	 * 	@param xPath
	 *	@return List<DOM.XMLNode>
	 */
	private static List<DOM.XMLNode> getNodes(DOM.XMLNode root, String xPath) { 
		DOM.XMLNode parentNode = getNode(root, xPath.split('/')[0],xPath);
		DOM.XMLNode[] theList = new List<DOM.XMLNode>();
		if( parentNode != null)
		theList = parentNode.getChildElements(); 
		return theList;
	}
	 
	/**
	 *  TODO: Getting a Node
	 *  Ex: rootName = 'TimeZoneResponse' and xPath = 'TimeZoneResponse/status' will return status node
	 *	@param root
	 *	@param rootName
	 *	@param xPath
	 *	@return DOM.XMLNode
	 */ 
	private static DOM.XMLNode getNode(DOM.XMLNode root, String rootName, String xPath){  
    	DOM.XmlNode tmp; 
    	if(root == null || String.isBlank(xPath) || rootName.equals(xPath)){
    		tmp = root;
    	}else{
	    	for(DOM.XMLNode node : root.getChildElements()){ 
	            if(tmp == null) tmp = getNode (node, rootName + '/' + node.getName(), xPath);
	            else break;
	        }
    	}
    	return tmp;  
    }
     
    //---------Mock respones--------------- 
    
    /** Getting mock response */
    private static HTTPResponse getMockResponse(HTTPRequest req){   
        HttpResponse res = new HttpResponse(); 
        res.setStatusCode(200);
        
        if(req.getEndpoint().startsWithIgnoreCase(ENDPOINT_GOOGLE_GEOCODE))
            res.setBody(MOCKRESPONE_GEO);
        else if(req.getEndpoint().startsWithIgnoreCase(ENDPOINT_GOOGLE_TIMEZONE))
            res.setBody(MOCKRESPONE_TIMEZONE);
        else if(req.getEndpoint().startsWithIgnoreCase(ENDPOINT_AIRPORT))
            res.setBody(MOCKRESPONE_AIRPORT);            
        
        return res;
    }
        
    /** Mock respones Geo*/
    private static final string MOCKRESPONE_GEO = '<GeocodeResponse>'+
													'<status>OK</status>'+ 
													'<result>'+
														'<geometry>'+
															'<location>'+
																'<lat>37.7749295</lat>'+
																'<lng>-122.4194155</lng>'+
															'</location>'+ 
														'</geometry>'+ 
													'</result>'+
												 '</GeocodeResponse>';
	/** Mock respones TimeZone*/											 
    private static final string MOCKRESPONE_TIMEZONE = 	'<TimeZoneResponse>'+
															'<status>OK</status>'+
															'<raw_offset>0.0000000</raw_offset>'+
															'<dst_offset>0.0000000</dst_offset>'+
															'<time_zone_id>America/Los_Angeles</time_zone_id>'+
															'<time_zone_name>Pacific Standard Time</time_zone_name>'+
														'</TimeZoneResponse>';
	/** Mock respones Airport*/													
    private static final string MOCKRESPONE_AIRPORT = 	'<br />'+ 
														'<b>Warning</b>:  Cannot modify header information'+ 
														'<?xml version="1.0"?>'+
														'<airports>'+
															'<airport>'+	
																'<code>SFO</code>'+
																'<lat>37.6148</lat>'+
																'<lon>-122.392</lon>'+ 
																'<dist>17.966</dist>'+
															'</airport>'+
															'<airport>'+	
																'<code>OAK</code>'+ 
															'</airport>'+ 
														'</airports>'; 
}