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
	
	/** Callout to get Geo information by address with full matched */
	public static Geo getGeoFullMatch(string addr){
		Geo geo = getGeo(addr);
		if(geo!=null && geo.isPartialMatch) geo = null;
		return geo;
	}
	
	/** Callout to get Geo information by address */
	private static Geo getGeo(string addr){
		Geo geo;
		HTTPResponse res = doCallOut(ENDPOINT_GOOGLE_GEOCODE+'?sensor=false&address='+ EncodingUtil.urlEncode(addr,'UTF-8'));
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
	public static Airport[] getNearestAirportsAsc(string latLong){  
		Airport[] listAirport;
		HTTPResponse res = doCallOut(ENDPOINT_AIRPORT+'?format=xml&near='+EncodingUtil.urlEncode(latLong,'UTF-8'));
		if(res.getStatusCode()==200){
			// Geting xml from response body: becuase it contain html and xml mixed together
			String separator = '<?xml version=';
	 		String resXML = separator + res.getBody().substringAfterLast(separator) ;
	 		listAirport = (new AirportsGenerator(resXML)).lstAirport; 
		}   
		return listAirport; 
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
      	req.setTimeout(40000); // Bunhor @ 17-June-15: 40000 since callout 3 times (maximum is 120,000 milliseconds. The maximum cumulative timeout for callouts by a single Apex transaction is 120 seconds.)
        
        // Sending the request and Recieving the response
        HTTPResponse res; 
        try{
        	res = Test.isRunningTest()? getMockResponse(req) : (new Http()).send(req);
        	system.debug('================res==='+res);
        	system.debug('================res=getBody=='+res.getBody());
        }catch(Exception ex){
        	res = new HTTPResponse();
        } 
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
    	public boolean isPartialMatch;
    	
    	/** Constructor */
    	public Geo(String xml){
    		super(xml);
    		isStatusOK = 'OK' == getNode(root, 'GeocodeResponse', 'GeocodeResponse/status').getText();
    		if(isStatusOK){
	    		lat = Decimal.valueOf(getNode(root, 'GeocodeResponse', 'GeocodeResponse/result/geometry/location/lat').getText());
	    		lng = Decimal.valueOf(getNode(root, 'GeocodeResponse', 'GeocodeResponse/result/geometry/location/lng').getText());
	    		
	    		DOM.XMLNode nodePartialMatch = getNode(root, 'GeocodeResponse', 'GeocodeResponse/result/partial_match'); 
	    		isPartialMatch = nodePartialMatch==null? false : Boolean.valueOf(nodePartialMatch.getText());
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
	    		//raw_offset = Decimal.valueOf(getNode(root, 'TimeZoneResponse', 'TimeZoneResponse/raw_offset').getText());
	    		//dst_offset = Decimal.valueOf(getNode(root, 'TimeZoneResponse', 'TimeZoneResponse/dst_offset').getText());
	    		time_zone_id = getNode(root, 'TimeZoneResponse', 'TimeZoneResponse/time_zone_id').getText(); 
    		}
    	}
    	
    	/** Getting offset as hour, regarding DST */
    	//public Integer getOffsetAsHour(){ return math.abs(Integer.valueOf((raw_offset+dst_offset)/3600)) ;} // raw_offset and dst_offset are in seconds: convert to hour by dividing 3600 
    } 
    
    /** DTO class for Airport */
    public class Airport{ 
    	public String code;
    	public String airportType;
    	public Integer runway_length; 
    }
    
    /** Airports Generator*/
    public class AirportsGenerator extends XMLParser{ 
    	public Airport[] lstAirport;
    	
    	/** Constructor */
    	public AirportsGenerator(String xml){
    		super(xml);
    		List<DOM.XMLNode> lstAirportNode = getNodes(root, 'airports');
    		if(lstAirportNode!=null && !lstAirportNode.isEmpty()){
    			lstAirport = new List<Airport>();
    			for(DOM.XMLNode node : lstAirportNode){
    				Airport ap = new Airport();
    				ap.code 			= getNode(node, 'airport', 'airport/code').getText();
    				ap.airportType 		= getNode(node, 'airport', 'airport/type').getText();
    				
    				string runwayLen = getNode(node, 'airport', 'airport/runway_length').getText();
    				ap.runway_length = String.isBlank(runwayLen)? 0 : Integer.valueOf(runwayLen);
    				
    				lstAirport.add(ap);	
    			}
    		} 
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
    public static string MOCKRESPONE_GEO = '<GeocodeResponse>'+
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
																'<code>MOD</code>'+
																 '<lat>37.6319</lat>'+
																 '<lon>-120.959</lon>'+
																 '<name>Modesto City County Airport-Harry Sham Field</name>'+
																 '<city>Modesto</city>'+
																 '<state>California</state>'+
																 '<country>United States</country>'+
																 '<woeid>12520978</woeid>'+
																 '<tz>America/Los_Angeles</tz>'+
																 '<phone></phone>'+
																 '<type>Airports</type>'+
																 '<email></email>'+
																 '<url></url>'+
																 '<runway_length>8911</runway_length>'+
																 '<elev>97</elev>'+
																 '<icao>KMOD</icao>'+
																 '<direct_flights>1</direct_flights>'+
																 '<carriers>2</carriers>'+
																 '<dist>129.444</dist>'+ 
															'</airport>'+ 
														'</airports>'; 
}