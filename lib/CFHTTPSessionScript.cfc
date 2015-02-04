/**
*
* @output false
* @hint Handles a CFHTTP session by sending an receving cookies behind the scenes.
*/
component{

	// new line
	variables.NL = CreateObject("java", "java.lang.System").getProperty("line.separator");
	// Pseudo constructor. Set up data structures and 
	// default values. 
	variables.instance = {
		LogFilePath: ''// This is the log file path used for debugging.
		, Cookies: {} // Cookies returned from the request that enable session across multiple requests
		, RequestData: { // request data that will be sent with our requests
			Url: ''
			,referer: ''
			,UserAgent: 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6'
			,Params: []
		}
	};

	/**
	* @output false 
	* @hint Returns an initialized component.
	*/	
	public any function init(string LogFilePath, string UserAgent){

		if(structkeyExists( arguments, 'LogFilePath'))variables.Instance.LogFilePath = arguments.LogFilePath;
		if(structkeyExists( arguments, 'UserAgent'))variables.Instance.UserAgent = arguments.UserAgent;
	
		return this;
	}

	/**
	* @hint Adds a CGI value. Returns THIS scope for method chaining.
	*/	
	public any function addCGI(Required string name, required string value, string encoded="yes"){
		return this.addParam(Type:"CGI", Name: arguments.Name, Value: arguments.Value, Encoded:arguments.Encoded);
	}

	/**
	* 
	* @hint Adds a cookie value. Returns THIS scope for method chaining.
	*/				
	public any function addCookie(required string name, required string value){
		return THIS.AddParam( Type: "Cookie", Name: arguments.Name, Value: arguments.Value); 
	}

	/**
	* @hint Adds a file value. Returns THIS scope for method chaining.
	*/	
	public any function addFile(required string name, required string path, string mimetype="application/octet-stream"){
		return THIS.AddParam(Type: "File",	Name: arguments.Name, File: arguments.Path, MimeType: arguments.MimeType );
	}

	/**
	* @hint Adds a form value. Returns THIS scope for method chaining.
	*/
	public any function addFormField(required string name, required string value, string encoded="yes"){
		return THIS.AddParam(Type: "FormField", Name: arguments.Name, Value: arguments.Value, Encoded: arguments.Encoded);
	}

	/**
	* @hint Adds a header value. Returns THIS scope for method chaining.
	*/
	public any function addHeader(required string name, required string value){
		return THIS.AddParam(Type: "Header", Name: arguments.Name, Value: arguments.Value);
	}
	
	/**
	* @hint Adds a CFHttpParam data point. Returns THIS scope for method chaining.
	*/		
	public any function addParam(required string type, string name, any value, string file='',string mimetype='',string encoded="yes"){
		// Define the LOCAL scope. 
		var LOCAL = {};


		// Check to see which kind of data point we are dealing 
		// with so that we can see how to create the param.

		switch(arguments.Type){
			
			case "Body": //Create the param. 
				
				LOCAL.Param = {	
					Type = arguments.Type,	
					Value = arguments.Value	
				};
			
			Break;
			
			case "CGI": // Create the param.
				
				LOCAL.Param = {
					Type = arguments.Type,
					Name = arguments.Name,
					Value = arguments.Value,
					Encoded = arguments.Encoded
				};
			
			Break;
			
			case "Cookie": // Create the param.
			
				LOCAL.Param = {
					Type = arguments.Type,
					Name = arguments.Name,
					Value = arguments.Value
				};
			
			Break;
			
			case "File": // Create the param.
				
				LOCAL.Param = {
					Type = arguments.Type,
					Name = arguments.Name,
					File = arguments.File,
					MimeType = arguments.MimeType
				};
			
			Break;
			
			case "FormField": // Create the param.
			
				LOCAL.Param = {
					Type = arguments.Type,
					Name = arguments.Name,
					Value = arguments.Value,
					Encoded = arguments.Encoded
				};
			
			Break;
			
			case "Header": // Create the param.
			
				LOCAL.Param = {
					Type = arguments.Type,
					Name = arguments.Name,
					Value = arguments.Value
				};
			
			Break;
			
			case "Url": // Create the param.
				
				LOCAL.Param = {
					Type = arguments.Type,
					Name = arguments.Name,
					Value = arguments.Value
				};
			
			Break;
			
			case "Xml": // Create the param.

				LOCAL.Param = {
					Type = arguments.Type,
					Value = arguments.Value
				};
			
			Break;
					
		}
		
		
		// Add the parameter for the next request.
		ArrayAppend( variables.Instance.RequestData.Params,	LOCAL.Param );
		
		// Return This reference. 
		return THIS;

	}

	/**
	* @hint Adds a url value. Returns THIS scope for method chaining.
	*/
	public any function addURL(required string name, required string value){
		return THIS.AddParam(Type: "Url", Name: arguments.Name, Value: arguments.Value);
	}
	
	/**
	* @hint Uses the GET method to place the next request. Returns the CFHttp response.
	*/
	public struct function Get (string getAsBinary="auto"){
		return THIS.Request(Method: "get",	GetAsBinary: arguments.GetAsBinary	);
	}
	
	/**
	* @hint Returns the internal session cookies.
	*/	
	public struct function getCookies(){
		return variables.Instance.Cookies;
	}

	/**
	* @hint I log the given request to the log file, if it exists.
	*/		
	public void function logRequestData(string method, string getAsBinary="auto"){

			
		// Define the LOCAL scope.
		var LOCAL = {};
		
		// Check to see if the log file path is set. If not, 
		// just return out. 
		if(!len(variables.Instance.LogFilePath)) return;

		// Create a data buffer for the request data. 
		savecontent variable="LOCAL.Output" { 
			WriteOutput("+----------------------------------------------+" & variables.NL);
			WriteOutput("REQUEST: #TimeFormat( Now(), "HH:mm:ss:L" )#" & variables.NL);
			WriteOutput("URL: #variables.Instance.RequestData.Url#" & variables.NL);
			WriteOutput("Method: #arguments.Method#" & variables.NL);
			WriteOutput("UserAgent: #variables.Instance.RequestData.UserAgent#" & variables.NL);
			WriteOutput("GetAsBinary: #arguments.GetAsBinary#" & variables.NL);
			WriteOutput(variables.NL);			
			WriteOutput("-- Cookies --" & variables.NL);
			WriteOutput(variables.NL);	
			
			for(var key in variables.Instance.Cookies){
				Writeoutput("#Key#: #variables.Instance.Cookies[ Key ].Value#" & variables.NL);
			}
			
			WriteOutput("-- Headers --" & variables.NL);
			WriteOutput(variables.NL);		
			WriteOutput("Referer: #variables.Instance.RequestData.Referer#" & variables.NL);
			WriteOutput(variables.NL);	
			WriteOutput("-- Params --" & variables.NL);
			for(var param in variables.Instance.RequestData.Params){
				for(var paramkey in param){
					Writeoutput("#ParamKey# : #Param[ ParamKey ]#" & variables.NL);
				}
			}	
		
		}
		
		// Clean up request data. 
		LOCAL.Output = REReplace(LOCAL.Output, 	"(?m)^[ \t]+|[ \t]+$", 	"", "all" 	);
			
		//Write the output to log file. 
		var fileObj = FileOpen(variables.Instance.LogFilePath,"append");
			fileWrite( fileObj, LOCAL.Output);
			fileClose( fileObj ); 
		
		return;
	}
	
	/**
	* @hint I log the given response to the log file, if it exists.
	*/
	public void function LogResponseData(required struct Response){

		// Define the LOCAL scope. 
		var LOCAL = {};
		
		// Check to see if the log file path is set. If not, 
		// just return out. 

		if(!len( variables.Instance.LogFilePath )) return;
		
		// Create a data buffer for the request data. 
		savecontent variable="LOCAL.Output" { 
			WriteOutput("+----------------------------------------------+" & variables.NL);
			WriteOutput("RESPONSE: #TimeFormat( Now(), "HH:mm:ss:L" )#" & variables.NL);
			WriteOutput(variables.NL);	
			WriteOutput("-- Cookies --" & variables.NL);
			WriteOutput(variables.NL);		
			if(StructKeyExists( arguments.Response.ResponseHeader, "Set-Cookie" )){
				if(IsSimpleValue( arguments.Response.ResponseHeader[ "Set-Cookie" ] )){
					writeoutput(arguments.Response.ResponseHeader[ "Set-Cookie" ] & variables.NL);
				}else{
					for(var LOCAL.cookieIndex in arguments.Response.ResponseHeader[ 'Set-Cookie' ]){
						writeoutput(arguments.Response.ResponseHeader[ 'Set-Cookie' ][ LOCAL.CookieIndex ] & variables.NL);							
					}		
				}
			}
			WriteOutput(variables.NL);	
			WriteOutput("-- Redirect --" & variables.NL);		
			if(StructKeyExists( arguments.Response.ResponseHeader, "Location" )){
				writeoutput(arguments.Response.ResponseHeader.Location & variables.NL);
			}
			WriteOutput(variables.NL);					
		}
		
		// Clean up request data. 
		LOCAL.Output = REReplace(LOCAL.Output, 	"(?m)^[ \t]+|[ \t]+$", 	"", "all" 	);
			
		//Write the output to log file. 
		var fileObj = FileOpen(variables.Instance.LogFilePath,"append");
			fileWrite( fileObj, LOCAL.Output);
			fileClose( fileObj );
		
		return;
	}
	
	/**
	* @hint Sets up the object for a new request. Returns THIS scope for method chaining.
	*/
	public any function newRequest(required string url, string referer=""){
			
		
		// Before we store the URL, let's check to see if we 
		// already had one in memory. If so, then we can use 
		// that for a referer (which we then have the option 
		// to override. The point here is that each URL can 
		// be the referer for the next one.
		
		if(Len( variables.Instance.RequestData.Url )){
		// Store the previous url as the next referer. We 
		// may override this in a second.
			variables.Instance.RequestData.Referer = variables.Instance.RequestData.Url;
		}
		
		// Store the passed-in url. 
		variables.Instance.RequestData.Url = arguments.Url;
		

		// Check to see if the referer was passed in. Since we 
		// are using previous URLs as the next referring url, 
		// we only want to store the passed in value if it has 
		// length

		if(Len( arguments.Referer )){
			// Store manually set referer. 
			variables.Instance.RequestData.Referer = arguments.Referer;
		}
		
		//Clear the request data. 
		variables.Instance.RequestData.Params = [];
		
		// Return This reference. 
		return this;
	}
	
	/**
	* @hint Uses the POST method to place the next request. Returns the CFHttp response.
	*/	
	public struct function Post(string getAsBinary="auto"){

		return THIS.Request(Method: "post", GetAsBinary: arguments.GetAsBinary );
	}

	/**
	* @hint Performs the CFHttp request and returns the response.
	*/		
	public struct function Request(string method="get", string getAsBindary="auto"){

		//Define the LOCAL scope.
		var LOCAL = {};
		
		// Before we make the actual request, log request data 
		// for debugging pursposes. Pass the same arguments to 
		// the logging method.

		THIS.LogRequestData( ArgumentCollection = arguments );
			
		// Make request. When the request comes back, we don't 
		// want to follow any redirects. We want this to be 
		// done manually.

		httpService = new http(); 
		httpService.setURL(variables.Instance.RequestData.Url);
		httpService.setmethod(arguments.Method);
		httpService.setuseragent(variables.Instance.RequestData.UserAgent);
		httpService.setgetasbinary(arguments.GetAsBinary);
		httpService.setredirect("no");
		httpService.setresult("LOCAL.Get");
			

		// In order to maintain the user's session, we are 
		// going to resend any cookies that we have stored 
		// internally. 

		for(var LOCAL.key in variables.Instance.Cookies){
			 httpService.addParam(type="cookie",name="#LOCAL.Key#",value="#variables.Instance.Cookies[ LOCAL.Key ].Value#");
		}
			

		// At this point, we have done everything that we 
		// need to in order to maintain the user's session 
		// across CFHttp requests. Now we can go ahead and 
		// pass along any addional data that has been specified.
			
		// Let's spoof the referer.
		httpService.addParam(type="header",name="referer",value="#variables.Instance.RequestData.Referer#");
			
		// Loop over params. 
		for(var LOCAL.Param in variables.Instance.RequestData.Params){
			httpService.addParam(attributecollection=local.Param);
		}

		LOCAL.Get = httpService.send().getPrefix();
		
		// Debug the response. 
		THIS.LogResponseData( LOCAL.Get );
	

		// Store the response cookies into our internal cookie 
		// storage struct.

		StoreResponseCookies( LOCAL.Get );
		

		// Check to see if there was some sort of redirect 
		// returned with the repsonse. If there was, we want 
		// to redirect with the proper value. 

		if(StructKeyExists( LOCAL.Get.ResponseHeader, "Location" )){
		

			// There was a response, so now we want to do a 
			// recursive call to return the next page. When 
			// we do this, make sure we have the proper URL 
			// going out. 

			if(REFindNoCase( "^http",  LOCAL.Get.ResponseHeader.Location)){
				
				// Proper url. 
				return THIS
					.NewRequest( LOCAL.Get.ResponseHeader.Location )
					.Get();
				
			// Check for absolute-relative URLs. 
			}else if(REFindNoCase( 	"^[\\\/]", LOCAL.Get.ResponseHeader.Location)){
				

				// With an absolute-relative URL, we need to 
				// append the given location to the DOMAIN of 
				// our current url.

				return THIS
					.NewRequest( 
						REReplace(
							variables.Instance.RequestData.Url,
							"^(https?://[^/]+).*",
							"\1",
							"one"
							) & 
						LOCAL.Get.ResponseHeader.Location 
					)
					.Get();
			
			}else{
				
			
				// Non-root url. We need to append the current 
				// redirect url to our last URL for relative 
				// path traversal.
			
				return THIS
					.NewRequest( 
						GetDirectoryFromPath( variables.Instance.RequestData.Url ) & 
						LOCAL.Get.ResponseHeader.Location 
					)
					.Get();
			}

		}else{
		
			// No redirect, so just return the current 
			// request response object.
			return LOCAL.Get;
			
		}
	}
	
	/**
	* @hint Sets the body data of next request. Returns THIS scope for method chaining.
	*/
	public any function setBody(any value){	

		return THIS.AddParam(Type: "Body", Name: "", Value: arguments.Value	);
	}
	
	/**
	* @hint Sets the user agent for next request. Returns THIS scope for method chaining.
	*/	
	public any function setUserAgent(string value){
		//Store value. 
		variables.Instance.RequestData.UserAgent = arguments.Value;
		
		return THIS;
	}
	
	/**
	* @hint Sets the XML body data of next request. Returns THIS scope for method chaining.
	*/		
	public any function setXML(any value){
		
		 return THIS.AddParam(Type: "Xml",	Name: "",Value: arguments.Value );
	}
		
	/**
	* @hint This parses the response of a CFHttp call and puts the cookies into a struct.
	*/
	public void function StoreResponseCookies(required struct response){		

		
		// Define the LOCAL scope. 
		var LOCAL = StructNew();
		
	
		// Create the default struct in which we will hold 
		// the response cookies. This struct will contain structs
		// and will be keyed on the name of the cookie to be set.
	
		LOCAL.Cookies = StructNew();
		
	
		// Get a reference to the cookies that werew returned 
		// from the page request. This will give us an numericly 
		// indexed struct of cookie strings (which we will have
		// to parse out for values). BUT, check to make sure
		// that cookies were even sent in the response. If they
		// were not, then there is not work to be done.	
	
		if(!StructKeyExists(arguments.Response.ResponseHeader, "Set-Cookie"	)) return;
		
		
		
	 
		// ASSERT: We know that cookie were returned in the page
		// response and that they are available at the key, 
		// "Set-Cookie" of the reponse header.
	
	
		// The cookies might be coming back as a struct or they
		// might be coming back as a string. If there is only 
		// ONE cookie being retunred, then it comes back as a 
		// string. If that is the case, then re-store it as a 
		// struct. 
	
		if(IsSimpleValue( arguments.Response.ResponseHeader[ "Set-Cookie" ] )){
			
			LOCAL.ReturnedCookies = {};
			LOCAL.ReturnedCookies[ 1 ] = arguments.Response.ResponseHeader[ "Set-Cookie" ];
			
		}else{
		
			// Get a reference to the cookies struct. 
			LOCAL.ReturnedCookies = arguments.Response.ResponseHeader[ "Set-Cookie" ];
			
		}
	
		// At this point, we know that no matter how the 
		// cookies came back, we have the cookies in a 
		// structure of cookie values. 
	
		for(var LOCAL.CookieIndex in LOCAL.ReturnedCookies ){

		 
			// As we loop through the cookie struct, get 
			// the cookie string we want to parse.
		
			LOCAL.CookieString = LOCAL.ReturnedCookies[ LOCAL.CookieIndex ];
		 
			// For each of these cookie strings, we are going 
			// to need to parse out the values. We can treate 
			// the cookie string as a semi-colon delimited list.
		
			for(LOCAL.Index=1; LOCAL.Index LTE ListLen(Local.CookieString,';'); LOCAL.Index++ ){
			
				//Get the name-value pair. 
				LOCAL.Pair = ListGetAt(
					LOCAL.CookieString,
					LOCAL.Index,
					";"
					);		
			 
				// Get the name as the first part of the pair 
				// sepparated by the equals sign.
			
				LOCAL.Name = ListFirst( LOCAL.Pair, "=" );
			
			  
				// Check to see if we have a value part. Not all
				// cookies are going to send values of length, 
				// which can throw off ColdFusion.
			
				if (ListLen( LOCAL.Pair, "=" ) GT 1){
				
					//Grab the rest of the list.
					LOCAL.Value = ListRest( LOCAL.Pair, "=" );
				
				}else{

					// Since ColdFusion did not find more than 
					// one value in the list, just get the empty 
					// string as the value.
				
					LOCAL.Value = "";
				
				}
			  
				// Now that we have the name-value data values, 
				// we have to store them in the struct. If we 
				// are looking at the first part of the cookie 
				// string, this is going to be the name of the 
				// cookie and it's struct index.
			
				if(LOCAL.Index EQ 1){
				
				 
					// Create a new struct with this cookie's name
					// as the key in the return cookie struct.
				
					LOCAL.Cookies[ LOCAL.Name ] = StructNew();
	
						// Now that we have the struct in place, lets
					// get a reference to it so that we can refer 
					// to it in subseqent loops.
				
					LOCAL.Cookie = LOCAL.Cookies[ LOCAL.Name ];
					
					
					//Store the value of this cookie. 
					LOCAL.Cookie.Value = LOCAL.Value;
				

					// Now, this cookie might have more than just
					// the first name-value pair. Let's create an 
					// additional attributes struct to hold those 
					// values.
				
					LOCAL.Cookie.Attributes = StructNew();
				
				}else{

					// For all subseqent calls, just store the 
					// name-value pair into the established 
					// cookie's attributes strcut.
				
					LOCAL.Cookie.Attributes[ LOCAL.Name ] = LOCAL.Value;
					
				}
			}		
		}	

	  
		// Now that we have all the response cookies in a 
		// struct, let's append those cookies to our internal 
		// response cookies. 
	
		StructAppend( 
			variables.Instance.Cookies,
			LOCAL.Cookies
			);
		
		//Return out. 
		return;
	}

}